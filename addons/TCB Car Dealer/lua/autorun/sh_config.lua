/*---------------------------------------------------------------------------
	
	Creator: TheCodingBeast - TheCodingBeast.com
	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
	To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/
	
---------------------------------------------------------------------------*/

--[[---------------------------------------------------------
	Variables
-----------------------------------------------------------]]
TCBDealer = TCBDealer or {}

TCBDealer.settings = {}
TCBDealer.dealerSpawns = {}
TCBDealer.vehicleTable = {}
TCBDealer.vehicleTableRent = {}

--[[---------------------------------------------------------
	Version
-----------------------------------------------------------]]
TCBDealer.version = 1.4

--[[---------------------------------------------------------
	Settings
-----------------------------------------------------------]]
TCBDealer.settings.testDriveLength = 30
TCBDealer.settings.salePercentage = 75
TCBDealer.settings.storeDistance = 400
TCBDealer.settings.colorPicker = true
TCBDealer.settings.randomColor = false
TCBDealer.settings.checkSpawn = false
TCBDealer.settings.autoEnter = true
TCBDealer.settings.frameTitle = "Car Dealer"

--[[---------------------------------------------------------
	Dealer Spawns
-----------------------------------------------------------]]
TCBDealer.dealerSpawns["rp_rockford_v2b"] = {
	{
		pos = Vector(-4754, -678, 64),
		ang = Angle(0, -90, 0),
		spawns = {
			{
				pos = Vector(-6099, -1753, 64),
				ang = Angle(0, -90, 0)
			},
			{
				pos = Vector(-6095, -1417, 64),
				ang = Angle(0, -90, 0)
			}
		}
	}
}

TCBDealer.dealerSpawns["rp_southside_day"] = {
	{
		pos = Vector( -7580, 1597, -31 ),
		ang = angle_zero,
		spawns = {
			{
				pos = Vector( -6849, 870, -39 ),
				ang = Angle(0, 90, 0)
			}
		}
	}
}

TCBDealer.dealerSpawns["rp_riverden_v1a"] = {
	{
		pos = Vector( -3924, 11710, 0 ),
		ang = Angle( 0, 180, 0 ),
		spawns = {
			{
				pos = Vector( -3392, 10657, -8 ),
				ang = Angle( 0, 180, 0 )
			}
		}
	}
}

TCBDealer.dealerSpawns["rp_truenorth_v1a"] = {
	{
		pos = Vector( 6075, 13063, 8 ),
		ang = angle_zero,
		spawns = {
			{
				pos = Vector( 6867, 12538, 8 ),
				ang = angle_zero
			}
		}
	}
}
--[[---------------------------------------------------------
	Vehicles - http://facepunch.com/showthread.php?t=1481400 / https://www.youtube.com/watch?v=WSTBFk6nX6k
-----------------------------------------------------------]]
--customCheck = function(ply) return table.HasValue({TEAM_EMT, TEAM_.., TEAM_..}, ply:Team()) end
--[[
TCBDealer.vehicleTable[""] = {
	price = ,
}
]]

--Rental vehicle tables start below--

TCBDealer.vehicleTableRent["suzuki_kingquad_lw"] = {
	price = 200
}

TCBDealer.vehicleTableRent["chev_impala_09"] = {
	price = 700
}

TCBDealer.vehicleTableRent["gmcvantdm"] = {
	price = 700
}

TCBDealer.vehicleTableRent["dod_ram_1500tdm"] = {
	price = 1000
}

TCBDealer.vehicleTableRent["rv"] = {
	price = 1700
}

TCBDealer.vehicleTableRent["bm_M35"] = {
	price = 2000
}

TCBDealer.vehicleTableRent["charger2012tdm"] = {
	price = 2000
}

TCBDealer.vehicleTableRent["fer_512trtdm"] = {
	price = 7000
}

TCBDealer.vehicleTableRent["murcielagosvtdm"] = {
	price = 7000
}

TCBDealer.vehicleTableRent["reventonrtdm"] = {
	price = 9000
}

TCBDealer.vehicleTableRent["lambosine"] = {
	price = 10000
}

TCBDealer.vehicleTableRent["c5500tdm"] = {
	price = 2000
}

TCBDealer.vehicleTableRent["courier_trucktdm"] = {
	price = 1000
}

--Normal vehicle tables start below--
--This list should be ordered from cheapest to most expensive
TCBDealer.vehicleTable["bustdm"] = {
	price = 0,
	customCheck = function(ply) return ply:Team() == TEAM_BUS end
}

