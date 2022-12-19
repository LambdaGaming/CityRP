AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Iron Refiner"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Crafting System"

function ENT:SpawnFunction( ply, tr, name )
	if not tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal
	local ent = ents.Create( name )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
    self:SetModel( "models/props_wasteland/laundry_washer001a.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetTrigger( true )
		self:SetUseType( SIMPLE_USE )
	end
 
    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	
	self:SetNWInt( "TotalSmelting", 0 )
end

local wepvalues = {
	["arccw_mifl_fas2_ak47"] = 7,
	["arccw_mifl_fas2_m4a1"] = 7,
	["arccw_mifl_fas2_m3"] = 10,
	["arccw_mifl_fas2_toz34"] = 8,
	["arccw_mifl_fas2_g3"] = 6,
	["arccw_mifl_fas2_g36c"] = 6,
	["arccw_mifl_fas2_m24"] = 10,
	["arccw_mifl_fas2_sg55x"] = 8,
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

local entvalues = {
	["wrench"] = 1,
	["dronesrewrite_nanodr"] = 11,
	["dronesrewrite_spyspider"] = 11,
	["rtx4090"] = 4
}

local ores = {
	["Ruby"] = {
		Time = 150,
		NewEnt = "ruby"
	},
	["Gold"] = {
		Time = 120,
		NewEnt = "goldbar"
	},
	["Diamond"] = {
		Time = 300,
		NewEnt = "diamond"
	}
}

function ENT:Use( ply )
	local found = ents.FindInSphere( self:GetPos(), 200 )
	local foundowned = false
	local total = 0
	if #found == 0 then
		DarkRP.notify( ply, 1, 6, "No iron detected. Move it closer. If you are trying to smelt something, touch it with the refiner." )
		return
	end
	for k,v in pairs( found ) do
		if v:GetOwner() == ply then
			total = total + 1
		end
	end
	if total == 0 then
		DarkRP.notify( ply, 1, 6, "Iron was found but none of it seems to be owned by you." )
		return
	elseif !ply:canAfford( total * 50 ) then
		DarkRP.notify( ply, 1, 6, "You can't afford to refine this iron! You need at least "..DarkRP.formatMoney( total * 50 ).."." )
		return
	end
	ply:addMoney( -( total * 50 ) )
	for k,v in pairs( found ) do
		if v:GetOwner() == ply then
			v:Remove()
		end
	end
	DarkRP.notify( ply, 0, 6, total.." iron detected. This will take "..( total * 60 ).." minutes." )
	timer.Simple( total * 60, function()
		if !IsValid( ply ) then return end
		for i=1,2 do
			local e = ents.Create( "ironbar" )
			e:SetPos( self:GetPos() + Vector( 0, 0, i * 20 ) )
			e:Spawn()
		end
		DarkRP.notify( ply, 0, 6, "Your refined iron is ready." )
	end )
end

function ENT:Touch( ent )
	if self:GetNWInt( "TotalSmelting" ) >= 3 then return end
	local class = ent:GetClass()

	if class == "mgs_ore" then
		local oretype = ent:GetNWString( "type" )
		if ores[oretype] then
			self:SetNWInt( "TotalSmelting", self:GetNWInt( "TotalSmelting" ) + 1 )
			timer.Simple( ores[oretype].Time, function()
				local e = ents.Create( ores[oretype].NewEnt )
				e:SetPos( self:GetPos() + Vector( 0, 0, 50 ) )
				e:Spawn()
				self:EmitSound( "ambient/fire/mtov_flame2.wav" )
				self:SetNWInt( "TotalSmelting", self:GetNWInt( "TotalSmelting" ) - 1 )
			end )
			ent:Remove()
			return
		end
	end

	local entamount = entvalues[class]
	if !entamount then return end
	local finalamount
	if class == "spawned_weapon" and wepamount then
		local wepamount = wepvalues[ent:GetWeaponClass()]
		if wepamount then
			finalamount = wepamount
		else
			finalamount = entamount
		end
	end
	self:SetNWInt( "TotalSmelting", self:GetNWInt( "TotalSmelting" ) + 1 )
	timer.Simple( 30 * finalamount, function()
		for i=1, finalamount do
			local e = ents.Create( "ironbar" )
			e:SetPos( self:GetPos() + Vector( 0, 0, i * 20 ) )
			e:Spawn()
		end
		self:EmitSound( "ambient/energy/weld"..math.random( 1, 2 )..".wav" )
		self:SetNWInt( "TotalSmelting", self:GetNWInt( "TotalSmelting" ) - 1 )
	end )
	ent:Remove()
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
			local title = "Smelter"
			local tw = surface.GetTextSize(title)
			
			ang:RotateAroundAxis(ang:Forward(), 90)
			ang:RotateAroundAxis(ang:Right(), -90)
			local textang = ang
			
			cam.Start3D2D(pos + ang:Right() * -20, ang, 0.2)
				draw.WordBox(2, -tw *0.5 + 5, -180, title, "Bebas40Font", color_theme, color_white)
			cam.End3D2D()
			cam.Start3D2D(pos + ang:Right() * -10, ang, 0.2)
				draw.WordBox(2, -tw *0.5 + -110, -180, "Currently Smelting: "..self:GetNWInt( "TotalSmelting" ).."/3", "Bebas40Font", color_theme, color_white)
			cam.End3D2D()
		end
	end
end
