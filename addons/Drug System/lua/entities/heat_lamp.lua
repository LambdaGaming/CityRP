AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Heat Lamp"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Drugs"

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Fuel" )
	if SERVER then
		self:SetFuel( 0 )
	end
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

sound.Add( {
	name = "heat_lamp_idle",
	channel = CHAN_STATIC,
	volume = 0.85,
	level = 75,
	pitch = { 95, 110 },
	sound = "ambient/atmosphere/laundry_amb.wav"
} )

function ENT:Initialize()
    self:SetModel( "models/props/de_nuke/IndustrialLight01.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:SetHealth( 200 )
		self:SetMaxHealth( 200 )
		self.Active = false
		timer.Create( "LampFire"..self:EntIndex(), 300, 0, function()
			if self.Active then
				local rand = math.random( 1, 100 )
				if rand <= 20 then
					self:Ignite()
					DarkRP.notify( self.Owner, 1, 6, "Your heat lamp is on fire!" )
				end
			end
		end )
	end
	self:PhysWake()
end

if SERVER then
	function ENT:StartTouch(ent)
		if IsValid( ent ) and ent:GetClass() == "ent_gauto_fuel" then
			self:EmitSound( "physics/metal/metal_barrel_impact_soft"..math.random( 1, 4 )..".wav" )
			self:SetFuel( 200 )
			ent:Remove()
		end
	end

	function ENT:Think()
		local fuel = self:GetFuel()
		if self.Active and fuel > 0 then
			self:SetFuel( math.Clamp( fuel - 1, 0, 200 ) )
		elseif self.Active and fuel <= 0 then
			self:TurnOff()
		end
		self:NextThink( CurTime() + 2 )
		return true
	end

	function ENT:TurnOff()
		if self.light then
			self.light:Remove()
		end
		self.Active = false
		self:StopSound( "heat_lamp_idle" )
		self:EmitSound( "buttons/lightswitch2.wav" )
	end

	function ENT:TurnOn()
		if self:GetFuel() <= 0 then
			self:EmitSound( "buttons/lever6.wav" )
			return
		end
		self.Active = true
		self.light = ents.Create( "light_dynamic" )
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
		if IsValid( tr.Entity ) and tr.Entity:GetClass() == "farm_plant" then
			self.light:SetKeyValue( "_light", "255 191 0 255" )
		else
			self.light:SetKeyValue( "_light", "255 0 0 255" )
		end
	end

	function ENT:Use( activator, caller )
		if self.Active then
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
			local ply = dmg:GetAttacker()
			if ply:IsPlayer() and ply:isCP() then
				ply:addMoney( 200 )
				DarkRP.notify( ply, 0, 6, "You have been given $200 for destroying illegal contraband." )
			end
			self:TurnOff()
			CreateExplosion( self:GetPos(), 100 )
			self:Remove()
		end
	end
end
