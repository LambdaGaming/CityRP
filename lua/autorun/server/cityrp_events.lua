
local function PickRandomEvent()
	local rand2 = math.random( 1, 5 )
	if rand2 == 1 then
		OverturnedTruck()
	elseif rand2 == 2 then
		ActiveShooter()
	elseif rand2 == 3 then
		HouseFire()
	elseif rand2 == 4 then
		MoneyTransfer()
	else
		FoodDelivery()
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

EventPos["rp_rockford_v2b"] = {
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
	}
}

EventPos["rp_chaos_city_v33x_03"] = {
	Truck = {
		Vector( 960, -6112, -1830 ),
		Vector( -2571, 10691, -1450 ),
		Vector( -6010, -12180, -2105 )
	},
	Shooter = {
		Vector( 3213, 724, -1868 ),
		Vector( 1685, -6161, -1868 ),
		Vector( 8846, -796, -1742 ),
		Vector( -8077, 5271, -1489 ),
		Vector( -10997, -2, -2007 )
	},
	Fire = {
		Vector( 363, -5319, -1612 ),
		Vector( -13279, -11533, -2122 ),
		Vector( -14771, -13026, -2108 ),
		Vector( -13361, -14607, -2114 ),
		Vector( -8260, -15135, -2117 ),
		Vector( -9333, 14742, -1481 )
	},
	Food = {
		Vector( 2270, -734, -1868 ),
		Vector( 4288, -5536, -1868 ),
		Vector( -7994, 14441, -1481 ),
		Vector( -9625, -1610, -2135 )
	}
}

EventPos["rp_evocity2_v5p"] = {
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
	}
}

EventPos["rp_florida_v2"] = {
	Truck = {
		Vector( 5682, -1344, 150 ),
		Vector( -5071, 404, 150 ),
		Vector( 2468, 7806, 150 )
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
	}
}

EventPos["rp_truenorth_v1a"] = {
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
	}
}

EventPos["rp_newexton2_v4h"] = {
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
	}
}

local function GetCurrentEvent()
    return GetGlobalString( "ActiveEvent" )
end

hook.Add( "PlayerSay", "CurEvent", function( ply, text )
	if text == "!currentevent" then
		ply:ChatPrint( "Event that is currently active: "..GetCurrentEvent()  )
	end
end )

local function RandTruck()
	for k,v in pairs( EventPos ) do
		if k == tostring( game.GetMap() ) then
			return table.Random( v.Truck )
		end
	end
end

local function RandShooter()
	for k,v in pairs( EventPos ) do
		if k == tostring( game.GetMap() ) then
			return table.Random( v.Shooter )
		end
	end
end

local function RandFire()
	for k,v in pairs( EventPos ) do
		if k == tostring( game.GetMap() ) then
			return table.Random( v.Fire )
		end
	end
end

