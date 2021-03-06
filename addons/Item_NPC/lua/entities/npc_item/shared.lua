
--[[
	This is a modified version of my Item NPC addon. If you are looking for the main addon, it can be found here: https://github.com/LambdaGaming/Item_NPC

	If you are here to find out how to add a specific item, more than likely you will find it below. Some items that have been added to this NPC include
	health, armor, weapons, entities, and vehicles. This version also includes support for having animated playermodels on the NPC base.
	(Which can be found in the init.lua under the ENT:Think() function.) If you need a custom item added and you can't find an example on how to do
	it here, feel free to add me on steam and ask me about it: https://steamcommunity.com/profiles/76561198136556075 (Make sure you leave a comment stating why you're adding me or you'll get ignored)
]]

ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Item NPC"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.Category = "Item NPC"

local rockford = "rp_rockford_v2b"
local southside = "rp_southside"
local evocity = "rp_evocity2_v5p"
local florida = "rp_florida_v2"
local truenorth = "rp_truenorth_v1a"
local newexton = "rp_newexton2_v4h"
local map = game.GetMap()

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "NPCType" )
end

local VehicleSpawns
if SERVER then
	local angle_ninety = Angle( 0, 90, 0 )
	local angle_ninety_neg = Angle( 0, -90, 0 )
	local angle_one_eighty = Angle( 0, 180, 0 )
	VehicleSpawns = {
		{ --Police spawns
			[rockford] = { Vector( -8248, -5485, 0 ), angle_zero },
			[southside] = { Vector( 8688, 8619, -127 ), angle_ninety },
			[evocity] = { Vector( -13, -2278, -179 ), angle_zero },
			[florida] = { Vector( 6537, -1612, 136 ), angle_zero },
			[truenorth] = { Vector( 3238, 3914, 0 ), angle_zero },
			[newexton] = { Vector( -7225, 10207, 1024 ), angle_ninety_neg }
		},
		{ --Fire spawns
			[rockford] = { Vector( -5257, -3349, 8 ), angle_one_eighty },
			[southside] = { Vector( 9431, 1260, -103 ), angle_ninety_neg },
			[evocity] = { Vector( 5363, 13248, 68 ), angle_zero },
			[florida] = { Vector( 6604, -4522, 136 ), angle_ninety },
			[truenorth] = { Vector( 13135, 11426, 8 ), angle_ninety },
			[newexton] = { Vector( 199, -6835, 1024 ), angle_one_eighty }
		},
		{ --Medic spawns
			[rockford] = { Vector( 318, -4842, 64 ), angle_ninety },
			[southside] = { Vector( 7308, 4544, -63 ), angle_ninety },
			[evocity] = { Vector( -3191, 417, 76 ), angle_zero },
			[florida] = { Vector( 6714, 2145, 128 ), angle_ninety },
			[truenorth] = { Vector( 13135, 11426, 8 ), angle_ninety },
			[newexton] = { Vector( 7651, 7446, 1016 ), angle_ninety }
		},
		{ --Tow truck spawns
			[rockford] = { Vector( -7564, 680, 3 ), angle_zero },
			[southside] = { Vector( -1656, 6421, 14 ), angle_zero },
			[evocity] = { Vector( -3282, 2636, 76 ), angle_zero },
			[florida] = { Vector( 2198, -2753, 131 ), angle_ninety_neg },
			[truenorth] = { Vector( 8909, 12963, 0 ), angle_zero },
			[newexton] = { Vector( -5618, -7700, -511 ), angle_zero }
		},
		{ --Semi spawns
			[rockford] = { Vector( -1434, 4509, 536 ), angle_ninety },
			[southside] = { Vector( 701, -3806, -231 ), angle_ninety_neg },
			[evocity] = { Vector( 8621, 3497, -1824 ), angle_one_eighty },
			[florida] = { Vector( -1930, 8490, 128 ), angle_one_eighty },
			[truenorth] = { Vector( 12511, -10243, 0 ), angle_zero },
			[newexton] = { Vector( 14464, 12104, -7 ), angle_one_eighty }
		},
		{ --Trailer spawns
			[rockford] = { Vector( -851, 4153, 536 ), angle_zero },
			[southside] = { Vector( 701, -3806, -231 ), angle_ninety },
			[evocity] = { Vector( 8005, 3514, -1824 ), angle_one_eighty },
			[florida] = { Vector( -1481, 7813, 128 ), angle_ninety },
			[truenorth] = { Vector( 12993, -10200, 0 ), angle_one_eighty },
			[newexton] = { Vector( 15593, 12228, -7 ), angle_ninety }
		},
		{ --Smuggle truck spawns
			[rockford] = { Vector( -2893, -6357, 0 ) , angle_ninety_neg },
			[southside] = { Vector( -7011, -3749, -319 ), angle_one_eighty },
			[evocity] = { Vector( 8528, 8225, 64 ), angle_ninety_neg },
			[florida] = { Vector( 9, -135, 156 ), angle_ninety },
			[truenorth] = { Vector( 6137, 8882, 0 ), angle_zero },
			[newexton] = { Vector( -12616, 6635, 1016 ), Angle( 0, 145, 0 ) }
		}
	}
end

local function SpawnBlueprint( ply )
	local combined = table.Add( BLUEPRINT_CONFIG_TIER1, BLUEPRINT_CONFIG_TIER2 )
	combined = table.Add( combined, BLUEPRINT_CONFIG_TIER3 )
	local randwep = table.Random( combined )
	local e = ents.Create( "crafting_blueprint" )
	e:SetPos( ply:GetPos() + Vector( 0, 30, 0 ) )
	e:SetAngles( ply:GetAngles() + Angle( 0, 180, 0 ) )
	e:Spawn()
	e:SetEntName( randwep[1] )
	e:SetRealName( randwep[2] )
	e:SetUses( 3 )
end

SmuggleItems = {
	{
		Name = "Number Nine Large",
		Model = "models/food/burger.mdl",
		Pos = Vector( 0, -110, 30 ),
		Reward = function( ply )
			ply:addMoney( 1300 )
			return "$1,300"
		end
	},
	{
		Name = "Illegal Ammunition",
		Model = "models/Items/item_item_crate_dynamic.mdl",
		Pos = Vector( 0, -110, 40 ),
		Reward = function( ply )
			ply:addMoney( 3500 )
			return "$3,500"
		end
	},
	{
		Name = "Unregistered Weapons",
		Model = "models/props/CS_militia/footlocker01_closed.mdl",
		Pos = Vector( 0, -50, 50 ),
		Reward = function( ply )
			ply:addMoney( 6500 )
			return "$6,500"
		end
	},
	{
		Name = "C4",
		Model = "models/weapons/w_c4_planted.mdl",
		Pos = Vector( 0, -110, 40 ),
		Reward = function( ply )
			SpawnBlueprint( ply )
			return "a random tier crafting blueprint"
		end
	},
	{
		Name = "Stolen Sports Car",
		Model = "models/sentry/veneno_new.mdl",
		Pos = Vector( 0, -110, 40 ),
		Reward = function( ply )
			SpawnBlueprint( ply )
			ply:addMoney( 15000 )
			return "a random tier crafting blueprint and $15,000"
		end
	}
}

