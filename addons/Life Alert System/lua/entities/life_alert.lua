AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Life Alert"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Life Alert System"

function ENT:Initialize()
    self:SetModel( "models/props_lab/reciever01d.mdl" )
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
	end
	self:PhysWake()
end

function ENT:Use( ply )
	if ply.haslifealert then
		ply:ChatPrint( "You already have life alert!" )
		return
	end
	ply.haslifealert = true
	ply:ChatPrint( "You now have life alert!" )
	self:EmitSound( "buttons/button18.wav" )
	self:Remove()
end
