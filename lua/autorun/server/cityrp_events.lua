
local function PickRandomEvent()
	local rand2 = math.random( 1, 9 )
	if rand2 == 1 then
		OverturnedTruck()
	elseif rand2 == 2 then
		ActiveShooter()
	elseif rand2 == 3 then
		HouseFire()
	elseif rand2 == 4 then
		MoneyTransfer()
	elseif rand2 == 5 then
		FoodDelivery()
	elseif rand2 == 6 then
		RoadWork()
	elseif rand2 == 7 then
		Robbery()
	elseif rand2 == 8 then
		DrunkDriver()
	else
		BusPassenger()
	end
end

timer.Create( "EventLoop", 300, 0, function()
	local rand = math.random( 1, 10 )
	if GetGlobalBool( "EventActive" ) then return end --Doesn't activate another event if there's one active already
	if player.GetCount() == team.NumPlayers( TEAM_CITIZEN ) then return end --Doesn't activate an event if all players are civilians
	if rand <= 2 then
		PickRandomEvent()
	end
end )

local EventPos = {}
local rockford = "rp_rockford_v2b"
local southside = "rp_southside"
local evocity = "rp_evocity2_v5p"
local florida = "rp_florida_v2"
local truenorth = "rp_truenorth_v1a"
local newexton = "rp_newexton2_v4h"
local map = game.GetMap()

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

