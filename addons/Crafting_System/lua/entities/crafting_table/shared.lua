
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Crafting Table"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.Category = "Crafting Table"

CraftingTable = {}
CraftingCategory = {}
CraftingIngredient = {}

--Template Ingredient
--[[
	CraftingIngredient["iron"] = {
		Name = "Iron"
	}
]]

CraftingIngredient["ironbar"] = {
	Name = "Iron"
}

CraftingIngredient["wrench"] = {
	Name = "Wrench"
}

CraftingIngredient["swm_log"] = {
	Name = "Wood"
}

CraftingIngredient["dronesrewrite_spy"] = {
	Name = "Spy Drone"
}

--Template Category
--[[
	CraftingCategory[1] = {
		Name = "Pistols",
		Color = Color( 49, 53, 61, 255 )
	}
]]

CraftingCategory[1] = {
	Name = "Pistols",
	Color = Color( 49, 53, 61, 255 )
}

CraftingCategory[2] = {
	Name = "SMGs",
	Color = Color( 49, 53, 61, 255 )
}

CraftingCategory[3] = {
	Name = "Rifles",
	Color = Color( 49, 53, 61, 255 )
}

CraftingCategory[4] = {
	Name = "Shotguns",
	Color = Color( 49, 53, 61, 255 )
}

CraftingCategory[5] = {
	Name = "Explosives",
	Color = Color( 49, 53, 61, 255 )
}

CraftingCategory[6] = {
	Name = "Crafting Ingredients",
	Color = Color( 49, 53, 61, 255 )
}

CraftingCategory[7] = {
	Name = "Tools",
	Color = Color( 49, 53, 61, 255 )
}

CraftingCategory[8] = {
	Name = "Ammo & Upgrades",
	Color = Color( 49, 53, 61, 255 )
}

CraftingCategory[9] = {
	Name = "Other",
	Color = Color( 49, 53, 61, 255 )
}

--Template Item
--[[
	CraftingTable["weapon_crowbar"] = {
		Name = "Crowbar",
		Description = "Requires 1 ball.",
		NeedsBlueprint = true,
		Category = "Tools",
		Materials = {
			sent_ball = 2,
			edit_fog = 1
		},
		SpawnFunction =
			function( ply, self )
				local e = ents.Create( "weapon_crowbar" )
				e:SetPos( self:GetPos() - Vector( 0, 0, -5 ) )
				e:Spawn()
			end
		}
]]

CraftingTable["cw_l85a2"] = {
	Name = "L85A2",
	Description = "Requires 7 iron and 1 wrench.",
	Category = "SMGs",
	Materials = {
		ironbar = 7,
		wrench = 1
	},
	SpawnFunction =
		function( ply, self )
			ply:Give( "cw_l85a2" )
		end
	}

CraftingTable["cw_ump45"] = {
	Name = "UMP 45",
	Description = "Requires 5 iron and 1 wrench.",
	Category = "SMGs",
	Materials = {
		ironbar = 5,
		wrench = 1
	},
	SpawnFunction =
		function( ply, self )
			ply:Give( "cw_ump45" )
		end
	}

CraftingTable["cw_ws_mosin"] = {
	Name = "Mosin Nagant",
	Description = "Requires 5 iron and 2 wrenches.",
	Category = "Rifles",
	Materials = {
		ironbar = 5,
		wrench = 2
	},
	SpawnFunction =
		function( ply, self )
			ply:Give( "cw_ws_mosin" )
		end
	}

CraftingTable["cw_mp5"] = {
	Name = "MP5",
	Description = "Requires 5 iron and 1 wrench.",
	Category = "SMGs",
	Materials = {
		ironbar = 5,
		wrench = 1
	},
	SpawnFunction =
		function( ply, self )
			ply:Give( "cw_mp5" )
		end
	}

