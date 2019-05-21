
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Blueprint Dumpster"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Superadmin Only"

local BLUEPRINT_CONFIG_COOLDOWN_TIME = 300
local BLUEPRINT_CONFIG_PRICE = 5000

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
	if caller:getDarkRPVar( "money" ) < BLUEPRINT_CONFIG_PRICE then
		DarkRP.notify( caller, 1, 6, "You don't have enough money to use the dumpster!" )
		return
	end
	self:EmitSound( "physics/metal/metal_large_debris"..math.random( 1, 2 )..".wav" )
	local randwep = table.Random( BLUEPRINT_CONFIG_TIER1 )
	local e = ents.Create( "crafting_blueprint" )
	e:SetPos( self:GetPos() + Vector( 0, 30, 0 ) )
	e:SetAngles( self:GetAngles() + Angle( 0, 180, 0 ) )
	e:Spawn()
	e:SetEntName( randwep[1] )
	e:SetRealName( randwep[2] )
	caller:addMoney( -5000 )
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
			surface.SetFont("Bebas40Font")
			local title = "Blueprint Dumpster"
			local title2 = "$5000 For Each"
			
			local ang = self:GetAngles()
			ang:RotateAroundAxis( self:GetAngles():Right(),270 )
			ang:RotateAroundAxis( self:GetAngles():Forward(),90 )
			local pos = self:GetPos() + ang:Right() * -20 + ang:Up() * 26 + ang:Forward() * -25
			cam.Start3D2D(pos,ang,0.1)
				draw.RoundedBox( 0, 50, -120, 400, 150, VOTING.Theme.ControlColor )
				//draw.RoundedBox( 0, 20, 20, 450 -40, 200-40, VOTING.Theme.ControlColor )
				draw.SimpleText( title, "Bebas40Font", 260, -80, color_white, 1, 1 )
				draw.SimpleText( title2, "Bebas40Font", 260, -20, color_white, 1, 1 )
			cam.End3D2D()
		end
    end
end