EventPos[evocity] = {
	Truck = {
		Vector( 5878, 12433, 100 ),
		Vector( -1272, -569, 100 ),
		Vector( 10690, 1350, -1790 )
	},
	Shooter = {
		Vector( 2284, -1764, 76 ),
		Vector( -314, 2818, 76 ),
		Vector( -2612, 3700, 76 ),
		Vector( -2808, 686, 76 ),
		Vector( 3928, 1729, 76 )
	},
	Fire = {
		Vector( 3977, 630, 404 ),
		Vector( 3795, -2762, 252 ),
		Vector( 5381, 7782, -1695 ),
		Vector( 6153, 10531, -1759 ),
		Vector( 8519, 10341, -1791 ),
		Vector( 7665, 7182, -1819 )
	},
	Food = {
		Vector( 9139, 5744, -1823 ),
		Vector( 320, -232, 76 ),
		Vector( -6994, 1481, 140 ),
		Vector( 2169, 12760, 64 )
	},
	Road = {
		Vector( -1599, 2003, 68 ),
		Vector( -6294, 9766, 196 ),
		Vector( 11053, 6183, -1823 ),
		Vector( 6007, 7670, 68 )
	},
	Robbery = Vector( 1552, -31, 150 )
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

local function GetCurrentEvent()
    return GetGlobalString( "ActiveEvent" )
end

local function CurEvent( ply, text )
	if text == "!currentevent" then
		local event
		if GetCurrentEvent() == "" then
			event = "N/A"
		else
			event = GetCurrentEvent()
		end
		ply:ChatPrint( "Event that is currently active: "..event )
		return ""
	end
end
hook.Add( "PlayerSay", "CurEvent", CurEvent )

local function RandTruck()
	for k,v in pairs( EventPos ) do
		if k == tostring( map ) then
			return table.Random( v.Truck )
		end
	end
end

local function RandShooter()
	for k,v in pairs( EventPos ) do
		if k == tostring( map ) then
			return table.Random( v.Shooter )
		end
	end
end

local function RandFire()
	for k,v in pairs( EventPos ) do
		if k == tostring( map ) then
			return table.Random( v.Fire )
		end
	end
end

local function RandFood()
	for k,v in pairs( EventPos ) do
		if k == tostring( map ) then
			return table.Random( v.Food )
		end
	end
end

local function RandRoad()
	for k,v in pairs( EventPos ) do
		if k == tostring( map ) then
			return table.Random( v.Road )
		end
	end
end

local function ResetEventStatus()
    SetGlobalString( "ActiveEvent", "N/A" )
    SetGlobalBool( "EventActive", false )
end

function OverturnedTruck()
	if team.NumPlayers( TEAM_TOWER ) == 0 then return end
	
	local randtruck = RandTruck()
	
	event_truck = ents.Create( "prop_physics" )
	event_truck:SetPos( randtruck )
	event_truck:SetAngles( Angle( 90, 0, 0 ) )
	event_truck:SetModel( "models/sentry/p379.mdl" )
	event_truck:Spawn()
	event_truck:Activate()
	event_truck:Fire( "Lock", 0, 0 )
	event_truck.IsEventTruck = true
	event_truck:GetPhysicsObject():SetMass( 10000 )
	
	timer.Simple( 0.05, function()
		event_trailer = ents.Create( "prop_physics" )
		event_trailer:SetPos( event_truck:GetPos() + Vector( 0, -450, 20 ) )
		event_trailer:SetAngles( Angle( 90, 0, 10 ) )
		event_trailer:SetModel( "models/sentry/trailers/stortrailer.mdl" )
		event_trailer:Spawn()
		event_trailer:Activate()
		event_trailer.IsEventTrailer = true
		event_trailer:GetPhysicsObject():SetMass( 10000 )
		
		for k,v in pairs( player.GetAll() ) do
			if v:Team() == TEAM_TOWER or v:isCP() then
				DarkRP.notify( v, 0, 6, "A truck has been reported to have overturned somewhere on the map, find it and clear the road!" )
			end
		end
	end )
	
	timer.Create( "OverturnedFireTimer", math.random( 5, 300 ), 1, function()
		local rand = math.random( 0, 1 )
		if rand == 1 then
			CreateVFireBall( 1200, 10, event_truck:GetPos() + Vector( 0, 0, 60 ), Vector( 0, 0, 0 ), nil )
		end
	end )
	SetGlobalBool( "EventActive", true )
	SetGlobalString( "ActiveEvent", "Overturned Truck" )
end

local cooldown = 0
local ready = 0
function OverturnedTruckEnd()
	if cooldown > CurTime() then return end
	if IsValid( event_truck ) then event_truck:Remove() end
	if IsValid( event_trailer ) then event_trailer:Remove() end
	DarkRP.notifyAll( 0, 6, "The overturned truck has been cleared from the road!" )
	for k,v in pairs( player.GetAll() ) do
		if v:Team() == TEAM_TOWER then
			v:addMoney( 600 )
			DarkRP.notify( v, 0, 6, "You have been rewarded with $600 and a crafting blueprint for clearing the overturned truck." )
			local randwep = table.Random( BLUEPRINT_CONFIG_TIER2 )
			local e = ents.Create( "crafting_blueprint" )
			e:SetPos( v:GetPos() + Vector( 0, 30, 0 ) )
			e:SetAngles( v:GetAngles() + Angle( 0, 180, 0 ) )
			e:Spawn()
			e:SetEntName( randwep[1] )
			e:SetRealName( randwep[2] )
			e:SetUses( 3 )
			for a,b in pairs( ents.FindInSphere( v:GetPos(), 200 ) ) do
				if b:IsPlayer() and b:isCP() then
					b:addMoney( 300 )
					DarkRP.notify( b, 0, 6, "You have been rewarded $300 for assisting the tow truck driver." )
				end
			end
		end
	end
	timer.Remove( "OverturnedFireTimer" )
	ResetEventStatus()
	ready = 0
	cooldown = CurTime() + 1
end

local function OverturnedTruckThink()
	if !GetGlobalBool( "EventActive" ) or GetGlobalString( "ActiveEvent" ) != "Overturned Truck" then return end
	for k,v in pairs( ents.FindByClass( "prop_physics" ) ) do
		if IsValid( v ) then
			if !v.FlippedOver and math.Round( v:GetAngles().x ) == 0 then
				if v.IsEventTrailer then
					ready = ready + 1
					v.FlippedOver = true
					--print( "trailer flipped over" )
					DarkRP.notify( team.GetPlayers( TEAM_TOWER ), 2, 6, "The trailer has been flipped back over." )
				end
				if v.IsEventTruck then
					ready = ready + 1
					v.FlippedOver = true
					--print( "truck flipped over" )
					DarkRP.notify( team.GetPlayers( TEAM_TOWER ), 2, 6, "The truck has been flipped back over." )
				end
			end
			if ready == 2 then
				OverturnedTruckEnd()
			end
	    end
	end
end
hook.Add( "Think", "OverturnedTruckThink", OverturnedTruckThink )

function ActiveShooter()
	local numcops = team.NumPlayers( TEAM_POLICEBOSS ) + team.NumPlayers( TEAM_SWATBOSS ) + team.NumPlayers( TEAM_OFFICER ) + team.NumPlayers( TEAM_SWAT ) + team.NumPlayers( TEAM_FBI ) + team.NumPlayers( TEAM_UNDERCOVER )
	if numcops == 0 then return end
	local shooter = ents.Create( "npc_citizen" )
	shooter:SetPos( RandShooter() )
	shooter:Spawn()
	shooter:Activate()
	shooter:Give( "weapon_smg1" )
	shooter:SetHealth( math.random( 100, 500 ) )
	for k,v in pairs( player.GetAll() ) do
		shooter:AddEntityRelationship( v, D_HT, 99 )
	end
	shooter.IsEventNPC = true
	
	SetGlobalBool( "EventActive", true )
	SetGlobalString( "ActiveEvent", "Active Shooter" )
	DarkRP.notifyAll( 0, 6, "Shots fired reported somewhere in the city! Suspect is holding out in a nearby building!" )
end

function ActiveShooterEnd( killer )
	killer:addMoney( 600 )
	DarkRP.notify( killer, 0, 6, "You have been rewarded with $600 and a crafting blueprint for stopping the threat." )
	local randwep = table.Random( BLUEPRINT_CONFIG_TIER2 )
	local e = ents.Create( "crafting_blueprint" )
	e:SetPos( killer:GetPos() + Vector( 0, 30, 0 ) )
	e:SetAngles( killer:GetAngles() + Angle( 0, 180, 0 ) )
	e:Spawn()
	e:SetEntName( randwep[1] )
	e:SetRealName( randwep[2] )
	e:SetUses( 3 )
	for k,v in pairs( player.GetAll() ) do
		if v != killer then
			DarkRP.notify( v, 0, 6, killer:Nick().." has killed the active shooter and ended the threat!" )
		end
	end
	ResetEventStatus()
end

local meta = FindMetaTable( "Player" )
function meta:IsEMS()
	return self:Team() == TEAM_FIREBOSS or self:Team() == TEAM_FIRE
end

local FirePicked = false
function HouseFire()
	local numems = team.NumPlayers( TEAM_FIRE ) + team.NumPlayers( TEAM_FIREBOSS )
	if numems == 0 then PickRandomEvent() return end
	if vFiresCount > 0 then PickRandomEvent() return end
	SetGlobalBool( "EventActive", true )
	SetGlobalString( "ActiveEvent", "House Fire" )
	FirePicked = false
	CreateVFireBall( 1200, 200, RandFire() + Vector( 0, 0, 100 ), Vector( 0, 0, 0 ), nil )
	for k,v in pairs( player.GetAll() ) do
		if v:IsEMS() then
			DarkRP.notify( v, 0, 6, "A fire has been reported to have broken out in a residential building. Find the fire and put it out!" )
		end
	end
end

function HouseFireEnd()
    for k,v in pairs( player.GetAll() ) do
    	if v:IsEMS() then
    		v:addMoney( 300 )
    		DarkRP.notify( v, 0, 6, "You have been rewarded with $300 and a crafting blueprint for helping extinguish a building fire." )
			local randwep = table.Random( BLUEPRINT_CONFIG_TIER2 )
			local e = ents.Create( "crafting_blueprint" )
			e:SetPos( v:GetPos() + Vector( 0, 30, 0 ) )
			e:Spawn()
			e:SetEntName( randwep[1] )
			e:SetRealName( randwep[2] )
			e:SetUses( 3 )
    	end
		DarkRP.notify( v, 0, 6, "The residential fire has been put out!" )
	end
	ResetEventStatus()
end

local function FireEventCreate( fire, parent )
	if GetGlobalBool( "EventActive" ) and GetGlobalString( "ActiveEvent" ) == "House Fire" and !FirePicked then
		fire.IsEventFire = true
		FirePicked = true
	end
end
hook.Add( "vFireCreated", "FireEventCreate", FireEventCreate )

local function FireEventRemove( fire, parent )
	if fire.IsEventFire then
		HouseFireEnd()
	end
end
hook.Add( "vFireRemoved", "FireEventRemove", FireEventRemove )

function MoneyTransfer()
	if team.NumPlayers( TEAM_BANKER ) == 0 then return end
	for k,v in pairs( player.GetAll() ) do
		if v:isCP() or v:Team() == TEAM_BANKER then
			DarkRP.notify( v, 0, 6, "A check needs tranfered from the banker NPC to the check machine!" )
		end
	end
	SetGlobalBool( "EventActive", true )
	SetGlobalString( "ActiveEvent", "Money Transfer" )
end

function MoneyTransferEnd()
	for k,v in pairs( ents.FindByClass( "banker_npc" ) ) do
		v.checkused = false
	end
	ResetEventStatus()
end

function FoodDelivery()
	if team.NumPlayers( TEAM_COOK ) == 0 then return end
	if #ents.FindByClass( "npc_pizza" ) >= 1 then return end
	local e = ents.Create( "npc_pizza" )
	e:SetPos( RandFood() )
	e:Spawn()
	e:Activate()
	DarkRP.notify( team.GetPlayers( TEAM_COOK ), 0, 6, "A hungry customer wants a "..e:GetNWString( "SetPizza" ).."!" )
	SetGlobalBool( "EventActive", true )
	SetGlobalString( "ActiveEvent", "Food Delivery" )
end

function FoodDeliveryEnd()
	ResetEventStatus()
	for k,v in pairs( team.GetPlayers( TEAM_COOK ) ) do
		DarkRP.notify( v, 0, 6, "The hungry customer has been served!" )
	end
end

function RoadWork()
	if team.NumPlayers( TEAM_TOWER ) == 0 then return end
	if #ents.FindByClass( "pot_hole" ) >= 1 then return end
	local e = ents.Create( "pot_hole" )
	e:SetPos( RandRoad() + Vector( 0, 0, 50 ) )
	e:Spawn()
	DarkRP.notify( team.GetPlayers( TEAM_TOWER ), 0, 6, "Citizens have reported a large pothole in the area. Find and repair it." )
	SetGlobalBool( "EventActive", true )
	SetGlobalString( "ActiveEvent", "Pot Hole" )
end

function RoadWorkEnd( ply, ent )
	local pos = ent:GetPos()
	ply:addMoney( 400 )
	DarkRP.notify( ply, 0, 6, "You have been rewarded with $400 and a crafting blueprint for removing a pothole." )
	local randwep = table.Random( BLUEPRINT_CONFIG_TIER2 )
	local e = ents.Create( "crafting_blueprint" )
	e:SetPos( pos + Vector( 0, 30, 0 ) )
	e:Spawn()
	e:SetEntName( randwep[1] )
	e:SetRealName( randwep[2] )
	e:SetUses( 3 )
	ResetEventStatus()
end

local RobberCount = 0
function Robbery()
	local numcops = team.NumPlayers( TEAM_POLICEBOSS ) + team.NumPlayers( TEAM_SWATBOSS ) + team.NumPlayers( TEAM_OFFICER ) + team.NumPlayers( TEAM_SWAT ) + team.NumPlayers( TEAM_FBI ) + team.NumPlayers( TEAM_UNDERCOVER )
	if numcops == 0 or team.NumPlayers( TEAM_BANKER ) == 0 then return end
	local models = {
		"models/humans/group03/male_01.mdl",
		"models/humans/group03/male_02.mdl",
		"models/humans/group03/male_03.mdl",
		"models/humans/group03/male_04.mdl",
		"models/humans/group03/male_05.mdl",
		"models/humans/group03/male_06.mdl",
		"models/humans/group03/male_07.mdl",
		"models/humans/group03/male_08.mdl",
		"models/humans/group03/male_09.mdl"
	}
	local randwep = {
		"weapon_smg1",
		"weapon_pistol",
		"weapon_shotgun"
	}
	local origin = EventPos[map].Robbery
	for i=1, math.random( 2, 6 ) do
		local shooter = ents.Create( "npc_citizen" )
		shooter:SetPos( Vector( origin.x, origin.y + ( i * 30 ), origin.z ) )
		shooter:Spawn()
		shooter:Activate()
		shooter:SetModel( table.Random( models ) )
		shooter:Give( table.Random( randwep ) )
		shooter:SetHealth( 100 )
		for k,v in pairs( player.GetAll() ) do
			shooter:AddEntityRelationship( v, D_HT, 99 )
		end
		shooter.IsRobber = true
		RobberCount = RobberCount + 1
	end
	
	SetGlobalBool( "EventActive", true )
	SetGlobalString( "ActiveEvent", "Bank Robbery" )
	DarkRP.notifyAll( 0, 6, RobberCount.." armed men are attempting to rob the bank!" )
end

function RobberyEnd()
	DarkRP.notifyAll( 0, 6, "The bank robbers have been killed!" )
	RobberCount = 0
	ResetEventStatus()
end

function DrunkDriver()
	local numcops = team.NumPlayers( TEAM_POLICEBOSS ) + team.NumPlayers( TEAM_SWATBOSS ) + team.NumPlayers( TEAM_OFFICER ) + team.NumPlayers( TEAM_SWAT ) + team.NumPlayers( TEAM_FBI ) + team.NumPlayers( TEAM_UNDERCOVER )
	if numcops == 0 then return end
	RunConsoleCommand( "bot" )
	local veh = list.Get( "Vehicles" )
	local randveh, name = table.Random( veh )
	while AM_Config_Blacklist[randveh.Model] do --Prevents blacklisted vehicles such as trailers from spawning
		randveh, name = table.Random( veh )
	end

	timer.Simple( 1, function() --The server crashes without this timer, I guess the vehicle needs time to fully inititialize
		local e = ents.Create( "prop_vehicle_jeep" )
		e:SetKeyValue( "vehiclescript", randveh.KeyValues.vehiclescript )
		e:SetPos( RandRoad() + Vector( 0, 0, 10 ) )
		e:SetModel( randveh.Model )
		e:Spawn()
		e:Activate()
		e.VehicleTable = veh[name]
		e.DrunkVeh = true
		e:Fire( "HandBrakeOff", "", 0.01 )
	end )
	timer.Simple( 1, function() --Add another timer here just to be safe
		for k,v in pairs( player.GetBots() ) do
			v.DrunkDriver = true
			v:GodEnable() --Bots won't move if they're damaged
			for a,b in pairs( ents.FindByModel( randveh.Model ) ) do
				if b.DrunkVeh then
					v:EnterVehicle( b )
					AM_ToggleGodMode( b )
				end
			end
		end
	end )
	DarkRP.notifyAll( 0, 6, "A drunk driver has been reported to be in the area! Be on the lookout and report anything suspicious to police!" )
	SetGlobalBool( "EventActive", true )
	SetGlobalString( "ActiveEvent", "Drunk Driver" )
end

function EndDrunkDriver( bot, ply )
	bot:Kick( "Arrested by "..ply:Nick().."." )
	for k,v in pairs( ents.FindByClass( "prop_vehicle_jeep" ) ) do
		if v.DrunkVeh then v:Remove() end
	end
	ply:addMoney( 500 )
	DarkRP.notify( ply, 0, 6, "You have been rewarded with $500 and a crafting blueprint for arresting the drunk driver." )
	local randwep = table.Random( BLUEPRINT_CONFIG_TIER2 )
	local e = ents.Create( "crafting_blueprint" )
	e:SetPos( ply:GetPos() + Vector( 0, 30, 0 ) )
	e:SetAngles( ply:GetAngles() + Angle( 0, 180, 0 ) )
	e:Spawn()
	e:SetEntName( randwep[1] )
	e:SetRealName( randwep[2] )
	e:SetUses( 3 )
	DarkRP.notifyAll( 0, 6, "The drunk driver has been found and arrested by "..ply:Nick().."!" )
	ResetEventStatus()
end

local function DrunkDriverHandcuff( ply, bot, handcuffs )
	if bot:IsBot() and bot.DrunkDriver then
		EndDrunkDriver( bot, ply )
	end
end
hook.Add( "OnHandcuffed", "DrunkDriverHandcuff", DrunkDriverHandcuff )

Stops = {
	["City Hall"] = {
		[rockford] = Vector( -4656, -6421, 8 ),
		[southside] = Vector( 3978, 4452, -55 ),
		[evocity] = Vector( -758, -1140, 76 ),
		[florida] = Vector( 4128, -2294, 136 ),
		[truenorth] = Vector( 5065, 4512, 8 ),
		[newexton] = Vector( -4088, 829, 1536 )
	},
	["Hospital"] = {
		[rockford] = Vector( -1165, -5850, 0 ),
		[southside] = Vector( 7423, 4728, -60 ),
		[evocity] = Vector( -2341, 1355, 76 ),
		[florida] = Vector( 6702, 6, 128 ),
		[truenorth] = Vector( 13247, 13676, 0 ),
		[newexton] = Vector( 5681, 5813, 1024 )
	},
	["Bank"] = {
		[rockford] = Vector( -2806, -2797, 8 ),
		[southside] = Vector( -2171, 1969, -103 ),
		[evocity] = Vector( 1945, -444, 76 ),
		[florida] = Vector( 2869, -6658, 136 ),
		[truenorth] = Vector( 6994, 3091, 8 ),
		[newexton] = Vector( -8948, -929, 1536 )
	},
	["Car Dealer"] = {
		[rockford] = Vector( -4094, -1208, 0 ),
		[southside] = Vector( -7185, 739, -39 ),
		[evocity] = Vector( 2918, -1599, 76 ),
		[florida] = Vector( -1942, 5691, 128 ),
		[truenorth] = Vector( 6823, 13505, 0 ),
		[newexton] = Vector( -6594, -6189, 1008 )
	}
}

function BusPassenger()
	if team.NumPlayers( TEAM_BUS ) == 0 then return end
	local e = ents.Create( "bus_passenger" )
	e:SetPos( RandFood() )
	e:Spawn()
	for k,v in pairs( team.GetPlayers( TEAM_BUS ) ) do
		DarkRP.notify( v, 0, 6, "A passenger needs picked up! Find them and take them to their destination!" )
	end
	SetGlobalBool( "EventActive", true )
	SetGlobalString( "ActiveEvent", "Bus Passenger" )
end

function EndBusPassenger()
	ResetEventStatus()
	for k,v in pairs( team.GetPlayers( TEAM_BUS ) ) do
		DarkRP.notify( v, 0, 6, "The passenger has been transported!" )
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
			ply:ChatPrint( "Thanks. Here's $500 and a crafting blueprint." )
			ply:addMoney( 500 )
			veh.HasPassenger = false
			EndBusPassenger()
			local randwep = table.Random( BLUEPRINT_CONFIG_TIER2 )
			local e = ents.Create( "crafting_blueprint" )
			e:SetPos( ply:GetPos() + Vector( 0, 0, 35 ) )
			e:SetAngles( ply:GetAngles() + Angle( 0, 180, 0 ) )
			e:Spawn()
			e:SetEntName( randwep[1] )
			e:SetRealName( randwep[2] )
			e:SetUses( 3 )
		else
			DarkRP.notify( ply, 1, 6, "You are too far away from the "..stopname..". Move closer." )
		end
	end
end
hook.Add( "PlayerSay", "BusDriverChat", BusDriverChat )

local function ActiveShooterRelationship( ply )
	local event = GetGlobalString( "ActiveEvent" )
	if GetGlobalBool( "EventActive" ) and ( event == "Active Shooter" or event == "Bank Robbery" ) then
		for k,v in pairs( ents.FindByClass( "npc_citizen" ) ) do
			if v.IsEventNPC or v.IsRobber then
				v:AddEntityRelationship( ply, D_HT, 99 )
			end
		end
	end
end
hook.Add( "PlayerInitialSpawn", "ActiveShooterRelationship", ActiveShooterRelationship )

local function ShooterKilled( npc, attacker, inflictor )
	if npc:GetClass() == "npc_citizen" then
		if npc.IsEventNPC then
			ActiveShooterEnd( attacker )
			for k,v in pairs( ents.FindInSphere( npc:GetPos(), 50 ) ) do
				if v:GetClass() == "weapon_smg1" then
					v:Remove()
				end
			end
		end
		if npc.IsRobber then
			for k,v in pairs( ents.FindInSphere( npc:GetPos(), 50 ) ) do
				timer.Simple( 1, function()
					if IsValid( v ) then
						local weplist = {
							["weapon_smg1"] = true,
							["weapon_pistol"] = true,
							["weapon_shotgun"] = true
						}
						if weplist[v:GetClass()] and !IsValid( v:GetOwner() ) then
							v:Remove()
						end
					end
				end )
			end
			if attacker:IsPlayer() then
				attacker:addMoney( 200 )
				DarkRP.notify( attacker, 0, 6, "You have been rewarded with $200 and a crafting blueprint for killing a robber." )
				local randwep = table.Random( BLUEPRINT_CONFIG_TIER2 )
				local e = ents.Create( "crafting_blueprint" )
				e:SetPos( attacker:GetPos() + Vector( 0, 30, 0 ) )
				e:SetAngles( attacker:GetAngles() + Angle( 0, 180, 0 ) )
				e:Spawn()
				e:SetEntName( randwep[1] )
				e:SetRealName( randwep[2] )
				e:SetUses( 3 )
			end
			RobberCount = RobberCount - 1
			if RobberCount == 0 then
				RobberyEnd()
			end
		end
	end
end
hook.Add( "OnNPCKilled", "ShooterKilled", ShooterKilled )

MsgC( color_red, "\n[CityRP] Loaded server events.\n" )
