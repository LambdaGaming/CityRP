AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Heat Lamp"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Drugs"

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "HasCanister" )
	self:NetworkVar( "Entity", 0, "Canister" )
end

function ENT:SpawnFunction( ply, tr, name )
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 10
	local ent = ents.Create( name )
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
		volume = 0.85,
		level = 75,
		pitch = { 95, 110 },
		sound = "ambient/atmosphere/laundry_amb.wav"
	} )
    self:SetModel( "models/props/de_nuke/IndustrialLight01.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:SetHealth( 200 )
		self:SetMaxHealth( 200 )
	end
	self:PhysWake()
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

if SERVER then
	function ENT:StartTouch(ent)
		if IsValid( ent ) and ent:GetClass() == "rp_gas" and !self:GetHasCanister() and !ent:GetHasStove() then
			if !ent:IsReadyForStove() then return end
			self:SetHasCanister( true )
			self:SetCanister( ent )
			ent:SetHasStove( true )
			ent:SetStove( self )
			local weld = constraint.Weld( self, ent, 0, 0, 0, true, false )
			self:EmitSound( "physics/metal/metal_barrel_impact_soft"..math.random( 1, 4 )..".wav" )
			local phys = self:GetPhysicsObject()
			phys:SetMass( 1 )
		end
	end

	function ENT:Think()
		if self:GetNWBool( "TurnedOn" ) and self:GetHasCanister() then
			local fuel = self:GetCanister():GetFuel()
			if fuel > 0 then
				self:GetCanister():SetFuel( math.Clamp( fuel - 1, 0, 200 ) )
			else
				self:TurnOff()
			end
		elseif self:GetNWBool( "TurnedOn" ) and !self:GetHasCanister() then
			self:TurnOff()
		end
		self:NextThink( CurTime() + 2 )
		return true
	end
end

function ENT:TurnOff()
	if self.light then
		self.light:Remove()
	end
	self:SetNWBool( "TurnedOn", false )
	self:StopSound( "heat_lamp_idle" )
	self:EmitSound( "buttons/lightswitch2.wav" )
end

function ENT:TurnOn()
	if !self:GetHasCanister() or self:GetCanister():GetFuel() <= 0 then
		self:EmitSound( "buttons/lever6.wav" )
		return
	end
	self:SetNWBool( "TurnedOn", true )
	self.light = ents.Create("light_dynamic")
	self.light:SetPos( self:GetPos() + Vector( 0, 0, -30 ) )
	self.light:SetParent( self )
	self.light:SetKeyValue( "pitch", "180" )
	self.light:SetKeyValue( "distance", "1500" )
	self.light:Spawn()
	self:EmitSound( "heat_lamp_idle" )
	self:EmitSound( "buttons/lightswitch2.wav" )

	local tr = util.TraceLine( {
		start = self:GetPos() + Vector( 0, 0, -50 ),
		endpos = self:GetPos() + self:GetAngles():Up() * -200
	} )
	if IsValid( tr.Entity ) and string.find( tr.Entity:GetClass(), "coca_plant_" ) then
		self.light:SetKeyValue( "_light", "255 191 0 255" )
	else
		self.light:SetKeyValue( "_light", "255 0 0 255" )
	end
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