local function SpawnVehicle( ply, class, model, script, type, noenter, smugid )
	if SERVER then
		local realpos = VehicleSpawns[type][map][1]
		if model == "models/tdmcars/dod_ram_3500.mdl" then --Fix for this truck since it spawns below the map for some reason
			realpos = realpos + Vector( 0, 0, 50 )
		end
		local e = ents.Create( "prop_vehicle_jeep" )
		e:SetKeyValue( "vehiclescript", script )
		e:SetPos( realpos )
		e:SetAngles( VehicleSpawns[type][map][2] )
		e:SetModel( model )
		e:Spawn()
		e:Activate()
		e.VehicleTable = list.GetForEdit( "Vehicles" )[class]
		e:Fire( "HandBrakeOff", "", 0.01 )
		e:SetNWEntity( "VehicleOwner", ply )
		if smugid then
			local item = SmuggleItems[smugid]
			e.SmuggleTruck = true
			e.SmuggleOwner = ply
			e.SmuggleID = smugid
			e:SetBodygroup( 1, 1 )
			local prop = ents.Create( "prop_dynamic" )
			prop:SetModel( item.Model )
			prop:SetParent( e )
			prop:SetLocalPos( item.Pos )
			prop:SetLocalAngles( angle_zero )
			prop:Spawn()
			DarkRP.notify( ply, 0, 6, "Deliver this truck to the Smuggle Sell NPC for a reward." )
		end
		if !noenter then
			ply:EnterVehicle( e )
		end
	end
end

local function PoliceBanCheck( ply )
	if GetGlobalBool( "PoliceCarBanActive" ) then
		DarkRP.notify( ply, 1, 6, "You cannot spawn this vehicle due to the mayor ordering a temporary ban on all police cars." )
		return false
	end
	return true
end

local function ApplyBlueprintData( ent, index )
	ent:SetEntName( BLUEPRINT_CONFIG_TIER1[index][1] )
	ent:SetRealName( BLUEPRINT_CONFIG_TIER1[index][2] )
	ent:SetUses( 3 )
end

local function SmuggleCheck( ply )
	local copcount = team.NumPlayers( TEAM_POLICEBOSS ) + team.NumPlayers( TEAM_OFFICER ) + team.NumPlayers( TEAM_SWATBOSS ) + team.NumPlayers( TEAM_SWAT ) + team.NumPlayers( TEAM_UNDERCOVER ) + team.NumPlayers( TEAM_FBI )
	if ply.SmuggleCooldown and ply.SmuggleCooldown > CurTime() then
		DarkRP.notify( ply, 1, 6, "Please wait "..string.ToMinutesSeconds( ply.SmuggleCooldown - CurTime() ).." to smuggle again." )
		return false
	end
	if copcount < 1 then
		DarkRP.notify( ply, 1, 6, "There needs to be at least 1 cop on the server for smuggling to unlock." )
		return false
	end
	return true
end

local function DoSmuggle( ply, id )
	local class = "c5500tdm"
	local model = "models/tdmcars/trucks/gmc_c5500.mdl"
	local script = "scripts/vehicles/TDMCars/c5500.txt"
	SpawnVehicle( ply, class, model, script, 7, false, id )
	ply.SmuggleCooldown = CurTime() + 600
end

ItemNPC = {} --Initializes the item table, don't touch
ItemNPCType = {} --Initializes the type table, don't touch

ItemNPCType[1] = {
	Name = "Supermarket",
	Model = "models/breen.mdl",
	MenuColor = Color( 49, 53, 61, 200 ),
	MenuTextColor = color_white,
	ButtonColor = Color( 230, 93, 80, 255 ),
	ButtonTextColor = color_white,
	Allowed = {}
}

ItemNPCType[2] = {
	Name = "Contraband Dealer",
	Model = "models/Humans/Group03/male_07.mdl",
	MenuColor = Color( 230, 93, 80, 200 ),
	MenuTextColor = color_white,
	ButtonColor = Color( 49, 53, 61, 255 ),
	ButtonTextColor = color_white,
	Allowed = {}
}

ItemNPCType[3] = {
	Name = "Firefighter",
	Model = "models/player/portal/male_07_fireman.mdl",
	MenuColor = Color( 49, 53, 61, 200 ),
	MenuTextColor = color_white,
	ButtonColor = Color( 230, 93, 80, 255 ),
	ButtonTextColor = color_white,
	Allowed = {
		[TEAM_FIREBOSS] = true,
		[TEAM_FIRE] = true
	}
}

ItemNPCType[4] = {
	Name = "Police Secretary",
	Model = "models/taggart/police01/male_07.mdl",
	MenuColor = Color( 49, 53, 61, 200 ),
	MenuTextColor = color_white,
	ButtonColor = Color( 230, 93, 80, 255 ),
	ButtonTextColor = color_white,
	Allowed = {
		[TEAM_MAYOR] = true,
		[TEAM_POLICEBOSS] = true,
		[TEAM_OFFICER] = true,
		[TEAM_SWATBOSS] = true,
		[TEAM_SWAT] = true,
		[TEAM_UNDERCOVER] = true,
		[TEAM_FBI] = true
	}
}

ItemNPCType[5] = {
	Name = "Paramedic",
	Model = "models/player/magnusson.mdl",
	MenuColor = Color( 49, 53, 61, 200 ),
	MenuTextColor = color_white,
	ButtonColor = Color( 230, 93, 80, 255 ),
	ButtonTextColor = color_white,
	Allowed = {
		[TEAM_FIREBOSS] = true,
		[TEAM_FIRE] = true
	}
}

ItemNPCType[6] = {
	Name = "Healer",
	Model = "models/kleiner.mdl",
	MenuColor = Color( 49, 53, 61, 200 ),
	MenuTextColor = color_white,
	ButtonColor = Color( 230, 93, 80, 255 ),
	ButtonTextColor = color_white,
	Allowed = {}
}

ItemNPCType[7] = {
	Name = "Tower",
	Model = "models/monk.mdl",
	MenuColor = Color( 49, 53, 61, 200 ),
	MenuTextColor = color_white,
	ButtonColor = Color( 230, 93, 80, 255 ),
	ButtonTextColor = color_white,
	Allowed = {
		[TEAM_TOWER] = true
	}
}

ItemNPCType[8] = {
	Name = "Trucker",
	Model = "models/humans/group02/male_08.mdl",
	MenuColor = Color( 49, 53, 61, 200 ),
	MenuTextColor = color_white,
	ButtonColor = Color( 230, 93, 80, 255 ),
	ButtonTextColor = color_white,
	Allowed = {}
}

ItemNPCType[9] = {
	Name = "Smuggle Seller",
	Model = "models/humans/group03/male_01.mdl",
	MenuColor = Color( 49, 53, 61, 200 ),
	MenuTextColor = color_white,
	ButtonColor = Color( 230, 93, 80, 255 ),
	ButtonTextColor = color_white,
	Allowed = {
		[TEAM_CITIZEN] = true,
		[TEAM_TOWER] = true,
		[TEAM_CAMERA] = true,
		[TEAM_BUS] = true,
		[TEAM_HITMAN] = true
	}
}

-----SHOP NPC ITEMS-----
ItemNPC["cw_nen_glock17"] = {
	Name = "Glock 17",
	Description = "Does good amounts of damage at medium range.",
	Model = "models/weapons/nen/glock 17/w_pist_glock17.mdl",
	Price = 800,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "cw_nen_glock17" )
	end
}

ItemNPC["cw_p99"] = {
	Name = "P99",
	Description = "Does fair amounts of damage at medium range.",
	Model = "models/weapons/w_pist_p228.mdl",
	Price = 500,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "cw_p99" )
	end
}

ItemNPC["cw_fiveseven"] = {
	Name = "FiveSeven",
	Description = "Does pretty good amounts of damage at medium range.",
	Model = "models/weapons/w_pist_fiveseven.mdl",
	Price = 900,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "cw_fiveseven" )
	end
}

ItemNPC["cw_deagle"] = {
	Name = "Desert Eagle",
	Description = "Does heavy amounts of damage at all ranges, most powerful sidearm.",
	Model = "models/weapons/w_pist_deagle.mdl",
	Price = 1500,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "cw_deagle" )
	end
}

