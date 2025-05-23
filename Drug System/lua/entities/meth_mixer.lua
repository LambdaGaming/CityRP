AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Meth Mixer"
ENT.Author = "OPGman"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Drugs"

sound.Add( {
	name = "meth_mixer_idle",
	channel = CHAN_STATIC,
	volume = 1,
	level = 75,
	pitch = { 95, 110 },
	sound = "ambient/machines/laundry_machine1_amb.wav"
} )

function ENT:SetupDataTables()
	self:NetworkVar( "Int", "NumIngredients" )
	if SERVER then
		self:SetNumIngredients( 0 )
	end
end

function ENT:Initialize()
    self:SetModel( "models/props_wasteland/laundry_washer001a.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:SetHealth( 200 )
		self:SetMaxHealth( 200 )
		self.Active = false
		self.Ingredients = {}
		self.Quality = 0
	end
	self:PhysWake()
end

if SERVER then
	function ENT:AddIngredient( name, quality )
		local ing = self.Ingredients
		ing[name] = ing[name] and ing[name] + 1 or 1
		self.Quality = self.Quality + quality
		self:SetNumIngredients( self:GetNumIngredients() + 1 )
	end

	function ENT:Use( ply )
		if self.Active then
			DarkRP.notify( ply, 0, 6, "The mixer is currently mixing up a batch." )
		elseif self:GetNumIngredients() < 10 then
			local left = 10 - self:GetNumIngredients()
			DarkRP.notify( ply, 1, 6, "You need to add "..left.." more ingredients for the mixing to start." )
		end
	end

	function ENT:StartTouch( ent )
		if self.Active then return end
		local c = ent:GetClass()
		if c == "meth_filler" then
			self:AddIngredient( "Filler", 100 )
			ent:Remove()
		elseif c == "drug_weed" then
			if ent:GetWeedType() == 2 then
				self:AddIngredient( "SpicyWeed", 1200 )
			else
				self:AddIngredient( "Weed", 300 )
			end
			ent:Remove()
		elseif c == "drug_cocaine" then
			self:AddIngredient( "Cocaine", ent:GetPurity() * 60 )
			ent:Remove()
		elseif c == "ent_gauto_fuel" then
			self:AddIngredient( "Fuel", 0 )
			ent:Remove()
		elseif c == "slot_machine" then
			self:AddIngredient( "SlotMachine", 1000 )
			ent:Remove()
		elseif c == "mediaplayer_tv" then
			self:AddIngredient( "MediaPlayer", 500 )
			ent:Remove()
		elseif c == "boombox" then
			self:AddIngredient( "Boombox", 650 )
			ent:Remove()
		elseif c == "heat_lamp" then
			self:AddIngredient( "HeatLamp", 800 )
			ent:Remove()
		elseif c == "zombie_experiment" then
			self:AddIngredient( "Steroid", 6000 )
			ent:Remove()
		elseif c == "ucs_steel" then
			self:AddIngredient( "Steel", 500 )
			ent:Remove()
		end
		if self:GetNumIngredients() == 10 then
			if self.Ingredients.Fuel then
				CreateExplosion( self:GetPos(), 200 )
				return
			end
			self:EmitSound( "meth_mixer_idle" )
			self.Active = true
			timer.Simple( 600, function()
				if !IsValid( self ) then return end
				self:StopSound( "meth_mixer_idle" )
				self.Active = false
				local e = ents.Create( "drug_meth" )
				e:SetPos( self:GetPos() + self:GetForward() * 5 )
				e:SetBaked( false )
				e:Spawn()
				e.Ingredients = self.Ingredients
				e.Quality = self.Quality
				self.Ingredients = {}
				self.Quality = 0
			end )
		end
	end

	function ENT:OnTakeDamage( dmg )
		local d = dmg:GetDamage()
		local health = self:Health()
		if health > 0 then
			self:SetHealth( health - d )
		else
			CreateExplosion( self:GetPos(), 100 )
			self:Remove()
		end
	end

	function ENT:OnRemove()
		self:EmitSound( "meth_mixer_idle" )
	end
end

if CLIENT then
	local offset = Vector( 0, 0, 60 )
	function ENT:Draw()
		local ing = self:GetNumIngredients()
		self:DrawNPCText( "Meth Mixer\nIngredients: "..ing.."/10", offset )
	end
end
