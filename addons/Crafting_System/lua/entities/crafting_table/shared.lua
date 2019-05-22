
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Crafting Table"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.Category = "Crafting Table"

CraftingTable = {}

--Template Item
--[[
	CraftingTable["weapon_crowbar"] = { --Add the entity name of the item in the brackets with quotes
	Name = "Crowbar", --Name of the item, different from the item's entity name
	Description = "Requires 1 ball.", --Description of the item
	NeedsBlueprint = true,
	Materials = { --Entities that are required to craft this item, make sure you leave the entity names WITHOUT quotes!
		sent_ball = 2,
		edit_fog = 1
	},
	SpawnFunction = --Function to spawn the item, don't modify anything outside of the entity name unless you know what you're doing
		function( ply, self ) --In this function you are able to modify the player who is crafting, the table itself, and the item that is being crafted
			local e = ents.Create( "weapon_crowbar" ) --Replace the entity name with the one at the very top inside the brackets
			e:SetPos( self:GetPos() - Vector( 0, 0, -5 ) ) --A negative Z coordinate is added here to prevent items from spawning on top of the table and being consumed, you'll have to change it if you use a different model otherwise keep it as it is
			e:Spawn()
		end
	}
]]

--On top of configuring your item here, don't forget to add the entity name to the list of allowed ents in craft_config.lua! Failure to do so will result in errors!

CraftingTable["cw_ak74"] = {
	Name = "AK-74 (Rifle)",
	Description = "Needs 4 wood, 2 wrenches, and 6 iron",
	NeedsBlueprint = true,
	Materials = {
		swm_log = 4,
		ironbar = 6,
		wrench = 2,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "cw_ak74" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["cw_ar15"] = {
	Name = "AR-15 (Rifle)",
	Description = "Needs 6 iron and 2 wrenches",
	NeedsBlueprint = true,
	Materials = {
		wrench = 2,
		ironbar = 6,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "cw_ar15" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["cw_m3super90"] = {
	Name = "M3 Super 90 (Shotgun)",
	Description = "Needs 3 wrenches and 8 iron",
	NeedsBlueprint = true,
	Materials = {
		wrench = 3,
		ironbar = 8,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "cw_m3super90" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["wrench"] = {
	Name = "Wrench (Ingredient)",
	Description = "Needs 2 iron",
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
	Name = "SCAR-H (Rifle)",
	Description = "Needs 8 iron and 2 wrenches",
	NeedsBlueprint = true,
	Materials = {
		ironbar = 8,
		wrench = 2,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "cw_scarh" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["cw_g3a3"] = {
	Name = "G3A3 (Rifle)",
	Description = "Needs 6 iron and 1 wrench",
	NeedsBlueprint = true,
	Materials = {
		ironbar = 6,
		wrench = 1,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "cw_g3a3" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["cw_g36c"] = {
	Name = "G36C (Rifle)",
	Description = "Needs 6 iron and 1 wrench",
	NeedsBlueprint = true,
	Materials = {
		ironbar = 6,
		wrench = 1,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "cw_g36c" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["cw_frag_grenade"] = {
	Name = "Frag Grenade",
	Description = "Needs 4 iron, and 4 wrenches",
	NeedsBlueprint = true,
	Materials = {
		ironbar = 4,
		wrench = 4,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "cw_frag_grenade" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["cw_l115"] = {
	Name = "L115 (Sniper Rifle)",
	Description = "Needs 10 iron and 2 wrenches",
	NeedsBlueprint = true,
	Materials = {
		ironbar = 10,
		wrench = 2,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "cw_l115" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["cw_m14"] = {
	Name = "M14 (Rifle)",
	Description = "Needs 7 iron and 2 wrenches",
	NeedsBlueprint = true,
	Materials = {
		ironbar = 7,
		wrench = 2,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "cw_m14" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["cw_vss"] = {
	Name = "VSS (Rifle)",
	Description = "Needs 6 iron and 1 wrench",
	NeedsBlueprint = true,
	Materials = {
		ironbar = 6,
		wrench = 1,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "cw_vss" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["sent_turtle"] = {
	Name = "Toy Turtle",
	Description = "Needs 2 wood",
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
	Materials = {
		ironbar = 3,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "lockpick" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["factory_lockpick"] = {
	Name = "Premium Lockpick",
	Description = "Needs 20 iron",
	NeedsBlueprint = true,
	Materials = {
		ironbar = 20,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "factory_lockpick" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["usm_c4"] = {
	Name = "Timed C4 (Explosive)",
	Description = "Needs 8 iron and 4 wrenches",
	NeedsBlueprint = true,
	Materials = {
		ironbar = 8,
		wrench = 4,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "usm_c4" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["cw_extrema_ratio_official"] = {
	Name = "Knife",
	Description = "Needs 1 wood and 2 iron",
	Materials = {
		ironbar = 3,
		swm_log = 1,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "cw_extrema_ratio_official" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["cw_mr96"] = {
	Name = "MR-96 (Revolver)",
	Description = "Needs 5 iron and 1 wrench",
	NeedsBlueprint = true,
	Materials = {
		ironbar = 5,
		wrench = 1,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "cw_mr96" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["item_box_buckshot"] = {
	Name = "Shotgun Ammo",
	Description = "Needs 1 wrench and 4 iron",
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
	Name = "Serbu Super-Shorty (Shotgun)",
	Description = "Needs 3 wrenches and 6 iron",
	NeedsBlueprint = true,
	Materials = {
		wrench = 3,
		ironbar = 6,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "cw_shorty" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["cw_attpack_suppressors"] = {
	Name = "Suppressor Attachment Pack",
	Description = "Needs 8 iron",
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
	Name = "M429 (LMG)",
	Description = "Needs 2 wrenches and 10 iron",
	NeedsBlueprint = true,
	Materials = {
		wrench = 2,
		ironbar = 10,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "cw_m249_official" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["cw_attpack_ammotypes_rifles"] = {
	Name = "Extra Rifle Ammo Types",
	Description = "Needs 5 iron",
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
	Materials = {
		ironbar = 10,
		wrench = 4,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "weapon_slam" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["cw_attpack_sights_longrange"] = {
	Name = "Long Range Scopes Attachment Pack",
	Description = "Needs 5 iron and 1 wrench",
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

CraftingTable["car_bomb"] = {
	Name = "Car Bomb",
	Description = "Needs 6 iron and 4 wrenches",
	NeedsBlueprint = true,
	Materials = {
		ironbar = 6,
		wrench = 4,
	},
	SpawnFunction =
		function( ply, self )
			local e = ents.Create( "car_bomb" )
			e:SetPos( self:GetPos() + Vector( 0, 0, -5 ) )
			e:Spawn()
		end
}

CraftingTable["ins2_atow_rpg7"] = {
	Name = "RPG-7 (Explosive)",
	Description = "Needs 25 iron, 10 wrenches, and 10 wood",
	NeedsBlueprint = true,
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