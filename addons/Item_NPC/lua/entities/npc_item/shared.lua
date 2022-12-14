ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Item NPC"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.Category = "Item NPC"

local rockford = "rp_rockford_v2b"
local southside = "rp_southside_day"
local riverden = "rp_riverden_v1a"
local truenorth = "rp_truenorth_v1a"
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
		[1] = { --Police spawns
			[rockford] = { Vector( -8248, -5485, 0 ), angle_zero },
			[southside] = { Vector( 8688, 8619, -127 ), angle_ninety },
			[riverden] = { Vector( -8703, 8141, -264 ), angle_one_eighty },
			[truenorth] = { Vector( 3238, 3914, 0 ), angle_zero }
		},
		[2] = { --Fire spawns
			[rockford] = { Vector( -5257, -3349, 8 ), angle_one_eighty },
			[southside] = { Vector( 9431, 1260, -103 ), angle_ninety_neg },
			[riverden] = { Vector( -12202, 1422, -256 ), angle_one_eighty },
			[truenorth] = { Vector( 13135, 11426, 8 ), angle_ninety }
		},
		[4] = { --Tow truck spawns
			[rockford] = { Vector( -7564, 680, 3 ), angle_zero },
			[southside] = { Vector( -1656, 6421, 14 ), angle_zero },
			[riverden] = { Vector( -1820, 6037, -264 ), angle_zero },
			[truenorth] = { Vector( 8909, 12963, 0 ), angle_zero }
		},
		[7] = { --Smuggle truck spawns
			[rockford] = { Vector( -2893, -6357, 0 ) , angle_ninety_neg },
			[southside] = { Vector( -7011, -3749, -319 ), angle_one_eighty },
			[riverden] = { Vector( -4213, 2226, -264 ), angle_one_eighty },
			[truenorth] = { Vector( 6137, 8882, 0 ), angle_zero }
		}
	}
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
			SpawnBlueprint( BLUEPRINT_COMBINED, ply, 3 )
			return "a random tier crafting blueprint"
		end
	},
	{
		Name = "Stolen Sports Car",
		Model = "models/sentry/veneno_new.mdl",
		Pos = Vector( 0, -110, 40 ),
		Reward = function( ply )
			SpawnBlueprint( BLUEPRINT_COMBINED, ply, 3 )
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
	ent:SetEntName( BLUEPRINT_COMBINED[index][1] )
	ent:SetRealName( BLUEPRINT_COMBINED[index][2] )
	ent:SetUses( 3 )
end

local function SmuggleCheck( ply )
	local copcount = team.NumPlayers( TEAM_POLICEBOSS ) + team.NumPlayers( TEAM_OFFICER ) + team.NumPlayers( TEAM_UNDERCOVER ) + team.NumPlayers( TEAM_FBI )
	if ply.SmuggleCooldown and ply.SmuggleCooldown > CurTime() then
		DarkRP.notify( ply, 1, 6, "Please wait "..string.ToMinutesSeconds( ply.SmuggleCooldown - CurTime() ).." to smuggle again." )
		return false
	end
	if copcount < 2 then
		DarkRP.notify( ply, 1, 6, "There needs to be at least 2 cops on the server for smuggling to unlock." )
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
	ButtonColor = Color( 230, 93, 80, 255 ),
	Allowed = {}
}

ItemNPCType[2] = {
	Name = "Contraband Dealer",
	Model = "models/Humans/Group03/male_07.mdl",
	MenuColor = Color( 230, 93, 80, 200 ),
	ButtonColor = Color( 49, 53, 61, 255 ),
	Allowed = {}
}

ItemNPCType[3] = {
	Name = "Firefighter",
	Model = "models/player/portal/male_07_fireman.mdl",
	MenuColor = Color( 49, 53, 61, 200 ),
	ButtonColor = Color( 230, 93, 80, 255 ),
	Allowed = {
		[TEAM_FIREBOSS] = true,
		[TEAM_FIRE] = true
	}
}

ItemNPCType[4] = {
	Name = "Police Secretary",
	Model = "models/taggart/police01/male_07.mdl",
	MenuColor = Color( 49, 53, 61, 200 ),
	ButtonColor = Color( 230, 93, 80, 255 ),
	Allowed = {
		[TEAM_MAYOR] = true,
		[TEAM_POLICEBOSS] = true,
		[TEAM_OFFICER] = true,
		[TEAM_UNDERCOVER] = true,
		[TEAM_FBI] = true
	}
}

