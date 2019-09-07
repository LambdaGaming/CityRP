
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Pure Cocaine (Marketable)"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Cocaine System"

function ENT:SpawnFunction( ply, tr )
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 1
	local ent = ents.Create( "pure_cocaine_marketable" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

local COKE_GOOD_PURITY = 0xD7 --Number randomly selected between 70 and 590, changes every few sessions
local COKE_GOOD_PURITY_LESS = COKE_GOOD_PURITY - 10
local COKE_GOOD_PURITY_MORE = COKE_GOOD_PURITY + 10
local COKE_PAYOUT = 30000

local function PurityPayout( purity )
	if purity == COKE_GOOD_PURITY then
		return COKE_PAYOUT
	elseif purity >= COKE_GOOD_PURITY_LESS and purity <= COKE_GOOD_PURITY_MORE and purity > COKE_GOOD_PURITY then
		return COKE_PAYOUT - ( ( purity - COKE_GOOD_PURITY ) * 1000 )
	elseif purity >= COKE_GOOD_PURITY_LESS and purity <= COKE_GOOD_PURITY_MORE and purity < COKE_GOOD_PURITY then
		return COKE_PAYOUT - ( ( COKE_GOOD_PURITY - purity ) * 1000 )
	end
	return 10000
end

function ENT:Initialize()
    self:SetModel( "models/props/cs_assault/Money.mdl" )
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
	end
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self:SetMaterial( "models/debug/debugwhite" )
end

function ENT:Use( activator, caller )
	local iscop = table.HasValue( cop, caller:Team() )
	local iscivi = table.HasValue( civi, caller:Team() )
	local purity = self:GetNWInt( "Purity" )
	if IsValid(caller) and caller:IsPlayer() then
		for k, v in pairs( ents.FindInSphere( self:GetPos(), 128 ) ) do
			if ( v:GetClass() == "rp_dealer" ) then
				local rand = math.random( 1, 10 )
				if rand <= 3 and !caller:isWanted() and iscivi then
					caller:wanted( actor, "Seen selling drugs.", 600 )
				end
				if iscop then
					caller:ChatPrint( "Processing drugs....standby for payment...." )
					timer.Simple( 30, function()
						DarkRP.createMoneyBag( v:GetPos() + Vector( 35, 0, 10 ), PurityPayout( purity ) )
						caller:ChatPrint( "You have sold cocaine for "..DarkRP.formatMoney( PurityPayout( purity ) ).." as a government official." )
					end )
				end
				if iscivi then
					caller:addMoney( PurityPayout( purity ) )
					caller:ChatPrint( "You have sold cocaine for "..DarkRP.formatMoney( PurityPayout( purity ) ).."." )
				end
				self:Remove()
			end
		end
	end
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end
end