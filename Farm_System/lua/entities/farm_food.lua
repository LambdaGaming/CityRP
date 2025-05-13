AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Farm Food"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = false

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "PlantType" )
end

function ENT:Initialize()
	local PlantType = self:GetPlantType()
	local PlantTable = PlantTypes[PlantType]
    self:SetModel( PlantTable.FoodModel )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetMaterial( PlantTable.FoodMaterial )
	self:SetColor( PlantTable.LabelColor )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
	end
	self:PhysWake()
end

function ENT:Use( ply )
	local PlantType = self:GetPlantType()
	local PlantTable = PlantTypes[PlantType]
	ply:SetHealth( math.Clamp( ply:Health() + PlantTable.HealthAmount, 0, ply:GetMaxHealth() ) )
	self:EmitSound( "npc/barnacle/barnacle_crunch"..math.random( 2, 3 )..".wav" )
	self:Remove()
end
