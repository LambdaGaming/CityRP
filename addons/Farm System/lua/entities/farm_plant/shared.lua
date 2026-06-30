ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Farm Plant"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true 
ENT.Category = "Farm System"

function ENT:SetupDataTables()
    self:NetworkVar( "Int", 0, "PlantType" )
    self:NetworkVar( "Int", 1, "Growth" )
    self:NetworkVar( "Bool", 0, "Planted" )
end

function ENT:ReadyForHarvest()
    local PlantType = self:GetPlantType()
    local Growth = PlantTypes[PlantType].GrowthTime
    return self:GetGrowth() >= Growth
end
