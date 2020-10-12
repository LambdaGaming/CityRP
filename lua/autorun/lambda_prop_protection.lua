
AddCSLuaFile()

local physblacklist = { --Entities that can't be physgunned by anyone but superadmins
	["rp_vendingmachine"] = true,
	["mgs_rock"] = true,
	["mgs_iron_rock"] = true,
	["swm_wood"] = true,
	["swm_wood_red"] = true,
	["dumpser"] = true,
	["mgs_factory"] = true,
	["swm_sawmill"] = true,
	["swm_sawmill_part1"] = true,
	["swm_sawmill_part2"] = true,
	["swm_sawmill_part3"] = true,
	["banker_npc"] = true,
	["mgs_factory_part1"] = true,
	["mgs_factory_part2"] = true,
	["mgs_factory_part3"] = true,
	["ent_speedtrapsensor"] = true,
	["base_ai"] = true,
	["npc_courier"] = true,
	["rp_pistol_ammo_vendor"] = true,
	["rp_rifle_ammo_vendor"] = true,
	["rp_dealer"] = true,
	["tfby_pdr_van"] = true,
	["itemstore_bank"] = true,
	["enterprise_atm"] = true,
	["bank_vault"] = true,
	["vault_money"] = true
}

local defaultblock = { --Blocked for all players including superadmins
	["prop_door"] = true,
	["prop_door_rotating"] = true,
	["func_detail"] = true,
	["prop_dynamic_ornament"] = true,
	["prop_dymanic_override"] = true,
	["prop_dynamic"] = true,
	["prop_static"] = true,
	["func_door"] = true,
	["func_door_rotating"] = true,
	["func_ladder"] = true,
	["func_monitor"] = true,
	["func_wall"] = true,
	["func_brush"] = true,
	["door"] = true,
	["func_reflective_glass"] = true,
	["func_button"] = true,
	["smuggle_item"] = true,
	["func_tracktrain"] = true,
	["func_movelinear"] = true,
	["gas_pump"] = true
}

local gravblacklist = {
	["deposit_box"] = true
}

local function PlayerPickup( ply, ent )
	if ent:IsWorld() or !IsValid( ent ) then return false end
	if ent.IsPermaProp and !ply:IsSuperAdmin() then return false end --Only superadmins can pick up perma props
	if physblacklist[ent:GetClass()] and !ply:IsSuperAdmin() then --Prevents players who arent superadmin from physgunning blacklisted entities
		return false
	end
	if defaultblock[ent:GetClass()] or ( ent:GetClass() == "prop_physics" and ( ent.IsEventTruck or ent.IsEventTrailer ) ) then --Prevents all players from physgunning blacklisted entities
		return false
	end
	if string.find( ent:GetClass():lower(), "npc_" ) and !ply:IsSuperAdmin() then --Only superadmins can pick up NPCs
		return false
	end
	if string.find( ent:GetClass():lower(), "fs_" ) then --Farming items can only be gravgunned
		return false
	end
	if !ply:IsSuperAdmin() and ( ent:GetClass() == "prop_vehicle_jeep" and !string.find( ent:GetModel(), "models/tdmcars/trailers/*.mdl" ) ) then --Only superadmins can pick up vehicles
		return false
	end
end
hook.Add( "PhysgunPickup", "disallow_pickup", PlayerPickup)

local function ToolRestrict( ply, tr, tool )
	if IsValid( tr.Entity ) and SERVER then
		if defaultblock[tr.Entity:GetClass()] or tr.Entity:CreatedByMap() then
			return false
		end
	end
end
hook.Add( "CanTool", "disallow_maptools", ToolRestrict )

local function GravRestrict( ply, ent )
	if IsValid( ent ) then
		if gravblacklist[ent:GetClass()] then
			return false
		end
	end
end
hook.Add( "GravGunPickupAllowed", "disallow_gravgun", GravRestrict )

MsgC( color_orange, "[CityRP] Loaded prop protection." )