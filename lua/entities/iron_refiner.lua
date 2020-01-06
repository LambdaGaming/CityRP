
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Iron Refiner"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Mining System"

function ENT:SpawnFunction( ply, tr, name )
	if not tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 1
	local ent = ents.Create( name )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
    self:SetModel( "models/props_wasteland/laundry_washer001a.mdl" )
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetTrigger( true )
	end
 
    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	
	self.refining = false
	self:SetNWString( "CurRefining", "Nothing" )
end

local allowedweps = {
	["cw_ak74"] = true,
	["cw_ar15"] = true,
	["cw_m3super90"] = true,
	["cw_scarh"] = true,
	["cw_g3a3"] = true,
	["cw_g36c"] = true,
	["cw_l115"] = true,
	["cw_m14"] = true,
	["cw_vss"] = true,
	["lockpick"] = true,
	["factory_lockpick"] = true,
	["usm_c4"] = true,
	["cw_extrema_ratio_official"] = true,
	["cw_mr96"] = true,
	["cw_shorty"] = true,
	["cw_m249_official"] = true,
	["weapon_slam"] = true,
	["car_bomb"] = true,
	["ins2_atow_rpg7"] = true,
	["nik_m1garandnew"] = true,
	["cw_kks_doi_mg42"] = true
}

local wepvalues = {
	["cw_ak74"] = 7,
	["cw_ar15"] = 7,
	["cw_m3super90"] = 10,
	["cw_scarh"] = 8,
	["cw_g3a3"] = 6,
	["cw_g36c"] = 6,
	["cw_l115"] = 10,
	["cw_m14"] = 8,
	["cw_vss"] = 6,
	["lockpick"] = 1,
	["factory_lockpick"] = 14,
	["usm_c4"] = 11,
	["cw_extrema_ratio_official"] = 2,
	["cw_mr96"] = 5,
	["cw_shorty"] = 8,
	["cw_m249_official"] = 16,
	["weapon_slam"] = 13,
	["car_bomb"] = 10,
	["ins2_atow_rpg7"] = 42,
	["nik_m1garandnew"] = 11,
	["cw_kks_doi_mg42"] = 17
}

local allowedents = {
	["spawned_weapon"] = true,
	["wrench"] = true,
	["cw_attpack_suppressors"] = true,
	["cw_attpack_ammotypes_rifles"] = true,
	["cw_attpack_ammotypes_shotguns"] = true,
	["cw_attpack_sights_longrange"] = true,
	["cw_attpack_various"] = true,
	["dronesrewrite_nanodr"] = true,
	["dronesrewrite_spyspider"] = true
}

local entvalues = {
	["wrench"] = 1,
	["cw_attpack_suppressors"] = 6,
	["cw_attpack_ammotypes_rifles"] = 4,
	["cw_attpack_ammotypes_shotguns"] = 7,
	["cw_attpack_sights_longrange"] = 5,
	["cw_attpack_various"] = 7,
	["dronesrewrite_nanodr"] = 11,
	["dronesrewrite_spyspider"] = 11
}

function ENT:Touch( ent )
	if self.refining then return end
	if allowedents[ent:GetClass()] then
		if ent:GetClass() == "spawned_weapon" and allowedweps[ent:GetWeaponClass()] then
			for k,v in pairs( wepvalues ) do
				if k == tostring( ent:GetWeaponClass() ) then
					self:SetNWString( "CurRefining", k )
					timer.Simple( 30 * v, function()
						for i=1, v do
							local e = ents.Create( "ironbar" )
							e:SetPos( self:GetPos() + Vector( 0, 0, i*20 ) )
							e:Spawn()
						end
						self:EmitSound( "ambient/energy/weld"..math.random( 1, 2 )..".wav" )
						self:SetNWString( "CurRefining", "Nothing" )
					end )
					ent:Remove()
				end
			end
		else
			for k,v in pairs( entvalues ) do
				if k == tostring( ent:GetClass() ) then
					self:SetNWString( "CurRefining", k )
					timer.Simple( 30 * v, function()
						for i=1, v do
							local e = ents.Create( "ironbar" )
							e:SetPos( self:GetPos() + Vector( 0, 0, i*20 ) )
							e:Spawn()
						end
						self:EmitSound( "ambient/energy/weld"..math.random( 1, 2 )..".wav" )
						self:SetNWString( "CurRefining", "Nothing" )
					end )
					ent:Remove()
				end
			end
		end
	end
end

if CLIENT then
    function ENT:Draw()
		self:DrawModel()
		local plyShootPos = LocalPlayer():GetShootPos()
		if self:GetPos():DistToSqr( plyShootPos ) < 562500 then
			local pos = self:GetPos()
			pos.z = (pos.z + 15)
			local ang = self:GetAngles()
			
			surface.SetFont("Bebas40Font")
			local title = "Iron Refiner"
			local tw = surface.GetTextSize(title)
			
			ang:RotateAroundAxis(ang:Forward(), 90)
			ang:RotateAroundAxis(ang:Right(), -90)
			local textang = ang
			
			cam.Start3D2D(pos + ang:Right() * -20, ang, 0.2)
				draw.WordBox(2, -tw *0.5 + 5, -180, title, "Bebas40Font", color_theme, color_white)
			cam.End3D2D()
			cam.Start3D2D(pos + ang:Right() * -10, ang, 0.2)
				draw.WordBox(2, -tw *0.5 + -110, -180, "Currently Refining: "..self:GetNWString( "CurRefining" ), "Bebas40Font", color_theme, color_white)
			cam.End3D2D()
		end
	end
end