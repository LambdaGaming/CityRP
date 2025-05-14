MineableEntity["rock"] = {
    Name = "Rock",
    Models = {
        "models/props/cs_militia/militiarock05.mdl",
        "models/props/cs_militia/militiarock03.mdl",
        "models/props/cs_militia/militiarock02.mdl"
    },
    Tools = { ["weapon_hl2pickaxe"] = 15, ["arc9_fas_m79"] = 100, ["arc9_fas_m67"] = 100 },
    Drops = { ["ucs_iron"] = 100, ["ucs_pcb"] = 5 }
}

MineableEntity["tree"] = {
	Name = "Tree",
	Models = { "models/props/CS_militia/tree_large_militia.mdl" },
	Tools = { ["weapon_hl2axe"] = 15 },
	Drops = { ["ucs_wood"] = 100 },
	MaxSpawn = 4,
	TextOffset = Vector( 20, 20, -650 )
}

CraftingTable["default"] = {
	Name = "Crafting Table",
	Model = "models/props_wasteland/controlroom_desk001b.mdl",
	AllowAutomation = true,
	TextOffset = Vector( 0, 0, 30 )
}

CraftingIngredient["ucs_iron"] = {
	Name = "Iron",
	Category = "Basic Ingredients",
	Types = { ["default"] = true }
}

CraftingIngredient["ucs_wood"] = {
	Name = "Wood",
	Category = "Basic Ingredients",
	Types = { ["default"] = true }
}

CraftingIngredient["ucs_steel"] = {
	Name = "Steel",
	Category = "Basic Ingredients",
	Types = { ["default"] = true }
}

CraftingIngredient["ucs_pcb"] = {
	Name = "PCB",
	Category = "Advanced Ingredients",
	Types = { ["default"] = true }
}

CraftingRecipe["arc9_fas_famas"] = {
	Name = "FAMAS",
	Description = "French bullpup assault rifle. Needs 6 iron and 1 steel.",
	Category = "Rifles",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 6, ["ucs_steel"] = 1 }
}

CraftingRecipe["arc9_fas_mp5"] = {
	Name = "MP5",
	Description = "German submachine gun. Needs 4 iron and 1 steel.",
	Category = "SMGs",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 4, ["ucs_steel"] = 1 }
}

CraftingRecipe["arc9_fas_colt"] = {
	Name = "Colt M639",
	Description = "American Vietnam-era submachine gun. Needs 4 iron and 1 steel.",
	Category = "SMGs",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 4, ["ucs_steel"] = 1 }
}

CraftingRecipe["arc9_fas_mac11"] = {
	Name = "MAC-11",
	Description = "American machine pistol. Needs 3 iron and 1 steel.",
	Category = "SMGs",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 3, ["ucs_steel"] = 1 }
}

CraftingRecipe["arc9_fas_bizon"] = {
	Name = "PP-19 Bizon",
	Description = "Russian submachine gun. Needs 3 iron and 1 steel.",
	Category = "SMGs",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 3, ["ucs_steel"] = 1 }
}

CraftingRecipe["arc9_fas_sterling"] = {
	Name = "Sterling L2A3",
	Description = "British WW2-era submachine gun. Needs 5 iron and 1 steel.",
	Category = "SMGs",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 5, ["ucs_steel"] = 1 }
}

CraftingRecipe["arc9_fas_uzi"] = {
	Name = "Uzi",
	Description = "Israeli machine pistol. Needs 4 iron and 1 steel.",
	Category = "SMGs",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 4, ["ucs_steel"] = 1 }
}

CraftingRecipe["arc9_fas_rpk"] = {
	Name = "RPK",
	Description = "Soviet light machine gun. Needs 7 iron, 2 steel, 4 wood, and a blueprint.",
	Blueprint = "arc9_fas_rpk",
	Category = "LMGs",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 7, ["ucs_steel"] = 2, ["ucs_wood"] = 4 }
}

CraftingRecipe["arc9_fas_m82"] = {
	Name = "Barrett M82",
	Description = "American sniper rifle. Needs 16 iron and 3 steel.",
	Category = "Rifles",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 16, ["ucs_steel"] = 3 }
}