CraftingTable["cw_mac11"] = {
	Name = "MAC-11",
	Description = "Requires 4 iron and 1 wrench.",
	Category = "SMGs",
	Materials = {
		ironbar = 4,
		wrench = 1
	},
	SpawnFunction =
		function( ply, self )
			ply:Give( "cw_mac11" )
		end
	}

CraftingTable["dronesrewrite_spyspider"] = {
	Name = "Spider Drone",
	Description = "Requires 5 iron, 3 wrenches, and 1 spy drone.",
	Category = "Tools",
	Materials = {
		wrench = 3,
		ironbar = 5,
		dronesrewrite_spy = 1
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "dronesrewrite_spyspider" )
			e:SetPos( self:GetPos() - Vector( 0, 0, -5 ) )
			e:Spawn()
			e:SetupOwner( ply )
		end
	}

CraftingTable["dronesrewrite_nanodr"] = {
	Name = "Nano Drone",
	Description = "Requires 5 iron and 3 wrenches.",
	NeedsBlueprint = true,
	Category = "Tools",
	Materials = {
		wrench = 3,
		ironbar = 5
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "dronesrewrite_nanodr" )
			e:SetPos( self:GetPos() - Vector( 0, 0, -5 ) )
			e:Spawn()
			e:SetupOwner( ply )
		end
	}

CraftingTable["cw_kks_doi_mg42"] = {
	Name = "MG 42",
	Description = "Needs 5 wrenches and 12 iron",
	NeedsBlueprint = true,
	Category = "Rifles",
	Materials = {
		wrench = 5,
		ironbar = 12,
	},
	SpawnFunction =
		function( ply, self )
			ply:Give( "cw_kks_doi_mg42" )
		end
}

CraftingTable["nik_m1garandnew"] = {
	Name = "M1 Garand",
	Description = "Needs 4 wrenches, and 7 iron",
	NeedsBlueprint = true,
	Category = "Rifles",
	Materials = {
		ironbar = 7,
		wrench = 4,
	},
	SpawnFunction =
		function( ply, self )
			ply:Give( "nik_m1garandnew" )
		end
}

CraftingTable["cw_ak74"] = {
	Name = "AK-74",
	Description = "Needs 4 wood, 2 wrenches, and 6 iron",
	NeedsBlueprint = true,
	Category = "Rifles",
	Materials = {
		swm_log = 4,
		ironbar = 6,
		wrench = 2,
	},
	SpawnFunction =
		function( ply, self )
			ply:Give( "cw_ak74" )
		end
}

CraftingTable["cw_ar15"] = {
	Name = "AR-15",
	Description = "Needs 6 iron and 2 wrenches",
	NeedsBlueprint = true,
	Category = "Rifles",
	Materials = {
		wrench = 2,
		ironbar = 6,
	},
	SpawnFunction =
		function( ply, self )
			ply:Give( "cw_ar15" )
		end
}

CraftingTable["cw_m3super90"] = {
	Name = "M3 Super 90",
	Description = "Needs 3 wrenches and 8 iron",
	NeedsBlueprint = true,
	Category = "Shotguns",
	Materials = {
		wrench = 3,
		ironbar = 8,
	},
	SpawnFunction =
		function( ply, self )
			ply:Give( "cw_m3super90" )
		end
}

