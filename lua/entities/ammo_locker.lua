AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Ammo Locker"
ENT.Author = "Lambda Gaming"
ENT.Category = "Superadmin Only"
ENT.Spawnable = true

if SERVER then
	function ENT:Initialize()
		self:SetModel( "models/props_c17/Lockers001a.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion( false )
			phys:Wake()
		end
		self.Used = false
		self.BreakOpenHealthMax = 10
		self.BreakOpenHealth = 10
		self.BreakOpenBroken = false
	end

	local AmmoTypes = {
		["Buckshot"] = { "item_box_buckshot", 40 },
		["Pistol"] = {"item_ammo_pistol_large", 20 },
		["SMG1"] = { "item_ammo_smg1", 30 }
	}

	function ENT:BreakOpen( ply ) --Integrate with the Enterprise ATM for robbing feature
		local m = ents.Create( "item_box_buckshot" )
		m:SetPos( self:GetPos() + ( self:GetForward() * 35 ) + ( self:GetUp() * 30 ) )
		m:Spawn()
	end

	function ENT:Use( ply )
		if self.Used then return end
		local getwep = ply:GetActiveWeapon()
		local primaryammo = getwep:GetPrimaryAmmoType()
		local primaryname = game.GetAmmoName( primaryammo )
		if !AmmoTypes[primaryname] or !AmmoTypes[primaryname][1] then
			DarkRP.notify( ply, 1, 6, "Ammo is not available for this weapon." )
			return
		end
		local name = AmmoTypes[primaryname][1]
		local price = AmmoTypes[primaryname][2]
		if !ply:canAfford( price ) then
			DarkRP.notify( ply, 1, 6, "You can't afford ammo for this weapon." )
			return
		end
		if primaryname == "Buckshot" and !ply:isCP() then
			DarkRP.notify( ply, 1, 10, "Only police can purchase shotgun ammo from this locker. You may be able to get it through more forceful means though..." )
			return
		end
		self.Used = true
		ply:EmitSound( "doors/metal_stop1.wav", 50, 100 )
		timer.Simple( 1.5, function()
			if !IsValid( self ) then return end
			local pos, ang = LocalToWorld( Vector( 20, -5, -30 ), Angle( -90, -90, 0 ), self:GetPos(), self:GetAngles() )
			local salestax = price * ( GetGlobalInt( "MAYOR_SalesTax" ) * 0.01 )
			local ammo = ents.Create( name )
			ammo:SetPos( pos )
			ammo:SetAngles( ang )
			ammo:Spawn()
			if ply:isCP() then
				SetGlobalInt( "MAYOR_Money", GetGlobalInt( "MAYOR_Money" ) - salestax )
			else
				local finalprice = price + salestax
				SetGlobalInt( "MAYOR_Money", GetGlobalInt( "MAYOR_Money" ) + salestax )
				ply:addMoney( -finalprice )
			end
			self.Used = false
		end )
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
		local plyShootPos = LocalPlayer():GetShootPos()
		if self:GetPos():DistToSqr( plyShootPos ) < 562500 then
			local pos = self:GetPos()
			pos.z = pos.z + 15
			local ang = self:GetAngles()
			
			surface.SetFont("Bebas40Font")
			local title = "Ammo"
			local tw = surface.GetTextSize(title)
			
			ang:RotateAroundAxis(ang:Forward(), 90)
			ang:RotateAroundAxis(ang:Right(), -90)
			
			cam.Start3D2D(pos + ang:Right(), ang, 0.2)
				draw.WordBox(2, -tw *0.5 + 5, -180, title, "Bebas40Font", color_theme, color_white)
			cam.End3D2D()
		end
	end
end