ItemNPC["cw_mac11"] = {
	Name = "MAC-11",
	Description = "Automatic pistol, does fair amounts of damage.",
	Model = "models/weapons/w_cst_mac11.mdl",
	Price = 2500,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "cw_mac11" )
	end
}

ItemNPC["cw_mp5"] = {
	Name = "MP5",
	Description = "Automatic weapon, does fair amounts of damage.",
	Model = "models/weapons/w_smg_mp5.mdl",
	Price = 3500,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "cw_mp5" )
	end
}

ItemNPC["mediaplayer_tv"] = {
	Name = "Media Player",
	Description = "Watch meme videos and torture prisoners with Undertale cringe.",
	Model = "models/gmod_tower/suitetv_large.mdl",
	Price = 200,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "mediaplayer_tv" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
	end
}

ItemNPC["swm_chopping_axe"] = {
	Name = "Axe",
	Description = "For chopping down trees.",
	Model = "models/weapons/w_chopping_axe/w_chopping_axe.mdl",
	Price = 200,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "swm_chopping_axe" )
	end
}

ItemNPC["mgs_pickaxe"] = {
	Name = "Pickaxe",
	Description = "For mining rocks.",
	Model = "models/weapons/w_stone_pickaxe.mdl",
	Price = 300,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "mgs_pickaxe" )
	end
}

ItemNPC["mgs_cart"] = {
	Name = "Mining Cart",
	Description = "Holds up to 20 ores or logs, can be put in a grinder or sawmill for a profit.",
	Model = "models/props_wasteland/laundry_cart002.mdl",
	Price = 200,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "mgs_cart" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		e:Setowning_ent( ply )
	end
}

ItemNPC["enterprise_crowbar"] = {
	Name = "Crowbar",
	Description = "Easy to handle, good for breaking things.",
	Model = "models/weapons/w_crowbar.mdl",
	Price = 400,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "enterprise_crowbar" )
	end
}

ItemNPC["weapon_extinguisher_infinite"] = {
	Name = "Fire Extinguisher",
	Description = "Puts out fires.",
	Model = "models/weapons/w_fire_extinguisher.mdl",
	Price = 100,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "weapon_extinguisher_infinite" )
	end
}

ItemNPC["cw_extrema_ratio_official"] = {
	Name = "Knife",
	Description = "Sharp metal blade to easily slice through almost anything.",
	Model = "models/weapons/wcw_ex_ra.mdl",
	Price = 250,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "cw_extrema_ratio_official" )
	end
}

ItemNPC["cw_ws_mosin"] = {
	Name = "Mosin Nagant",
	Description = "Small rifle, has scopes for long range encounters.",
	Model = "models/weapons/ws mosin/w_ws_mosin.mdl",
	Price = 4000,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "cw_ws_mosin" )
	end
}

ItemNPC["crafting_table"] = {
	Name = "Crafting Table",
	Description = "Make things using this workbench!",
	Model = "models/props_wasteland/controlroom_desk001b.mdl",
	Price = 200,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_table" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
	end
}

ItemNPC["automod_repair_kit"] = {
	Name = "Vehicle Repair Kit",
	Description = "Repairs 30% of your vehicles max health.",
	Model = "models/Items/HealthKit.mdl",
	Price = 200,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "automod_repair_kit" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
	end
}

ItemNPC["cw_ump45"] = {
	Name = "UMP 45",
	Description = "Large, automatic SMG.",
	Model = "models/weapons/w_smg_ump45.mdl",
	Price = 3500,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "cw_ump45" )
	end
}

ItemNPC["cw_l85a2"] = {
	Name = "L85A2",
	Description = "Large, automatic SMG.",
	Model = "models/weapons/w_cw20_l85a2.mdl",
	Price = 5000,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "cw_l85a2" )
	end
}

ItemNPC["cw_m1911"] = {
	Name = "M1911",
	Description = "Does alright damage, least powerful sidearm.",
	Model = "models/weapons/cw_pist_m1911.mdl",
	Price = 300,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "cw_m1911" )
	end
}

ItemNPC["cw_makarov"] = {
	Name = "Makarov",
	Description = "Soviet standard issue side arm.",
	Model = "models/cw2/pistols/w_makarov.mdl",
	Price = 300,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "cw_makarov" )
	end
}

ItemNPC["slot_machine"] = {
	Name = "Slot Machine",
	Description = "Spend money to try and win more money.",
	Model = "models/props/slotmachine/slotmachinefinal.mdl",
	Price = 500,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "slot_machine" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 30 ) )
		e:Spawn()
	end
}

ItemNPC["apple_seeds"] = {
	Name = "Apple Seeds",
	Description = "Grows an apple tree.",
	Model = "models/props/de_inferno/crate_fruit_break_gib2.mdl",
	Price = 100,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "farm_plant" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:SetPlantType( 1 )
		e:Spawn()
	end
}

ItemNPC["cabbage_seeds"] = {
	Name = "Cabbage Seeds",
	Description = "Grows a cabbage plant.",
	Price = 350,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "farm_plant" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:SetPlantType( 2 )
		e:Spawn()
	end
}

ItemNPC["cantaloupe_seeds"] = {
	Name = "Cantaloupe Seeds",
	Description = "Grows a cantaloupe plant.",
	Price = 800,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "farm_plant" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:SetPlantType( 3 )
		e:Spawn()
	end
}

ItemNPC["potato_seeds"] = {
	Name = "Potato Seeds",
	Description = "Grows potatos.",
	Model = "models/props_phx/misc/potato.mdl",
	Price = 225,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "farm_plant" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:SetPlantType( 4 )
		e:Spawn()
	end
}

ItemNPC["watermelon_seeds"] = {
	Name = "Watermelon Seeds",
	Description = "Grows a watermelon plant.",
	Model = "models/props_junk/watermelon01.mdl",
	Price = 1300,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "farm_plant" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:SetPlantType( 5 )
		e:Spawn()
	end
}

ItemNPC["farm_box"] = {
	Name = "Farm Box",
	Description = "Fill this with grown food and take to the farmer NPC for money.",
	Model = "models/props_junk/wood_crate002a.mdl",
	Price = 100,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "farm_box" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		e:SetNWEntity( "owner", ply )
	end
}

ItemNPC["weapon_checker"] = {
	Name = "Handheld Metal Detector",
	Description = "Detects weapons being carried by a player.",
	Model = "models/weapons/Custom/w_scanner.mdl",
	Price = 200,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "weapon_checker" )
	end
}

ItemNPC["metal_detector"] = {
	Name = "Metal Detector",
	Description = "Doesn't require a player to function, also checks inventories.",
	Model = "models/props_wasteland/interior_fence002e.mdl",
	Price = 600,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "metal_detector" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		e:SetOwningEntity( ply )
	end
}

ItemNPC["zpizmak_opensign"] = {
	Name = "Business Sign",
	Description = "Displays opened or closed, use key to change status.",
	Model = "models/props_trainstation/TrackSign02.mdl",
	Price = 50,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "zpizmak_opensign" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
	end
}

ItemNPC["anti_bomb"] = {
	Name = "Car Bomb Protection",
	Description = "One time use item. Protects a car from bombs being placed on it. Does not protect against bombs already placed on the car.",
	Model = "models/props_junk/metal_paintcan001a.mdl",
	Price = 800,
	Type = 1,
	SpawnCheck = function( ply, self )
		if ply:Team() != TEAM_TOWER then
			if SERVER then
				DarkRP.notify( ply, 1, 6, "Only tow truck drivers can purchase this item." )
			end
			return false
		end
		return true
	end,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "anti_bomb" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
	end
}

ItemNPC["life_alert"] = {
	Name = "Life Alert",
	Description = "Notifies police and EMS of your location when you type !alert. Gets removed when you die.",
	Model = "models/props_lab/reciever01d.mdl",
	Price = 600,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "life_alert" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
	end
}