CraftingTable["wrench"] = {
	Name = "Wrench",
	Description = "Needs 2 iron",
	Category = "Crafting Ingredients",
	Materials = {
		ironbar = 2,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "wrench" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["cw_scarh"] = {
	Name = "SCAR-H",
	Description = "Needs 8 iron and 2 wrenches",
	NeedsBlueprint = true,
	Category = "Rifles",
	Materials = {
		ironbar = 8,
		wrench = 2,
	},
	SpawnFunction =
		function( ply, self )
			ply:Give( "cw_scarh" )
		end
}

CraftingTable["cw_g3a3"] = {
	Name = "G3A3",
	Description = "Needs 6 iron and 1 wrench",
	NeedsBlueprint = true,
	Category = "Rifles",
	Materials = {
		ironbar = 6,
		wrench = 1,
	},
	SpawnFunction =
		function( ply, self )
			ply:Give( "cw_g3a3" )
		end
}

CraftingTable["cw_g36c"] = {
	Name = "G36C",
	Description = "Needs 6 iron and 1 wrench",
	NeedsBlueprint = true,
	Category = "Rifles",
	Materials = {
		ironbar = 6,
		wrench = 1,
	},
	SpawnFunction =
		function( ply, self )
			ply:Give( "cw_g36c" )
		end
}

CraftingTable["cw_frag_grenade"] = {
	Name = "Frag Grenade",
	Description = "Needs 4 iron, and 4 wrenches",
	NeedsBlueprint = true,
	Category = "Explosives",
	Materials = {
		ironbar = 4,
		wrench = 4,
	},
	SpawnFunction =
		function( ply, self )
			ply:Give( "cw_frag_grenade" )
		end
}

CraftingTable["cw_l115"] = {
	Name = "L115 Sniper",
	Description = "Needs 10 iron and 2 wrenches",
	NeedsBlueprint = true,
	Category = "Rifles",
	Materials = {
		ironbar = 10,
		wrench = 2,
	},
	SpawnFunction =
		function( ply, self )
			ply:Give( "cw_l115" )
		end
}

CraftingTable["cw_m14"] = {
	Name = "M14",
	Description = "Needs 7 iron and 2 wrenches",
	NeedsBlueprint = true,
	Category = "Rifles",
	Materials = {
		ironbar = 7,
		wrench = 2,
	},
	SpawnFunction =
		function( ply, self )
			ply:Give( "cw_m14" )
		end
}

CraftingTable["cw_vss"] = {
	Name = "VSS",
	Description = "Needs 6 iron and 1 wrench",
	NeedsBlueprint = true,
	Category = "Rifles",
	Materials = {
		ironbar = 6,
		wrench = 1,
	},
	SpawnFunction =
		function( ply, self )
			ply:Give( "cw_vss" )
		end
}

CraftingTable["sent_turtle"] = {
	Name = "Toy Turtle",
	Description = "Needs 2 wood",
	Category = "Other",
	Materials = {
		swm_log = 2,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "sent_turtle" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["lockpick"] = {
	Name = "Lockpick",
	Description = "Needs 3 iron",
	Category = "Tools",
	Materials = {
		ironbar = 3,
	},
	SpawnFunction =
		function( ply, self )
			ply:Give( "lockpick" )
		end
}

CraftingTable["factory_lockpick"] = {
	Name = "Premium Lockpick",
	Description = "Needs 20 iron",
	NeedsBlueprint = true,
	Category = "Tools",
	Materials = {
		ironbar = 20,
	},
	SpawnFunction =
		function( ply, self )
			ply:Give( "factory_lockpick" )
		end
}

CraftingTable["usm_c4"] = {
	Name = "Timed C4",
	Description = "Needs 8 iron and 4 wrenches",
	NeedsBlueprint = true,
	Category = "Explosives",
	Materials = {
		ironbar = 8,
		wrench = 4,
	},
	SpawnFunction =
		function( ply, self )
			ply:Give( "usm_c4" )
		end
}

CraftingTable["cw_extrema_ratio_official"] = {
	Name = "Knife",
	Description = "Needs 1 wood and 2 iron",
	Category = "Tools",
	Materials = {
		ironbar = 3,
		swm_log = 1,
	},
	SpawnFunction =
		function( ply, self )
			ply:Give( "cw_extrema_ratio_official" )
		end
}

CraftingTable["cw_mr96"] = {
	Name = "MR-96",
	Description = "Needs 5 iron and 1 wrench",
	NeedsBlueprint = true,
	Category = "Pistols",
	Materials = {
		ironbar = 5,
		wrench = 1,
	},
	SpawnFunction =
		function( ply, self )
			ply:Give( "cw_mr96" )
		end
}

CraftingTable["item_box_buckshot"] = {
	Name = "Shotgun Ammo",
	Description = "Needs 1 wrench and 4 iron",
	Category = "Ammo & Upgrades",
	Materials = {
		ironbar = 4,
		wrench = 1,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "item_box_buckshot" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["cw_shorty"] = {
	Name = "Serbu Super-Shorty",
	Description = "Needs 3 wrenches and 6 iron",
	NeedsBlueprint = true,
	Category = "Shotguns",
	Materials = {
		wrench = 3,
		ironbar = 6,
	},
	SpawnFunction =
		function( ply, self )
			ply:Give( "cw_shorty" )
		end
}

CraftingTable["cw_attpack_suppressors"] = {
	Name = "Suppressor Attachment Pack",
	Description = "Needs 8 iron",
	Category = "Ammo & Upgrades",
	Materials = {
		ironbar = 8,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "cw_attpack_suppressors" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["cw_m249_official"] = {
	Name = "M429",
	Description = "Needs 2 wrenches and 10 iron",
	NeedsBlueprint = true,
	Category = "Rifles",
	Materials = {
		wrench = 2,
		ironbar = 10,
	},
	SpawnFunction =
		function( ply, self )
			ply:Give( "cw_m249_official" )
		end
}

CraftingTable["cw_attpack_ammotypes_rifles"] = {
	Name = "Extra Rifle Ammo Types",
	Description = "Needs 5 iron",
	Category = "Ammo & Upgrades",
	Materials = {
		ironbar = 5,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "cw_attpack_ammotypes_rifles" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["cw_attpack_ammotypes_shotguns"] = {
	Name = "Extra Shotgun Ammo Types",
	Description = "Needs 10 iron",
	Category = "Ammo & Upgrades",
	Materials = {
		ironbar = 10,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "cw_attpack_ammotypes_shotguns" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["weapon_slam"] = {
	Name = "SLAM Remote Explosive",
	Description = "Needs 10 iron and 4 wrenches",
	NeedsBlueprint = true,
	Category = "Explosives",
	Materials = {
		ironbar = 10,
		wrench = 4,
	},
	SpawnFunction =
		function( ply, self )
			ply:Give( "weapon_slam" )
		end
}

CraftingTable["cw_attpack_sights_longrange"] = {
	Name = "Long Range Scopes Attachment Pack",
	Description = "Needs 5 iron and 1 wrench",
	Category = "Ammo & Upgrades",
	Materials = {
		ironbar = 5,
		wrench = 1,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "cw_attpack_sights_longrange" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["cw_attpack_various"] = {
	Name = "40mm Grenade Launcher Rifle Attachment",
	Description = "Needs 6 iron and 2 wrenches",
	NeedsBlueprint = true,
	Category = "Ammo & Upgrades",
	Materials = {
		ironbar = 6,
		wrench = 2,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "cw_attpack_various" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["cw_ammo_40mm"] = {
	Name = "40mm Grenade",
	Description = "Needs 7 iron and 4 wrenches",
	Category = "Ammo & Upgrades",
	Materials = {
		ironbar = 7,
		wrench = 4,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "cw_ammo_40mm" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["weapon_car_bomb"] = {
	Name = "Car Bomb",
	Description = "Needs 6 iron and 4 wrenches",
	NeedsBlueprint = true,
	Category = "Explosives",
	Materials = {
		ironbar = 6,
		wrench = 4,
	},
	SpawnFunction =
		function( ply, self )
			ply:Give( "weapon_car_bomb" )
		end
}

CraftingTable["ins2_atow_rpg7"] = {
	Name = "RPG-7",
	Description = "Needs 25 iron, 10 wrenches, and 10 wood",
	NeedsBlueprint = true,
	Category = "Explosives",
	Materials = {
		ironbar = 25,
		wrench = 10,
		swm_log = 10,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "ins2_atow_rpg7" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}