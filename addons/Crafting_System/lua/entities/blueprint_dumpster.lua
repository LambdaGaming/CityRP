
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

BLUEPRINT_CONFIG_TIER2 = { --Blueprints you can get from smuggling weapons, pd bank, and random events
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

BLUEPRINT_CONFIG_TIER3 = { --Blueprints you can get from gov bank and deposit boxes
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
    self:SetModel( "models/props_junk/dumpster.mdl" )
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
	end
	self:SetMaterial( "phoenix_storms/metalset_1-2" )
 
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
	e:SetAngles( self:GetAngles() + Angle( 0, 180, 0 ) )
	e:Spawn()
	e:SetEntName( randwep[1] )
	e:SetRealName( randwep[2] )
	timer.Create( "BlueprintCooldown", BLUEPRINT_CONFIG_COOLDOWN_TIME, 1, function() end )
end

function ENT:OnRemove()
	if timer.Exists( "BlueprintCooldown" ) then timer.Remove( "BlueprintCooldown" ) end
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
		local plyShootPos = LocalPlayer():GetShootPos()
		if self:GetPos():DistToSqr( plyShootPos ) < 562500 then
			local pos = self:GetPos() + Vector( 25, 0, -38 )
			pos.z = (pos.z + 15)
			local ang = self:GetAngles()
			
			surface.SetFont("Bebas40Font")
			local title = "Blueprint Dumpster"
			local title2 = "$5000 For Each"
			local tw = surface.GetTextSize(title)
			
			ang:RotateAroundAxis(ang:Forward(), 90)
			ang:RotateAroundAxis(ang:Right(), -90)
			
			cam.Start3D2D(pos + ang:Right() * -20, ang, 0.2)
				draw.WordBox(2, -tw *0.5 + 5, -180, title, "Bebas40Font", VOTING.Theme.ControlColor, color_white)
				draw.WordBox(2, -tw *0.5 + 30, -140, title2, "Bebas40Font", VOTING.Theme.ControlColor, color_white)
			cam.End3D2D()
		end
    end
end