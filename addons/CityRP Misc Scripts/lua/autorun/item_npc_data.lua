ItemNPCType = ItemNPCType or {}

ItemNPCType = {
    [1] = {
        Name = "Supermarket",
        Model = "models/breen.mdl"
    },
    [2] = {
        Name = "Contraband Dealer",
        Model = "models/Humans/Group03/male_07.mdl",
        MenuColor = Color( 230, 93, 80, 255 ), --Invert colors
    },
    [3] = {
        Name = "Firefighter",
        Model = "models/player/portal/male_07_fireman.mdl",
        Anim = 20,
        CanUse = function( ply )
        return ply:IsEMS()
        end
    },
    [4] = {
        Name = "Police Secretary",
        Model = "models/taggart/police01/male_07.mdl",
        Anim = 20,
        CanUse = function( ply )
        return ply:isCP()
        end
    },
    [6] = {
        Name = "Healer",
        Model = "models/kleiner.mdl"
    },
    [7] = {
        Name = "Trucker",
        Model = "models/player/monk.mdl",
        Anim = 20,
        CanUse = function( ply )
        return ply:Team() == TEAM_TOWER
        end
    },
    [9] = {
        Name = "Accessory Vendor",
        Model = "models/humans/group01/female_01.mdl",
        CanUse = function( ply )
        --Override default behavior to open pointshop menu instead
        ply:PS_ToggleMenu()
        return false
        end
    }
}

