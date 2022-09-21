local map = game.GetMap()

function DrunkDriver()
	RunConsoleCommand( "bot" )
	local veh = list.Get( "Vehicles" )
	local randveh, name = table.Random( veh )
	while AM_Config_Blacklist[randveh.Model] do --Prevents blacklisted vehicles such as trailers from spawning
		randveh, name = table.Random( veh )
	end

	timer.Simple( 1, function() --The server crashes without this timer, I guess the vehicle needs time to fully initialize
		local e = ents.Create( "prop_vehicle_jeep" )
		e:SetKeyValue( "vehiclescript", randveh.KeyValues.vehiclescript )
		e:SetPos( table.Random( EventPos[map].Road ) + Vector( 0, 0, 10 ) )
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
	for k,v in ipairs( player.GetAll() ) do
		DarkRP.notify( v, 0, 10, "Citizens are reporting a drunk driver in the area. Be on the lookout." )
	end
end

function EndDrunkDriver( bot, ply )
	local numcp = 1
	for k,v in ipairs( player.GetAll() ) do
		if v:isCP() and v:Team() != TEAM_MAYOR then
			numcp = numcp + 1
		end
	end
	local reward = 12000 + ( numcp * 4000 )
	bot:Kick( "Arrested by "..ply:Nick().."." )
	for k,v in pairs( ents.FindByClass( "prop_vehicle_jeep" ) ) do
		if v.DrunkVeh then v:Remove() end
	end
	DarkRP.notify( ply, 0, 10, "You have been rewarded with $"..reward.." and a crafting blueprint for arresting the drunk driver." )
	if numcp > 1 then
		DarkRP.notify( ply, 2, 10, "Please distribute these earnings among those who helped you." )
	end
	GiveReward( ply, reward )
	ActiveEvents[EVENT_DRUNK_DRIVER] = false
end

local function DrunkDriverHandcuff( ply, bot, handcuffs )
	if bot:IsBot() and bot.DrunkDriver then
		EndDrunkDriver( bot, ply )
	end
end
hook.Add( "OnHandcuffed", "DrunkDriverHandcuff", DrunkDriverHandcuff )
