local map = game.GetMap()
local rockford = "rp_rockford_v2b"
local southside = "rp_southside_day"
local riverden = "rp_riverden_v1a"
local florida = "rp_florida_v2"
local truenorth = "rp_truenorth_v1a"
local newexton = "rp_newexton2_v4h"

Stops = {
	["City Hall"] = {
		[rockford] = Vector( -4656, -6421, 8 ),
		[southside] = Vector( 3978, 4452, -55 ),
		[riverden] = Vector( -10519, 10943, 0 ),
		[florida] = Vector( 4128, -2294, 136 ),
		[truenorth] = Vector( 5065, 4512, 8 ),
		[newexton] = Vector( -4088, 829, 1536 )
	},
	["Hospital"] = {
		[rockford] = Vector( -1165, -5850, 0 ),
		[southside] = Vector( 7423, 4728, -60 ),
		[riverden] = Vector( -5156, 1771, -256 ),
		[florida] = Vector( 6702, 6, 128 ),
		[truenorth] = Vector( 13247, 13676, 0 ),
		[newexton] = Vector( 5681, 5813, 1024 )
	},
	["Bank"] = {
		[rockford] = Vector( -2806, -2797, 8 ),
		[southside] = Vector( -2171, 1969, -103 ),
		[riverden] = Vector( -12720, 13972, 0 ),
		[florida] = Vector( 2869, -6658, 136 ),
		[truenorth] = Vector( 6994, 3091, 8 ),
		[newexton] = Vector( -8948, -929, 1536 )
	},
	["Car Dealer"] = {
		[rockford] = Vector( -4094, -1208, 0 ),
		[southside] = Vector( -7185, 739, -39 ),
		[riverden] = Vector( -5546, 11358, 0 ),
		[florida] = Vector( -1942, 5691, 128 ),
		[truenorth] = Vector( 6823, 13505, 0 ),
		[newexton] = Vector( -6594, -6189, 1008 )
	}
}

function BusPassenger()
	local e = ents.Create( "bus_passenger" )
	e:SetPos( table.Random( EventPos[map].Food ) )
	e:Spawn()
	for k,v in pairs( team.GetPlayers( TEAM_BUS ) ) do
		DarkRP.notify( v, 0, 10, "A passenger needs picked up! Find them and take them to their destination!" )
	end
end

function EndBusPassenger()
	ActiveEvents[EVENT_BUS_PASSENGER] = false
	for k,v in pairs( team.GetPlayers( TEAM_BUS ) ) do
		DarkRP.notify( v, 0, 10, "The passenger has been transported!" )
	end
end

local function BusDriverChat( ply, text )
	if text == "!busstop" then
		if ply:Team() != TEAM_BUS then
			DarkRP.notify( ply, 1, 6, "Only bus drivers can use this command." )
			return
		end
		if !ply:InVehicle() or !ply:GetVehicle().HasPassenger then
			DarkRP.notify( ply, 1, 6, "You must be in your bus with a passenger on board to use this command." )
			return
		end
		local veh = ply:GetVehicle()
		local stopname = veh.SetStop
		local dist = ply:GetPos():DistToSqr( Stops[stopname][map] )
		if dist <= 250000 then
			local reward = 750 * team.NumPlayers( TEAM_BUS )
			ply:ChatPrint( "Thanks. Here's $"..reward.." and a crafting blueprint." )
			veh.HasPassenger = false
			EndBusPassenger()
			GiveReward( ply, reward )
		else
			DarkRP.notify( ply, 1, 6, "You are too far away from the "..stopname..". Move closer." )
		end
	end
end
hook.Add( "PlayerSay", "BusDriverChat", BusDriverChat )
