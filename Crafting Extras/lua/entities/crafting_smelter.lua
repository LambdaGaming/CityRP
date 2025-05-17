AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Smelter"
ENT.Author = "OPGman"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Universal Crafting System"

function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "Smelt" )
	if SERVER then
		self:SetSmelt( "N/A" )
	end
end

function ENT:Initialize()
	self:SetModel( "models/props/cs_militia/furnace01.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:SetTrigger( true )
		self.SmeltTable = {}
		self.Smelting = false
		self.SmeltSound = CreateSound( self, "ambient/gas/steam_loop1.wav" )
	end
	self:PhysWake()
end

function ENT:Use( ply )
	DarkRP.notify( ply, 0, 6, "Touch iron or crafted items with this to smelt them." )
end

function ENT:Touch( ent )
	if self.Smelting then return end
	local class = ent:GetClass()
	if class == "spawned_weapon" or CraftingRecipe[class] then
		local finalClass = ent.GetWeaponClass and ent:GetWeaponClass() or ent:GetClass()
		if !CraftingRecipe[finalClass] then return end
		for k,v in pairs( CraftingRecipe[finalClass].Materials ) do
			if v >= 2 then
				local num = math.Round( v * 0.5 )
				self.SmeltTable[k] = num
			end
		end
		ent:Remove()
		self:SetSmelt( CraftingRecipe[finalClass].Name )
		self.Smelting = true
		self.SmeltSound:Play()
		local time = ( self.SmeltTable["ucs_iron"] or 1 ) * 30
		timer.Simple( time, function()
			if !IsValid( self ) then return end
			local count = 0
			for k,v in pairs( self.SmeltTable ) do
				for i=1,v do
					local e = ents.Create( k )
					e:SetPos( self:GetPos() + ( self:GetForward() * 30 ) + Vector( 0, 0, count * 10 ) )
					e:Spawn()
					count = count + 1
				end
			end
			self:EmitSound( "ambient/fire/mtov_flame2.wav" )
			self:SetSmelt( "N/A" )
			self.Smelting = false
			self.SmeltSound:Stop()
		end )
	elseif class = "ucs_iron" then
		ent:Remove()
		self:SetSmelt( "Iron" )
		self.Smelting = true
		self.SmeltSound:Play()
		timer.Simple( 30, function()
			if !IsValid( self ) then return end
			local e = ents.Create( "ucs_steel" )
			e:SetPos( self:GetPos() + self:GetForward() * 30 )
			e:Spawn()
			self:EmitSound( "ambient/fire/mtov_flame2.wav" )
			self:SetSmelt( "N/A" )
			self.Smelting = false
			self.SmeltSound:Stop()
		end )
	end
end

if CLIENT then
	function ENT:Draw()
		local smelt = self:GetSmelt()
		self:DrawNPCText( "Currently Smelting: "..smelt )
	end
end
