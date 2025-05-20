AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Pure Cocaine"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Drugs"

function ENT:SetupDataTables()
	self:NetworkVar( "Int", "Purity" )
	if SERVER then
		self:SetPurity( 0 )
	end
end

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
end

function ENT:Use( ply )
	ply:SetGravity( 0.5 )
	ply:SetHealth( 200 )
	ply:SetArmor( 100 )
	ply:SetRunSpeed( 400 )
	ply:SetWalkSpeed( 200 )
	ply:AddOD( 3 )
	ply:DrugEffect()
	ply:SetDSP( 13 )
	timer.Simple( self:GetPurity() * 6, function()
		if !IsValid( ply ) or ply:GetNWInt( "Overdose" ) == 0 then return end
		ply:SetGravity( 1 )
		ply:TakeDamage( 145 )
		ply:SetArmor( 0 )
		ply:SetRunSpeed( 245 )
		ply:SetWalkSpeed( 165 )
		ply:DrugEffect( true )
		ply:SetDSP( 1 )
	end )
	self:Remove()
end