CraftingRecipe["arc9_fas_ak47"] = {
	Name = "AK-47",
	Description = "Soviet assault rifle. Needs 7 iron, 1 steel, and 4 wood.",
	Category = "Rifles",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 7, ["ucs_steel"] = 1, ["ucs_wood"] = 4 }
}

CraftingRecipe["arc9_fas_svd"] = {
	Name = "SVD",
	Description = "Soviet sniper rifle. Needs 11 iron, 1 steel, and 4 wood.",
	Category = "Rifles",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 11, ["ucs_steel"] = 1, ["ucs_wood"] = 4 }
}

CraftingRecipe["arc9_fas_sks"] = {
	Name = "SKS",
	Description = "Soviet WW2-era carbine. Needs 9 iron, 1 steel, and 2 wood.",
	Category = "Rifles",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 9, ["ucs_steel"] = 1, ["ucs_wood"] = 2 }
}

CraftingRecipe["arc9_fas_sr25"] = {
	Name = "SR-25",
	Description = "American sniper rifle. Needs 9 iron and 2 steel.",
	Category = "Rifles",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 9, ["ucs_steel"] = 2 }
}

CraftingRecipe["arc9_fas_m14"] = {
	Name = "M14",
	Description = "American battle rifle. Needs 9 iron, 1 steel, and 2 wood.",
	Category = "Rifles",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 9, ["ucs_steel"] = 1, ["ucs_wood"] = 2 }
}

CraftingRecipe["arc9_fas_m16a2"] = {
	Name = "M16",
	Description = "American Vietnam-era assault rifle. Needs 6 iron and 1 steel.",
	Category = "Rifles",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 6, ["ucs_steel"] = 1 }
}

CraftingRecipe["arc9_fas_ots33"] = {
	Name = "Ots-33 Pernach",
	Description = "Russian machine pistol. Needs 4 iron and 1 steel.",
	Category = "Pistols",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 4, ["ucs_steel"] = 1 }
}

CraftingRecipe["arc9_fas_rk95"] = {
	Name = "RK-95",
	Description = "Finnish assault rifle. Needs 7 iron and 1 steel.",
	Category = "Rifles",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 7, ["ucs_steel"] = 1 }
}

CraftingRecipe["arc9_fas_ak74"] = {
	Name = "AK-74",
	Description = "Soviet assault rifle. Needs 6 iron and 1 steel.",
	Category = "Rifles",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 6, ["ucs_steel"] = 1 }
}

CraftingRecipe["arc9_fas_m4a1"] = {
	Name = "M4A1",
	Description = "American assault rifle. Needs 6 iron and 1 steel.",
	Category = "Rifles",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 6, ["ucs_steel"] = 1 }
}

CraftingRecipe["arc9_fas_m3super90"] = {
	Name = "M3 Super 90",
	Description = "Italian semi-auto shotgun. Needs 3 iron and 4 steel.",
	Category = "Shotguns",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 3, ["ucs_steel"] = 4 }
}

CraftingRecipe["arc9_fas_saiga"] = {
	Name = "Saiga 12K",
	Description = "Russian semi-auto shotgun. Needs 5 iron and 4 steel.",
	Category = "Shotguns",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 5, ["ucs_steel"] = 4 }
}

CraftingRecipe["arc9_fas_g3"] = {
	Name = "G3A3",
	Description = "German battle rifle. Needs 5 iron and 4 steel.",
	Category = "Rifles",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 5, ["ucs_steel"] = 4 }
}

CraftingRecipe["arc9_fas_g36c"] = {
	Name = "G36C",
	Description = "German assault rifle. Needs 6 iron and 1 steel.",
	Category = "Rifles",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 6, ["ucs_steel"] = 1 }
}

CraftingRecipe["arc9_fas_m67"] = {
	Name = "M67",
	Description = "American frag grenade. Needs 4 iron, 2 steel, and a blueprint.",
	Blueprint = "arc9_fas_m67",
	Category = "Explosives",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 4, ["ucs_steel"] = 2 }
}

