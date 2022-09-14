ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Crafting Table"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.Category = "Crafting Table"

CraftingTable = {}
CraftingCategory = {}
CraftingIngredient = {}
local COLOR_DEFAULT = Color( 49, 53, 61, 255 )

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

CraftingIngredient["goldbar"] = {
	Name = "Gold"
}

CraftingIngredient["ruby"] = {
	Name = "Ruby"
}

CraftingIngredient["diamond"] = {
	Name = "Diamond"
}

--Template Category
--[[
	CraftingCategory[1] = {
		Name = "Pistols",
		Color = COLOR_DEFAULT,
		StartCollapsed = false
	}
]]

CraftingCategory[1] = {
	Name = "Pistols",
	Color = COLOR_DEFAULT
}

CraftingCategory[2] = {
	Name = "SMGs",
	Color = COLOR_DEFAULT
}

CraftingCategory[3] = {
	Name = "Rifles",
	Color = COLOR_DEFAULT
}

CraftingCategory[4] = {
	Name = "Shotguns",
	Color = COLOR_DEFAULT
}

CraftingCategory[5] = {
	Name = "Explosives",
	Color = COLOR_DEFAULT
}

CraftingCategory[6] = {
	Name = "Crafting Ingredients",
	Color = COLOR_DEFAULT
}

CraftingCategory[7] = {
	Name = "Tools",
	Color = COLOR_DEFAULT
}

CraftingCategory[8] = {
	Name = "Ammo & Upgrades",
	Color = COLOR_DEFAULT
}

CraftingCategory[9] = {
	Name = "Other",
	Color = COLOR_DEFAULT
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
		SpawnFunction = function( ply, self )
			local e = ents.Create( "weapon_crowbar" )
			e:SetPos( self:GetPos() - Vector( 0, 0, -5 ) )
			e:Spawn()
		end
	}
]]

CraftingTable["arccw_mifl_fas2_famas"] = {
	Name = "FAMAS",
	Description = "Requires 7 iron and 1 wrench.",
	Category = "Rifles",
	Materials = {
		ironbar = 7,
		wrench = 1
	},
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_mifl_fas2_famas" )
	end
}

CraftingTable["arccw_mifl_fas2_sr25"] = {
	Name = "SR-25",
	Description = "Requires 5 iron and 2 wrenches.",
	Category = "Rifles",
	Materials = {
		ironbar = 5,
		wrench = 2
	},
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_mifl_fas2_sr25" )
	end
}

CraftingTable["arccw_mifl_fas2_mp5"] = {
	Name = "MP5",
	Description = "Requires 5 iron and 1 wrench.",
	Category = "SMGs",
	Materials = {
		ironbar = 5,
		wrench = 1
	},
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_mifl_fas2_mp5" )
	end
}

CraftingTable["arccw_mifl_fas2_mac11"] = {
	Name = "MAC-11",
	Description = "Requires 4 iron and 1 wrench.",
	Category = "SMGs",
	Materials = {
		ironbar = 4,
		wrench = 1
	},
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_mifl_fas2_mac11" )
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
	SpawnFunction = function( ply, self )
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
	SpawnFunction = function( ply, self )
		local e = ents.Create( "dronesrewrite_nanodr" )
		e:SetPos( self:GetPos() - Vector( 0, 0, -5 ) )
		e:Spawn()
		e:SetupOwner( ply )
	end
}

CraftingTable["arccw_mifl_fas2_rpk"] = {
	Name = "RPK47",
	Description = "Needs 5 wrenches and 12 iron",
	NeedsBlueprint = true,
	Category = "Rifles",
	Materials = {
		wrench = 5,
		ironbar = 12,
	},
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_mifl_fas2_rpk" )
	end
}

CraftingTable["arccw_mifl_fas2_m82"] = {
	Name = "M82 Antimaterial Rifle",
	Description = "Needs 4 wrenches, and 7 iron",
	NeedsBlueprint = true,
	Category = "Rifles",
	Materials = {
		ironbar = 7,
		wrench = 4,
	},
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_mifl_fas2_m82" )
	end
}

CraftingTable["arccw_mifl_fas2_ak47"] = {
	Name = "AK-47",
	Description = "Needs 4 wood, 2 wrenches, and 6 iron",
	NeedsBlueprint = true,
	Category = "Rifles",
	Materials = {
		swm_log = 4,
		ironbar = 6,
		wrench = 2,
	},
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_mifl_fas2_ak47" )
	end
}

CraftingTable["arccw_mifl_fas2_m4a1"] = {
	Name = "M4A1",
	Description = "Needs 6 iron and 2 wrenches",
	NeedsBlueprint = true,
	Category = "Rifles",
	Materials = {
		wrench = 2,
		ironbar = 6,
	},
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_mifl_fas2_m4a1" )
	end
}

CraftingTable["arccw_mifl_fas2_m3"] = {
	Name = "M3 Super 90",
	Description = "Needs 3 wrenches and 8 iron",
	NeedsBlueprint = true,
	Category = "Shotguns",
	Materials = {
		wrench = 3,
		ironbar = 8,
	},
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_mifl_fas2_m3" )
	end
}

CraftingTable["wrench"] = {
	Name = "Wrench",
	Description = "Needs 2 iron",
	Category = "Crafting Ingredients",
	Materials = {
		ironbar = 2,
	},
	SpawnFunction = function( ply, self )
		local e = ents.Create( "wrench" )
		e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
		e:Spawn()
	end
}

CraftingTable["arccw_mifl_fas2_toz34"] = {
	Name = "TOZ-34",
	Description = "Needs 8 iron and 2 wrenches",
	NeedsBlueprint = true,
	Category = "Shotguns",
	Materials = {
		ironbar = 8,
		wrench = 2,
	},
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_mifl_fas2_toz34" )
	end
}