ItemNPC["announcement_speaker"] = {
	Name = "Announcement Speaker",
	Description = "Broadcast your voice over a loudspeaker. Requires an announcement microphone to work.",
	Model = "models/props_wasteland/speakercluster01a.mdl",
	Price = 100,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "announcement_speaker" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
	end
}

ItemNPC["weapon_announcement"] = {
	Name = "Announcement Microphone",
	Description = "Broadcast your voice over a loudspeaker. Requires announcement speakers to work.",
	Model = "models/props_wasteland/speakercluster01a.mdl",
	Price = 800,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "weapon_announcement" )
	end
}

ItemNPC["dronesrewrite_bird"] = {
	Name = "Camera Drone",
	Description = "Drone with a camera on it, nothing special.",
	Model = "models/dronesrewrite/birddr/birddr.mdl",
	Price = 1000,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "dronesrewrite_bird" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		e:SetupOwner( ply )
	end
}

ItemNPC["dronesrewrite_spy"] = {
	Name = "Spy Drone",
	Description = "Identifies and points out entities by their class name.",
	Model = "models/dronesrewrite/spydr/spydr.mdl",
	Price = 3000,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "dronesrewrite_spy" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		e:SetupOwner( ply )
	end
}

ItemNPC["weapon_drr_fuelcan"] = {
	Name = "Drone Fuel",
	Description = "Fuels drones.",
	Model = "models/props_junk/gascan001a.mdl",
	Price = 400,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "weapon_drr_fuelcan" )
	end
}

ItemNPC["weapon_drr_repairtool"] = {
	Name = "Drone Repair Tool",
	Description = "Repairs drones.",
	Price = 200,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "weapon_drr_repairtool" )
	end
}

ItemNPC["automod_fuel"] = {
	Name = "Fuel Can",
	Description = "Fuels up to 75% of a vehicle's fuel capacity.",
	Model = "models/props_junk/gascan001a.mdl",
	Price = 200,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "automod_fuel" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
	end
}

ItemNPC["crafting_blueprint_g3a3"] = {
	Name = "G3A3 Crafting Blueprint",
	Description = "Crafting blueprint for the G3A3 rifle.",
	Model = "models/props_lab/binderblue.mdl",
	Price = 3000,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		ApplyBlueprintData( e, 1 )
	end
}

ItemNPC["crafting_blueprint_g36c"] = {
	Name = "G36C Crafting Blueprint",
	Description = "Crafting blueprint for the G36C rifle.",
	Model = "models/props_lab/binderblue.mdl",
	Price = 3000,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		ApplyBlueprintData( e, 2 )
	end
}

ItemNPC["crafting_blueprint_vss"] = {
	Name = "VSS Crafting Blueprint",
	Description = "Crafting blueprint for the VSS rifle.",
	Model = "models/props_lab/binderblue.mdl",
	Price = 3000,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		ApplyBlueprintData( e, 3 )
	end
}

ItemNPC["crafting_blueprint_lockpick"] = {
	Name = "Premium Lockpick Crafting Blueprint",
	Description = "Crafting blueprint for the premium lockpick.",
	Model = "models/props_lab/binderblue.mdl",
	Price = 700,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		ApplyBlueprintData( e, 4 )
	end
}

ItemNPC["crafting_blueprint_mr96"] = {
	Name = "MR-96 Crafting Blueprint",
	Description = "Crafting blueprint for the MR-96 revolver.",
	Model = "models/props_lab/binderblue.mdl",
	Price = 2500,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		ApplyBlueprintData( e, 5 )
	end
}

ItemNPC["crafting_blueprint_shorty"] = {
	Name = "Shorty Shotgun Crafting Blueprint",
	Description = "Crafting blueprint for the shorty shotgun.",
	Model = "models/props_lab/binderblue.mdl",
	Price = 5000,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		ApplyBlueprintData( e, 6 )
	end
}

ItemNPC["crafting_blueprint_nano"] = {
	Name = "Nano Drone Crafting Blueprint",
	Description = "Crafting blueprint for the nano drone.",
	Model = "models/props_lab/binderblue.mdl",
	Price = 3500,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		ApplyBlueprintData( e, 7 )
	end
}

ItemNPC["ore_smelter"] = {
	Name = "Ore Smelter",
	Description = "Used to smelt ores obtained from rocks.",
	Model = "models/props/cs_militia/furnace01.mdl",
	Price = 5000,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "ore_smelter" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
	end
}

ItemNPC["rp_gas"] = {
	Name = "Propane Canister",
	Description = "Propane gas for fueling industrial appliances.",
	Model = "models/props_junk/propane_tank001a.mdl",
	Price = 250,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "rp_gas" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 35 ) )
		e:Spawn()
	end
}

-----CONTRABAND ITEMS-----
ItemNPC["dronesrewrite_console"] = {
	Name = "Drone Console",
	Description = "Provides a greater control range and hacking abilities.",
	Model = "models/dronesrewrite/console/console.mdl",
	Price = 5000,
	Type = 2,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "dronesrewrite_console" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 35 ) )
		e:Spawn()
	end
}

ItemNPC["printer_paper"] = {
	Name = "Money Printer Paper",
	Description = "Paper required for the money printer to work.",
	Model = "models/props_lab/binderblue.mdl",
	Price = 50,
	Type = 2,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "printer_paper" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 35 ) )
		e:Spawn()
	end
}

ItemNPC["policebadge"] = {
	Name = "Forged Police Badge",
	Description = "Badge that you can show to police to get into secure areas. Works best with disguiser.",
	Model = "models/freeman/policebadge.mdl",
	Price = 400,
	Type = 2,
	SpawnFunction = function( ply, self )
		ply:Give( "policebadge" )
	end
}

ItemNPC["weapon_nmrih_molotov"] = {
	Name = "Molotov Cocktail",
	Description = "Creates a ball of fire wherever it lands.",
	Model = "models/props_junk/garbage_glassbottle003a.mdl",
	Price = 500,
	Type = 2,
	SpawnFunction = function( ply, self )
		ply:Give( "weapon_nmrih_molotov" )
	end
}

ItemNPC["weapon_cuff_shackles"] = {
	Name = "Strong Cable Tie",
	Description = "Used to tie players up. Steel, doesn't break easily.",
	Price = 900,
	Type = 2,
	SpawnFunction = function( ply, self )
		ply:Give( "weapon_cuff_shackles" )
	end
}

ItemNPC["cw_flash_grenade"] = {
	Name = "Flashbang",
	Description = "Temporarily blinds any player that looks at the grenade.",
	Model = "models/weapons/w_eq_flashbang.mdl",
	Price = 300,
	Type = 2,
	SpawnFunction = function( ply, self )
		ply:Give( "cw_flash_grenade" )
	end
}

ItemNPC["cw_smoke_grenade"] = {
	Name = "Smoke Grenade",
	Description = "Emits a dense cloud of grey smoke.",
	Model = "models/weapons/w_eq_smokegrenade.mdl",
	Price = 200,
	Type = 2,
	SpawnFunction = function( ply, self )
		ply:Give( "cw_smoke_grenade" )
	end
}

ItemNPC["epic_carevicter"] = {
	Name = "Car Evictor",
	Description = "Forces players out of the drivers seat of any vehicle.",
	Price = 300,
	Type = 2,
	SpawnFunction = function( ply, self )
		ply:Give( "epic_carevicter" )
	end
}

ItemNPC["rp_chloride"] = {
	Name = "Chloride (Meth)",
	Description = "One of two ingredients for making meth.",
	Model = "models/props_junk/garbage_plasticbottle001a.mdl",
	Price = 1500,
	Type = 2,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "rp_chloride" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 35 ) )
		e:Spawn()
	end
}

