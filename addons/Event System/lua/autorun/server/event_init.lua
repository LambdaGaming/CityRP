local rockford = "rp_rockford_v2b"
local southside = "rp_southside_day"
local riverden = "rp_riverden_v1a"
local florida = "rp_florida_v2"
local truenorth = "rp_truenorth_v1a"
local newexton = "rp_newexton2_v4h"
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
	Food = { --Need 4 positions
		Vector( -6974, 5644, 8 ),
		Vector( -9536, -5775, 8 ),
		Vector( 5156, -11509, 322 ),
		Vector( 8562, 3765, 1544 )
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
	Food = {
		Vector( 2716, 4100, -55 ),
		Vector( -93, 557, -103 ),
		Vector( 5387, -909, -103 ),
		Vector( 8241, 4295, -58 )
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
	Food = {
		Vector( -5538, 11362, 0 ),
		Vector( -5160, 1092, -256 ),
		Vector( 3840, 2059, -264 ),
		Vector( -10275, -10213, -264 )
	},
	Road = {
		Vector( -10800, 2179, -314 ),
		Vector( -9714, 10592, -58 ),
		Vector( 4218, -1695, -314 ),
		Vector( 8702, 1821, 718 )
	},
	Robbery = Vector( -11333, 14619, 0 )
}

EventPos[florida] = {
	Truck = {
		Vector( 5682, -1344, 180 ),
		Vector( -5071, 404, 180 ),
		Vector( 2468, 7806, 180 )
	},
	Shooter = {
		Vector( -2159, 5129, 136 ),
		Vector( 3637, -6783, 137 ),
		Vector( 607, -5028, 136 ),
		Vector( -1872, -5229, 88 ),
		Vector( 7639, -4423, 136 )
	},
	Fire = {
		Vector( 8375, 71, 288 ),
		Vector( -6516, -752, 136 ),
		Vector( -6244, 1369, 136 ),
		Vector( -9334, 1147, 136 ),
		Vector( -9322, -427, 136 ),
		Vector( 9171, 2481, 280 )
	},
	Food = {
		Vector( 7953, 2658, 136 ),
		Vector( 5382, -852, 136 ),
		Vector( -100, -10064, 137 ),
		Vector( -5480, -29, 136 )
	},
	Road = {
		Vector( 2871, -1864, 128 ),
		Vector( 5241, 10570, 128 ),
		Vector( -7706, 757, 128 ),
		Vector( 7162, -9455, 128 )
	},
	Robbery = Vector( 4734, -6663, 137 )
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
	Food = {
		Vector( 10664, 9312, 8 ),
		Vector( 14139, 1583, 19 ),
		Vector( -9772, 7037, 0 ),
		Vector( 12820, 3541, 6397 )
	},
	Road = {
		Vector( 6275, 5781, 0 ),
		Vector( 8494, 15230, 0 ),
		Vector( -6757, -10766, 0 ),
		Vector( -10804, 15175, 2560 )
	},
	Robbery = Vector( 6737, 2556, 20 )
}

EventPos[newexton] = {
	Truck = {
		Vector( -8727, 6911, 1070 ),
		Vector( -4808, -9089, -570 ),
		Vector( 9874, 8503, 1070 )
	},
	Shooter = {
		Vector( 6607, 5499, 1024 ),
		Vector( 3409, 6446, 1024 ),
		Vector( -8487, 8426, 1024 ),
		Vector( -6584, -5575, 1016 ),
		Vector( -5904, -9763, -511 )
	},
	Fire = {
		Vector( -2561, -8722, -431 ),
		Vector( -8719, 1241, -479 ),
		Vector( -5888, -1489, 1536 ),
		Vector( 7166, 10635, 1552 ),
		Vector( 10810, 2180, 1024 ),
		Vector( -3825, 6559, 1024 )
	},
	Food = {
		Vector( -9541, 5963, 1024 ),
		Vector( 9360, 7625, 1032 ),
		Vector( 14688, -4537, 276 ),
		Vector( -5418, -9387, -511 )
	},
	Road = {
		Vector( -8789, 6240, 1016 ),
		Vector( 3249, 3879, 1016 ),
		Vector( 15187, 3764, -7 ),
		Vector( -5695, -3282, -519 )
	},
	Robbery = Vector( -9838, -2134, 1420 )
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

local meta = FindMetaTable( "Player" )
function meta:IsEMS()
	return self:Team() == TEAM_FIREBOSS or self:Team() == TEAM_FIRE
end

function IsEventActive( event )
	return ActiveEvents[event]
end

function GiveReward( ply, money )
	local randwep = table.Random( BLUEPRINT_CONFIG_TIER2 )
	local e = ents.Create( "crafting_blueprint" )
	e:SetPos( ply:GetPos() + Vector( 0, 0, 35 ) )
	e:SetAngles( ply:GetAngles() + Angle( 0, 180, 0 ) )
	e:Spawn()
	e:SetEntName( randwep[1] )
	e:SetRealName( randwep[2] )
	e:SetUses( 3 )
	ply:addMoney( money )
end
