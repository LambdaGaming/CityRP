
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
 
    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:Use( activator, caller )
	local PlantType = self:GetPlantType()
	local PlantTable = PlantTypes[PlantType]
	activator:SetHealth( math.Clamp( activator:Health() + PlantTable.HealthAmount, 0, activator:GetMaxHealth() ) )
	self:EmitSound( "npc/barnacle/barnacle_crunch"..math.random( 2, 3 )..".wav" )
	self:Remove()
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end
end
