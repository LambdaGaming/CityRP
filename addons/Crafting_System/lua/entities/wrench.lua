AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Wrench"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Crafting Table"
ENT.DoNotDuplicate = true

function ENT:Initialize()
	if SERVER then
		self:SetModel( "models/props_c17/tools_wrench01a.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		local phys = self:GetPhysicsObject()
		if IsValid( phys ) then
			phys:Wake()
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end
