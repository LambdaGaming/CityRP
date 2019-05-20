
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Blueprint Dumpster"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Superadmin Only"

local BLUEPRINT_CONFIG_COOLDOWN_TIME = 300

BLUEPRINT_CONFIG_TIER1 = { --Blueprints you can get from the dumpster
	{ "cw_ar15", "AR-15 (Rifle)" },
	{ "cw_g3a3", "G3A3 (Rifle)" },
	{ "cw_g36c", "G36C (Rifle)" },
	{ "cw_m14", "M14 (Rifle)" },
	{ "cw_vss", "VSS (Rifle)" },
	{ "factory_lockpick", "Premium Lockpick" },
	{ "cw_mr96", "MR-96 (Revolver)" },
	{ "cw_shorty", "Serbu Super-Shorty (Shotgun)" }
}

BLUEPRINT_CONFIG_TIER2 = { --Blueprints you can get from things like the smuggle system
	{ "cw_ak74", "AK-74 (Rifle)" },
	{ "cw_m3super90", "M3 Super 90 (Shotgun)" },
	{ "cw_scarh", "SCAR-H (Rifle)" },
	{ "cw_frag_grenade", "Frag Grenade" },
	{ "cw_l115", "L115 (Sniper Rifle)" },
	{ "cw_m14", "M14 (Rifle)" },
	{ "cw_ar15", "AR-15 (Rifle)" },
	{ "cw_shorty", "Serbu Super-Shorty (Shotgun)" },
	{ "cw_attpack_various", "40mm Grenade Launcher Rifle Attachment" }
}

BLUEPRINT_CONFIG_TIER3 = { --Blueprints you can get from things like robbing the gov bank and deposit boxes
	{ "cw_frag_grenade", "Frag Grenade" },
	{ "usm_c4", "Timed C4 (Explosive)" },
	{ "weapon_slam", "SLAM Remote Explosive" },
	{ "cw_m249_official", "M249 (LMG)" },
	{ "cw_attpack_various", "40mm Grenade Launcher Rifle Attachment" },
	{ "car_bomb", "Car Bomb" },
	{ "ins2_atow_rpg7", "RPG-7 (Explosive)" }
}

function ENT:SpawnFunction( ply, tr )
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 1
	local ent = ents.Create( "blueprint_dumpster" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
    self:SetModel( "models/error.mdl" )
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
	end
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use( caller, activator )
	if timer.Exists( "BlueprintCooldown" ) then
		DarkRP.notify( caller, 1, 6, "Please wait "..string.ToMinutesSeconds( timer.TimeLeft( "BlueprintCooldown" ) ).." for the cooldown to end." )
		return
	end
	self:EmitSound( "physics/metal/metal_large_debris1.wav" )
	local randwep = table.Random( BLUEPRINT_CONFIG_TIER1 )
	local e = ents.Create( "crafting_blueprint" )
	e:SetPos( self:GetPos() + Vector( 0, 30, 0 ) )
	e:Spawn()
	e:SetEntName( randwep[1] )
	e:SetRealName( randwep[2] )
	timer.Create( "BlueprintCooldown", BLUEPRINT_CONFIG_COOLDOWN_TIME, 1, function() end )
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end
end