CraftingTable["arccw_mifl_fas2_g3"] = {
	Name = "G3A3",
	Description = "Needs 6 iron and 1 wrench",
	NeedsBlueprint = true,
	Category = "Rifles",
	Materials = {
		ironbar = 6,
		wrench = 1,
	},
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_mifl_fas2_g3" )
	end
}

CraftingTable["arccw_mifl_fas2_g36c"] = {
	Name = "G36C",
	Description = "Needs 6 iron and 1 wrench",
	NeedsBlueprint = true,
	Category = "Rifles",
	Materials = {
		ironbar = 6,
		wrench = 1,
	},
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_mifl_fas2_g36c" )
	end
}

CraftingTable["arccw_nade_frag"] = {
	Name = "Frag Grenade",
	Description = "Needs 4 iron, 1 diamond, and 1 ruby.",
	NeedsBlueprint = true,
	Category = "Explosives",
	Materials = {
		ironbar = 4,
		diamond = 1,
		ruby = 1,
	},
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_nade_frag" )
	end
}

CraftingTable["arccw_mifl_fas2_m24"] = {
	Name = "M24 Sniper",
	Description = "Needs 10 iron and 2 wrenches",
	NeedsBlueprint = true,
	Category = "Rifles",
	Materials = {
		ironbar = 10,
		wrench = 2,
	},
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_mifl_fas2_m24" )
	end
}

CraftingTable["arccw_mifl_fas2_sg55x"] = {
	Name = "SG552",
	Description = "Needs 7 iron and 2 wrenches",
	NeedsBlueprint = true,
	Category = "Rifles",
	Materials = {
		ironbar = 7,
		wrench = 2,
	},
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_mifl_fas2_sg55x" )
	end
}

CraftingTable["sent_turtle"] = {
	Name = "Toy Turtle",
	Description = "Needs 2 wood",
	Category = "Other",
	Materials = {
		swm_log = 2,
	},
	SpawnFunction = function( ply, self )
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
	SpawnFunction = function( ply, self )
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
	SpawnFunction = function( ply, self )
		ply:Give( "factory_lockpick" )
	end
}

CraftingTable["usm_c4"] = {
	Name = "Timed C4",
	Description = "Needs 8 iron, 1 gold, and 1 diamond.",
	NeedsBlueprint = true,
	Category = "Explosives",
	Materials = {
		ironbar = 8,
		goldbar = 1,
		diamond = 1,
	},
	SpawnFunction = function( ply, self )
		ply:Give( "usm_c4" )
	end
}

CraftingTable["arccw_mifl_fas2_ragingbull"] = {
	Name = "Raging Bull",
	Description = "Needs 5 iron and 1 wrench",
	NeedsBlueprint = true,
	Category = "Pistols",
	Materials = {
		ironbar = 5,
		wrench = 1,
	},
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_mifl_fas2_ragingbull" )
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
	SpawnFunction = function( ply, self )
		local e = ents.Create( "item_box_buckshot" )
		e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
		e:Spawn()
	end
}

CraftingTable["arccw_fml_fas2_custom_mass26"] = {
	Name = "MASS-26",
	Description = "Needs 3 wrenches and 6 iron",
	NeedsBlueprint = true,
	Category = "Shotguns",
	Materials = {
		wrench = 3,
		ironbar = 6,
	},
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_fml_fas2_custom_mass26" )
	end
}

CraftingTable["arccw_mifl_fas2_ks23"] = {
	Name = "KS-23",
	Description = "Needs 4 wrenches and 8 iron",
	NeedsBlueprint = true,
	Category = "Shotguns",
	Materials = {
		wrench = 4,
		ironbar = 8,
	},
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_mifl_fas2_ks23" )
	end
}

CraftingTable["arccw_mifl_fas2_minimi"] = {
	Name = "M429",
	Description = "Needs 2 wrenches and 10 iron",
	NeedsBlueprint = true,
	Category = "Rifles",
	Materials = {
		wrench = 2,
		ironbar = 10,
	},
	SpawnFunction = function( ply, self )
		ply:Give( "arccw_mifl_fas2_minimi" )
	end
}

CraftingTable["weapon_slam"] = {
	Name = "SLAM Remote Explosive",
	Description = "Needs 10 iron, 1 gold, and 1 diamond.",
	NeedsBlueprint = true,
	Category = "Explosives",
	Materials = {
		ironbar = 10,
		goldbar = 1,
		diamond = 1,
	},
	SpawnFunction = function( ply, self )
		ply:Give( "weapon_slam" )
	end
}

CraftingTable["weapon_car_bomb"] = {
	Name = "Car Bomb",
	Description = "Needs 6 iron, 1 gold, and 1 diamond.",
	NeedsBlueprint = true,
	Category = "Explosives",
	Materials = {
		ironbar = 6,
		goldbar = 1,
		diamond = 1,
	},
	SpawnFunction = function( ply, self )
		ply:Give( "weapon_car_bomb" )
	end
}

CraftingTable["arccw_mifl_fas2_m79"] = {
	Name = "M79 Grenade Launcher",
	Description = "Needs 25 iron, 3 diamonds, 2 rubys, and 10 wood",
	NeedsBlueprint = true,
	Category = "Explosives",
	Materials = {
		ironbar = 25,
		diamond = 3,
		ruby = 2,
		swm_log = 10,
	},
	SpawnFunction = function( ply, self )
		local e = ents.Create( "arccw_mifl_fas2_m79" )
		e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
		e:Spawn()
	end
}
