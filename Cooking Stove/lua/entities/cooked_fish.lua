AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Cooked Fish"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Cooking Stove"

function ENT:Initialize()
    self:SetModel( "models/props/CS_militia/fishriver01.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
	end
	self:PhysWake()
end

function ENT:Use( ply )
	ply:SetHealth( ply:GetMaxHealth() )
	ply:setSelfDarkRPVar( "Energy", 100 )
	self:EmitSound( "npc/barnacle/barnacle_gulp"..math.random( 1, 2 )..".wav" )
	self:Remove()
end
