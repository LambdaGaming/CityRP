AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
    self:SetModel( "models/props_lab/box01a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetHealth( 50 )
	self:SetMaxHealth( 50 )
	self:SetUseType( SIMPLE_USE )
	self:PrecacheGibs()
	self:PhysWake()
end

function ENT:Use( ply )
	if self:GetPlanted() and !self:ReadyForHarvest() then return end --Don't need to do anything while the plant is growing

	local PlantType = self:GetPlantType()
	local PlantTable = PlantTypes[PlantType]
	if self:GetPlanted() then
		if self:ReadyForHarvest() then
			for i=1, PlantTable.HarvestAmount do
				if PlantTable.HarvestOverride then
					PlantTable.HarvestOverride( self, i )
				else
					local e = ents.Create( "farm_food" )
					e:SetPos( self:GetPos() + Vector( 0, 0, i * 5 ) )
					e:SetPlantType( self:GetPlantType() )
					e:Spawn()
				end
			end
			self:EmitSound( "physics/surfaces/sand_impact_bullet"..math.random( 1, 4 )..".wav" )
			self:SetGrowth( 0 )
		end
	else
		self:SetModel( PlantTable.PlantModel )
		self:SetAngles( Angle( 0, self:GetAngles().yaw, 0 ) )
		self:EmitSound( "physics/surfaces/sand_impact_bullet"..math.random( 1, 4 )..".wav" )
		self:SetMoveType( MOVETYPE_NONE )
		self:SetPlanted( true )
	end
end

function ENT:Think()
	if self:GetPlanted() and !self:ReadyForHarvest() then
		local tr = util.TraceLine( {
			start = self:GetPos() + Vector( 0, 0, 100 ),
			endpos = self:GetPos() + self:GetAngles():Up() * 100000
		} )
		local lamp = tr.Entity
		local gotHeat = IsValid( lamp ) and lamp:GetClass() == "heat_lamp" and lamp.Active
		if tr.HitSky or gotHeat then --Make sure the plant is getting sunlight or is below an active heat lamp
			local amount = 1
			if EcoPerkActive( "Cut Agricultural Budget" ) then
				amount = 0.5
			elseif EcoPerkActive( "Increase Agricultural Budget" ) then
				amount = 2
			end
			self:SetGrowth( self:GetGrowth() + amount )
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
		local ply = dmg:GetAttacker()
		local contraband = { [6] = true, [7] = true, [8] = true }
		if ply:IsPlayer() and ply:isCP() and contraband[self:GetPlantType()] then
			ply:addMoney( 200 )
			DarkRP.notify( ply, 0, 6, "You have been given $200 for destroying illegal contraband." )
		end
		self:GibBreakClient( vector_origin )
		self:Remove()
	end
end
