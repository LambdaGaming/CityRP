local map = game.GetMap()

if SERVER then
	--Vehicle model precache
	hook.Add( "InitPostEntity", "PrecacheModels", function()
		local vehicles = list.Get( "Vehicles" )
		local weps = weapons.GetList()
		for k,v in pairs( vehicles ) do
			local model = v.Model
			util.PrecacheModel( model )
			print( "Precaching "..model )
		end
	end )

	--Deduct money on death
	hook.Add( "PlayerDeath", "DeductMoney", function( ply, inf, attack )
		if !GetGlobalBool( "DarkRP_Purge" ) and !ply:isArrested() and !ply.HasLifeInsurance then
			local wallet = ply:getDarkRPVar( "money" )
			local walletpercent = math.Round( wallet * 0.012 ) --1.2% of the players wallet
			ply:addMoney( -walletpercent )
			DarkRP.createMoneyBag( ply:GetPos() + Vector( 0, 0, 10 ), walletpercent )
			DarkRP.notify( ply, 0, 6, "You have lost $"..walletpercent.." as a result of your death." )
		end
	end )

	--Gas pump spawns
	local GasPumpMaps = {
		["rp_rockford_v2b"] = "models/statua/shell/shellpump1.mdl",
		["rp_southside_day"] = "models/unioncity2/props_unioncity/gas_pump.mdl",
		["rp_riverden_v1a"] = "models/unioncity2/props_unioncity/gaspump_712.mdl",
		["rp_truenorth_v1a"] = "models/props_equipment/gas_pump.mdl"
	}
	hook.Add( "InitPostEntity", "GasPumpSpawn", function()
		for k,v in pairs( ents.FindByModel( GasPumpMaps[map] ) ) do
			if v:CreatedByMap() then
				local pos, ang = v:GetPos(), v:GetAngles()
				v:Remove()
				
				local e = ents.Create( "gas_pump" )
				e:SetPos( pos )
				e:SetAngles( ang )
				e:Spawn()
				e:SetModel( GasPumpMaps[map] )
			end
		end
	end )
	
	--Suspicious bank activity monitor
	hook.Add( "playerWalletChanged", "PoliceNotify", function( ply, amount, wallet )
		local policejob = {
			[TEAM_POLICEBOSS] = true,
			[TEAM_OFFICER] = true,
			[TEAM_UNDERCOVER] = true,
			[TEAM_FBI] = true,
			[TEAM_BANKER] = true,
			[TEAM_DETECTIVE] = true
		}

		for k,v in ipairs( player.GetAll() ) do
			if policejob[v:Team()] and amount >= 10000 then
				DarkRP.notify( v, 1, 6, "Suspicious bank activity coming from "..ply:Nick().."." )
			end
		end
	end )

	--End purge and parade when mayor dies or leaves
	local function EndEvents( ply )
		if ply:Team() == TEAM_MAYOR then
			if GetGlobalBool( "DarkRP_Purge" ) then DarkRP.endPurge( ply ) end
			if GetGlobalBool( "DarkRP_Parade" ) then DarkRP.endParade( ply ) end
		end
	end
	hook.Add( "DoPlayerDeath", "MayorEndCommands", EndEvents )
	hook.Add( "PlayerDisconnected", "MayorEndCommandsDisconnect", EndEvents )

	--Remove active job-specific vehicles
	local function RemoveVehicles( ply )
		if ply.VehicleList then
			for k,v in pairs( ply.VehicleList ) do
				if IsValid( v ) then v:Remove() end
			end
		end
	end
	hook.Add( "PlayerDisconnected", "DisconnectRemoveVehicle", RemoveVehicles )
	hook.Add( "OnPlayerChangedTeam", "ChangeTeamRemoveVehicle", RemoveVehicles )
end

if CLIENT then
	--Suppress warning about missing Photon parts
	hook.Add( "OnEntityCreated", "PhotonSuppress", function( ent )
		if ent:GetClass() == "prop_vehicle_jeep" then
			ent.PhotonAlertedMissingRequirements = true
		end
	end )
end

--Fish stove initializer
util.PrecacheModel( "models/props_interiors/pot02a.mdl" )
hook.Add( "OnPlayerChangedTeam", "CookInit", function( ply, before, after )
	if after == TEAM_COOK then ply.CookFish = 0 end
	if after != TEAM_COOK then ply.CookFish = nil end
end )
