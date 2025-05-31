AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Meth Oven"
ENT.Author = "OPGman"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Drugs"

function ENT:SetupDataTables()
	self:NetworkVar( "Int", "Fuel" )
	if SERVER then
		self:SetFuel( 0 )
	end
end

sound.Add( {
	name = "meth_oven_idle",
	channel = CHAN_STATIC,
	volume = 1,
	level = 75,
	pitch = { 95, 110 },
	sound = "ambient/atmosphere/laundry_amb.wav"
} )

function ENT:Initialize()
    self:SetModel( "models/props_wasteland/kitchen_stove001a.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:SetHealth( 200 )
		self:SetMaxHealth( 200 )
		self.Active = false
		self.HasMeth = false
		self.Ingredients = {}
	end
	self:PhysWake()
end

if SERVER then
	function ENT:StartTouch( ent )
		if ent:GetClass() == "ent_gauto_fuel" then
			self:EmitSound( "physics/metal/metal_barrel_impact_soft"..math.random( 1, 4 )..".wav" )
			self:SetFuel( 100 )
			ent:Remove()
		elseif ent:GetClass() == "drug_meth" and !ent:GetBaked() and self.Active and !self.HasMeth then
			self.Ingredients = ent.Ingredients
			self.HasMeth = true
			ent:Remove()
			timer.Simple( 300, function()
				if !IsValid( self ) then return end
				self:EmitSound( "zpizmak/kitchentimer_ding.wav" )
				self.Ready = true
				timer.Simple( 120, function()
					if !IsValid( self ) or !self.Ready then return end
					CreateExplosion( self:GetPos(), 200 )
				end )
			end )
		end
	end

	function ENT:Think()
		local fuel = self:GetFuel()
		if !self.Active and fuel > 0 then
			self.Active = true
			self.light = ents.Create( "light_dynamic" )
			self.light:SetPos( self:GetPos() )
			self.light:SetParent( self )
			self.light:SetKeyValue( "pitch", "180" )
			self.light:SetKeyValue( "distance", "1500" )
			self.light:SetKeyValue( "_light", "255 191 0 255" )
			self.light:Spawn()
			self:EmitSound( "heat_lamp_idle" )
		elseif self.Active and fuel > 0 then
			self:SetFuel( math.Clamp( fuel - 1, 0, 100 ) )
		elseif self.Active and fuel <= 0 then
			self.light:Remove()
			self.Active = false
			self:StopSound( "heat_lamp_idle" )
		end
		self:NextThink( CurTime() + 2 )
		return true
	end

	function ENT:Use( ply )
		if self.Ready then
			local e = ents.Create( "drug_meth" )
			e:SetPos( self:GetPos() + self:GetForward() * 5 )
			e.Ingredients = self.Ingredients
			self.HasMeth = false
			self.Ready = false
		elseif self.HasMeth then
			DarkRP.notify( ply, 1, 6, "Wait for the baking to finish before taking the meth out." )
		else
			DarkRP.notify( ply, 0, 6, "Insert fuel and unbaked meth to create the final product." )
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
				ply:addMoney( 500 )
				DarkRP.notify( ply, 0, 6, "You have been given $500 for destroying illegal contraband." )
			end
			CreateExplosion( self:GetPos(), 200 )
			self:Remove()
		end
	end
end

if CLIENT then
	local offset = Vector( 0, 0, 65 )
	function ENT:Draw()
		local fuel = self:GetFuel()
		self:DrawNPCText( "Meth Oven\nFuel: "..fuel.."%", offset )
	end
end
