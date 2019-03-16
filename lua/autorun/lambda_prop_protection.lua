
AddCSLuaFile()

local physblacklist = { --Entities that can't be physgunned by anyone but superadmins
	"contraband_npc_shop",
	"rp_vendingmachine",
	"mgs_rock",
	"mgs_iron_rock",
	"swm_wood",
	"swm_wood_red",
	"dumpser",
	"mgs_factory",
	"swm_sawmill",
	"swm_sawmill_part1",
	"swm_sawmill_part2",
	"swm_sawmill_part3",
	"banker_npc",
	"mgs_factory_part1",
	"mgs_factory_part2",
	"mgs_factory_part3",
	"ent_speedtrapsensor",
	"base_ai",
	"ent1",
	"rp_pistol_ammo_vendor",
	"rp_rifle_ammo_vendor",
	"rp_dealer",
	"tfby_pdr_van",
	"itemstore_bank",
	"enterprise_atm",
	"bank_vault",
	"simple_drugs_buyer",
	"vault_money"
}

local defaultblock = { --Blocked for all players including superadmins
	"prop_door",
	"prop_door_rotating",
	"func_detail",
	"prop_dynamic_ornament",
	"prop_dymanic_override",
	"prop_dynamic",
	"prop_static",
	"func_door",
	"func_door_rotating",
	"func_ladder",
	"func_monitor",
	"func_wall",
	"func_brush",
	"door",
	"func_reflective_glass",
	"func_button",
	"smuggle_item",
	"func_tracktrain",
	"func_movelinear"
}

local function PlayerPickup( ply, ent )
	if ent:IsWorld() then return false end
	if table.HasValue( physblacklist, ent:GetClass() ) and !ply:IsSuperAdmin() then --Prevents players who arent superadmin from physgunning blacklisted entities
		return false
	end
	if table.HasValue( defaultblock, ent:GetClass() ) or ( ent:GetClass() == "prop_physics" and ( ent.IsEventTruck or ent.IsEventTrailer ) ) then --Prevents all players from physgunning blacklisted entities
		return false
	end
	if string.find( ent:GetClass():lower(), "npc_" ) and !ply:IsSuperAdmin() then --Only superadmins can pick up NPCs
		return false
	end
	if string.find( ent:GetClass():lower(), "fs_" ) then --Farming items can only be gravgunned
		return false
	end
	if !ply:IsAdmin() and ( ent:GetClass() == "prop_vehicle_jeep" and ent:GetModel() != "models/tdmcars/trailers/*.mdl" ) then --Only admins can pick up vehicles
		return false
	end
end
hook.Add( "PhysgunPickup", "disallow_pickup", PlayerPickup)