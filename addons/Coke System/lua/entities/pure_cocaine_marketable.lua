
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Pure Cocaine (Marketable)"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Cocaine System"

function ENT:SpawnFunction( ply, tr, name )
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 1
	local ent = ents.Create( name )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

local COKE_GOOD_PURITY
local COKE_GOOD_PURITY_LESS
local COKE_GOOD_PURITY_MORE
local COKE_PAYOUT

if SERVER then
	COKE_GOOD_PURITY = file.Read( "cokekey.txt", "DATA" )
	COKE_GOOD_PURITY_LESS = COKE_GOOD_PURITY - 10
	COKE_GOOD_PURITY_MORE = COKE_GOOD_PURITY + 10
	COKE_PAYOUT = 30000
end

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
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
	end
 
    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	self:SetMaterial( "models/debug/debugwhite" )
end

local cop = {
	[TEAM_POLICEBOSS] = true,
	[TEAM_OFFICER] = true,
	[TEAM_UNDERCOVER] = true,
	[TEAM_SWATBOSS] = true,
	[TEAM_SWAT] = true,
	[TEAM_FBI] = true,
	[TEAM_MAYOR] = true,
	[TEAM_BOUNTY] = true
}

local civi = {
	[TEAM_CITIZEN] = true,
	[TEAM_TOWER] = true,
	[TEAM_CAMERA] = true,
	[TEAM_BANKER] = true,
	[TEAM_FIREBOSS] = true,
	[TEAM_FIRE] = true,
	[TEAM_DETECTIVE] = true,
	[TEAM_COOK] = true,
	[TEAM_UTILITY] = true,
	[TEAM_HITMAN] = true,
	[TEAM_BUS] = true,
	[TEAM_SHOP] = true
}

function ENT:Use( activator, caller )
	local purity = self:GetNWInt( "Purity" )
	if IsValid(activator) and activator:IsPlayer() then
		for k, v in pairs( ents.FindInSphere( self:GetPos(), 128 ) ) do
			if ( v:GetClass() == "rp_dealer" ) then
				local rand = math.random( 1, 10 )
				if rand <= 3 and !activator:isWanted() and civi[activator:Team()] then
					activator:wanted( actor, "Seen selling drugs.", 600 )
				end
				if cop[activator:Team()] then
					activator:ChatPrint( "Processing drugs....standby for payment...." )
					timer.Simple( 30, function()
						DarkRP.createMoneyBag( v:GetPos() + Vector( 35, 0, 10 ), PurityPayout( purity ) )
						activator:ChatPrint( "You have sold cocaine for "..DarkRP.formatMoney( PurityPayout( purity ) ).." as a government official." )
					end )
				elseif civi[activator:Team()] then
					activator:addMoney( PurityPayout( purity ) )
					activator:ChatPrint( "You have sold cocaine for "..DarkRP.formatMoney( PurityPayout( purity ) ).."." )
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