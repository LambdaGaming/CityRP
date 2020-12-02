AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Gold Bar"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Crafting Table"
ENT.DoNotDuplicate = true

function ENT:Initialize()
	if SERVER then
		self:SetModel( "models/props_c17/computer01_keyboard.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetMaterial( "models/player/shared/gold_player" )
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
