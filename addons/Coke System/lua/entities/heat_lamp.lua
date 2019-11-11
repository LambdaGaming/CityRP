
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Heat Lamp"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Cocaine System"

function ENT:SpawnFunction( ply, tr )
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 10
	local ent = ents.Create( "heat_lamp" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	ent.Owner = ply
	return ent
end

function ENT:Initialize()
	sound.Add( {
		name = "heat_lamp_idle",
		channel = CHAN_STATIC,
		volume = 0.65,
		level = 75,
		pitch = { 95, 110 },
		sound = "ambient/atmosphere/laundry_amb.wav"
	} )
    self:SetModel( "models/props/de_nuke/IndustrialLight01.mdl" )
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetHealth( 200 )
		self:SetMaxHealth( 200 )
	end
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self:SetNWBool( "TurnedOn", false )
	timer.Create( "LampFire"..self:EntIndex(), 300, 0, function()
		if self:GetNWBool( "TurnedOn" ) then
			local rand = math.random( 1, 100 )
			if rand <= 20 then
				if SERVER then
					self:Ignite()
					DarkRP.notify( self.Owner, 1, 6, "Your heat lamp is on fire!" )
				end
			end
		end
	end )
end

function ENT:TurnOff()
	self:SetNWBool( "TurnedOn", false )
	self.light:Remove()
	self:StopSound( "heat_lamp_idle" )
	self:EmitSound( "buttons/lightswitch2.wav" )
	if timer.Exists( "Lamp"..self:EntIndex() ) then
		timer.Remove( "Lamp"..self:EntIndex() )
	end
end

function ENT:TurnOn()
	self:SetNWBool( "TurnedOn", true )
	self.light = ents.Create("light_dynamic")
	self.light:SetPos( self:GetPos() + Vector( 0, 0, -30 ) )
	self.light:SetParent( self )
	self.light:SetKeyValue( "_light", "255 191 0 255" )
	self.light:SetKeyValue( "pitch", "180" )
	self.light:SetKeyValue( "distance", "1500" )
	self.light:Spawn()
	self:EmitSound( "heat_lamp_idle" )
	self:EmitSound( "buttons/lightswitch2.wav" )
	timer.Create( "Lamp"..self:EntIndex(), 180, 1, function() self:TurnOff() end )
end

function ENT:Use( activator, caller )
	local ison = self:GetNWBool( "TurnedOn" )
	if ison then
		self:TurnOff()
	else
		self:TurnOn()
	end
end

function ENT:OnRemove()
	self:StopSound( "heat_lamp_idle" )
end

function ENT:OnTakeDamage( dmg )
	local d = dmg:GetDamage()
	local health = self:Health()
	if health > 0 then
		self:SetHealth( health - d )
	else
		self:TurnOff()
		local e = ents.Create( "env_explosion" )
		e:SetPos( self:GetPos() )
		e:Spawn()
		e:SetKeyValue( "iMagnitude", "100" )
		e:Fire( "Explode", 0, 0 )
		self:Remove()
	end
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end
end