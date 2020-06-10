
CreateConVar( "VF_VehicleExplodeTime", 30, FCVAR_NONE, "How many seconds it takes for a vehicle that's on fire to explode. Set to 0 to instantly explode when ignited." )
CreateConVar( "VF_VehicleExplodeMagnitude", 100, FCVAR_NONE, "The magnitude of the vehicle explosion, the higher the number, the greater the range and the more damage it does. 0 to disable." )
CreateConVar( "VF_VehicleRemoveTime", 600, FCVAR_NONE, "How many seconds until the vehicle gets removed after exploding. Set to -1 to never remove and 0 to instantly remove." )

local explodetime = GetConVar( "VF_VehicleExplodeTime" ):GetInt()
local magnitude = GetConVar( "VF_VehicleExplodeMagnitude" ):GetInt()
local removetime = GetConVar( "VF_VehicleRemoveTime" ):GetInt()

local veh = FindMetaTable( "Vehicle" )
function veh:VF_Explode()
	local pos = self:GetPos()
	local explode = ents.Create( "env_explosion" )
	explode:SetPos( pos )
	explode:Spawn()
	explode:SetKeyValue( "iMagnitude", magnitude )
	explode:Fire( "Explode", 0, 0 )
end

function veh:VF_CreateProp()
	local model = self:GetModel()
	local pos = self:GetPos()
	local ang = self:GetAngles()
	local e = ents.Create( "prop_physics" ) --Creates a physics prop and puts it in place of the vehicle that exploded
	e:SetPos( pos )
	e:SetModel( model )
	e:SetAngles( ang )
	e:SetColor( Color( 128, 128, 128 ) )
	e:SetMaterial( "models/props_foliage/tree_deciduous_01a_trunk" ) --Sets the material to make it look like the car was scorched
	e:Spawn()
	self:Remove()
	if removetime > -1 then
		if removetime == 0 then
			e:Remove()
		else
			timer.Simple( removetime, function()
				if IsValid( e ) then e:Remove() end
			end )
		end
	end
end

hook.Add( "vFireEntityStartedBurning", "VF_OnIgnite", function( ent )
	if IsValid( ent ) and ent:GetClass() == "prop_vehicle_jeep" and !timer.Exists( "VF_VehicleExplode"..ent:EntIndex() ) and ent:IsOnFire() then
		timer.Create( "VF_VehicleExplode"..ent:EntIndex(), explodetime, 1, function()
			if !IsValid( ent ) then return end
			ent:VF_Explode()
			ent:VF_CreateProp()
		end )
	end
end )

hook.Add( "vFireEntityStoppedBurning", "VF_OnExtinguish", function( ent )
	if IsValid( ent ) and ent:GetClass() == "prop_vehicle_jeep" and timer.Exists( "VF_VehicleExplode"..ent:EntIndex() ) then
		timer.Remove( "VF_VehicleExplode"..ent:EntIndex() )
	end
end )
