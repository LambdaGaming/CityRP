
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
	["arccw_mifl_fas2_ak47"] = true,
	["arccw_mifl_fas2_m4a1"] = true,
	["arccw_mifl_fas2_m3"] = true,
	["arccw_mifl_fas2_toz34"] = true,
	["arccw_mifl_fas2_g3"] = true,
	["arccw_mifl_fas2_g36c"] = true,
	["arccw_mifl_fas2_m24"] = true,
	["arccw_mifl_fas2_sg55x"] = true,
	["arccw_mifl_fas2_870"] = true,
	["lockpick"] = true,
	["factory_lockpick"] = true,
	["usm_c4"] = true,
	["arccw_mifl_fas2_ragingbull"] = true,
	["arccw_fml_fas2_custom_mass26"] = true,
	["arccw_mifl_fas2_minimi"] = true,
	["weapon_slam"] = true,
	["car_bomb"] = true,
	["arccw_mifl_fas2_m79"] = true,
	["arccw_mifl_fas2_m82"] = true,
	["arccw_mifl_fas2_rpk"] = true,
	["arccw_mifl_fas2_ks23"] = true
}

local wepvalues = {
	["arccw_mifl_fas2_ak47"] = 7,
	["arccw_mifl_fas2_m4a1"] = 7,
	["arccw_mifl_fas2_m3"] = 10,
	["arccw_mifl_fas2_toz34"] = 8,
	["arccw_mifl_fas2_g3"] = 6,
	["arccw_mifl_fas2_g36c"] = 6,
	["arccw_mifl_fas2_m24"] = 10,
	["arccw_mifl_fas2_sg55x"] = 8,
	["arccw_mifl_fas2_870"] = 6,
	["lockpick"] = 1,
	["factory_lockpick"] = 14,
	["usm_c4"] = 11,
	["arccw_mifl_fas2_ragingbull"] = 5,
	["arccw_fml_fas2_custom_mass26"] = 8,
	["arccw_mifl_fas2_minimi"] = 16,
	["weapon_slam"] = 13,
	["car_bomb"] = 10,
	["arccw_mifl_fas2_m79"] = 42,
	["arccw_mifl_fas2_m82"] = 11,
	["arccw_mifl_fas2_rpk"] = 17,
	["arccw_mifl_fas2_ks23"] = 8
}

local allowedents = {
	["spawned_weapon"] = true,
	["wrench"] = true,
	["dronesrewrite_nanodr"] = true,
	["dronesrewrite_spyspider"] = true
}

local entvalues = {
	["wrench"] = 1,
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