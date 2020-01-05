
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Announcement Speaker"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Announcement System"

function ENT:SpawnFunction( ply, tr, name )
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 1
	local ent = ents.Create( name )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
    self:SetModel( "models/props_wasteland/speakercluster01a.mdl" )
	self:SetColor( Color( 255, 0, 0, 255 ) )
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetHealth( 100 )
		self:SetMaxHealth( 100 )
	end
 
    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	self:SetNWInt( "Announce_Channel", 1 )
end

local cooldown = 0
function ENT:Use( activator, caller )
	if cooldown > CurTime() then return end
	local channel = self:GetNWInt( "Announce_Channel" )
	if channel == 5 then
		self:SetNWInt( "Announce_Channel", 1 )
	else
		self:SetNWInt( "Announce_Channel", channel + 1 )
	end
	activator:ChatPrint( "New Speaker Channel: "..channel )
	cooldown = CurTime() + 1
end

function ENT:OnTakeDamage( dmg )
	local d = dmg:GetDamage()
	self:SetHealth( self:Health() - d )
	if self:Health() <= 0 then
		local explode = ents.Create("env_explosion")
		explode:SetPos( self:GetPos() )
		explode:Spawn()
		explode:SetKeyValue( "iMagnitude", "0" )
		explode:Fire( "Explode", 0, 0 )
		self:Remove()
	end
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end
end