ItemNPCType[6] = {
	Name = "Healer",
	Model = "models/kleiner.mdl",
	MenuColor = Color( 49, 53, 61, 200 ),
	ButtonColor = Color( 230, 93, 80, 255 ),
	Allowed = {}
}

ItemNPCType[7] = {
	Name = "Trucker",
	Model = "models/player/monk.mdl",
	MenuColor = Color( 49, 53, 61, 200 ),
	ButtonColor = Color( 230, 93, 80, 255 ),
	Allowed = {
		[TEAM_TOWER] = true
	}
}

ItemNPCType[8] = {
	Name = "Job Broker",
	Model = "models/gman.mdl",
	MenuColor = Color( 49, 53, 61, 200 ),
	ButtonColor = Color( 230, 93, 80, 255 ),
	Allowed = {}
}

ItemNPCType[9] = {
	Name = "Smuggle Seller",
	Model = "models/humans/group03/male_01.mdl",
	MenuColor = Color( 49, 53, 61, 200 ),
	ButtonColor = Color( 230, 93, 80, 255 ),
	Allowed = {
		[TEAM_CITIZEN] = true,
		[TEAM_TOWER] = true,
		[TEAM_CAMERA] = true,
		[TEAM_BUS] = true,
		[TEAM_HITMAN] = true
	}
}

-----SHOP NPC ITEMS-----
ItemNPC["arccw_mifl_fas2_g20"] = {
	Name = "Glock 20",
	Description = "Does good amounts of damage at medium range.",
	Model = "models/weapons/arccw/mifl/fas2/c_glock20.mdl",
	Price = 800,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_mifl_fas2_g20" )
	end
}

ItemNPC["arccw_mifl_fas2_p226"] = {
	Name = "P226",
	Description = "Does fair amounts of damage at medium range.",
	Model = "models/weapons/w_pist_p228.mdl",
	Price = 500,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_mifl_fas2_p226" )
	end
}

ItemNPC["arccw_mifl_fas2_deagle"] = {
	Name = "Desert Eagle",
	Description = "Does heavy amounts of damage at all ranges, most powerful sidearm.",
	Model = "models/weapons/w_pist_deagle.mdl",
	Price = 1500,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_mifl_fas2_deagle" )
	end
}

ItemNPC["arccw_mifl_fas2_mac11"] = {
	Name = "MAC-11",
	Description = "Automatic pistol, does fair amounts of damage.",
	Model = "models/weapons/w_cst_mac11.mdl",
	Price = 2500,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_mifl_fas2_mac11" )
	end
}

