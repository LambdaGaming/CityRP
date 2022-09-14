AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Crafting Blueprint"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = false
ENT.AdminOnly = true

BLUEPRINT_CONFIG_TIER1 = { --Blueprints you can get from the dumpster
	{ "arccw_mifl_fas2_g3", "G3A3" },
	{ "arccw_mifl_fas2_g36c", "G36C" },
	{ "factory_lockpick", "Premium Lockpick" },
	{ "arccw_mifl_fas2_ragingbull", "Raging Bull" },
	{ "arccw_fml_fas2_custom_mass26", "MASS-26" },
	{ "dronesrewrite_nanodr", "Nano Drone" }
}

BLUEPRINT_CONFIG_TIER2 = { --Blueprints you can get from smuggling weapons and random events
	{ "arccw_mifl_fas2_ak47", "AK-47" },
	{ "arccw_mifl_fas2_m3", "M3 Super 90" },
	{ "arccw_mifl_fas2_toz34", "TOZ-34" },
	{ "arccw_mifl_fas2_m24", "M24" },
	{ "arccw_mifl_fas2_sg55x", "SG552" },
	{ "arccw_mifl_fas2_m4a1", "M4A1" },
	{ "weapon_car_bomb", "Car Bomb" },
	{ "arccw_nade_frag", "Frag Grenade" },
}

BLUEPRINT_CONFIG_TIER3 = { --Blueprints you can get from gov bank, PD bank, and deposit boxes
	{ "arccw_mifl_fas2_ks23", "KS-23" },
	{ "usm_c4", "Timed C4" },
	{ "weapon_slam", "SLAM Remote Explosive" },
	{ "arccw_mifl_fas2_minimi", "M249" },
	{ "arccw_mifl_fas2_m79", "M79 Grenade Launcher" },
	{ "arccw_mifl_fas2_rpk", "RPK47" },
	{ "arccw_mifl_fas2_m82", "M82 Antimaterial Rifle" }
}

BLUEPRINT_COMBINED = table.Add( table.Add( BLUEPRINT_CONFIG_TIER1, BLUEPRINT_CONFIG_TIER2 ), BLUEPRINT_CONFIG_TIER3 )

function ENT:SpawnFunction( ply, tr, name )
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 1
	local ent = ents.Create( name )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "EntName" )
	self:NetworkVar( "String", 1, "RealName" )
	self:NetworkVar( "Int", 0, "Uses" )
end

function ENT:Initialize()
    self:SetModel( "models/props_lab/binderblue.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
	end
 
    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:Use( caller, activator )
	DarkRP.notify( caller, 0, 6, "Place this near a crafting table to use it." )
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
		local plyShootPos = LocalPlayer():GetShootPos()
		if self:GetPos():DistToSqr( plyShootPos ) < 100000 then
			local Ang = self:GetAngles() + Angle(-90,0,0)

			surface.SetFont("Bebas40Font")
			local title = "Crafting Blueprint"
			local title2 = self:GetRealName()
			local title3 = "Uses left: "..self:GetUses()
			local tw = surface.GetTextSize( title )

			Ang:RotateAroundAxis( Ang:Forward(), 90 )
			Ang:RotateAroundAxis( Ang:Right(), -90 )
		
			cam.Start3D2D( self:GetPos() + ( self:GetUp() * 6 ) + self:GetRight() * -2, Ang, 0.05 )
				draw.WordBox( 2, -tw *0.5 + 5, -60, title, "Bebas40Font", VOTING.Theme.ControlColor, color_white )
				draw.WordBox( 2, -tw *0.5 + 5, -20, title2, "Bebas40Font", VOTING.Theme.ControlColor, color_white )
				draw.WordBox( 2, -tw *0.5 + 5, 20, title3, "Bebas40Font", VOTING.Theme.ControlColor, color_white )
			cam.End3D2D()
		end
    end
end
