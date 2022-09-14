AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

local ores = {
	["Ruby"] = { color_red, 30, { 7, 15 } },
	["Gold"] = { color_yellow, 60, { 3, 5 } },
	["Diamond"] = { Color( 100, 100, 255 ), 160, { 1, 3 } },
	["Rock"] = { Color( 128, 128, 128 ), 10, { 1, 3 } }
}

function ENT:SpawnFunction( ply, tr, name )
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 100
	local ent = ents.Create( name )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
    self:SetModel( table.Random( CRAFT_CONFIG_ROCK_MODELS ) )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:SetRenderMode( RENDERMODE_TRANSCOLOR )
	
    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end

	self:SetHealth( CRAFT_CONFIG_ROCK_HEALTH )
	self:SetMaxHealth( CRAFT_CONFIG_ROCK_HEALTH )
	self:SetNWBool( "IsHidden", false )
	hook.Run( "Craft_Rock_OnSpawn", self )
	self.Loot = {}
	self:CreateLoot()
end

function ENT:Unhide()
	self:SetSolid( SOLID_VPHYSICS )
	self:SetColor( color_white )
	self:SetNWBool( "IsHidden", false )
	self:SetHealth( self:GetMaxHealth() )
	self:CreateLoot()
	hook.Run( "Craft_Rock_OnRespawn", self )
end

function ENT:Hide()
	local color = self:GetColor()
	self:SetSolid( SOLID_NONE )
	self:SetColor( ColorAlpha( color, 0 ) )
	self:SetNWBool( "IsHidden", true )
	timer.Create( "Hidden_"..self:EntIndex(), CRAFT_CONFIG_ROCK_RESPAWN, 1, function()
		if IsValid( self ) then
			self:Unhide()
		end
	end )
end

local function GetRandomOre( type )
	local tbl = { "Ruby", "Gold", "Diamond" }
	return table.Random( tbl )
end

--[[
	Loot table structure:
	{ EntName, Amount, OreType }
	OR
	{ EntName, Amount }
]]
function ENT:CreateLoot()
	local rand = math.random( 1, 100 )
	if rand >= 60 then
		local rand2 = math.random( 0, 1 )
		table.insert( self.Loot, {"mgs_ore", 2, "Rock" } )
		if rand2 == 1 then
			table.insert( self.Loot, { "ironbar", 2 } )
		else
			table.insert( self.Loot, {"mgs_ore", 2, GetRandomOre() } )
		end
	elseif rand >= 30 and rand < 60 then
		local rand2 = math.random( 0, 1 )
		table.insert( self.Loot, {"mgs_ore", "Rock", 2 } )
		if rand2 == 1 then
			table.insert( self.Loot, { "ironbar", 4 } )
		else
			table.insert( self.Loot, {"mgs_ore", 4, GetRandomOre() } )
		end
	elseif rand >= 10 and rand < 30
		table.insert( self.Loot, { "mgs_ore", 3, GetRandomOre() } )
		table.insert( self.Loot, { "ironbar", 3 } )
	elseif rand > 1 and rand < 10 then
		table.insert( self.Loot, { "mgs_ore", 6, GetRandomOre() } )
		table.insert( self.Loot, { "ironbar", 6 } )
	else
		table.insert( self.Loot, { "ironbar", 15 } )
	end
end

function ENT:SpawnLoot()
	for k,v in pairs( self.Loot ) do
		for i = 1, v[2] do
			local e = ents.Create( v[1] )
			e:SetPos( self:GetPos() + Vector( math.Rand( 1, 20 ), math.Rand( 1, 20 ), 20 ) )
			if #self.Loot == 3 then
				e:SetNWInt( "price", ores[v[3]][2] )
				e:SetNWInt( "mass", math.Rand( ores[v[3]][3][1], ores[v[3]][3][2] ) )
				e:SetNWString( "type", v[3] )
				e:SetColor( ores[v[3]][1] )
			end
			e:Spawn()
		end
	end
end

function ENT:OnTakeDamage( dmg )
	local ply = dmg:GetAttacker()
	local wep = ply:GetActiveWeapon()
	local hidden = self:GetNWBool( "IsHidden" )
	local wepclass = string.lower( wep:GetClass() )
	if !ply:IsPlayer() or self:Health() <= 0 then return end
	if CRAFT_CONFIG_MINE_WHITELIST_ROCK[wepclass] then
		local health = self:Health()
		local maxhealth = self:GetMaxHealth()
		local damage
		damage = dmg:GetDamage()
		self:SetHealth( math.Clamp( health - damage, 0, maxhealth ) )
	end
	if self:Health() <= 0 and !hidden then
		self:Hide()
		SpawnLoot()
		hook.Run( "Craft_Rock_OnMined", self, ply )
	end
end

function ENT:OnRemove()
	local index = self:EntIndex()
	if timer.Exists( "Hidden_"..index ) then
		timer.Remove( "Hidden_"..index )
	end
end
