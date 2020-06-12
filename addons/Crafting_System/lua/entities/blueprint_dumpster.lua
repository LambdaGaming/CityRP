
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Blueprint Dumpster"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Crafting Table"

local BLUEPRINT_CONFIG_COOLDOWN_TIME = 180
local BLUEPRINT_CONFIG_PRICE = 1500

BLUEPRINT_CONFIG_TIER1 = { --Blueprints you can get from the dumpster
	{ "cw_ar15", "AR-15" },
	{ "cw_g3a3", "G3A3" },
	{ "cw_g36c", "G36C" },
	{ "cw_m14", "M14" },
	{ "cw_vss", "VSS" },
	{ "factory_lockpick", "Premium Lockpick" },
	{ "cw_mr96", "MR-96" },
	{ "cw_shorty", "Serbu Super-Shorty" },
	{ "dronesrewrite_nanodr", "Nano Drone" }
}

BLUEPRINT_CONFIG_TIER2 = { --Blueprints you can get from smuggling weapons and random events
	{ "cw_ak74", "AK-74" },
	{ "cw_m3super90", "M3 Super 90" },
	{ "cw_scarh", "SCAR-H" },
	{ "cw_frag_grenade", "Frag Grenade" },
	{ "cw_l115", "L115" },
	{ "cw_m14", "M14" },
	{ "cw_ar15", "AR-15" },
	{ "cw_shorty", "Serbu Super-Shorty" },
	{ "cw_attpack_various", "40mm Grenade Launcher Attachment" },
	{ "nik_m1garandnew", "M1 Garand" },
	{ "dronesrewrite_nanodr", "Nano Drone" }
}

BLUEPRINT_CONFIG_TIER3 = { --Blueprints you can get from gov bank, PD bank, and deposit boxes
	{ "cw_frag_grenade", "Frag Grenade" },
	{ "usm_c4", "Timed C4" },
	{ "weapon_slam", "SLAM Remote Explosive" },
	{ "cw_m249_official", "M249" },
	{ "cw_attpack_various", "40mm Grenade Launcher Attachment" },
	{ "car_bomb", "Car Bomb" },
	{ "ins2_atow_rpg7", "RPG-7" },
	{ "cw_kks_doi_mg42", "MG 42" }
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
	e:SetUses( 3 )
	caller:addMoney( -BLUEPRINT_CONFIG_PRICE )
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
			local title2 = "$"..BLUEPRINT_CONFIG_PRICE.." For Each"
			
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