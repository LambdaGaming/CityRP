local map = game.GetMap()

if SERVER then
	--Vehicle model precache
	hook.Add( "InitPostEntity", "PrecacheVehicles", function()
		local vehicles = list.Get( "Vehicles" )
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

	--Smuggle truck confiscation
	hook.Add( "PlayerEnteredVehicle", "SmuggleConfiscate", function( ply, veh )
		if veh.SmuggleTruck then
			if ply:isCP() then
				DarkRP.notify( ply, 0, 6, "You have successfully seized this smuggle truck. You have been awarded with $500." )
				ply:addMoney( 500 )
				DarkRP.notify( veh.SmuggleOwner, 1, 6, "The police have seized your smuggle truck." )
				veh:Remove()
				return
			end
			if ply != veh.SmuggleOwner then
				veh.SmuggleOwner = ply
				DarkRP.notify( ply, 0, 6, "You have taken ownership of this smuggle truck." )
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
