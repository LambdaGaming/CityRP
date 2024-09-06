local map = game.GetMap()
local cooldown = 0
local event_truck

local function OverturnedTruckThink()
	for k,v in pairs( ents.FindByModel( "models/tdmcars/trucks/gmc_c5500.mdl" ) ) do
		if v.IsEventTruck then
			if !v.FlippedOver and math.Round( v:GetAngles().x ) == 0 then
				v.FlippedOver = true
				OverturnedTruckEnd()
			end
	    end
	end
end

function OverturnedTruck()
	local randtruck = table.Random( EventPos[map].Truck )
	event_truck = ents.Create( "prop_physics" )
	event_truck:SetPos( randtruck )
	event_truck:SetAngles( Angle( 90, 0, 0 ) )
	event_truck:SetModel( "models/tdmcars/trucks/gmc_c5500.mdl" )
	event_truck:Spawn()
	event_truck:Activate()
	event_truck:Fire( "Lock", 0, 0 )
	event_truck.IsEventTruck = true
	event_truck:GetPhysicsObject():SetMass( 10000 )
	
	for k,v in ipairs( player.GetAll() ) do
		if v:Team() == TEAM_TOWER or v:isCP() or v:IsEMS() then
			DarkRP.notify( v, 0, 10, "A truck has been reported to have overturned somewhere on the map, find it and clear the road!" )
		end
	end
	
	hook.Add( "Think", "OverturnedTruckThink", OverturnedTruckThink )
	timer.Create( "OverturnedFireTimer", math.random( 60, 300 ), 1, function()
		local rand = math.random( 0, 1 )
		if rand == 1 then
			CreateVFireBall( 1200, 10, event_truck:GetPos() + Vector( 0, 0, 60 ), vector_origin, nil )
		end
	end )
end

function OverturnedTruckEnd()
	if cooldown > CurTime() then return end
	if IsValid( event_truck ) then event_truck:Remove() end
	for k,v in pairs( team.GetPlayers( TEAM_TOWER ) ) do
		DarkRP.notify( v, 0, 10, "You have been given $4500 and a crafting blueprint for clearing the overturned truck." )
		GiveReward( v, 4500 )
	end
	timer.Remove( "OverturnedFireTimer" )
	hook.Remove( "Think", "OverturnedTruckThink" )
	ResetEventStatus()
	ready = 0
	cooldown = CurTime() + 1
end
