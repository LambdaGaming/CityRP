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
		["Buckshot"] = { 60, 20 }, --Price, amount
		["Pistol"] = { 25, 30 },
		["SMG1"] = { 30, 30 },
		["357"] = { 80, 15 },
		["AR2"] = { 50, 30 },
		["SniperPenetratedRound"] = { 100, 10 },
		["Taser"] = { 20, 3 }
	}

	function ENT:BreakOpen( ply ) --Integrate with the Enterprise ATM for robbing feature
		if ply:HasWeapon( "stungun" ) then
			ply:GiveAmmo( 3, "Taser" )
			return
		end
		ply:GiveAmmo( 20, "Buckshot" )
	end

	function ENT:Use( ply )
		if self.Used then return end
		local getwep = ply:GetActiveWeapon()
		local primaryammo = getwep:GetPrimaryAmmoType()
		local primaryname = game.GetAmmoName( primaryammo )
		if !AmmoTypes[primaryname] then
			DarkRP.notify( ply, 1, 6, "Ammo is not available for this weapon." )
			return
		end
		local price = AmmoTypes[primaryname][1]
		local amount = AmmoTypes[primaryname][2]
		if !ply:canAfford( price ) and !ply:isCP() then
			DarkRP.notify( ply, 1, 6, "You can't afford ammo for this weapon." )
			return
		end
		if ( primaryname == "Buckshot" or primaryname == "Taser" ) and !ply:isCP() then
			DarkRP.notify( ply, 1, 10, "Only police can purchase shotgun and taser ammo from this locker. Shotgun ammo can be obtained by crafting." )
			return
		end
		self.Used = true
		ply:EmitSound( "doors/metal_stop1.wav", 50, 100 )
		timer.Simple( 1.5, function()
			if !IsValid( self ) or !IsValid( ply ) then return end
			local mayorfunds = GetVaultAmount()
			local salestax = price * ( GetGlobalInt( "MAYOR_SalesTax" ) * 0.01 )
			if mayorfunds < salestax and ply:isCP() then
				DarkRP.notify( ply, 1, 6, "There is not enough in the city bank to buy ammo for this weapon." )
				return
			end
			ply:EmitSound( "items/ammo_pickup.wav" )
			ply:GiveAmmo( amount, primaryname )
			if ply:isCP() then
				AddVaultFunds( -salestax )
			else
				local finalprice = price + salestax
				AddVaultFunds( salestax )
				ply:addMoney( -finalprice )
			end
			self.Used = false
		end )
	end
end

if CLIENT then
	local offset = Vector( 0, 0, 50 )
	function ENT:Draw()
		self:DrawModel()
		self:DrawNPCText( "Ammo", offset )
	end
end
