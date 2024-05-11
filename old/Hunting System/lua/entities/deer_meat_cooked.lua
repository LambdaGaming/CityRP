
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Cooked Deer Meat"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Superadmin Only"

function ENT:SpawnFunction( ply, tr )
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 1
	local ent = ents.Create( "deer_meat_cooked" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
    self:SetModel( "models/foodnhouseholditems/meat8.mdl" )
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
end

function ENT:Use( activator, caller )
	if caller:IsPlayer() then
		caller:SetHealth( math.Clamp( caller:Health() + 50, 0, 100 ) )
		if team.NumPlayers( TEAM_COOK ) >= 1 then
			caller:setDarkRPVar( "Energy", math.Clamp( caller:getDarkRPVar( "Energy" ) + 50, 0, 100 ) )
		end
		self:EmitSound( "vo/sandwicheat09.mp3" )
		self:Remove()
	end
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end
end