CraftingRecipe["arc9_fas_m24"] = {
	Name = "M24",
	Description = "American sniper rifle. Needs 12 iron and 2 steel.",
	Category = "Rifles",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 12, ["ucs_steel"] = 2 }
}

CraftingRecipe["arc9_fas_sg550"] = {
	Name = "SG 550",
	Description = "Swiss assault rifle. Needs 6 iron and 1 steel.",
	Category = "Rifles",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 6, ["ucs_steel"] = 1 }
}

CraftingRecipe["arc9_fas_ragingbull"] = {
	Name = "Raging Bull",
	Description = "Brazilian revolver. Needs 14 iron and 1 steel.",
	Category = "Pistols",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 14, ["ucs_steel"] = 1 }
}

CraftingRecipe["arc9_fas_deagle"] = {
	Name = "Desert Eagle",
	Description = "American semi-auto pistol. Needs 11 iron and 1 steel.",
	Category = "Pistols",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 10, ["ucs_steel"] = 1 }
}

CraftingRecipe["arc9_fas_870"] = {
	Name = "Remington 870",
	Description = "American pump shotgun. Needs 3 iron and 3 steel.",
	Category = "Shotguns",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 3, ["ucs_steel"] = 3 }
}

CraftingRecipe["arc9_fas_ks23"] = {
	Name = "KS-23",
	Description = "Soviet pump shotgun. Needs 4 iron, 3 steel, and 2 wood.",
	Category = "Shotguns",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 4, ["ucs_steel"] = 3, ["ucs_wood"] = 2 }
}

CraftingRecipe["arc9_fas_m249"] = {
	Name = "M429",
	Description = "American light machine gun. Needs 6 iron, 2 steel, and a blueprint.",
	Blueprint = "arc9_fas_m249",
	Category = "LMGs",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 6, ["ucs_steel"] = 2 }
}

CraftingRecipe["arc9_fas_mc51"] = {
	Name = "MC51B Vollmer",
	Description = "Modified MP5 that shoots 7.62 NATO. Needs 7 iron, 2 steel, and a blueprint.",
	Blueprint = "arc9_fas_mc51",
	Category = "LMGs",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 7, ["ucs_steel"] = 2 }
}

CraftingRecipe["arc9_fas_m60"] = {
	Name = "M60",
	Description = "American Vietnam-era light machine gun. Needs 7 iron, 2 steel, and a blueprint.",
	Blueprint = "arc9_fas_m60",
	Category = "LMGs",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 4, ["ucs_steel"] = 1 }
}

CraftingRecipe["arc9_fas_m79"] = {
	Name = "M79",
	Description = "American grenade launcher. Needs 15 iron, 5 steel, and a blueprint.",
	Blueprint = "arc9_fas_m79",
	Category = "Explosives",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 4, ["ucs_steel"] = 1 }
}

CraftingRecipe["dronesrewrite_cargo"] = {
	Name = "Cargo Drone",
	Description = "Drone that can carry objects. Needs 6 iron, 3 steel, and 1 PCB.",
	Category = "Drones",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 6, ["ucs_steel"] = 3, ["ucs_pcb"] = 1 },
	SpawnOverride = function( ply, self )
		local e = ents.Create( "dronesrewrite_cargo" )
		e:SetPos( self:GetPos() - Vector( 0, 0, -5 ) )
		e:Spawn()
		e:SetupOwner( ply )
	end
}

CraftingRecipe["dronesrewrite_nanodr"] = {
	Name = "Nano Drone",
	Description = "Tiny, quiet drone useful for spying. Needs 5 iron and 3 steel.",
	Category = "Drones",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 5, ["ucs_steel"] = 3 },
	SpawnOverride = function( ply, self )
		local e = ents.Create( "dronesrewrite_nano" )
		e:SetPos( self:GetPos() - Vector( 0, 0, -5 ) )
		e:Spawn()
		e:SetupOwner( ply )
	end
}

