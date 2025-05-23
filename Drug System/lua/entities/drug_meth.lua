AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Meth"
ENT.Author = "OPGman"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Drugs"

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", "Baked" )
	if SERVER then
		self:SetBaked( true )
	end
end

function ENT:Initialize()
	if self:GetBaked() then
		self:SetModel( "models/props_junk/rock001a.mdl" )
		self:SetColor( color_cyan )
		self:SetMaterial( "models/debug/debugwhite" )
	else
		self:SetModel( "models/props_junk/rock001a.mdl" )
	end
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self.Ingredients = {}
		self.Quality = 0
	end
	self:PhysWake()
end

function ENT:Use( ply )
	if !self:GetBaked() then
		DarkRP.notify( ply, 1, 6, "This meth needs baked in a meth oven before it can be consumed." )
		return
	end
	local ing = self.Ingredients
	ply:SetHealth( 130 )
	ply:SetArmor( 50 )
	ply:SetGravity( 0.5 )
	if ing.Weed then
		local amount = self:Health() + ( ing.Weed * 5 )
		ply:SetHealth( math.Clamp( amount, 0, 200 ) )
	end
	if ing.SpicyWeed then
		ply:GodEnable()
		ply:Ignite( 180, 50 )
	end
	if ing.Cocaine then
		ply:SetGravity( 0.1 )
		ply:SetRunSpeed( 400 )
		ply:SetWalkSpeed( 200 )
	end
	if ing.SlotMachine then
		ply:addMoney( ing.SlotMachine * 600 )
	end
	if ing.MediaPlayer then
		ply:SetMaterial( "" )
	end
	if ing.BoomBox then
		if ing.BoomBox >= 5 then
			CreateExplosion( ply:GetPos(), 200 )
		else
			ply:EmitSound( "music/hl1_song11.mp3" )
		end
	end
	if ing.HeatLamp then
		ply.DrugGlow = ents.Create( "light_dynamic" )
		ply.DrugGlow:SetPos( self:GetPos() + Vector( 0, 0, 35 ) )
		ply.DrugGlow:SetParent( self )
		ply.DrugGlow:SetKeyValue( "pitch", "180" )
		ply.DrugGlow:SetKeyValue( "distance", "1500" )
		ply.DrugGlow:SetKeyValue( "_light", "255 191 0 255" )
		ply.DrugGlow:Spawn()
	end
	if ing.Steroid then
		ply.Infected = true
	end
	if ing.Steel then
		ply:SetArmor( ing.Steel * 50 )
	end
	ply:AddOD( 4 )
	ply:DrugEffect()
	ply:SetDSP( 16 )
	timer.Create( "MethHigh"..ply:EntIndex(), 300, 1, function()
		if IsValid( ply ) then
			ply:EndHigh()
			if ing.SlotMachine then
				local money = ply:getDarkRPVar( "money" )
				if money == 0 then
					ply:Kill()
				else
					ply:addMoney( -money )
					ply:createMoneyBag( ply:GetPos(), money )
				end
			end
			if ing.Steroid then
				ply:Kill()
			end
		end
	end )
	self:Remove()
end
