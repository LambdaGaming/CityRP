AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
    self:SetModel( "models/props_lab/box01a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetHealth( 50 )
	self:SetMaxHealth( 50 )
	self:SetUseType( SIMPLE_USE )
	self:PrecacheGibs()
 
    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:Use( activator, caller )
	if self:GetPlanted() and !self:ReadyForHarvest() then return end --Don't need to do anything while the plant is growing

	local PlantType = self:GetPlantType()
	local PlantTable = PlantTypes[PlantType]
	if self:GetPlanted() then
		if self:ReadyForHarvest() then
			for i=1, PlantTable.HarvestAmount do
				local e = ents.Create( "farm_food" )
				e:SetPos( self:GetPos() + Vector( 0, 0, i * 5 ) )
				e:SetPlantType( self:GetPlantType() )
				e:Spawn()
			end
			self:Remove()
		end
	else
		self:SetModel( PlantTable.PlantModel )
		self:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
		self:EmitSound( "physics/surfaces/sand_impact_bullet"..math.random( 1, 4 )..".wav" )
		self:SetMoveType( MOVETYPE_NONE )
		self:SetPlanted( true )
	end
end

function ENT:Think()
	if self:GetPlanted() and !self:ReadyForHarvest() then
		local tr = util.TraceLine( {
			start = self:GetPos() + Vector( 0, 0, 50 ),
			endpos = self:GetPos() + self:GetAngles():Up() * math.huge
		} )
		if tr.HitSky then --Make sure the plant is getting sunlight
			self:SetGrowth( self:GetGrowth() + 1 )
		end
	end
	self:NextThink( CurTime() + 1 )
	return true
end

function ENT:OnTakeDamage( dmg )
	local d = dmg:GetDamage()
	local health = self:Health()
	if health > 0 then
		self:SetHealth( health - d )
	else
		self:GibBreakClient( vector_origin )
		self:Remove()
	end
end