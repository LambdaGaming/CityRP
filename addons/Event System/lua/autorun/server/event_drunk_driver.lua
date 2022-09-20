local map = game.GetMap()

function DrunkDriver()
	RunConsoleCommand( "bot" )
	local veh = list.Get( "Vehicles" )
	local randveh, name = table.Random( veh )
	while AM_Config_Blacklist[randveh.Model] do --Prevents blacklisted vehicles such as trailers from spawning
		randveh, name = table.Random( veh )
	end

	timer.Simple( 1, function() --The server crashes without this timer, I guess the vehicle needs time to fully inititialize
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
	DarkRP.notifyAll( 0, 6, "A drunk driver has been reported to be in the area! Be on the lookout and report anything suspicious to police!" )
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
	ActiveEvents[EVENT_DRUNK_DRIVER] = false
end

local function DrunkDriverHandcuff( ply, bot, handcuffs )
	if bot:IsBot() and bot.DrunkDriver then
		EndDrunkDriver( bot, ply )
	end
end
hook.Add( "OnHandcuffed", "DrunkDriverHandcuff", DrunkDriverHandcuff )
