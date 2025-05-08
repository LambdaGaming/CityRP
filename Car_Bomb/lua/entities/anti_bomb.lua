
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Car Bomb Protection"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Car Bomb"

function ENT:SpawnFunction( ply, tr, name )
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 1
	local ent = ents.Create( name )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
    self:SetModel( "models/props_junk/metal_paintcan001a.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:SetTrigger( true )
	end
 
    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:Use( caller, activator )
	if SERVER then
		DarkRP.notify( caller, 0, 6, "Touch this with a car to add bomb protection." )
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

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end
end