ItemNPC["rp_pot"] = {
	Name = "Meth Stove Pot (Consumable)",
	Description = "Place meth ingredients in and place pot on a stove to make consumable meth.",
	Model = "models/props_c17/metalPot001a.mdl",
	Price = 100,
	Type = 2,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "rp_pot" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 35 ) )
		e:Spawn()
	end
}

ItemNPC["rp_pot_sell"] = {
	Name = "Meth Stove Pot (Marketable)",
	Description = "Place meth ingredients in and place pot on a stove to make marketable meth.",
	Model = "models/props_c17/metalPot001a.mdl",
	Price = 2800,
	Type = 2,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "rp_pot" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 35 ) )
		e:Spawn()
		e:SetNWBool( "IsMarketable", true )
	end
}

ItemNPC["rp_sodium"] = {
	Name = "Sodium (Meth)",
	Description = "One of two ingredients for making meth.",
	Model = "models/props_junk/garbage_plasticbottle002a.mdl",
	Price = 1500,
	Type = 2,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "rp_sodium" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 35 ) )
		e:Spawn()
	end
}

ItemNPC["rp_stove"] = {
	Name = "Meth Stove",
	Description = "Used for making meth.",
	Model = "models/props_c17/furnitureStove001a.mdl",
	Price = 6000,
	Type = 2,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "rp_stove" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 35 ) )
		e:Spawn()
	end
}

ItemNPC["rp_weed_plant"] = {
	Name = "Weed Plant",
	Description = "Grows consumable weed that can be made marketable via the purifier.",
	Model = "models/props/de_inferno/flower_barrel.mdl",
	Price = 1500,
	Type = 2,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "rp_weed_plant" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 35 ) )
		e:Spawn()
	end
}

ItemNPC["weapon_vfire_gascan"] = {
	Name = "Gas Can",
	Description = "Contains highly flammable gasoline.",
	Model = "models/props_junk/gascan001a.mdl",
	Price = 600,
	Type = 2,
	SpawnFunction = function( ply, self )
		ply:Give( "weapon_vfire_gascan" )
	end
}

ItemNPC["money_printer_silver"] = {
	Name = "Silver Money Printer",
	Description = "Inventorizable but doesn't make a lot of money compared to others.",
	Model = "models/props_c17/consolebox01a.mdl",
	Price = 600,
	Type = 2,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "money_printer_silver" )
		e:SetPos( ply:GetPos() + Vector( 0, 30, 35 ) )
		e:Spawn()
		e:SetNWEntity( "Owner", ply )
	end
}

ItemNPC["money_printer_gold"] = {
	Name = "Gold Money Printer",
	Description = "Makes a lot of money compared to silver but is not inventorizable.",
	Model = "models/props_c17/consolebox01a.mdl",
	Price = 1000,
	Type = 2,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "money_printer_gold" )
		e:SetPos( ply:GetPos() + Vector( 0, 30, 35 ) )
		e:Spawn()
		e.dt.owning_ent = ply
	end
}

ItemNPC["weapon_spraymhs"] = {
	Name = "Graffiti Spray",
	Description = "Used to vandalize property with paint, usually to send a message.",
	Model = "models/props_junk/propane_tank001a.mdl",
	Price = 50,
	Type = 2,
	SpawnFunction = function( ply, self )
		ply:Give( "weapon_spraymhs" )
	end
}

ItemNPC["realrbn_tazer_mr"] = {
	Name = "One-Time Taser",
	Description = "Stuns a player, then removes itself.",
	Model = "models/weapons/cg_ocrp2/w_taser.mdl",
	Price = 50,
	Type = 2,
	SpawnFunction = function( ply, self )
		ply:Give( "realrbn_tazer_mr" )
	end
}

ItemNPC["weapon_leash_rope"] = {
	Name = "Weak Tie (Leash)",
	Description = "Weak cuffs, but players can be dragged with them.",
	Price = 800,
	Type = 2,
	SpawnFunction = function( ply, self )
		ply:Give( "weapon_leash_rope" )
	end
}

ItemNPC["weapon_agent"] = {
	Name = "Disguise Kit",
	Description = "Allows user to change their playermodel to any job playermodel. (One-time use, disguise gets removed if you take damage.)",
	Model = "models/weapons/w_c4.mdl",
	Price = 3000,
	Type = 2,
	SpawnFunction = function( ply, self )
		ply:Give( "weapon_agent" )
	end
}

ItemNPC["coca_plant_marketable"] = {
	Name = "Coca Plant (Marketable)",
	Description = "Use heat lamp to grow, can be sold to the drug NPC once pure.",
	Model = "models/props/cs_office/plant01.mdl",
	Price = 3000,
	Type = 2,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "coca_plant_marketable" )
		e:SetPos( ply:GetPos() + Vector( 0, 30, 35 ) )
		e:Spawn()
	end
}

ItemNPC["coca_plant_consumable"] = {
	Name = "Coca Plant (Consumable)",
	Description = "Use heat lamp to grow, can be consumed for ability buffs.",
	Model = "models/props/cs_office/plant01.mdl",
	Price = 500,
	Type = 2,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "coca_plant_consumable" )
		e:SetPos( ply:GetPos() + Vector( 0, 30, 35 ) )
		e:Spawn()
	end
}

ItemNPC["heat_lamp"] = {
	Name = "Heat Lamp",
	Description = "Used to grow coca plants. Must be supervised at all times.",
	Model = "models/props/de_nuke/IndustrialLight01.mdl",
	Price = 1000,
	Type = 2,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "heat_lamp" )
		e:SetPos( ply:GetPos() + Vector( 0, 30, 35 ) )
		e:Spawn()
		e.Owner = ply
	end
}

ItemNPC["contraband_package"] = {
	Name = "Contraband Package",
	Description = "You don't know what's in it, and you don't need to. Just take it to it's target without question and get rewarded.",
	Model = "models/props_junk/cardboard_box001a.mdl",
	Price = 3000,
	Type = 2,
	SpawnCheck = function( ply, self )
		if ply:isWanted() then
			DarkRP.notify( ply, 1, 6, "You cannot buy this item while wanted!" )
			return false
		end
		return true
	end,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "contraband_package" )
		e:SetPos( ply:GetPos() + Vector( 0, 30, 35 ) )
		e:Spawn()
		e.Owner = ply
	end
}

-----FIRE TRUCK NPC ITEMS-----
ItemNPC["fire_truck"] = {
	Name = "2014 Seagrave Marauder II Engine",
	Description = "Fire engine, enables use of the fire hose.",
	Model = "models/noble/engine_32.mdl",
	Price = 0,
	Type = 3,
	SpawnFunction = function( ply, self )
		local class = "2014 Seagrave Marauder II Engine"
		local model = "models/noble/engine_32.mdl"
		local script = "scripts/vehicles/noble/noble_engine32.txt"
		SpawnVehicle( ply, class, model, script, 2 )
	end
}

ItemNPC["fire_truck_tesla"] = {
	Name = "Tesla Cybertruck - FD",
	Description = "Truck with red and white emergency lights. Useful for getting places the big engine can't reach.",
	Model = "models/sentry/cybertruck.mdl",
	Price = 0,
	Type = 3,
	SpawnFunction = function( ply, self )
		local class = "Tesla Cybertruck - FD"
		local model = "models/sentry/cybertruck.mdl"
		local script = "scripts/vehicles/sentry/cybertruck.txt"
		SpawnVehicle( ply, class, model, script, 2 )
	end
}

