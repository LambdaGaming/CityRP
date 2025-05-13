AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Pure Cocaine"
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
end

function ENT:Use( activator, caller )
	activator:SetDSP( 6 )
	activator:SetGravity( 0.5 )
	activator:SetHealth( 200 )
	activator:SetArmor( 100 )
	activator:SetRunSpeed( 400 )
	activator:SetWalkSpeed( 200 )
	timer.Simple( 30, function()
		activator:SetDSP( 1, false )
		activator:SetGravity( 1 )
		activator:SetHealth( activator:Health() - 145 )
		activator:SetArmor( 0 )
		activator:SetRunSpeed( 245 )
		activator:SetWalkSpeed( 165 )
		if activator:Health() <= 0 then
			activator:Kill()
		elseif activator.od >= 5 and activator.od <= 8 then
			activator:SetWalkSpeed( 110 )
			activator:SetRunSpeed( 163 )
			if !activator:GetNWBool( "HasOD" ) then
				timer.Create( "ODGroan"..activator:EntIndex(), 5, 0, function()
					if !IsValid( activator ) then return end
					activator:EmitSound( "vo/npc/male01/moan0"..math.random( 1, 5 )..".wav" )
				end )
				activator:SetNWBool( "HasOD", true )
			end
		elseif activator.od > 8 then
			activator:Kill()
		end
	end )
	self:Remove()
end
