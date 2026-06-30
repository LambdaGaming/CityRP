AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Meth Filler"
ENT.Author = "OPGman"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Drugs"

function ENT:Initialize()
    self:SetModel( "models/props_junk/garbage_plasticbottle001a.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
	end
	self:PhysWake()
end

function ENT:Use( ply )
	DarkRP.notify( ply, 0, 6, "Touch this with a meth mixer to begin the meth making process." )
end