CraftingRecipe["dronesrewrite_gunner"] = {
	Name = "Gun Drone",
	Description = "Lethal drone armed with a machine gun. Needs 60 iron, 10 steel, and 2 PCBs.",
	Category = "Drones",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 60, ["ucs_steel"] = 10, ["ucs_pcb"] = 2 },
	SpawnOverride = function( ply, self )
		local e = ents.Create( "dronesrewrite_gunner" )
		e:SetPos( self:GetPos() - Vector( 0, 0, -5 ) )
		e:Spawn()
		e:SetupOwner( ply )
	end
}

CraftingRecipe["dronesrewrite_plotdr"] = {
	Name = "PLOT-130",
	Description = "Basically just a metal gear. Needs 200 iron, 25 steel, and 3 PCBs.",
	Category = "Drones",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 200, ["ucs_steel"] = 25, ["ucs_pcb"] = 3 },
	SpawnOverride = function( ply, self )
		local e = ents.Create( "dronesrewrite_plotdr" )
		e:SetPos( self:GetPos() - Vector( 0, 0, -5 ) )
		e:Spawn()
		e:SetupOwner( ply )
	end
}

CraftingRecipe["dronesrewrite_turret"] = {
	Name = "Controllable Turret",
	Description = "Remote-controlled, deployable turret. Needs 25 iron, 5 steel, and 1 PCB.",
	Category = "Drones",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 25, ["ucs_steel"] = 5, ["ucs_pcb"] = 1 },
	SpawnOverride = function( ply, self )
		local e = ents.Create( "dronesrewrite_turret" )
		e:SetPos( self:GetPos() - Vector( 0, 0, -5 ) )
		e:Spawn()
		e:SetupOwner( ply )
	end
}

CraftingRecipe["sent_turtle"] = {
	Name = "Toy Turtle",
	Description = "Hops around and makes noise. Needs 4 wood.",
	Category = "Tools",
	Types = { ["default"] = true },
	Materials = { ["ucs_wood"] = 4 }
}

CraftingRecipe["lockpick"] = {
	Name = "Lockpick",
	Description = "Unlocks doors and vehicles. Needs 3 iron.",
	Category = "Tools",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 3 }
}

CraftingRecipe["factory_lockpick"] = {
	Name = "Premium Lockpick",
	Description = "Works at a faster rate than the normal lockpick. Needs 20 iron.",
	Category = "Tools",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 20 }
}

CraftingRecipe["usm_c4"] = {
	Name = "Timed C4",
	Description = "Plastic explosive with adjustable timer. Needs 8 iron, 2 steel, and a blueprint.",
	Blueprint = "usm_c4",
	Category = "Explosives",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 8, ["ucs_steel"] = 2 }
}

CraftingRecipe["item_box_buckshot"] = {
	Name = "Shotgun Ammo",
	Description = "Needs 4 iron and 1 steel.",
	Category = "Ammo",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 4, ["ucs_steel"] = 1 }
}

CraftingRecipe["weapon_slam"] = {
	Name = "SLAM",
	Description = "Remotely detonated explosive with tripmine ability. Needs 10 iron, 2 steel, and a blueprint.",
	Blueprint = "weapon_slam",
	Category = "Explosives",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 10, ["ucs_steel"] = 2 }
}

CraftingRecipe["weapon_car_bomb"] = {
	Name = "Car Bomb",
	Description = "Detonates when someone starts up the target vehicle. Needs 6 iron, 2 steel, and a blueprint.",
	Blueprint = "weapon_car_bomb",
	Category = "Explosives",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 6, ["ucs_steel"] = 2 }
}

CraftingRecipe["rtx4090"] = {
	Name = "RTX 4090",
	Description = "Those power connectors are sketchy. Needs 4 iron, 4 steel, 1 PCB, and a blueprint.",
	Blueprint = "rtx4090",
	Category = "Explosives",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 4, ["ucs_steel"] = 4, ["ucs_pcb"] = 1 }
}

CraftingRecipe["police_scanner"] = {
	Name = "Police Scanner",
	Description = "Lets you listen to the police group chat. Needs 8 iron and 1 PCB.",
	Category = "Tools",
	Types = { ["default"] = true },
	Materials = { ["ucs_iron"] = 8, ["ucs_pcb"] = 1 }
}