TCBDealer.vehicleTable["gmc_savana_news_lw"] = {
	price = 0,
	customCheck = function(ply) return ply:Team() == TEAM_CAMERA end
}

TCBDealer.vehicleTable["suzuki_kingquad_lw"] = {
	price = 2500,
}

TCBDealer.vehicleTable["Polaris Quad 6x6 Utility"] = {
	price = 4500,
}

TCBDealer.vehicleTable["dodge_monaco_lw"] = {
	price = 5000,
}

TCBDealer.vehicleTable["pon_firebirdtransamtdm"] = {
	price = 6000,
}

TCBDealer.vehicleTable["chev_impala_09"] = {
	price = 10000,
}

TCBDealer.vehicleTable["pon_fierogttdm"] = {
	price = 10000,
}

TCBDealer.vehicleTable["chev_impala_09_taxi"] = {
	price = 10500,
}

TCBDealer.vehicleTable["gmcvantdm"] = {
	price = 11000,
}

TCBDealer.vehicleTable["syclonetdm"] = {
	price = 12000,
}

TCBDealer.vehicleTable["h1tdm"] = {
	price = 20000,
}

TCBDealer.vehicleTable["h1opentdm"] = {
	price = 20000,
}

TCBDealer.vehicleTable["chev_suburban"] = {
	price = 20000,
}

TCBDealer.vehicleTable["chev_tahoe_lw"] = {
	price = 20000,
}

TCBDealer.vehicleTable["dod_ram_1500tdm"] = {
	price = 20000,
}

TCBDealer.vehicleTable["courier_trucktdm"] = {
	price = 20000
}

TCBDealer.vehicleTable["Airboat"] = {
	price = 25000,
}

TCBDealer.vehicleTable["rv"] = {
	price = 25000,
}

TCBDealer.vehicleTable["challanger70tdm"] = {
	price = 25000,
}

TCBDealer.vehicleTable["chargersrt8tdm"] = {
	price = 25000,
}

TCBDealer.vehicleTable["c5500tdm"] = {
	price = 30000,
}

TCBDealer.vehicleTable["bm_M35"] = {
	price = 30000,
}

TCBDealer.vehicleTable["dod_ram_3500tdm"] = {
	price = 30000,
}

TCBDealer.vehicleTable["charger2012tdm"] = {
	price = 30000,
}

TCBDealer.vehicleTable["dod_challenger15tdm"] = {
	price = 30000,
}

TCBDealer.vehicleTable["dodgeramtdm"] = {
	price = 35000,
}

TCBDealer.vehicleTable["vipvipertdm"] = {
	price = 45000,
}

TCBDealer.vehicleTable["diablotdm"] = {
	price = 50000,
}

TCBDealer.vehicleTable["fer_250gttdm"] = {
	price = 60000,
}

TCBDealer.vehicleTable["fer_250gtotdm"] = {
	price = 60000,
}

TCBDealer.vehicleTable["ferf430tdm"] = {
	price = 60000,
}

TCBDealer.vehicleTable["lam_huracan_lw"] = {
	price = 65000,
}

TCBDealer.vehicleTable["gallardospydtdm"] = {
	price = 70000,
}

TCBDealer.vehicleTable["miuracontdm"] = {
	price = 80000,
}

TCBDealer.vehicleTable["cybertruck_sgm"] = {
	price = 100000,
}

TCBDealer.vehicleTable["aventador"] = {
	price = 100000,
}

TCBDealer.vehicleTable["fer_458spidtdm"] = {
	price = 100000,
}

TCBDealer.vehicleTable["fer_512trtdm"] = {
	price = 100000,
}

TCBDealer.vehicleTable["murcielagosvtdm"] = {
	price = 100000,
}

TCBDealer.vehicleTable["ferf12tdm"] = {
	price = 120000,
}

TCBDealer.vehicleTable["reventonrtdm"] = {
	price = 140000,
}

TCBDealer.vehicleTable["lambosine"] = {
	price = 150000,
}

TCBDealer.vehicleTable["laferrari"] = {
	price = 200000,
}

TCBDealer.vehicleTable["fer_enzotdm"] = {
	price = 250000,
}

TCBDealer.vehicleTable["veneno_new"] = {
	price = 300000,
}

TCBDealer.vehicleTable["rcars_patty_wagon2"] = {
	price = 500000,
}

TCBDealer.vehicleTable["ctv_grave_digger"] = {
	price = 1000000,
}