-----GOV VEHICLE NPC ITEMS-----
ItemNPC["chevy_impala"] = {
	Name = "Chevrolet Impala LS Police Cruiser",
	Description = "Chevrolet Impala with police features.",
	Model = "models/lonewolfie/chev_impala_09_police.mdl",
	Price = 0,
	Type = 4,
	SpawnCheck = function( ply, self )
		return PoliceBanCheck( ply )
	end,
	SpawnFunction = function( ply, self )
		local class = "Chevrolet Impala LS Police Cruiser"
		local model = "models/lonewolfie/chev_impala_09_police.mdl"
		local script = "scripts/vehicles/lwcars/chev_impala_09.txt"
		SpawnVehicle( ply, class, model, script, 1 )
	end
}

ItemNPC["chev_tahoe_police_lw"] = {
	Name = "2007 Chevrolet Tahoe Unmarked",
	Description = "Small unmarked SUV with police equipment.",
	Model = "models/LoneWolfie/chev_tahoe_police.mdl",
	Price = 0,
	Type = 4,
	SpawnCheck = function( ply, self )
		return PoliceBanCheck( ply )
	end,
	SpawnFunction = function( ply, self )
		local class = "Unmarked Chevy Tahoe"
		local model = "models/LoneWolfie/chev_tahoe_police.mdl"
		local script = "scripts/vehicles/LWCars/chev_tahoe.txt"
		SpawnVehicle( ply, class, model, script, 1 )
	end
}

ItemNPC["chev_suburban_pol"] = {
	Name = "2007 Chevrolet Suburban",
	Description = "Large SUV with police equipment.",
	Model = "models/LoneWolfie/chev_suburban_pol.mdl",
	Price = 0,
	Type = 4,
	SpawnCheck = function( ply, self )
		return PoliceBanCheck( ply )
	end,
	SpawnFunction = function( ply, self )
		local class = "Chicago Police Chevy Suburban"
		local model = "models/LoneWolfie/chev_suburban_pol.mdl"
		local script = "scripts/vehicles/LWCars/chev_suburban.txt"
		SpawnVehicle( ply, class, model, script, 1 )
	end
}

ItemNPC["swat_van"] = {
	Name = "Lenco Bearcat G3",
	Description = "A strong SWAT van.",
	Model = "models/perrynsvehicles/bearcat_g3/bearcat_g3.mdl",
	Price = 0,
	Type = 4,
	SpawnCheck = function( ply, self )
		return PoliceBanCheck( ply )
	end,
	SpawnFunction = function( ply, self )
		local class = "Lenco Bearcat G3"
		local model = "models/perrynsvehicles/bearcat_g3/bearcat_g3.mdl"
		local script = "scripts/vehicles/perryn/bearcat_g3.txt"
		SpawnVehicle( ply, class, model, script, 1 )
	end
}

ItemNPC["ford_crownvic"] = {
	Name = "Ford Crown Vic Police",
	Description = "Crown vic with police equipment.",
	Model = "models/tdmcars/emergency/for_crownvic_fh3.mdl",
	Price = 0,
	Type = 4,
	SpawnCheck = function( ply, self )
		return PoliceBanCheck( ply )
	end,
	SpawnFunction = function( ply, self )
		local class = "Ford Crown Vic Police"
		local model = "models/tdmcars/emergency/for_crownvic_fh3.mdl"
		local script = "scripts/vehicles/TDMCars/for_crownvic_fh3.txt"
		SpawnVehicle( ply, class, model, script, 1 )
	end
}

ItemNPC["ford_crownvic_und"] = {
	Name = "Ford Crown Vic Undercover",
	Description = "Undercover Crown Vic.",
	Model = "models/tdmcars/emergency/for_crownvic_fh3.mdl",
	Price = 0,
	Type = 4,
	SpawnCheck = function( ply, self )
		return PoliceBanCheck( ply )
	end,
	SpawnFunction = function( ply, self )
		local class = "Ford Crown Vic Undercover"
		local model = "models/tdmcars/emergency/for_crownvic_fh3.mdl"
		local script = "scripts/vehicles/TDMCars/for_crownvic_fh3.txt"
		SpawnVehicle( ply, class, model, script, 1 )
	end
}

ItemNPC["ram_3500"] = {
	Name = "Dodge Ram 3500 Police",
	Description = "Police pickup truck.",
	Model = "models/tdmcars/dod_ram_3500.mdl",
	Price = 0,
	Type = 4,
	SpawnCheck = function( ply, self )
		return PoliceBanCheck( ply )
	end,
	SpawnFunction = function( ply, self )
		local class = "Dodge Ram 3500 Police"
		local model = "models/tdmcars/dod_ram_3500.mdl"
		local script = "scripts/vehicles/TDMCars/dod_ram_3500.txt"
		SpawnVehicle( ply, class, model, script, 1 )
	end
}

ItemNPC["charger_police"] = {
	Name = "Dodge Charger 2015 Pursuit",
	Description = "Traffic enforcement model.",
	Model = "models/lonewolfie/dodge_charger_2015_police.mdl",
	Price = 0,
	Type = 4,
	SpawnCheck = function( ply, self )
		return PoliceBanCheck( ply )
	end,
	SpawnFunction = function( ply, self )
		local class = "Dodge Charger 2015 Pursuit"
		local model = "models/lonewolfie/dodge_charger_2015_police.mdl"
		local script = "scripts/vehicles/lwcars/dodge_charger_2015_police.txt"
		SpawnVehicle( ply, class, model, script, 1 )
	end
}

ItemNPC["charger_und"] = {
	Name = "Dodge Charger 2015 Undercover",
	Description = "Traffic enforcement model.",
	Model = "models/lonewolfie/dodge_charger_2015_undercover.mdl",
	Price = 0,
	Type = 4,
	SpawnCheck = function( ply, self )
		return PoliceBanCheck( ply )
	end,
	SpawnFunction = function( ply, self )
		local class = "Dodge Charger 2015 Undercover"
		local model = "models/lonewolfie/dodge_charger_2015_undercover.mdl"
		local script = "scripts/vehicles/lwcars/dodge_charger_2015_police.txt"
		SpawnVehicle( ply, class, model, script, 1 )
	end
}

ItemNPC["lambosine"] = {
	Name = "Lambosine",
	Description = "Cruise around town in style. While getting shot at.",
	Model = "models/sentry/lambosine.mdl",
	Price = 0,
	Type = 4,
	SpawnCheck = function( ply, self )
		return PoliceBanCheck( ply )
	end,
	SpawnFunction = function( ply, self )
		local class = "lambosine"
		local model = "models/sentry/lambosine.mdl"
		local script = "scripts/vehicles/sentry/lambosine.txt"
		SpawnVehicle( ply, class, model, script, 1 )
	end
}

ItemNPC["lambo_veneno"] = {
	Name = "Lamborghini Veneno Police Edition",
	Description = "Its erm....a little fast.",
	Model = "models/sentry/veneno_new_cop.mdl",
	Price = 0,
	Type = 4,
	SpawnCheck = function( ply, self )
		return PoliceBanCheck( ply )
	end,
	SpawnFunction = function( ply, self )
		local class = "Lamborghini Veneno Police Edition"
		local model = "models/sentry/veneno_new_cop.mdl"
		local script = "scripts/vehicles/sentry/veneno_new.txt"
		SpawnVehicle( ply, class, model, script, 1 )
	end
}

ItemNPC["dodge_monaco"] = {
	Name = "Dodge Monaco Police",
	Description = "Standard 70's patrol car.",
	Model = "models/lonewolfie/dodge_monaco_police.mdl",
	Price = 0,
	Type = 4,
	SpawnCheck = function( ply, self )
		return PoliceBanCheck( ply )
	end,
	SpawnFunction = function( ply, self )
		local class = "Dodge Monaco Police "
		local model = "models/lonewolfie/dodge_monaco_police.mdl"
		local script = "scripts/vehicles/LWCars/dodge_monaco.txt"
		SpawnVehicle( ply, class, model, script, 1 )
	end
}

