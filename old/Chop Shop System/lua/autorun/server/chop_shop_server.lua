
ChopShopPos = {}

ChopShopPos["rp_rockford_v2b"] = {
	Tier1 = { Vector( -6014.8466796875, -635.71325683594, 0.03125 ), Angle( 3.4320087432861, 41.604152679443, 0 ) },
	Tier2 = { Vector( -5381.9130859375, -472.61096191406, 0.03125 ), Angle( 1.5840091705322, -27.695707321167, 0 ) },
	Tier3 = { Vector( -3390.8623046875, -821.61248779297, 16.03125 ), Angle( 3.8280086517334, -88.151847839355, 0 ) }
}

ChopShopPos["rp_chaos_city_v33x_03"] = {
	Tier1 = { Vector(), Angle() },
	Tier2 = { Vector(), Angle() },
	Tier3 = { Vector(), Angle() }
}

ChopShopPos["rp_evocity2_v5p"] = {
	Tier1 = { Vector(), Angle() },
	Tier2 = { Vector(), Angle() },
	Tier3 = { Vector(), Angle() }
}

ChopShopPos["rp_florida_v2"] = {
	Tier1 = { Vector(), Angle() },
	Tier2 = { Vector(), Angle() },
	Tier3 = { Vector(), Angle() }
}

ChopShopPos["rp_truenorth_v1a"] = {
	Tier1 = { Vector(), Angle() },
	Tier2 = { Vector(), Angle() },
	Tier3 = { Vector(), Angle() }
}

ChopShopPos["rp_newexton2_v4h"] = {
	Tier1 = { Vector(), Angle() },
	Tier2 = { Vector(), Angle() },
	Tier3 = { Vector(), Angle() }
}

local ChopShopVehTier1 = {
	"suzuki_kingquad_lw",
	"syclonetdm",
	"gmcvantdm",
	"15f150",
	"jeewillystdm",
	"rv",
	"c5500tdm",
	"bm_M35",
	"dodgeramtdm",
	"chev_suburban"
}

local ChopShopVehTier2 = {
	"07sgmcrownvic",
	"beetle68tdm",
	"dodge_monaco_lw",
	"chev_impala_09",
	"chev_tahoe_lw",
	"vwcampertdm",
	"wranglertdm",
	"grandchetdm",
	"h1tdm",
	"vwsciroccortdm"
}

local ChopShopVehTier3 = {
	"challanger70tdm",
	"charger2012tdm",
	"jag_xfr",
	"15challenger_sgm",
	"vipvipertdm",
	"diablotdm",
	"fer_250gttdm",
	"lam_huracan_lw",
	"gallardospydtdm",
	"miuracontdm",
	"911turbo_sgm",
	"aventador",
	"fer_458spidtdm",
	"murcielagosvtdm",
	"ferf12tdm",
	"reventonrtdm",
	"laferrari",
	"fer_enzotdm",
	"veneno_new"
}

function SpawnRental( num )
	if num == 1 then
		local vehpos = ChopShopPos[game.GetMap()].Tier1
		local randveh = table.Random( ChopShopVehTier1 )
		local vehtable = list.Get( "Vehicles" )[randveh]
		local e = ents.Create( "prop_vehicle_jeep" )
		if vehtable.KeyValues then
			for k,v in pairs( vehtable.KeyValues ) do
				e:SetKeyValue( k, v )
			end
		end
		e:SetModel( vehtable.Model )
		e:SetPos( vehpos[1] )
		e:SetAngles( vehpos[2] )
		e:Spawn()
		e:Activate()
		e:SetNWInt( "ChopTier", 1 )
		--VC_Lock( e )
	elseif num == 2 then
		local vehpos = ChopShopPos[game.GetMap()].Tier2
		local randveh = table.Random( ChopShopVehTier2 )
		local vehtable = list.Get( "Vehicles" )[randveh]
		local e = ents.Create( "prop_vehicle_jeep" )
		if vehtable.KeyValues then
			for k,v in pairs( vehtable.KeyValues ) do
				e:SetKeyValue( k, v )
			end
		end
		e:SetModel( vehtable.Model )
		e:SetPos( vehpos[1] )
		e:SetAngles( vehpos[2] )
		e:Spawn()
		e:Activate()
		e:SetNWInt( "ChopTier", 2 )
		VC_Lock( e )
	else
		local vehpos = ChopShopPos[game.GetMap()].Tier3
		local randveh = table.Random( ChopShopVehTier3 )
		local vehtable = list.Get( "Vehicles" )[randveh]
		local e = ents.Create( "prop_vehicle_jeep" )
		if vehtable.KeyValues then
			for k,v in pairs( vehtable.KeyValues ) do
				e:SetKeyValue( k, v )
			end
		end
		e:SetModel( vehtable.Model )
		e:SetPos( vehpos[1] )
		e:SetAngles( vehpos[2] )
		e:Spawn()
		e:Activate()
		e:SetNWInt( "ChopTier", 3 )
		VC_Lock( e )
	end
