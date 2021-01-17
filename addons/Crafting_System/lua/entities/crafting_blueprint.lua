
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Crafting Blueprint"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = false
ENT.AdminOnly = true

BLUEPRINT_CONFIG_TIER1 = { --Blueprints you can get from the dumpster
	{ "cw_g3a3", "G3A3" },
	{ "cw_g36c", "G36C" },
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
	{ "cw_attpack_various", "40mm Grenade Launcher Attachment" },
	{ "nik_m1garandnew", "M1 Garand" },
	{ "car_bomb", "Car Bomb" }
}

BLUEPRINT_CONFIG_TIER3 = { --Blueprints you can get from gov bank, PD bank, and deposit boxes
	{ "cw_frag_grenade", "Frag Grenade" },
	{ "usm_c4", "Timed C4" },
	{ "weapon_slam", "SLAM Remote Explosive" },
	{ "cw_m249_official", "M249" },
	{ "cw_attpack_various", "40mm Grenade Launcher Attachment" },
	{ "ins2_atow_rpg7", "RPG-7" },
	{ "cw_kks_doi_mg42", "MG 42" }
}

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