ItemNPC["transport_truck"] = {
	Name = "Transport Truck",
	Description = "A truck used to transport evidence.",
	Model = "models/tdmcars/trucks/gmc_c5500.mdl",
	Price = 0,
	Type = 4,
	SpawnCheck = function( ply, self )
		return PoliceBanCheck( ply )
	end,
	SpawnFunction = function( ply, self )
		local class = "c5500tdm"
		local model = "models/tdmcars/trucks/gmc_c5500.mdl"
		local script = "scripts/vehicles/TDMCars/c5500.txt"
		SpawnVehicle( ply, class, model, script, 1 )
	end
}

ItemNPC["ford_explorer"] = {
	Name = "2016 Ford Police Interceptor Utility",
	Description = "Modern police SUV.",
	Model = "models/schmal/fpiu/ford_utility.mdl",
	Price = 0,
	Type = 4,
	SpawnCheck = function( ply, self )
		return PoliceBanCheck( ply )
	end,
	SpawnFunction = function( ply, self )
		local class = "2016 Ford Police Interceptor Utility"
		local model = "models/schmal/fpiu/ford_utility.mdl"
		local script = "scripts/vehicles/schmal/ford_pol_int_2016.txt"
		SpawnVehicle( ply, class, model, script, 1 )
	end
}

ItemNPC["ford_taurus"] = {
	Name = "2010 Ford Taurus Police Interceptor",
	Description = "Modern police interceptor.",
	Model = "models/sentry/taurussho.mdl",
	Price = 0,
	Type = 4,
	SpawnCheck = function( ply, self )
		return PoliceBanCheck( ply )
	end,
	SpawnFunction = function( ply, self )
		local class = "2010 Ford Taurus Police Interceptor"
		local model = "models/sentry/taurussho.mdl"
		local script = "scripts/vehicles/sentry/taurus.txt"
		SpawnVehicle( ply, class, model, script, 1 )
	end
}

ItemNPC["lambo_huracan"] = {
	Name = "Lamborghini Huracan Undercover",
	Description = "Unmarked lambo.",
	Model = "models/lonewolfie/lam_huracan.mdl",
	Price = 0,
	Type = 4,
	SpawnCheck = function( ply, self )
		return PoliceBanCheck( ply )
	end,
	SpawnFunction = function( ply, self )
		local class = "Lamborghini Huracan Undercover"
		local model = "models/lonewolfie/lam_huracan.mdl"
		local script = "scripts/vehicles/LWCars/lam_huracan.txt"
		SpawnVehicle( ply, class, model, script, 1 )
	end
}

ItemNPC["dodge_challenger"] = {
	Name = "2015 Challenger Unmarked",
	Description = "Unmarked challenger.",
	Model = "models/tdmcars/dod_challenger15.mdl",
	Price = 0,
	Type = 4,
	SpawnCheck = function( ply, self )
		return PoliceBanCheck( ply )
	end,
	SpawnFunction = function( ply, self )
		local class = "2015 Challenger Unmarked"
		local model = "models/tdmcars/dod_challenger15.mdl"
		local script = "scripts/vehicles/TDMCars/dod_challenger15.txt"
		SpawnVehicle( ply, class, model, script, 1 )
	end
}

ItemNPC["hummer"] = {
	Name = "Hummer H1 SWAT Edition",
	Description = "SWAT hummer.",
	Model = "models/tdmcars/hummerh1.mdl",
	Price = 0,
	Type = 4,
	SpawnCheck = function( ply, self )
		return PoliceBanCheck( ply )
	end,
	SpawnFunction = function( ply, self )
		local class = "Hummer H1 SWAT Edition"
		local model = "models/tdmcars/hummerh1.mdl"
		local script = "scripts/vehicles/TDMCars/h1.txt"
		SpawnVehicle( ply, class, model, script, 1 )
	end
}

ItemNPC["chevy_impala_taxi"] = {
	Name = "Impala Taxi Unmarked",
	Description = "Just a normal taxi, nothing to see here.",
	Model = "models/lonewolfie/chev_impala_09_taxi.mdl",
	Price = 0,
	Type = 4,
	SpawnCheck = function( ply, self )
		return PoliceBanCheck( ply )
	end,
	SpawnFunction = function( ply, self )
		local class = "Impala Taxi Unmarked"
		local model = "models/lonewolfie/chev_impala_09_taxi.mdl"
		local script = "scripts/vehicles/LWCars/chev_impala_09.txt"
		SpawnVehicle( ply, class, model, script, 1 )
	end
}

ItemNPC["laferrari"] = {
	Name = "Unmarked LaFerrari",
	Description = "Fast and stealthy boi",
	Model = "models/tdmcars/fer_lafer.mdl",
	Price = 0,
	Type = 4,
	SpawnCheck = function( ply, self )
		return PoliceBanCheck( ply )
	end,
	SpawnFunction = function( ply, self )
		local class = "Unmarked LaFerrari"
		local model = "models/tdmcars/fer_lafer.mdl"
		local script = "scripts/vehicles/TDMCars/laferrari.txt"
		SpawnVehicle( ply, class, model, script, 1 )
	end
}

ItemNPC["charger_old"] = {
	Name = "Charger SRT-8 Police Undercover",
	Description = "Undercover old charger.",
	Model = "models/tdmcars/dod_charger12.mdl",
	Price = 0,
	Type = 4,
	SpawnCheck = function( ply, self )
		return PoliceBanCheck( ply )
	end,
	SpawnFunction = function( ply, self )
		local class = "Charger SRT-8 Police Undercover"
		local model = "models/tdmcars/dod_charger12.mdl"
		local script = "scripts/vehicles/TDMCars/charger2012.txt"
		SpawnVehicle( ply, class, model, script, 1 )
	end
}

-----AMBULANCE NPC ITEMS-----
ItemNPC["ambulance"] = {
	Name = "Ford F350 Ambulance",
	Description = "Standard ambulance.",
	Model = "models/lonewolfie/ford_f350_ambu.mdl",
	Price = 0,
	Type = 5,
	SpawnFunction = function( ply, self )
		local class = "Ford F350 Ambulance Photon"
		local model = "models/lonewolfie/ford_f350_ambu.mdl"
		local script = "scripts/vehicles/lwcars/ford_f350_ambu.txt"
		SpawnVehicle( ply, class, model, script, 3 )
	end
}

ItemNPC["crownvic_med"] = {
	Name = "2011 CVPI Medic",
	Description = "Ford Crown Victoria with EMS lighting.",
	Model = "models/tdmcars/emergency/for_crownvic_fh3.mdl",
	Price = 0,
	Type = 5,
	SpawnFunction = function( ply, self )
		local class = "2011 CVPI Medic"
		local model = "models/tdmcars/emergency/for_crownvic_fh3.mdl"
		local script = "scripts/vehicles/TDMCars/for_crownvic_fh3.txt"
		SpawnVehicle( ply, class, model, script, 3 )
	end
}

-----HEALTH NPC ITEMS-----
ItemNPC["health"] = {
	Name = "Replenish Health",
	Description = "Set your health back to 100.",
	Price = 300,
	Type = 6,
	SpawnCheck = function( ply, self )
		if ply:Health() >= ply:GetMaxHealth() then
			DarkRP.notify( ply, 1, 6, "Your health is already at max." )
			return false
		end
		return true
	end,
	SpawnFunction = function( ply, self )
		ply:SetHealth( ply:GetMaxHealth() )
		if team.NumPlayers( TEAM_FIREBOSS ) == 0 and team.NumPlayers( TEAM_FIRE ) == 0 then
			ply:addMoney( 150 ) --Health from NPC is cheaper if there aren't any players to give free health
		end
	end
}

