/*---------------------------------------------------------------------------
	
	Creator: TheCodingBeast - TheCodingBeast.com
	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
	To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/
	
---------------------------------------------------------------------------*/
util.AddNetworkString("TCBDealerMenu")
util.AddNetworkString("TCBDealerSpawn")
util.AddNetworkString("TCBDealerPurchase")
util.AddNetworkString("TCBDealerSell")
util.AddNetworkString("TCBDealerChat")
util.AddNetworkString("TCBDealerStore")

local rockford = "rp_rockford_v2b"
local southside = "rp_southside_day"
local riverden = "rp_riverden_v1a"
local truenorth = "rp_truenorth_v1a"

local rentspawns = {
	[rockford] = { Vector( -5798, -1215, 0 ), angle_ninety },
	[southside] = { Vector( -7209, 517, -40 ), angle_ninety },
	[riverden] = { Vector( -3351, 11229, -8 ), angle_one_eighty },
	[truenorth] = { Vector( 7145, 12418, 0 ), angle_one_eighty }
}

local VehicleFuel = {}

--[[---------------------------------------------------------
	Database Setup
-----------------------------------------------------------]]
function TCBDealer.databaseSetup()
	--> Compatibility
	local AUTOINCREMENT = MySQLite.isMySQL() and "AUTO_INCREMENT" or "AUTOINCREMENT"

	--> Table
	MySQLite.query([[
		CREATE TABLE IF NOT EXISTS tcb_cardealer (
			id INTEGER NOT NULL PRIMARY KEY ]]..AUTOINCREMENT..[[,
			steamID VARCHAR(50) NOT NULL,
			vehicle VARCHAR(255) NOT NULL
		)
	]])
end
hook.Add("DarkRPDBInitialized", "TCBDealer.databaseSetup", TCBDealer.databaseSetup)

--[[---------------------------------------------------------
	Spawn Dealer
-----------------------------------------------------------]]
local function FindVehicles( ply )
	local listveh = {}
	for k,v in pairs( ents.FindInSphere( ply:GetPos(), 500 ) ) do
		if v:IsVehicle() and !v:GetNWBool( "IsGAutoSeat" ) then
			table.insert( listveh, v )
		end
	end
	return listveh
end

util.AddNetworkString( "TCBDealerMenuRent" )
function TCBDealer.spawnDealer()
	--> Map Check
	if !TCBDealer.dealerSpawns[game.GetMap()] then
		ErrorNoHalt("Missing car dealer spawn points for map: "..game.GetMap())
		return 
	end

	--> Loop Dealers
	for k,v in pairs(TCBDealer.dealerSpawns[game.GetMap()]) do
		local dealer = ents.Create("car_dealer")
		dealer:SetPos(v.pos + Vector(0, 0, 10))
		dealer:SetAngles(v.ang)
		dealer:Spawn()
		dealer.id = k
	end
end
hook.Add("InitPostEntity", "TCBDealer.spawnDealer", TCBDealer.spawnDealer)

--[[---------------------------------------------------------
	Purchase Vehicle
-----------------------------------------------------------]]
function TCBDealer.purchaseVehicle(length, ply)
	--> Vehicle
	local vehID = net.ReadString()
	if !TCBDealer.vehicleTable[vehID] then 
		DarkRP.notify(ply, 1, 4, "The requested vehicle is not for sale.") 
		return 
	end

	local vehicle = TCBDealer.vehicleTable[vehID]
	local vehicleInfo = list.GetForEdit("Vehicles")[vehID]
	if !vehicleInfo then return end

	local vehName = vehicle.name or vehicleInfo.Name
	--> CustomCheck
	if vehicle.customCheck and !vehicle.customCheck(ply) then 
		if vehicle.CustomCheckFailMsg then
			DarkRP.notify(ply, 1, 4, vehicle.CustomCheckFailMsg)
		else
			DarkRP.notify(ply, 1, 4, "This vehicle is currently not available for you.")
		end
		return
	end

	--> Money
	if !ply:canAfford(vehicle.price) then
		DarkRP.notify(ply, 1, 4, "You can't afford this vehicle.") 
		return
	end
	ply:addMoney(-vehicle.price)

	--> Purchase
	MySQLite.query(string.format([[INSERT INTO tcb_cardealer (steamID, vehicle) VALUES (%s, %s)]], MySQLite.SQLStr(ply:SteamID()), MySQLite.SQLStr(vehID)))
	--> Notify
	DarkRP.notify(ply, 3, 4, "You bought a "..vehName.." for "..DarkRP.formatMoney(vehicle.price).."!")
end
net.Receive("TCBDealerPurchase", TCBDealer.purchaseVehicle)

