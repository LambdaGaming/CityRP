local map = game.GetMap()
local rockford = "rp_rockford_v2b"
local southside = "rp_southside_day"
local riverden = "rp_riverden_v1a"
local truenorth = "rp_truenorth_v1a"

BusPassengerEventStats = {
	DestinationName = "",
	TotalPassengers = 0
}

BusDestinations = {
	["City Hall"] = {
		[rockford] = Vector( -4656, -6421, 8 ),
		[southside] = Vector( 3978, 4452, -55 ),
		[riverden] = Vector( -10519, 10943, 0 ),
		[truenorth] = Vector( 5065, 4512, 8 )
	},
	["Hospital"] = {
		[rockford] = Vector( -1165, -5850, 0 ),
		[southside] = Vector( 7423, 4728, -60 ),
		[riverden] = Vector( -5156, 1771, -256 ),
		[truenorth] = Vector( 13247, 13676, 0 )
	},
	["Bank"] = {
		[rockford] = Vector( -2806, -2797, 8 ),
		[southside] = Vector( -2171, 1969, -103 ),
		[riverden] = Vector( -12720, 13972, 0 ),
		[truenorth] = Vector( 6994, 3091, 8 )
	},
	["Car Dealer"] = {
		[rockford] = Vector( -4094, -1208, 0 ),
		[southside] = Vector( -7185, 739, -39 ),
		[riverden] = Vector( -5546, 11358, 0 ),
		[truenorth] = Vector( 6823, 13505, 0 )
	},
	["Police Department"] = {
		[rockford] = Vector( -8960, -5831, 8 ),
		[southside] = Vector( 6282, 7642, 128 ),
		[riverden] = Vector( -8982, 10338, 0 ),
		[truenorth] = Vector( 3393, 5552, 0 )
	},
	["Fire Department"] = {
		[rockford] = Vector( -6368, -3269, 8 ),
		[southside] = Vector( 9038, 1522, -107 ),
		[riverden] = Vector( -12274, 2367, -263 ),
		[truenorth] = Vector( 13756, 10776, 8 )
	},
	["Supermarket"] = {
		[rockford] = Vector( 2260, 5249, 536 ),
		[southside] = Vector( -5566, -111, -80 ),
		[riverden] = Vector( -10430, 2175, -264 ),
		[truenorth] = Vector( 14374, 9923, 8 )
	}
}

function BusPassenger()
	local count = 1
	for k,v in pairs( ents.FindByModel( "models/rp_koski/busstop.mdl" ) ) do
		if v:CreatedByMap() or v.IsPermaProp then
			local e = ents.Create( "bus_passenger" )
			e:SetPos( v:LocalToWorld( Vector( -47, 15, -32 ) ) )
			e:SetAngles( v:LocalToWorldAngles( Angle( 0, -90, 0 ) ) )
			e:Spawn()
			e.PassengerID = count
			BusPassengerEventStats.TotalPassengers = BusPassengerEventStats.TotalPassengers + 1
			count = count + 1
		end
	end
	local randtbl, randkey = table.Random( BusDestinations )
	BusPassengerEventStats.DestinationName = randkey
	NotifyJob( TEAM_BUS, 0, 10, "Drive around to bus stops and pickup passengers." )
end

function EndBusPassenger()
	ActiveEvents[EVENT_BUS_PASSENGER] = false
	for k,v in pairs( ents.FindByClass( "bus_passenger" ) ) do
		v:Remove()
	end
	BusPassengerEventStats = {
		DestinationName = "",
		TotalPassengers = 0
	}
end

hook.Add( "EntityRemoved", "BusRemoved", function( ent )
	if ActiveEvents[EVENT_BUS_PASSENGER] and ent.TotalPassengers then
		EndBusPassenger()
		NotifyJob( TEAM_BUS, 1, 6, "Your job was cancelled due to your bus being deleted." )
	end
end )