ItemNPC["arccw_mifl_fas2_mp5"] = {
	Name = "MP5",
	Description = "Automatic weapon, does fair amounts of damage.",
	Model = "models/weapons/w_smg_mp5.mdl",
	Price = 3500,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_mifl_fas2_mp5" )
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

ItemNPC["arccw_mifl_fas2_sr25"] = {
	Name = "SR-25",
	Description = "Small sniper rifle.",
	Model = "models/weapons/arccw/mifl/fas2/c_sr25.mdl",
	Price = 4000,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_mifl_fas2_sr25" )
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

ItemNPC["arccw_mifl_fas2_famas"] = {
	Name = "FAMAS",
	Description = "Large, automatic rifle.",
	Model = "models/weapons/arccw/mifl/fas2/c_famas.mdl",
	Price = 5000,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_mifl_fas2_famas" )
	end
}

ItemNPC["arccw_mifl_fas2_m1911"] = {
	Name = "M1911",
	Description = "Does alright damage, least powerful sidearm.",
	Model = "models/weapons/arccw/mifl/fas2/c_m1911.mdl",
	Price = 300,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_mifl_fas2_m1911" )
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
	Discount = { [TEAM_COOK] = 0.5 },
	SpawnFunction = function( ply, self )
		local e = ents.Create( "farm_plant" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:SetPlantType( 1 )
		e:Spawn()
	end
}

ItemNPC["banana_seeds"] = {
	Name = "Banana Seeds",
	Description = "Grows a banana plant.",
	Model = "models/props/cs_italy/bananna.mdl",
	Price = 350,
	Type = 1,
	Discount = { [TEAM_COOK] = 0.5 },
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
	Discount = { [TEAM_COOK] = 0.5 },
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
	Discount = { [TEAM_COOK] = 0.5 },
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
	Discount = { [TEAM_COOK] = 0.5 },
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
	Discount = { [TEAM_COOK] = 0.5 },
	SpawnFunction = function( ply, self )
		local e = ents.Create( "farm_box" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		e:SetOwner( ply )
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

ItemNPC["dronesrewrite_bird"] = {
	Name = "Camera Drone",
	Description = "Drone with a camera on it, nothing special.",
	Model = "models/dronesrewrite/birddr/birddr.mdl",
	Price = 1000,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "dronesrewrite_bird" )
		e:SetPos( self:GetPos() + Vector( 0, 0, 100 ) )
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
		e:SetPos( self:GetPos() + Vector( 0, 0, 100 ) )
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
	Price = 1000,
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
	Price = 1000,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		ApplyBlueprintData( e, 2 )
	end
}

ItemNPC["crafting_blueprint_lockpick"] = {
	Name = "Premium Lockpick",
	Description = "Crafting blueprint for the premium lockpick.",
	Model = "models/props_lab/binderblue.mdl",
	Price = 500,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		ApplyBlueprintData( e, 3 )
	end
}

ItemNPC["crafting_blueprint_ragingbull"] = {
	Name = "Raging Bull Crafting Blueprint",
	Description = "Crafting blueprint for the Raging Bull revolver.",
	Model = "models/props_lab/binderblue.mdl",
	Price = 1000,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		ApplyBlueprintData( e, 4 )
	end
}

ItemNPC["crafting_blueprint_mass26"] = {
	Name = "MASS-26 Crafting Blueprint",
	Description = "Crafting blueprint for the MASS-26 shotgun.",
	Model = "models/props_lab/binderblue.mdl",
	Price = 1000,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		ApplyBlueprintData( e, 5 )
	end
}

ItemNPC["crafting_blueprint_nano"] = {
	Name = "Nano Drone Crafting Blueprint",
	Description = "Crafting blueprint for the nano drone.",
	Model = "models/props_lab/binderblue.mdl",
	Price = 1000,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		ApplyBlueprintData( e, 6 )
	end
}

ItemNPC["crafting_blueprint_ak47"] = {
	Name = "AK-47 Crafting Blueprint",
	Description = "Crafting blueprint for the AK-47 rifle.",
	Model = "models/props_lab/binderblue.mdl",
	Price = 5000,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		ApplyBlueprintData( e, 7 )
	end
}

ItemNPC["crafting_blueprint_m3super90"] = {
	Name = "M3 Super 90 Crafting Blueprint",
	Description = "Crafting blueprint for the M3 Super 90 shotgun.",
	Model = "models/props_lab/binderblue.mdl",
	Price = 5000,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		ApplyBlueprintData( e, 8 )
	end
}

ItemNPC["crafting_blueprint_toz34"] = {
	Name = "TOZ-34 Crafting Blueprint",
	Description = "Crafting blueprint for the TOZ-34 shotgun.",
	Model = "models/props_lab/binderblue.mdl",
	Price = 5000,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		ApplyBlueprintData( e, 9 )
	end
}

ItemNPC["crafting_blueprint_m24"] = {
	Name = "M24 Crafting Blueprint",
	Description = "Crafting blueprint for the M24 rifle.",
	Model = "models/props_lab/binderblue.mdl",
	Price = 5000,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		ApplyBlueprintData( e, 10 )
	end
}

ItemNPC["crafting_blueprint_sg552"] = {
	Name = "SG552 Crafting Blueprint",
	Description = "Crafting blueprint for the SG552 rifle.",
	Model = "models/props_lab/binderblue.mdl",
	Price = 5000,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		ApplyBlueprintData( e, 11 )
	end
}

ItemNPC["crafting_blueprint_m4a1"] = {
	Name = "M4A1 Crafting Blueprint",
	Description = "Crafting blueprint for the M4A1 rifle.",
	Model = "models/props_lab/binderblue.mdl",
	Price = 5000,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		ApplyBlueprintData( e, 12 )
	end
}

ItemNPC["crafting_blueprint_carbomb"] = {
	Name = "Car Bomb Crafting Blueprint",
	Description = "Crafting blueprint for the car bomb.",
	Model = "models/props_lab/binderblue.mdl",
	Price = 5000,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		ApplyBlueprintData( e, 13 )
	end
}

ItemNPC["crafting_blueprint_frag"] = {
	Name = "Frag Grenade Crafting Blueprint",
	Description = "Crafting blueprint for the frag grenade.",
	Model = "models/props_lab/binderblue.mdl",
	Price = 5000,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		ApplyBlueprintData( e, 14 )
	end
}

ItemNPC["crafting_blueprint_ks23"] = {
	Name = "KS-23 Crafting Blueprint",
	Description = "Crafting blueprint for the KS-23 shotgun.",
	Model = "models/props_lab/binderblue.mdl",
	Price = 10000,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		ApplyBlueprintData( e, 15 )
	end
}

ItemNPC["crafting_blueprint_c4"] = {
	Name = "C4 Crafting Blueprint",
	Description = "Crafting blueprint for the C4 explosive.",
	Model = "models/props_lab/binderblue.mdl",
	Price = 10000,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		ApplyBlueprintData( e, 16 )
	end
}

ItemNPC["crafting_blueprint_slam"] = {
	Name = "SLAM Crafting Blueprint",
	Description = "Crafting blueprint for the SLAM remote explosive.",
	Model = "models/props_lab/binderblue.mdl",
	Price = 10000,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		ApplyBlueprintData( e, 17 )
	end
}

ItemNPC["crafting_blueprint_m249"] = {
	Name = "M249 Crafting Blueprint",
	Description = "Crafting blueprint for the M249 LMG.",
	Model = "models/props_lab/binderblue.mdl",
	Price = 10000,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		ApplyBlueprintData( e, 18 )
	end
}

ItemNPC["crafting_blueprint_m79"] = {
	Name = "M79 Crafting Blueprint",
	Description = "Crafting blueprint for the M79 grenade launcher.",
	Model = "models/props_lab/binderblue.mdl",
	Price = 10000,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		ApplyBlueprintData( e, 19 )
	end
}

ItemNPC["crafting_blueprint_rpk"] = {
	Name = "RPK47 Crafting Blueprint",
	Description = "Crafting blueprint for the RPK47 LMG.",
	Model = "models/props_lab/binderblue.mdl",
	Price = 10000,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		ApplyBlueprintData( e, 20 )
	end
}

ItemNPC["crafting_blueprint_m82"] = {
	Name = "M82 Crafting Blueprint",
	Description = "Crafting blueprint for the M82 antimaterial rifle.",
	Model = "models/props_lab/binderblue.mdl",
	Price = 10000,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
		e:Spawn()
		ApplyBlueprintData( e, 21 )
	end
}

ItemNPC["rock_scanner"] = {
	Name = "Rock Scanner",
	Description = "Scans and displays the contents of rocks.",
	Model = "models/props/cs_militia/furnace01.mdl",
	Price = 500,
	Type = 1,
	SpawnFunction = function( ply, self )
		ply:Give( "rock_scanner" )
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

ItemNPC["news_tv"] = {
	Name = "News TV",
	Description = "Displays live feed from any active news cameras.",
	Model = "models/props/cs_office/TV_plasma.mdl",
	Price = 50,
	Type = 1,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "news_tv" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 35 ) )
		e:Spawn()
		e:SetOwner( ply )
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

ItemNPC["weapon_molotov"] = {
	Name = "Molotov Cocktail",
	Description = "Creates a ball of fire wherever it lands.",
	Model = "models/props_junk/garbage_glassbottle003a.mdl",
	Price = 500,
	Type = 2,
	SpawnFunction = function( ply, self )
		ply:Give( "weapon_molotov" )
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

ItemNPC["arccw_nade_flash"] = {
	Name = "Flashbang",
	Description = "Temporarily blinds any player that looks at the grenade.",
	Model = "models/weapons/w_eq_flashbang.mdl",
	Price = 300,
	Type = 2,
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_nade_flash" )
	end
}

ItemNPC["arccw_nade_smoke"] = {
	Name = "Smoke Grenade",
	Description = "Emits a dense cloud of grey smoke.",
	Model = "models/weapons/w_eq_smokegrenade.mdl",
	Price = 200,
	Type = 2,
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_nade_smoke" )
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
	Name = "Meth Stove Pot",
	Description = "Place meth ingredients in and place pot on a stove to make meth.",
	Model = "models/props_c17/metalPot001a.mdl",
	Price = 100,
	Type = 2,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "rp_pot" )
		e:SetPos( self:GetPos() + Vector( 0, 30, 35 ) )
		e:Spawn()
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
	Description = "Grows 1 weed every 100 seconds. Needs harvested before another one can start growing.",
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
	Description = "Can be stored in your inventory but doesn't make a lot of money compared to others.",
	Model = "models/props_c17/consolebox01a.mdl",
	Price = 600,
	Type = 2,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "money_printer_silver" )
		e:SetPos( ply:GetPos() + Vector( 0, 30, 35 ) )
		e:Spawn()
		e:SetOwner( ply )
	end
}

ItemNPC["money_printer_gold"] = {
	Name = "Gold Money Printer",
	Description = "Makes more money compared to silver but cannot be stored in your inventory.",
	Model = "models/props_c17/consolebox01a.mdl",
	Price = 1000,
	Type = 2,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "money_printer_gold" )
		e:SetPos( ply:GetPos() + Vector( 0, 30, 35 ) )
		e:Spawn()
		e:SetOwner( ply )
	end
}

ItemNPC["graffiti-swep"] = {
	Name = "Graffiti Spray",
	Description = "Used to vandalize property with paint, usually to send a message.",
	Model = "models/props_junk/propane_tank001a.mdl",
	Price = 50,
	Type = 2,
	SpawnFunction = function( ply, self )
		ply:Give( "graffiti-swep" )
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

ItemNPC["coca_plant"] = {
	Name = "Coca Plant",
	Description = "Use heat lamp to grow, can be sold to the drug NPC once pure.",
	Model = "models/props/cs_office/plant01.mdl",
	Price = 500,
	Type = 2,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "coca_plant" )
		e:SetPos( ply:GetPos() + Vector( 0, 30, 35 ) )
		e:Spawn()
	end
}

ItemNPC["heat_lamp"] = {
	Name = "Heat Lamp",
	Description = "Used to grow coca plants. Must be supervised at all times.",
	Model = "models/props/de_nuke/IndustrialLight01.mdl",
	Price = 500,
	Type = 2,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "heat_lamp" )
		e:SetPos( ply:GetPos() + Vector( 0, 30, 35 ) )
		e:Spawn()
		e.Owner = ply
	end
}

ItemNPC["purifier"] = {
	Name = "Purififer",
	Description = "Used to purify raw cocaine.",
	Model = "models/props_wasteland/laundry_washer003.mdl",
	Price = 3000,
	Type = 2,
	SpawnFunction = function( ply, self )
		local e = ents.Create( "purifier" )
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

ItemNPC["ambulance"] = {
	Name = "Ford F350 Ambulance",
	Description = "Standard ambulance.",
	Model = "models/lonewolfie/ford_f350_ambu.mdl",
	Price = 0,
	Type = 3,
	SpawnFunction = function( ply, self )
		local class = "Ford F350 Ambulance Photon"
		local model = "models/lonewolfie/ford_f350_ambu.mdl"
		local script = "scripts/vehicles/lwcars/ford_f350_ambu.txt"
		SpawnVehicle( ply, class, model, script, 2 )
	end
}

ItemNPC["crownvic_med"] = {
	Name = "2011 CVPI Medic",
	Description = "Ford Crown Victoria with EMS lighting.",
	Model = "models/tdmcars/emergency/for_crownvic_fh3.mdl",
	Price = 0,
	Type = 3,
	SpawnFunction = function( ply, self )
		local class = "2011 CVPI Medic"
		local model = "models/tdmcars/emergency/for_crownvic_fh3.mdl"
		local script = "scripts/vehicles/TDMCars/for_crownvic_fh3.txt"
		SpawnVehicle( ply, class, model, script, 2 )
	end
}

-----GOV VEHICLE NPC ITEMS-----
ItemNPC["chevy_impala"] = {
	Name = "Chevrolet Impala Police",
	Description = "Chevrolet Impala with police features.",
	Model = "models/lonewolfie/chev_impala_09_police.mdl",
	Price = 0,
	Type = 4,
	SpawnCheck = function( ply, self )
		return PoliceBanCheck( ply )
	end,
	SpawnFunction = function( ply, self )
		local class = "Chevrolet Impala Police"
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

ItemNPC["lifeinsurance"] = {
	Name = "Life Insurance",
	Description = "You won't lose money on death for the rest of the session.",
	Price = 3000,
	Type = 6,
	SpawnCheck = function( ply, self )
		if ply.HasLifeInsurance then
			DarkRP.notify( ply, 1, 6, "You already have life insurance." )
			return false
		end
		return true
	end,
	SpawnFunction = function( ply, self )
		ply.HasLifeInsurance = true
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

-----EVENT ITEMS-----
ItemNPC["active_shooter"] = {
	Name = "Active Shooter",
	Description = "A gunman is going on a rampage shooting at anything that moves. His current location is unknown, but according to witnesses he is targeting popular buildings.",
	Price = 1500,
	Type = 8,
	EventID = EVENT_ACTIVE_SHOOTER,
	PrimaryJobs = { TEAM_OFFICER },
	SpawnFunction = function()
		ActiveShooter()
	end
}

ItemNPC["bus_passenger"] = {
	Name = "Bus Passenger",
	Description = "Drive around the city and pickup people and take them to a central location.",
	Price = 3000,
	Type = 8,
	EventID = EVENT_BUS_PASSENGER,
	PrimaryJobs = { TEAM_BUS },
	SpawnFunction = function()
		BusPassenger()
	end
}

ItemNPC["drunk_driver"] = {
	Name = "Drunk Driver",
	Description = "Citizens are reporting a drunk driver in the area driving recklessly. Attempt to find them and make contact.",
	Price = 8000,
	Type = 8,
	EventID = EVENT_DRUNK_DRIVER,
	PrimaryJobs = { TEAM_OFFICER },
	SpawnFunction = function()
		DrunkDriver()
	end
}

ItemNPC["food_delivery"] = {
	Name = "Food Delivery",
	Description = "A customer is requesting a pizza. Make the correct type and deliver it to them.",
	Price = 3000,
	Type = 8,
	EventID = EVENT_FOOD_DELIVERY,
	PrimaryJobs = { TEAM_COOK },
	SpawnFunction = function()
		FoodDelivery()
	end
}

ItemNPC["house_fire"] = {
	Name = "House Fire",
	Description = "A fire has broken out in a residential structure. It needs taken care of before it spreads out of control.",
	Price = 5000,
	Type = 8,
	EventID = EVENT_HOUSE_FIRE,
	PrimaryJobs = { TEAM_FIRE },
	SpawnFunction = function()
		HouseFire()
	end
}

ItemNPC["money_transfer"] = {
	Name = "Money Transfer",
	Description = "A check needs deposited at the bank. This is a highly valuable check that can be stolen so you need to be careful.",
	Price = 3000,
	Type = 8,
	EventID = EVENT_MONEY_TRANSFER,
	PrimaryJobs = { TEAM_BANKER },
	SpawnFunction = function()
		MoneyTransfer()
	end
}

ItemNPC["overturned_truck"] = {
	Name = "Overturned Truck",
	Description = "A semi truck took a curve too fast and overturned. The road is blocked and needs cleared. The truck is also leaking fuel and may combust if not cleaned up quickly.",
	Price = 5000,
	Type = 8,
	EventID = EVENT_OVERTURNED_TRUCK,
	PrimaryJobs = { TEAM_TOWER },
	SpawnFunction = function()
		OverturnedTruck()
	end
}

ItemNPC["road_work"] = {
	Name = "Road Work",
	Description = "A massive pothole has appeared on one of the main roads in the city. Shut down the affected road and make repairs before it damages someone's vehicle.",
	Price = 3000,
	Type = 8,
	EventID = EVENT_ROAD_WORK,
	PrimaryJobs = { TEAM_TOWER },
	SpawnFunction = function()
		RoadWork()
	end
}

ItemNPC["bank_robbery"] = {
	Name = "Bank Robbery",
	Description = "Armed robbers are currently robbing the bank. Stop them before they can escape with a large amount of cash.",
	Price = 5000,
	Type = 8,
	EventID = EVENT_ROBBERY,
	PrimaryJobs = { TEAM_OFFICER },
	SpawnFunction = function()
		Robbery()
	end
}
