
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Announcement Speaker"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Superadmin Only"

function ENT:SpawnFunction( ply, tr )
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 1
	local ent = ents.Create( "announcement_speaker" )
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
	end
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self:SetHealth( 100 )
	self:SetMaxHealth( 100 )
	self:SetNWInt( "Channel", 1 )
end

function ENT:Use( activator, caller )
	local channel = self:GetNWInt( "Channel" )
	if channel == 5 then
		self:SetNWInt( "Channel", 1 )
	else
		self:SetNWInt( "Channel", channel + 1 )
	end
	activator:ChatPrint( "New Speaker Channel: "..channel )
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