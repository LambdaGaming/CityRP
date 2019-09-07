AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Cooked Fish"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Cooking Stove"

function ENT:SpawnFunction( ply, tr )
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 1
	local ent = ents.Create( "cooked_fish" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
    self:SetModel( "models/props/CS_militia/fishriver01.mdl" )
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
	end
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end
end

function ENT:Use(caller, activator)
	caller:SetHealth( math.Clamp( caller:Health() + 50, 0, 100) )
	caller:setSelfDarkRPVar( "Energy", math.Clamp( caller:getDarkRPVar("Energy") + 20, 0, 100 ) )
	self:EmitSound("eating_and_drinking/eating.wav")
	self:Remove()
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end
end