--[[---------------------------------------------------------
	Sell Vehicle
-----------------------------------------------------------]]
function TCBDealer.sellVehicle(length, ply)
	--> Vehicle
	local vehID = net.ReadString()
	if !TCBDealer.vehicleTable[vehID] then 
		DarkRP.notify(ply, 1, 4, "The requested vehicle can't be sold.") 
		return 
	end
	vehicle = TCBDealer.vehicleTable[vehID]

	local vehicleInfo = list.GetForEdit("Vehicles")[vehID]
	if !vehicleInfo then return end

	local vehName = vehicle.name or vehicleInfo.Name

	--> Own
	local vehOwn = {}
	MySQLite.query(string.format([[SELECT * FROM tcb_cardealer WHERE steamID = %s AND vehicle = %s]], MySQLite.SQLStr(ply:SteamID()), MySQLite.SQLStr(vehID)), function(data)
		--> Variables
		vehOwn = data or {}

		--> Own
		if table.Count(vehOwn) == 0 then
			DarkRP.notify(ply, 1, 4, "The requested vehicle is not in you garage.") 
			return 
		end

		--> Current
		TCBDealer.removeVehicle(ply)

		--> Money
		local amount = vehicle.price*(TCBDealer.settings.salePercentage/100)
		ply:addMoney(amount)

		--> Sell
		MySQLite.query(string.format([[DELETE FROM tcb_cardealer WHERE steamID = %s AND vehicle = %s]], MySQLite.SQLStr(ply:SteamID()), MySQLite.SQLStr(vehID)))
		--> Notify
		DarkRP.notify(ply, 3, 4, "You sold your "..vehName.." for "..DarkRP.formatMoney(amount).."!")
	end)
end
net.Receive("TCBDealerSell", TCBDealer.sellVehicle)

