AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Car Bomb Protection"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Car Bomb"

function ENT:Initialize()
    self:SetModel( "models/props_junk/metal_paintcan001a.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:SetTrigger( true )
	end
	self:PhysWake()
end

function ENT:Use( ply )
	if SERVER then
		DarkRP.notify( ply, 0, 6, "Touch this with a car to add bomb protection." )
	end
end

function ENT:StartTouch( ent )
	if ent:IsVehicle() and !ent.hasbombprotection then
		ent.hasbombprotection = true
		local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		util.Effect( "cball_explode", effectdata )
		self:EmitSound( "physics/metal/metal_canister_impact_hard"..math.random( 1, 3 )..".wav" )
		self:Remove()
	end
end
