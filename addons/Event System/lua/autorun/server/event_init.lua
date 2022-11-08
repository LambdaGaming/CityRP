local rockford = "rp_rockford_v2b"
local southside = "rp_southside_day"
local riverden = "rp_riverden_v1a"
local truenorth = "rp_truenorth_v1a"
local map = game.GetMap()

EventPos = {}
EventPos[rockford] = {
	Truck = { --Need 3 positions
		Vector( -2511, -6511, 60 ),
		Vector( -678, 5338, 580 ),
		Vector( 5279, -11243, 370 )
	},
	Shooter = { --Need 5 positions
		Vector( 1337, 6106, 574 ),
		Vector( 438, 2363, 536 ),
		Vector( -3163, -3009, 32 ),
		Vector( -307, -5427, 64 ),
		Vector( -8866, -902, -319 )
	},
	Fire = { --Need 6 positions
		Vector( 8296, 7246, 1568 ),
		Vector( 8377, 5249, 1704 ),
		Vector( 9364, 1039, 1568 ),
		Vector( 10845, 2137, 1568 ),
		Vector( 10773, 4830, 1704 ),
		Vector( 10622, 7444, 1568 )
	},
	Road = { --Need 4 positions
		Vector( -3919, -6921, 0 ),
		Vector( -8019, 4866, 0 ),
		Vector( -2499, 12990, 519 ),
		Vector( 8875, 4412, 1536 )
	},
	Robbery = Vector( -3526, -3217, 40 ) --Need 1 position
}

EventPos[southside] = {
	Truck = {
		Vector( 2310, 9275, 150 ),
		Vector( -3233, 10219, 150 ),
		Vector( -2520, 3600, 81 )
	},
	Shooter = {
		Vector( 587, 14162, 128 ),
		Vector( -2548, 8235, 161 ),
		Vector( 1395, 2869, -95 ),
		Vector( 2728, 5036, 0 ),
		Vector( 8482, 7916, 200 )
	},
	Fire = {
		Vector( 8925, 7712, 200 ),
		Vector( -2027, 6036, 24 ),
		Vector( -1100, 5619, -103 ),
		Vector( -1735, 2493, -103 ),
		Vector( -5941, 564, -39 ),
		Vector( 7199, 5135, -55 )
	},
	Road = {
		Vector( 6267, 7477, 128 ),
		Vector( 2392, 9194, 120 ),
		Vector( -1408, 6163, 0 ),
		Vector( -2608, 2182, -111 )
	},
	Robbery = Vector( -1029, 2484, -102 )
}

EventPos[riverden] = {
	Truck = {
		Vector( -10926, 2225, -220 ),
		Vector( -9937, -9862, -220 ),
		Vector( 8415, -3144, 800 )
	},
	Shooter = {
		Vector( -11084, 12348, 128 ),
		Vector( -11281, 8013, -256 ),
		Vector( -13282, 6958, -415 ),
		Vector( -9442, 1035, -256 ),
		Vector( 6863, -14373, 776 )
	},
	Fire = {
		Vector( 11915, -11570, 824 ),
		Vector( 11024, 3567, 808 ),
		Vector( 7588, 8592, -242 ),
		Vector( -3090, -2614, -192 ),
		Vector( -6105, 2117, -256 ),
		Vector( -4166, 11292, 1 )
	},
	Road = {
		Vector( -10800, 2179, -314 ),
		Vector( -9714, 10592, -58 ),
		Vector( 4218, -1695, -314 ),
		Vector( 8702, 1821, 718 )
	},
	Robbery = Vector( -11333, 14619, 0 )
}

EventPos[truenorth] = {
	Truck = {
		Vector( 6294, 5792, 50 ),
		Vector( 1861, -62, 50 ),
		Vector( 1465, 12562, 3900 )
	},
	Shooter = {
		Vector( 2285, 3389, 8 ),
		Vector( 6319, 12982, 8 ),
		Vector( 13326, 12929, 64 ),
		Vector( 14941, 9866, 8 ),
		Vector( 12734, -9156, 32 )
	},
	Fire = {
		Vector( -6326, -14582, 32 ),
		Vector( 14897, 4765, 6432 ),
		Vector( 7903, -7935, 5408 ),
		Vector( 2411, -11834, 4896 ),
		Vector( 5460, 7141, 8 ),
		Vector( 12504, 4082, 272 )
	},
	Road = {
		Vector( 6275, 5781, 0 ),
		Vector( 8494, 15230, 0 ),
		Vector( -6757, -10766, 0 ),
		Vector( -10804, 15175, 2560 )
	},
	Robbery = Vector( 6737, 2556, 20 )
}

ActiveEvents = {}
EVENT_OVERTURNED_TRUCK = 1
EVENT_ACTIVE_SHOOTER = 2
EVENT_HOUSE_FIRE = 3
EVENT_MONEY_TRANSFER = 4
EVENT_FOOD_DELIVERY = 5
EVENT_ROAD_WORK = 6
EVENT_ROBBERY = 7
EVENT_DRUNK_DRIVER = 8
EVENT_BUS_PASSENGER = 9
EVENT_ZOMBIE = 10
EVENT_TIME_BOMB = 11

function IsEventActive( event )
	return ActiveEvents[event]
end

function GiveReward( ply, money )
	SpawnBlueprint( BLUEPRINT_TIER2, ply, 3 )
	ply:addMoney( money )
end