end

--[[ hook.Add( "InitPostEntity", "ChopShopCarSpawn", function()
	SpawnRental( 1 )
	SpawnRental( 2 )
	SpawnRental( 3 )
end ) ]]

hook.Add( "lockpickStarted", "LockpickRental", function( ply, ent, trace )
	if ent:GetClass() == "prop_vehicle_jeep" and ent:GetNWInt( "ChopTier" ) == 3 then
		ply:wanted( nil, "Stealing a rental vehicle.", 600 )
	end
end )

hook.Add( "PlayerEnteredVehicle", "StealVehicleMessage", function( ply, veh )
	if veh:GetNWInt( "ChopTier" ) > 0 and veh:GetNWEntity( "Renter" ) != ply then
		if veh:GetNWInt( "ChopTier" ) == 2 then
			ply:wanted( nil, "Stealing a rental vehicle.", 600 )
		end
		DarkRP.notify( ply, 0, 6, "Detected you as a car thief. Take it to the smuggle sell NPC for a profit." )
	end
end )

hook.Add( "PlayerDisconnected", "DisconncetRental", function( ply )
	local rented = ply:GetNWBool( "IsRenting" )
	for k,v in pairs( ents.FindByClass( "prop_vehicle_jeep" ) ) do
		local renter = ent:GetNWEntity( "Renter" )
		if !IsValid( ent ) then return end
		if choptier > 0 and renter == ply then
			v:Remove()
		end
	end
end )

util.AddNetworkString( "ChopCarMenu" )
hook.Add( "PlayerUse", "UseChopVehicle", function( ply, ent )
	local choptier = ent:GetNWInt( "ChopTier" )
	local rented = ply:GetNWBool( "IsRenting" )
	if ent:GetClass() == "prop_vehicle_jeep" and choptier > 0 then
		--if ply:KeyDown( IN_WALK ) or ply:KeyDown( IN_SPEED ) then return false end
		--if ply:KeyDown( IN_WALK ) then
			net.Start( "ChopCarMenu" )
			net.WriteEntity( ent )
			net.Send( ply )
			--return false
		--end
	end
	--return true
end )