--[[---------------------------------------------------------
	Spawn Vehicle
-----------------------------------------------------------]]
function TCBDealer.spawnVehicle(length, ply)
	--> Network
	local vehID = net.ReadString()
	local dealerID = net.ReadInt(32)
	local testDrive = net.ReadBool() or false

	--> Vehicle
	if !TCBDealer.vehicleTable[vehID] then 
		DarkRP.notify(ply, 1, 4, "The requested vehicle can't be spawned.") 
		return 
	end
	vehicle = TCBDealer.vehicleTable[vehID]

	--> CustomCheck
	if vehicle.customCheck and !vehicle.customCheck(ply) then 
		if vehicle.CustomCheckFailMsg then
			DarkRP.notify(ply, 1, 4, vehicle.CustomCheckFailMsg)
		else
			DarkRP.notify(ply, 1, 4, "This vehicle is currently not available for you.")
		end
		return
	end

	--> Function
	function spawnCode()

		--> Current
		TCBDealer.removeVehicle(ply)

		--> Dealer
		if !TCBDealer.dealerSpawns[game.GetMap()][dealerID] then
			DarkRP.notify(ply, 1, 4, "The car dealer wasn't found.") 
			return 
		end
		local dealer = TCBDealer.dealerSpawns[game.GetMap()][dealerID]
		
		local dealerResult = TCBDealer.dealerRange(ply, dealer)
		if !dealerResult then
			DarkRP.notify(ply, 1, 4, "You are not in range of the car dealer!") 
			return 
		end

		--> Spawns
		local spawnPoint = {}
		if TCBDealer.settings.checkSpawn then
			for k,v in pairs(dealer.spawns) do
				local entities = ents.FindInBox(Vector(v.pos.x + 100, v.pos.y + 100, v.pos.z - 150), Vector(v.pos.x - 100, v.pos.y - 100, v.pos.z + 150))
				
				local found = 0
				for _,v in pairs(entities) do
					if v:GetClass() != "physgun_beam" then
						found = 1
						break
					end
				end
				if found == 0 then
					spawnPoint = v
					break
				end
			end
		else
			spawnPoint = dealer.spawns[math.random(#dealer.spawns)]
		end

		if table.Count(spawnPoint) == 0 then
			DarkRP.notify(ply, 1, 4, "Something is blocking the spawn points.")
			return 
		end

		--> Spawn
		local vehicleList = list.GetForEdit("Vehicles")[vehID]
		if !vehicleList then return end

		local spawnedVehicle = ents.Create(vehicleList.Class)
		if !spawnedVehicle then return end

		spawnedVehicle:SetModel(vehicleList.Model)

		if vehicleList.KeyValues then
			for k, v in pairs(vehicleList.KeyValues) do
				spawnedVehicle:SetKeyValue(k, v)
			end
		end

		spawnedVehicle.VehicleTable = vehicleList

		if spawnedVehicle:GetModel() == "models/tdmcars/dod_ram_3500.mdl" then
			spawnedVehicle:SetPos(spawnPoint.pos + Vector( 0, 0, 50 ))
			spawnedVehicle:SetAngles(spawnPoint.ang)
		else
			spawnedVehicle:SetPos(spawnPoint.pos)
			spawnedVehicle:SetAngles(spawnPoint.ang)
		end
		spawnedVehicle:Spawn()
		spawnedVehicle:Activate()
		spawnedVehicle:SetNWString("dealerName", vehicle.name or vehicleList.Name)
		spawnedVehicle:SetNWString("dealerClass", vehID)
		spawnedVehicle:SetNWEntity( "Owner", ply )

		timer.Simple( 1, function()
			if VehicleFuel[ply:SteamID64()..spawnedVehicle:GetModel()] then
				spawnedVehicle:SetNWInt( "GAuto_FuelAmount", VehicleFuel[ply:SteamID64()..spawnedVehicle:GetModel()] )
			end
		end )
		
		gamemode.Call(PlayerSpawnedVehicle, ply, spawnedVehicle)
		ply:SetNWEntity("currentVehicle", spawnedVehicle)

		--> Color
		if vehicle.color then
			spawnedVehicle:SetColor(vehicle.color)
		elseif TCBDealer.settings.colorPicker then

			--> Variables
			local varColR = ply:GetInfoNum("tcb_cardealer_r", 0)
			local varColG = ply:GetInfoNum("tcb_cardealer_g", 0)
			local varColB = ply:GetInfoNum("tcb_cardealer_b", 0)

			--> Checks
			if varColR < 0 then varColR = 0 elseif varColR > 255 then varColR = 255 end
			if varColG < 0 then varColG = 0 elseif varColG > 255 then varColR = 255 end
			if varColB < 0 then varColB = 0 elseif varColB > 255 then varColB = 255 end

			--> Set Color
			spawnedVehicle:SetColor(Color(varColR, varColG, varColB, 255))

		elseif TCBDealer.settings.randomColor then
			spawnedVehicle:SetColor(Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255))
		end

		--> Test Drive
		ply.vehicleTest = false

		if timer.Exists("testDrive_"..ply:UniqueID()) then
			timer.Remove("testDrive_"..ply:UniqueID())
		end

		if testDrive then
			timer.Create("testDrive_"..ply:UniqueID(), TCBDealer.settings.testDriveLength, 1, function()

				if IsValid(ply) then
					ply:ExitVehicle()
					TCBDealer.removeVehicle(ply)
				end

				net.Start("TCBDealerChat")
					net.WriteString("Your test drive ran out!")
				net.Send(ply)

				ply.vehicleTest = false

			end)

			ply.vehicleTest = true

			net.Start("TCBDealerChat")
				net.WriteString("You can test drive this vehicle for the next "..TCBDealer.settings.testDriveLength.." seconds!")
			net.Send(ply)
		end

		--> Enter
		if TCBDealer.settings.autoEnter or testDrive then
			ply:EnterVehicle(spawnedVehicle)
		end

	end

	--> Own
	if !testDrive then
		local vehOwn = {}
		MySQLite.query(string.format([[SELECT * FROM tcb_cardealer WHERE steamID = %s AND vehicle = %s]], MySQLite.SQLStr(ply:SteamID()), MySQLite.SQLStr(vehID)), function(data)
			--> Variables
			vehOwn = data or {}
			--> Own
			if table.Count(vehOwn) == 0 then
				DarkRP.notify(ply, 1, 4, "The requested vehicle is not in you garage.") 
				return 
			end
			--> Code
			spawnCode()
		end)
	else
		--> Code
		spawnCode()
	end
end
net.Receive("TCBDealerSpawn", TCBDealer.spawnVehicle)

--[[---------------------------------------------------------
	Store Vehicle
-----------------------------------------------------------]]
function TCBDealer.storeVehicle(length, ply)

	--> Network
	local dealerID = net.ReadInt(32)

	--> Dealer
	if !TCBDealer.dealerSpawns[game.GetMap()][dealerID] then
		DarkRP.notify(ply, 1, 4, "The car dealer wasn't found.") 
		return 
	end
	local dealer = TCBDealer.dealerSpawns[game.GetMap()][dealerID]
	
	local dealerResult = TCBDealer.dealerRange(ply, dealer)
	if !dealerResult then
		DarkRP.notify(ply, 1, 4, "You are not in range of the car dealer!") 
		return 
	end

	--> Vehicle
	local currentVehicle = ply:GetNWEntity("currentVehicle")
	local dist = TCBDealer.settings.storeDistance * TCBDealer.settings.storeDistance
	if IsValid(currentVehicle) and currentVehicle:GetPos():DistToSqr(ply:GetPos()) <= dist then
		TCBDealer.removeVehicle(ply)
		DarkRP.notify(ply, 3, 4, "Your vehicle was stored in your garage!")
		return
	else
		DarkRP.notify(ply, 1, 4, "The vehicle is not in range.") 
		return
	end 

end
net.Receive("TCBDealerStore", TCBDealer.storeVehicle)

--[[---------------------------------------------------------
	Remove Vehicle
-----------------------------------------------------------]]
function TCBDealer.removeVehicle(ply)
	local currentVehicle = ply:GetNWEntity("currentVehicle")
	if IsValid(currentVehicle) then
		currentVehicle:Remove()
		VehicleFuel[ply:SteamID64()..currentVehicle:GetModel()] = currentVehicle:GetNWInt( "GAuto_FuelAmount" )
	end
end
hook.Add("PlayerDisconnected", "TCBDealer.removeVehicle", TCBDealer.removeVehicle)

--[[---------------------------------------------------------
	Player Changed
-----------------------------------------------------------]]
function TCBDealer.playerChanged(ply)
	local currentVehicle = ply:GetNWEntity("currentVehicle")
	if IsValid(currentVehicle) then
		local vehicle = TCBDealer.vehicleTable[currentVehicle:GetNWString("dealerClass")]
		if vehicle and vehicle.customCheck and !vehicle.customCheck(ply) then
			TCBDealer.removeVehicle(ply)
			DarkRP.notify(ply, 1, 4, "You no longer qualify for your vehicle.") 
			return
		end
	end
end
hook.Add("OnPlayerChangedTeam", "TCBDealer.playerChanged", TCBDealer.playerChanged)

--[[---------------------------------------------------------
	Dealer Range
-----------------------------------------------------------]]
function TCBDealer.dealerRange(ply, dealer)
	return ply:GetPos():DistToSqr(dealer.pos) <= 360000
end

--Rental and sell scripts start below--
util.AddNetworkString( "RentVehicle" )
local function RentVehicle( len, ply )
	local veh = net.ReadString()
	local price = TCBDealer.vehicleTableRent[veh].price
	if ply:Team() != TEAM_TOWER then return end

	if ply:canAfford( price ) then
		ply:addMoney( -price )
	else
		DarkRP.notify( ply, 1, 6, "You can't afford to rent this vehicle!" )
		return
	end

	local vehicleList = list.GetForEdit("Vehicles")[veh]
	local spawnedVehicle = ents.Create( vehicleList.Class )
	if !spawnedVehicle then return end
	spawnedVehicle:SetModel(vehicleList.Model)
	if vehicleList.KeyValues then
		for k,v in pairs(vehicleList.KeyValues) do
			spawnedVehicle:SetKeyValue( k, v )
		end
	end
	spawnedVehicle.VehicleTable = vehicleList

	local pos = rentspawns[game.GetMap()]
	spawnedVehicle:SetPos( pos[1] )
	spawnedVehicle:SetAngles( pos[2] )
	spawnedVehicle:Spawn()
	spawnedVehicle:Activate()
	spawnedVehicle:SetNWBool( "IsRental", true )
	spawnedVehicle:SetNWString( "dealerClass", veh )
	DarkRP.notify( ply, 0, 6, "You have rented a "..vehicleList.Name.." for "..DarkRP.formatMoney( price ).."." )
end
net.Receive( "RentVehicle", RentVehicle )

util.AddNetworkString( "SellVehicle" )
local function SellVehicle( len, ply )
	local veh = net.ReadEntity()
	local class = veh:GetNWString( "dealerClass" )
	local price = TCBDealer.vehicleTable[class].price
	local finalprice = price * 0.05
	if ply:isWanted() then
		DarkRP.notify( ply, 1, 6, "You can't sell vehicles while wanted." )
		return
	end
	if !IsValid( veh ) or ply:Team() != TEAM_TOWER or !class or class == "" or ply:GetNWEntity( "currentVehicle" ) == veh or IsValid( veh:GetDriver() ) then
		DarkRP.notify( ply, 1, 6, "You can't sell this vehicle." )
		return
	end
	ply:addMoney( finalprice )
	DarkRP.notify( ply, 0, 6, "You have sold a vehicle for "..DarkRP.formatMoney( finalprice ).."." )
	if !veh:GetNWBool( "IsRental" ) then
		local rand = math.random( 1, 10 )
		if rand <= 3 then
			ply:wanted( nil, "Selling a stolen vehicle." )
		end
	end
	veh:Remove()
end
net.Receive( "SellVehicle", SellVehicle )