ItemNPC = {
    ----SUPERMARKET ITEMS----
    {
        Name = "Crafting Table",
        Description = "Create new items by combining ingredients.",
        Model = "models/props_wasteland/controlroom_desk001b.mdl",
        Price = 200,
        Type = 1,
        SpawnOverride = function( ply, self )
        local e = ents.Create( "ucs_table" )
        e:SetPos( self:GetPos() + Vector( 0, 30, 10 ) )
        e:SetTableType( "default" )
        e:Spawn()
        end
    },
    {
        Name = "Media Player",
        Description = "Useful for watching meme videos and torturing prisoners.",
        Model = "models/gmod_tower/suitetv_large.mdl",
        Price = 200,
        Type = 1,
        SpawnClass = "mediaplayer_tv",
        SpawnOffset = Vector( 0, 30, 10 )
    },
    {
        Name = "Boombox",
        Description = "Plays internet radio streams in 3D space.",
        Model = "models/rammel/boombox.mdl",
        Price = 350,
        Type = 1,
        SpawnClass = "boombox",
        SpawnOffset = Vector( 0, 30, 35 )
    },
    {
        Name = "Beretta 93R",
        Description = "Beretta pistol with burst-fire option. Does up to 30 damage.",
        Model = "models/weapons/arc9_fas/pistols/m9.mdl",
        Price = 1250,
        Type = 1,
        Give = "arc9_fas_m93r"
    },
    {
        Name = "MP-443 Grach",
        Description = "Russian pistol that does up to 33 damage.",
        Model = "models/weapons/arc9_fas/pistols/grach.mdl",
        Price = 1350,
        Type = 1,
        Give = "arc9_fas_grach"
    },
    {
        Name = "P226",
        Description = "German/Swiss pistol that does up to 38 damage.",
        Model = "models/weapons/w_pist_p228.mdl",
        Price = 1575,
        Type = 1,
        Give = "arc9_fas_p226"
    },
    {
        Name = "Glock 20",
        Description = "German pistol that does up to 48 damage.",
        Model = "models/weapons/w_pist_glock18.mdl",
        Price = 1950,
        Type = 1,
        Give = "arc9_fas_g20"
    },
    {
        Name = "M1911",
        Description = "American pistol that does up to 50 damage.",
        Model = "models/weapons/arc9_fas/pistols/m1911.mdl",
        Price = 2050,
        Type = 1,
        Give = "arc9_fas_m1911"
    },
    {
        Name = "Combat Knife",
        Description = "Medium-sized knife commonly carried by soldiers.",
        Model = "models/weapons/arc9_fas/misc/dv2.mdl",
        Price = 200,
        Type = 1,
        Give = "arc9_fas_dv2"
    },
    {
        Name = "Machete",
        Description = "Large knife used for a variety of things and can be used with two hands.",
        Model = "models/weapons/arc9_fas/misc/machete.mdl",
        Price = 500,
        Type = 1,
        Give = "arc9_fas_machete"
    },
    {
        Name = "Frying Pan",
        Description = "Good for hitting things....oh and cooking I guess.",
        Model = "models/weapons/HL2meleepack/w_pan.mdl",
        Price = 250,
        Type = 1,
        Give = "weapon_hl2pan"
    },
    {
        Name = "Axe",
        Description = "For chopping down trees.",
        Model = "models/weapons/w_chopping_axe/w_chopping_axe.mdl",
        Price = 400,
        Type = 1,
        Give = "weapon_hl2axe"
    },
    {
        Name = "Pickaxe",
        Description = "For mining rocks.",
        Model = "models/weapons/w_stone_pickaxe.mdl",
        Price = 500,
        Type = 1,
        Give = "weapon_hl2pickaxe"
    },
    {
        Name = "Crowbar",
        Description = "Useful tool for breaking into things and killing small alien creatures.",
        Model = "models/weapons/w_crowbar.mdl",
        Price = 400,
        Type = 1,
        Give = "enterprise_crowbar"
    },
    {
        Name = "Fire Extinguisher",
        Description = "Puts out fires.",
        Model = "models/weapons/w_fire_extinguisher.mdl",
        Price = 100,
        Type = 1,
        Give = "weapon_extinguisher_infinite"
    },
    {
        Name = "Vehicle Repair Kit",
        Description = "Repairs 30% of your vehicles max health.",
        Model = "models/Items/HealthKit.mdl",
        Price = 200,
        Type = 1,
        SpawnClass = "ent_gauto_repair",
        SpawnOffset = Vector( 0, 30, 10 )
    },
    {
        Name = "Slot Machine",
        Description = "Spend money to try and win more money.",
        Model = "models/props/slotmachine/slotmachinefinal.mdl",
        Price = 500,
        Type = 1,
        SpawnClass = "slot_machine",
        SpawnOffset = Vector( 0, 30, 30 )
    },
    {
        Name = "Apple Seeds",
        Description = "Grows an apple tree.",
        Model = "models/props/de_inferno/crate_fruit_break_gib2.mdl",
        Price = 100,
        Type = 1,
        SpawnClass = "farm_plant",
        SpawnOffset = Vector( 0, 30, 10 ),
        SpawnFunc = function( ply, item )
        item:SetPlantType( 1 )
        end
    },
    {
        Name = "Banana Seeds",
        Description = "Grows a banana plant.",
        Model = "models/props/cs_italy/bananna.mdl",
        Price = 350,
        Type = 1,
        SpawnClass = "farm_plant",
        SpawnOffset = Vector( 0, 30, 10 ),
        SpawnFunc = function( ply, item )
        item:SetPlantType( 2 )
        end
    },
    {
        Name = "Cantaloupe Seeds",
        Description = "Grows a cantaloupe plant.",
        Price = 800,
        Type = 1,
        SpawnClass = "farm_plant",
        SpawnOffset = Vector( 0, 30, 10 ),
        SpawnFunc = function( ply, item )
        item:SetPlantType( 3 )
        end
    },
    {
        Name = "Potato Seeds",
        Description = "Grows potatos.",
        Model = "models/props_phx/misc/potato.mdl",
        Price = 225,
        Type = 1,
        SpawnClass = "farm_plant",
        SpawnOffset = Vector( 0, 30, 10 ),
        SpawnFunc = function( ply, item )
        item:SetPlantType( 4 )
        end
    },
    {
        Name = "Watermelon Seeds",
        Description = "Grows a watermelon plant.",
        Model = "models/props_junk/watermelon01.mdl",
        Price = 1300,
        Type = 1,
        SpawnClass = "farm_plant",
        SpawnOffset = Vector( 0, 30, 10 ),
        SpawnFunc = function( ply, item )
        item:SetPlantType( 5 )
        end
    },
    {
        Name = "Farm Box",
        Description = "Fill this with grown food and take to the farmer NPC for money.",
        Model = "models/props_junk/wood_crate002a.mdl",
        Price = 100,
        Type = 1,
        SpawnClass = "farm_box",
        SpawnOffset = Vector( 0, 30, 10 ),
        SpawnFunc = function( ply, item )
        item:SetOwner( ply )
        end
    },
    {
        Name = "Handheld Metal Detector",
        Description = "Detects weapons being carried by a player.",
        Model = "models/weapons/Custom/w_scanner.mdl",
        Price = 200,
        Type = 1,
        Give = "weapon_metal_detector"
    },
    {
        Name = "Metal Detector",
        Description = "Walk-through detector that doesn't require a player to operate, also checks inventories.",
        Model = "models/props_wasteland/interior_fence002e.mdl",
        Price = 600,
        Type = 1,
        SpawnClass = "metal_detector",
        SpawnOffset = Vector( 0, 30, 10 ),
        SpawnFunc = function( ply, item )
        item:SetOwningEntity( ply )
        end
    },
    {
        Name = "Business Sign",
        Description = "Displays opened or closed, use key to change status.",
        Model = "models/props_trainstation/TrackSign02.mdl",
        Price = 50,
        Type = 1,
        SpawnClass = "zpizmak_opensign",
        SpawnOffset = Vector( 0, 30, 10 )
    },
    {
        Name = "Life Alert",
        Description = "Notifies police and EMS of your location when you type !alert. Gets removed when you die.",
        Model = "models/props_lab/reciever01d.mdl",
        Price = 600,
        Type = 1,
        SpawnClass = "life_alert",
        SpawnOffset = Vector( 0, 30, 10 )
    },
    {
        Name = "Camera Drone",
        Description = "Drone with a camera on it, nothing special.",
        Model = "models/dronesrewrite/birddr/birddr.mdl",
        Price = 1000,
        Type = 1,
        SpawnClass = "dronesrewrite_bird",
        SpawnOffset = Vector( 0, 0, 100 ),
        SpawnFunc = function( ply, item )
        item:SetupOwner( ply )
        end
    },
    {
        Name = "Spy Drone",
        Description = "Identifies and points out entities by their class name.",
        Model = "models/dronesrewrite/spydr/spydr.mdl",
        Price = 3000,
        Type = 1,
        SpawnClass = "dronesrewrite_spy",
        SpawnOffset = Vector( 0, 0, 100 ),
        SpawnFunc = function( ply, item )
        item:SetupOwner( ply )
        end
    },
    {
        Name = "Drone Fuel",
        Description = "Fuels drones.",
        Model = "models/props_junk/gascan001a.mdl",
        Price = 400,
        Type = 1,
        Give = "weapon_drr_fuelcan"
    },
    {
        Name = "Drone Repair Tool",
        Description = "Repairs drones.",
        Price = 200,
        Type = 1,
        Give = "weapon_drr_repairtool"
    },
    {
        Name = "Fuel Can",
        Description = "Fills up 75% of a vehicle's fuel tank, and 100% of other machines that require fuel.",
        Model = "models/props_junk/gascan001a.mdl",
        Price = 200,
        Type = 1,
        SpawnClass = "ent_gauto_fuel",
        SpawnOffset = Vector( 0, 30, 10 ),
        SpawnFunc = function( ply, item )
        if EcoPerkActive( "Increase Oil and Gas Budget" ) then
            item.FuelPercent = 100
            end
            end
    },
    {
        Name = "News TV",
        Description = "Displays live feed from any active news cameras.",
        Model = "models/props/cs_office/TV_plasma.mdl",
        Price = 50,
        Type = 1,
        SpawnClass = "news_tv",
        SpawnOffset = Vector( 0, 30, 35 ),
        SpawnFunc = function( ply, item )
        item:SetOwner( ply )
        end
    },
    {
        Name = "Printer Paper",
        Description = "Standard paper commonly used in printers. Can also be written on.",
        Model = "models/props_lab/bindergreen.mdl",
        Price = 50,
        Type = 1,
        SpawnClass = "printer_paper",
        SpawnOffset = Vector( 0, 30, 35 ),
        SpawnFunc = function( ply, item )
        item:SetOwner( ply )
        end
    },
    {
        Name = "Inventory Box",
        Description = "Portable box for carrying up to 9 inventory items.",
        Model = "models/props/CS_militia/footlocker01_closed.mdl",
        Price = 500,
        Type = 1,
        SpawnClass = "itemstore_box",
        SpawnOffset = Vector( 0, 30, 35 )
    },
    {
        Name = "Smelter",
        Description = "Smelts iron into steel, and craftable items into 50% of their original ingredients.",
        Model = "models/props/cs_militia/furnace01.mdl",
        Price = 300,
        Type = 1,
        SpawnClass = "crafting_smelter",
        SpawnOffset = Vector( 0, 30, 35 )
    },

    ----CONTRABAND ITEMS----
    {
        Name = "Drone Console",
        Description = "Provides a greater control range and hacking abilities.",
        Model = "models/dronesrewrite/console/console.mdl",
        Price = 5000,
        Type = 2,
        SpawnClass = "dronesrewrite_console",
        SpawnOffset = Vector( 0, 30, 35 )
    },
    {
        Name = "Forged Police Badge",
        Description = "Badge that you can show to police to get into secure areas. Works best with disguiser.",
        Model = "models/freeman/policebadge.mdl",
        Price = 400,
        Type = 2,
        Give = "policebadge"
    },
    {
        Name = "Molotov Cocktail",
        Description = "Creates a ball of fire wherever it lands.",
        Model = "models/props_junk/garbage_glassbottle003a.mdl",
        Price = 500,
        Type = 2,
        Give = "weapon_molotov"
    },
    {
        Name = "Shackles",
        Description = "Used to tie players up to make them walk slower and prevent them from using weapons. Moderately strong.",
        Price = 900,
        Type = 2,
        Give = "weapon_cuff_shackles"
    },
    {
        Name = "Rope Leash",
        Description = "Similar to shackles, but players can be dragged with them.",
        Price = 800,
        Type = 2,
        Give = "weapon_leash_rope"
    },
    {
        Name = "Flashbang",
        Description = "Temporarily blinds any player that looks at the grenade.",
        Model = "models/weapons/w_eq_flashbang.mdl",
        Price = 300,
        Type = 2,
        Give = "arc9_fas_m84"
    },
    {
        Name = "Smoke Grenade",
        Description = "Emits a dense cloud of green smoke.",
        Model = "models/weapons/w_eq_smokegrenade.mdl",
        Price = 200,
        Type = 2,
        Give = "arc9_fas_m18"
    },
    {
        Name = "Meth Oven",
        Description = "Bakes meth mixes into their final consumable and sellable form.",
        Model = "models/props_wasteland/kitchen_stove001a.mdl",
        Price = 5000,
        Type = 2,
        SpawnClass = "meth_oven",
        SpawnOffset = Vector( 0, 30, 35 )
    },
    {
        Name = "Meth Mixer",
        Description = "Mixes ingredients together to prepare a meth mix for baking.",
        Model = "models/props_wasteland/laundry_washer001a.mdl",
        Price = 5000,
        Type = 2,
        SpawnClass = "meth_mixer",
        SpawnOffset = Vector( 0, 30, 35 )
    },
    {
        Name = "Meth Filler",
        Description = "Base ingredient required for all meth recipes.",
        Model = "models/props_junk/garbage_plasticbottle001a.mdl",
        Price = 500,
        Type = 2,
        SpawnClass = "meth_filler",
        SpawnOffset = Vector( 0, 30, 35 )
    },
    {
        Name = "Cannabis Seed (Normal)",
        Description = "Grows a normal cannabis plant that outputs 3 weed every 5 minutes.",
        Model = "models/props/de_inferno/flower_barrel.mdl",
        Price = 1500,
        Type = 2,
        SpawnClass = "farm_plant",
        SpawnOffset = Vector( 0, 30, 10 ),
        SpawnFunc = function( ply, item )
        item:SetPlantType( 6 )
        end
    },
    {
        Name = "Cannabis Seed (Spicy)",
        Description = "Grows a spicy cannabis plant that outputs 1 weed every 5 minutes.",
        Model = "models/props/de_inferno/flower_barrel.mdl",
        Price = 3000,
        Type = 2,
        SpawnClass = "farm_plant",
        SpawnOffset = Vector( 0, 30, 10 ),
        SpawnFunc = function( ply, item )
        item:SetPlantType( 7 )
        end
    },
    {
        Name = "Modified Gas Can",
        Description = "Illegal gas can with the safety devices removed to allow for pouring anywhere.",
        Model = "models/props_junk/gascan001a.mdl",
        Price = 600,
        Type = 2,
        Give = "weapon_vfire_gascan"
    },
    {
        Name = "Money Printer",
        Description = "Prints counterfeit money that can be used like regular money. Can be upgraded to improve things such as output amount and sound level.",
        Model = "models/props_c17/consolebox01a.mdl",
        Price = 9000,
        Type = 2,
        SpawnClass = "money_printer_advanced",
        SpawnOffset = Vector( 0, 30, 35 ),
        SpawnFunc = function( ply, item )
        item:SetOwner( ply )
        end
    },
    {
        Name = "Money Printer Paper Upgrade",
        Description = "Increases the max amount of paper a printer can hold.",
        Model = "models/props_c17/consolebox05a.mdl",
        Price = 1000,
        Type = 2,
        SpawnClass = "printer_upgrade_paper",
        SpawnOffset = Vector( 0, 30, 35 )
    },
    {
        Name = "Money Printer Sound Upgrade",
        Description = "Reduces the volume of the sound produced by a money printer.",
        Model = "models/props_c17/consolebox05a.mdl",
        Price = 5000,
        Type = 2,
        SpawnClass = "printer_upgrade_sound",
        SpawnOffset = Vector( 0, 30, 35 )
    },
    {
        Name = "Money Printer Cooling Upgrade",
        Description = "Reduces the chance of a money printer overheating and catching fire.",
        Model = "models/props_c17/consolebox05a.mdl",
        Price = 3000,
        Type = 2,
        SpawnClass = "printer_upgrade_cooling",
        SpawnOffset = Vector( 0, 30, 35 )
    },
    {
        Name = "Graffiti Spray",
        Description = "Used to vandalize property with paint, usually to send a message.",
        Model = "models/props_junk/propane_tank001a.mdl",
        Price = 50,
        Type = 2,
        Give = "graffiti-swep"
    },
    {
        Name = "Taser",
        Description = "Stuns a player. Requires special ammo.",
        Model = "models/defcon/taser/w_taser.mdl",
        Price = 1000,
        Type = 2,
        Give = "stungun"
    },
    {
        Name = "Disguise Kit",
        Description = "Allows user to change their playermodel to any job playermodel. (One-time use, disguise gets removed if you take damage.)",
        Model = "models/weapons/w_c4.mdl",
        Price = 3000,
        Type = 2,
        Give = "weapon_agent"
    },
    {
        Name = "Coca Seed",
        Description = "Grows a coca plant that outputs raw cocaine every 15 minutes.",
        Model = "models/props/cs_office/plant01.mdl",
        Price = 2500,
        Type = 2,
        SpawnClass = "farm_plant",
        SpawnOffset = Vector( 0, 30, 10 ),
        SpawnFunc = function( ply, item )
        item:SetPlantType( 8 )
        end
    },
    {
        Name = "Heat Lamp",
        Description = "Used to grow coca plants. Must be supervised at all times.",
        Model = "models/props/de_nuke/IndustrialLight01.mdl",
        Price = 500,
        Type = 2,
        SpawnClass = "heat_lamp",
        SpawnOffset = Vector( 0, 30, 35 ),
        SpawnFunc = function( ply, item )
        item.Owner = ply
        end
    },
    {
        Name = "Purifier",
        Description = "Used to purify raw cocaine.",
        Model = "models/props_wasteland/laundry_washer003.mdl",
        Price = 3000,
        Type = 2,
        SpawnClass = "purifier",
        SpawnOffset = Vector( 0, 30, 35 ),
        SpawnFunc = function( ply, item )
        item.Owner = ply
        end
    },
    {
        Name = "Drug Box",
        Description = "Stores drugs for selling to the smuggler.",
        Model = "models/props/CS_militia/crate_extrasmallmill.mdl",
        Price = 50,
        Type = 2,
        SpawnClass = "drug_box",
        SpawnOffset = Vector( 0, 30, 35 )
    },

    ----FIREFIGHTER VEHICLES----
    {
        Name = "2014 Seagrave Marauder II Engine",
        Description = "Fire engine, enables use of the fire hose.",
        Model = "models/noble/engine_32.mdl",
        Price = 0,
        Type = 3,
        SpawnOverride = function( ply, self )
        SpawnVehicle( ply, "2014 Seagrave Marauder II Engine", 2 )
        end
    },
    {
        Name = "Dodge Ram 3500 Fire",
        Description = "Truck with red and white emergency lights. Useful for getting places the big engine can't reach.",
        Model = "models/tdmcars/dod_ram_3500.mdl",
        Price = 0,
        Type = 3,
        SpawnOverride = function( ply, self )
        SpawnVehicle( ply, "Dodge Ram 3500 Fire", 2 )
        end
    },
    {
        Name = "Ford F350 Ambulance",
        Description = "Standard ambulance.",
        Model = "models/lonewolfie/ford_f350_ambu.mdl",
        Price = 0,
        Type = 3,
        SpawnOverride = function( ply, self )
        SpawnVehicle( ply, "Ford F350 Ambulance Photon", 2 )
        end
    },

    ----GOV VEHICLES----
    {
        Name = "Chevrolet Impala Police",
        Description = "Chevrolet Impala with police features.",
        Model = "models/lonewolfie/chev_impala_09_police.mdl",
        Price = 0,
        Type = 4,
        SpawnOverride = function( ply, self )
        SpawnVehicle( ply, "Chevrolet Impala Police", 1 )
        end
    },
    {
        Name = "2007 Chevrolet Tahoe Unmarked",
        Description = "Small unmarked SUV with police equipment.",
        Model = "models/LoneWolfie/chev_tahoe_police.mdl",
        Price = 0,
        Type = 4,
        SpawnOverride = function( ply, self )
        SpawnVehicle( ply, "Unmarked Chevy Tahoe", 1 )
        end
    },
    {
        Name = "2007 Chevrolet Suburban",
        Description = "Large SUV with police equipment.",
        Model = "models/LoneWolfie/chev_suburban_pol.mdl",
        Price = 0,
        Type = 4,
        SpawnOverride = function( ply, self )
        SpawnVehicle( ply, "Chicago Police Chevy Suburban", 1 )
        end
    },
    {
        Name = "Lenco Bearcat G3",
        Description = "A strong SWAT van.",
        Model = "models/perrynsvehicles/bearcat_g3/bearcat_g3.mdl",
        Price = 0,
        Type = 4,
        CanBuy = function( ply, self )
        return ply.IsSwat == true, "Only SWAT officers can spawn the Bearcat!"
        end,
        SpawnOverride = function( ply, self )
        SpawnVehicle( ply, "Lenco Bearcat G3", 1 )
        end
    },
    {
        Name = "Ford Crown Vic Police",
        Description = "Crown vic with police equipment.",
        Model = "models/tdmcars/emergency/for_crownvic_fh3.mdl",
        Price = 0,
        Type = 4,
        SpawnOverride = function( ply, self )
        SpawnVehicle( ply, "Ford Crown Vic Police", 1 )
        end
    },
    {
        Name = "Ford Crown Vic Undercover",
        Description = "Undercover Crown Vic.",
        Model = "models/tdmcars/emergency/for_crownvic_fh3.mdl",
        Price = 0,
        Type = 4,
        SpawnOverride = function( ply, self )
        SpawnVehicle( ply, "Ford Crown Vic Undercover", 1 )
        end
    },
    {
        Name = "Dodge Ram 3500 Police",
        Description = "Police pickup truck.",
        Model = "models/tdmcars/dod_ram_3500.mdl",
        Price = 0,
        Type = 4,
        SpawnOverride = function( ply, self )
        SpawnVehicle( ply, "Dodge Ram 3500 Police", 1 )
        end
    },
    {
        Name = "Dodge Charger 2015 Pursuit",
        Description = "Traffic enforcement model.",
        Model = "models/lonewolfie/dodge_charger_2015_police.mdl",
        Price = 0,
        Type = 4,
        SpawnOverride = function( ply, self )
        SpawnVehicle( ply, "Dodge Charger 2015 Pursuit", 1 )
        end
    },
    {
        Name = "Dodge Charger 2015 Undercover",
        Description = "Traffic enforcement model.",
        Model = "models/lonewolfie/dodge_charger_2015_undercover.mdl",
        Price = 0,
        Type = 4,
        SpawnOverride = function( ply, self )
        SpawnVehicle( ply, "Dodge Charger 2015 Undercover", 1 )
        end
    },
    {
        Name = "Lambosine",
        Description = "Cruise around town in style. While getting shot at.",
        Model = "models/sentry/lambosine.mdl",
        Price = 0,
        Type = 4,
        CanBuy = function( ply, self )
        return ply:Team() == TEAM_MAYOR, "Only the mayor can spawn the limo!"
        end,
        SpawnOverride = function( ply, self )
        SpawnVehicle( ply, "lambosine", 1 )
        end
    },
    {
        Name = "Lamborghini Veneno Police Edition",
        Description = "Its erm....a little fast.",
        Model = "models/sentry/veneno_new_cop.mdl",
        Price = 0,
        Type = 4,
        SpawnOverride = function( ply, self )
        SpawnVehicle( ply, "Lamborghini Veneno Police Edition", 1 )
        end
    },
    {
        Name = "Dodge Monaco Police",
        Description = "Standard 70's patrol car.",
        Model = "models/lonewolfie/dodge_monaco_police.mdl",
        Price = 0,
        Type = 4,
        SpawnOverride = function( ply, self )
        SpawnVehicle( ply, "Dodge Monaco Police ", 1 )
        end
    },
    {
        Name = "Lamborghini Huracan Undercover",
        Description = "Unmarked lambo.",
        Model = "models/lonewolfie/lam_huracan.mdl",
        Price = 0,
        Type = 4,
        SpawnOverride = function( ply, self )
        SpawnVehicle( ply, "Lamborghini Huracan Undercover", 1 )
        end
    },
    {
        Name = "2015 Challenger Unmarked",
        Description = "Unmarked challenger.",
        Model = "models/tdmcars/dod_challenger15.mdl",
        Price = 0,
        Type = 4,
        SpawnOverride = function( ply, self )
        SpawnVehicle( ply, "2015 Challenger Unmarked", 1 )
        end
    },
    {
        Name = "Impala Taxi Unmarked",
        Description = "Just a normal taxi, nothing to see here.",
        Model = "models/lonewolfie/chev_impala_09_taxi.mdl",
        Price = 0,
        Type = 4,
        SpawnOverride = function( ply, self )
        SpawnVehicle( ply, "Impala Taxi Unmarked", 1 )
        end
    },
    {
        Name = "Unmarked LaFerrari",
        Description = "Fast and stealthy boi",
        Model = "models/tdmcars/fer_lafer.mdl",
        Price = 0,
        Type = 4,
        SpawnOverride = function( ply, self )
        SpawnVehicle( ply, "Unmarked LaFerrari", 1 )
        end
    },
    {
        Name = "Charger SRT-8 Police Undercover",
        Description = "Undercover old charger.",
        Model = "models/tdmcars/dod_charger12.mdl",
        Price = 0,
        Type = 4,
        SpawnOverride = function( ply, self )
        SpawnVehicle( ply, "Charger SRT-8 Police Undercover", 1 )
        end
    },

    ----HEALER ITEMS----
    {
        Name = "Replenish Health",
        Description = "Set your health back to 100.",
        Price = 300,
        Type = 6,
        CanBuy = function( ply, self )
        return ply:Health() >= ply:GetMaxHealth(), "Your health is already at max."
        end,
        SpawnOverride = function( ply, self )
        ply:SetHealth( ply:GetMaxHealth() )
        if team.NumPlayers( TEAM_FIREBOSS ) == 0 and team.NumPlayers( TEAM_FIRE ) == 0 then
            ply:addMoney( 150 ) --Health from NPC is cheaper if there aren't any players to give free health
            end
            end
    },
    {
        Name = "One-Time Med Kit",
        Description = "Sets your health back to 100, can be used at any time but removes itself after being used.",
        Price = 500,
        Type = 6,
        CanBuy = function( ply, self )
        return ply:HasWeapon( "onetime_medkit" ), "You already have a one-time med kit!"
        end,
        Give = "onetime_medkit"
    },
    {
        Name = "One-Time Armor Kit",
        Description = "Sets your armor to 100, can be used at any time but removes itself after being used.",
        Price = 1000,
        Type = 6,
        CanBuy = function( ply, self )
        return ply:HasWeapon( "onetime_armorkit" ), "You already have a one-time armor kit!"
        end,
        Give = "onetime_armorkit"
    },
    {
        Name = "Replenish Armor",
        Description = "Set your armor to 100.",
        Price = 800,
        Type = 6,
        CanBuy = function( ply, self )
        return ply:Armor() >= 100, "Your armor is already at max."
        end,
        SpawnOverride = function( ply, self )
        ply:SetArmor( 100 )
        end
    },
    {
        Name = "Life Insurance",
        Description = "You won't lose money on death for the rest of the session.",
        Price = 3000,
        Type = 6,
        CanBuy = function( ply, self )
        return !ply.HasLifeInsurance, "You already have life insurance."
        end,
        SpawnOverride = function( ply, self )
        ply.HasLifeInsurance = true
        end
    },
    {
        Name = "Experimental Steroid",
        Description = "Regenerates a player's health by 3 HP every second, for 10 minutes. May behave unexpectedly under certain conditions...",
        Model = "models/props_lab/jar01b.mdl",
        Price = 5000,
        Type = 6,
        CanBuy = function( ply, self )
        return ply:Team() == TEAM_FIREBOSS, "Only fire chiefs can purchase this item."
        end,
        SpawnClass = "zombie_experiment",
        SpawnOffset = Vector( 0, 30, 35 )
    },

    ----TRUCKER ITEMS----
    {
        Name = "Dodge Ram 3500 Towtruck",
        Description = "Medium-sized tow truck for average tow jobs.",
        Model = "models/statetrooper/ram_tow.mdl",
        Price = 0,
        Type = 7,
        SpawnOverride = function( ply, self )
        SpawnVehicle( ply, "Dodge Ram 3500 Towtruck", 4 )
        end
    },
    {
        Name = "Flatbed Tow Truck",
        Description = "Flatbed truck for towing larger vehicles.",
        Model = "models/cipro/tow_truck/towtruck.mdl",
        Price = 0,
        Type = 7,
        SpawnOverride = function( ply, self )
        local e = SpawnVehicle( ply, "Flatbed Tow Truck", 4 )
        e:CreateFlatbed()
        end
    }
}
