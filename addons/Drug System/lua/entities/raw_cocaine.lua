AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Raw Cocaine"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Drugs"

function ENT:Initialize()
    self:SetModel( "models/props/cs_assault/Money.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
	end
	self:PhysWake()
	self:SetMaterial( "models/debug/debugwhite" )
	self:SetColor( color_darkgray )
end