local function RandFood()
	for k,v in pairs( EventPos ) do
		if k == tostring( game.GetMap() ) then
			return table.Random( v.Food )
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
	event_truck:SetModel( "models/tdmcars/trucks/peterbilt_579.mdl" )
	event_truck:Spawn()
	event_truck:Activate()
	event_truck:Fire( "Lock", 0, 0 )
	event_truck.IsEventTruck = true
	event_truck:GetPhysicsObject():SetMass( 10000 )
	
	timer.Simple( 0.05, function()
		event_trailer = ents.Create( "prop_physics" )
		event_trailer:SetPos( event_truck:GetPos() + Vector( 0, -450, 20 ) )
		event_trailer:SetAngles( Angle( 90, 0, 10 ) )
		event_trailer:SetModel( "models/tdmcars/trailers/reefer3000r.mdl" )
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
			DarkRP.notify( v, 0, 6, "You have been awarded $600 for clearing the road of the overturned truck." )
			local randwep = table.Random( BLUEPRINT_CONFIG_TIER2 )
			local e = ents.Create( "crafting_blueprint" )
			e:SetPos( v:GetPos() + Vector( 0, 30, 0 ) )
			e:SetAngles( v:GetAngles() + Angle( 0, 180, 0 ) )
			e:Spawn()
			e:SetEntName( randwep[1] )
			e:SetRealName( randwep[2] )
			DarkRP.notify( v, 0, 6, "You have also been rewarded with a crafting blueprint." )
			for a,b in pairs( ents.FindInSphere( v:GetPos(), 200 ) ) do
				if b:IsPlayer() and b:isCP() then
					b:addMoney( 300 )
					DarkRP.notify( b, 0, 6, "You have been awarded $300 for assisting the tow truck driver." )
				end
			end
		end
	end
	timer.Remove( "OverturnedFireTimer" )
	ResetEventStatus()
	ready = 0
	cooldown = CurTime() + 1
end

hook.Add( "Think", "OverturnedTruckThink", function()
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
end )

hook.Add( "PlayerInitialSpawn", "ActiveShooterRelationship", function( ply )
	if GetGlobalBool( "EventActive" ) and GetGlobalString( "ActiveEvent" ) == "Active Shooter" then
		for k,v in pairs( ents.FindByClass( "npc_citizen" ) ) do
			if v.IsEventNPC then
				v:AddEntityRelationship( ply, D_HT, 99 )
			end
		end
	end
end )

function ActiveShooter()
	local numcops = team.NumPlayers( TEAM_POLICEBOSS ) + team.NumPlayers( TEAM_SWATBOSS ) + team.NumPlayers( TEAM_OFFICER ) + team.NumPlayers( TEAM_SWAT ) + team.NumPlayers( TEAM_FBI ) + team.NumPlayers( TEAM_UNDERCOVER )
	if numcops == 0 then return end
	local models = {
		"models/humans/group03/female_01.mdl",
		"models/humans/group03/female_02.mdl",
		"models/humans/group03/female_03.mdl",
		"models/humans/group03/female_04.mdl",
		"models/humans/group03/female_05.mdl",
		"models/humans/group03/female_06.mdl",
		"models/humans/group03/female_07.mdl",
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
	local shooter = ents.Create( "npc_citizen" )
	shooter:SetPos( RandShooter() )
	shooter:SetModel( table.Random( models ) )
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
end

function ActiveShooterEnd( killer )
	killer:addMoney( 600 )
	DarkRP.notify( killer, 0, 6, "You have been rewarded $600 for stopping the threat." )
	local randwep = table.Random( BLUEPRINT_CONFIG_TIER2 )
	local e = ents.Create( "crafting_blueprint" )
	e:SetPos( killer:GetPos() + Vector( 0, 30, 0 ) )
	e:SetAngles( killer:GetAngles() + Angle( 0, 180, 0 ) )
	e:Spawn()
	e:SetEntName( randwep[1] )
	e:SetRealName( randwep[2] )
	DarkRP.notify( v, 0, 6, "You have also been rewarded with a crafting blueprint." )
	for k,v in pairs( player.GetAll() ) do
		if v != killer then
			DarkRP.notify( v, 0, 6, killer:Nick().." has killed the active shooter and ended the threat!" )
		end
	end
	ResetEventStatus()
end

hook.Add( "OnNPCKilled", "ShooterKilled", function( npc, attacker, inflictor )
	if npc:GetClass() == "npc_citizen" and npc.IsEventNPC then
		ActiveShooterEnd( attacker )
		for k,v in pairs( ents.FindInSphere( npc:GetPos(), 50 ) ) do
			if v:GetClass() == "weapon_smg1" then
				v:Remove()
			end
		end
	end
end )

local meta = FindMetaTable( "Player" )
function meta:IsEMS()
	return self:Team() == TEAM_FIREBOSS or self:Team() == TEAM_FIRE
end

function HouseFire()
	local numems = team.NumPlayers( TEAM_FIRE ) + team.NumPlayers( TEAM_FIREBOSS )
	if numems == 0 then PickRandomEvent() return end
	if vFiresCount > 0 then PickRandomEvent() return end
	CreateVFireBall( 1200, 200, RandFire() + Vector( 0, 0, 100 ), Vector( 0, 0, 0 ), nil )
	for k,v in pairs( player.GetAll() ) do
		if v:IsEMS() then
			DarkRP.notify( v, 0, 6, "A fire has been reported to have broken out in a residential building. Find the fire and put it out!" )
		end
	end
	--SetGlobalBool( "EventActive", true )
	--SetGlobalString( "ActiveEvent", "House Fire" )
end

--[[ function HouseFireEnd() --Currently can't get the entity that extinguished the fire, so awards can't work
    for k,v in pairs( player.GetAll() ) do
    	if v:IsEMS() then
    		v:addMoney( 500 )
    		DarkRP.notify( v, 0, 6, "You have been awarded $500 for extinguishing a house fire." )
    	end
		DarkRP.notify( v, 0, 6, "The residential fire has been put out!" )
	end
	ResetEventStatus()
end

hook.Add( "vFireRemoved", "FireEvent", function( fire, parent )
	if fire.IsEventFire then
		HouseFireEnd()
	end
end ) ]]

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
	DarkRP.notify( team.GetPlayers( TEAM_COOK ), 0, 6, "The hungry customer has been served!" )
end