util.AddNetworkString( "RentVehicle" )
net.Receive( "RentVehicle", function( len, ply )
	local ent = net.ReadEntity()
	local money = ply:getDarkRPVar( "money" )
	if IsValid( ent ) and ent:IsVehicle() then
		if money < 1000 then
			DarkRP.notify( ply, 1, 6, "You don't have enough money to pay the $1,000 initial rental fee." )
			return
		end
		if ply:GetNWEntity( "IsRenting" ) then
			DarkRP.notify( ply, 1, 6, "You are already renting a car. Return that one first before renting another one." )
			return
		end
		ply:EnterVehicle( ent )
		DarkRP.notify( ply, 0, 6, "You are now renting this vehicle. Charges will be automatically deducted every 5 minutes." )
		DarkRP.notify( ply, 0, 6, "If you miss a payment due to low balance, you will be given a warning. If it happens again, the car will be taken from you." )
		ent:SetNWEntity( "Renter", ply )
		ply:SetNWEntity( "RentedCar", ent )
		ply:SetNWBool( "IsRenting", true )
		ply:SetNWBool( "RentalWarning", false )
		ply:addMoney( -1000 )
		timer.Create( "Rental_"..ply:SteamID(), 300, 0, function()
			local rentedcar = ply:GetNWEntity( "RentedCar" )
			local rentwarning = ply:GetNWBool( "RentalWarning" )
			local choptier = ent:GetNWInt( "ChopTier" )
			local money = ply:getDarkRPVar( "money" )
			local amount = 0
			if IsValid( rentedcar ) then
				if choptier == 1 then
					amount = 50
				elseif choptier == 2 then
					amount = 75
				else
					amount = 100
				end
				if money < amount then
					if rentwarning then
						ply:SetNWBool( "IsRenting", false )
						ply:SetNWBool( "RentalWarning", false )
						ply:SetNWEntity( "RentedCar", nil )
						DarkRP.notify( ply, 1, 6, "You have failed to pay your rental fee twice. Your rental vehicle has been removed." )
						timer.Remove( "Rental_"..ply:SteamID() )
					else
						ply:SetNWBool( "RentalWarning", true )
						DarkRP.notify( ply, 1, 6, "You have been warned for failing to pay your rental fee. If it happens again your rental car will be removed." )
					end
				else
					ply:addMoney( -amount )
					DarkRP.notify( ply, 0, 6, "You have paid your rental fee of $"..amount.."." )
				end
			else
				ply:SetNWBool( "IsRenting", false )
				ply:SetNWBool( "RentalWarning", false )
				ply:SetNWEntity( "RentedCar", nil )
				DarkRP.notify( ply, 1, 6, "The server has detected that your rental car was removed. You are no longer being charged for it." )
				timer.Remove( "Rental_"..ply:SteamID() )
			end
		end )
	end
end )

util.AddNetworkString( "ReturnVehicle" )
net.Receive( "ReturnVehicle", function( len, ply )
	local ent = net.ReadEntity()
	if IsValid( ent ) and ent:IsVehicle() then
		local choptier = ent:GetNWInt( "ChopTier" )
		local rightrental = ply:GetNWEntity( "RentedCar" )
		if ent != rightrental then
			DarkRP.notify( ply, 1, 6, "This isn't your rental car, so you can't return it." )
			return
		end
		SpawnRental( choptier )
		ent:Remove()
		ply:SetNWBool( "IsRenting", false )
		ply:SetNWBool( "RentalWarning", false )
		ply:SetNWEntity( "RentedCar", nil )
		DarkRP.notify( ply, 0, 6, "Your rental car has been returned to the dealership. You will no longer be paying fees on it." )
		timer.Remove( "Rental_"..ply:SteamID() )
	end
end )

util.AddNetworkString( "StealVehicle" )
net.Receive( "StealVehicle", function( len, ply )
	local ent = net.ReadEntity()
	if IsValid( ent ) and ent:IsVehicle() then
		for k,v in pairs( ents.FindInSphere( ent:GetPos(), 350 ) ) do
			if v:GetClass() == "npc_smuggle_sell" then
				local choptier = ent:GetNWInt( "ChopTier" )
				local renter = ent:GetNWEntity( "Renter" )
				local amount = 0
				local istier1 = false
				if renter == ply then
					DarkRP.notify( ply, 1, 6, "You can't steal your own rental car!" )
					return
				end
				if choptier == 1 then
					amount = 3000
					istier1 = true
				elseif choptier == 2 then
					amount = 6500
				else
					amount = 10000
				end
				ply:addMoney( amount )
				DarkRP.notify( ply, 0, 6, "You have sold a stolen rental car for "..DarkRP.formatMoney( amount ).."." )
				if istier1 then
					ply:wanted( nil, "Stealing a rental vehicle.", 600 )
				end
				ent:Remove()
			end
		end
	end
end )

util.AddNetworkString( "EnterRental" )
net.Receive( "EnterRental", function( len, ply )
	local ent = net.ReadEntity()
	if IsValid( ent ) and ent:IsVehicle() then
		ply:EnterVehicle( ent )
	end
end )