ItemNPC["onetimehealth"] = {
	Name = "One-Time Med Kit",
	Description = "Sets your health back to 100, can be used at any time but removes itself after being used.",
	Price = 500,
	Type = 6,
	SpawnCheck = function( ply, self )
		if ply:HasWeapon( "onetime_medkit" ) then
			DarkRP.notify( ply, 1, 6, "You already have a one-time med kit!" )
			return
		end
		return true
	end,
	SpawnFunction = function( ply, self )
		ply:Give( "onetime_medkit" )
	end
}

ItemNPC["onetimearmor"] = {
	Name = "One-Time Armor Kit",
	Description = "Sets your armor to 100, can be used at any time but removes itself after being used.",
	Price = 1000,
	Type = 6,
	SpawnCheck = function( ply, self )
		if ply:HasWeapon( "onetime_armorkit" ) then
			DarkRP.notify( ply, 1, 6, "You already have a one-time armor kit!" )
			return
		end
		return true
	end,
	SpawnFunction = function( ply, self )
		ply:Give( "onetime_armorkit" )
	end
}

ItemNPC["armor"] = {
	Name = "Replenish Armor",
	Description = "Set your armor to 100.",
	Price = 800,
	Type = 6,
	SpawnCheck = function( ply, self )
		if ply:Armor() >= 100 then
			DarkRP.notify( ply, 1, 6, "Your armor is already at max." )
			return false
		end
		return true
	end,
	SpawnFunction = function( ply, self )
		ply:SetArmor( 100 )
	end
}

-----TOW TRUCK NPC ITEMS-----
ItemNPC["dodge_tow"] = {
	Name = "Dodge Ram 3500 Towtruck",
	Description = "Medium-sized tow truck for average tow jobs.",
	Model = "models/statetrooper/ram_tow.mdl",
	Price = 0,
	Type = 7,
	SpawnFunction = function( ply, self )
		local class = "Dodge Ram 3500 Towtruck"
		local model = "models/statetrooper/ram_tow.mdl"
		local script = "scripts/vehicles/statetrooper/ram3500_tow.txt"
		SpawnVehicle( ply, class, model, script, 4 )
	end
}

ItemNPC["peterbilt_tow"] = {
	Name = "Peterbilt Towtruck",
	Description = "Large tow truck for heavy tow jobs.",
	Model = "models/sentry/p379_tow.mdl",
	Price = 0,
	Type = 7,
	SpawnFunction = function( ply, self )
		local class = "Peterbilt Towtruck"
		local model = "models/sentry/p379_tow.mdl"
		local script = "scripts/vehicles/sentry/p379_tow.txt"
		SpawnVehicle( ply, class, model, script, 4 )
	end
}

-----TRUCK NPC ITEMS-----
ItemNPC["international"] = {
	Name = "International 9300",
	Description = "International 9300 semi.",
	Model = "models/sentry/i9300.mdl",
	Price = 1200,
	Type = 8,
	SpawnFunction = function( ply, self )
		local class = "i9300"
		local model = "models/sentry/i9300.mdl"
		local script = "scripts/vehicles/sentry/i9300.txt"
		SpawnVehicle( ply, class, model, script, 5 )
	end
}

ItemNPC["kenworth"] = {
	Name = "Kenworth T600",
	Description = "Kenworth T600 semi.",
	Model = "models/sentry/kt600.mdl",
	Price = 1200,
	Type = 8,
	SpawnFunction = function( ply, self )
		local class = "kt600"
		local model = "models/sentry/kt600.mdl"
		local script = "scripts/vehicles/sentry/kt600.txt"
		SpawnVehicle( ply, class, model, script, 5 )
	end
}

ItemNPC["peterbilt"] = {
	Name = "Peterbilt 379",
	Description = "Peterbilt 379 semi.",
	Model = "models/sentry/p379.mdl",
	Price = 1200,
	Type = 8,
	SpawnFunction = function( ply, self )
		local class = "p379"
		local model = "models/sentry/p379.mdl"
		local script = "scripts/vehicles/sentry/p379.txt"
		SpawnVehicle( ply, class, model, script, 5 )
	end
}

ItemNPC["gmc_moving"] = {
	Name = "GMC C5500",
	Description = "GMC C5500 moving truck.",
	Model = "models/tdmcars/trucks/gmc_c5500.mdl",
	Price = 750,
	Type = 8,
	SpawnFunction = function( ply, self )
		local class = "p379"
		local model = "models/tdmcars/trucks/gmc_c5500.mdl"
		local script = "scripts/vehicles/TDMCars/c5500.txt"
		SpawnVehicle( ply, class, model, script, 5 )
	end
}

ItemNPC["trailer_car"] = {
	Name = "Car Carrier",
	Description = "Carries small/medium-sized cars.",
	Model = "models/sentry/trailers/carcarrier.mdl",
	Price = 250,
	Type = 8,
	SpawnFunction = function( ply, self )
		local class = "carcarrier"
		local model = "models/sentry/trailers/carcarrier.mdl"
		local script = "scripts/vehicles/sentry/trailer.txt"
		SpawnVehicle( ply, class, model, script, 6, true )
	end
}

ItemNPC["trailer_storage"] = {
	Name = "Storage Trailer",
	Description = "Dry box trailer for storing pretty much anything.",
	Model = "models/sentry/trailers/stortrailer.mdl",
	Price = 500,
	Type = 8,
	SpawnFunction = function( ply, self )
		local class = "stortrailer"
		local model = "models/sentry/trailers/stortrailer.mdl"
		local script = "scripts/vehicles/sentry/stortrailer.txt"
		SpawnVehicle( ply, class, model, script, 6, true )
	end
}

-----SMUGGLE ITEMS-----
ItemNPC["smuggle_numbernine"] = {
	Name = "Number Nine Large",
	Description = "Stolen number nine large from Cluckin Bell.",
	Model = "models/food/burger.mdl",
	Price = 500,
	Type = 9,
	SpawnCheck = function( ply, self )
		return SmuggleCheck( ply )
	end,
	SpawnFunction = function( ply, self )
		DoSmuggle( ply, 1 )
	end
}

ItemNPC["smuggle_illegalammo"] = {
	Name = "Illegal Ammunition",
	Description = "Ammunition from China. Illegally smuggled into the US.",
	Model = "models/Items/item_item_crate_dynamic.mdl",
	Price = 2000,
	Type = 9,
	SpawnCheck = function( ply, self )
		return SmuggleCheck( ply )
	end,
	SpawnFunction = function( ply, self )
		DoSmuggle( ply, 2 )
	end
}

ItemNPC["smuggle_unregisteredweps"] = {
	Name = "Unregistered Weapons",
	Description = "Unregistered weapons to be sold on the black market.",
	Model = "models/props/CS_militia/footlocker01_closed.mdl",
	Price = 3500,
	Type = 9,
	SpawnCheck = function( ply, self )
		return SmuggleCheck( ply )
	end,
	SpawnFunction = function( ply, self )
		DoSmuggle( ply, 3 )
	end
}

ItemNPC["smuggle_c4"] = {
	Name = "C4",
	Description = "C4 explosives to be used in terrorist attacks.",
	Model = "models/weapons/w_c4_planted.mdl",
	Price = 8000,
	Type = 9,
	SpawnCheck = function( ply, self )
		return SmuggleCheck( ply )
	end,
	SpawnFunction = function( ply, self )
		DoSmuggle( ply, 4 )
	end
}

ItemNPC["smuggle_lambo"] = {
	Name = "Stolen Sports Car",
	Description = "Stolen Lamborghini from Dubai.",
	Model = "models/sentry/veneno_new.mdl",
	Price = 12000,
	Type = 9,
	SpawnCheck = function( ply, self )
		return SmuggleCheck( ply )
	end,
	SpawnFunction = function( ply, self )
		DoSmuggle( ply, 5 )
	end
}
