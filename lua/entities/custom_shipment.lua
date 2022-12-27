AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Customizable Shipment"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = false

ShipmentWepList = {
	{"arccw_mifl_fas2_famas", 1250}, {"arccw_mifl_fas2_sr25", 750}, {"arccw_mifl_fas2_mp5", 1000},
	{"arccw_mifl_fas2_mac11", 1000}, {"arccw_mifl_fas2_rpk", 3000}, {"arccw_mifl_fas2_m82", 3000},
	{"arccw_mifl_fas2_ak47", 2500}, {"arccw_mifl_fas2_m4a1", 2500}, {"arccw_mifl_fas2_m3", 2500},
	{"arccw_mifl_fas2_toz34", 1500}, {"arccw_mifl_fas2_g3", 2000}, {"arccw_mifl_fas2_g36c", 2000},
	{"arccw_mifl_fas2_m24", 2500}, {"arccw_mifl_fas2_sg55x", 2000}, {"arccw_mifl_fas2_ragingbull", 750},
	{"arccw_fml_fas2_custom_mass26", 2000}, {"arccw_mifl_fas2_ks23", 2000}, {"arccw_mifl_fas2_g20", 150},
	{"arccw_mifl_fas2_p226", 90}, {"arccw_mifl_fas2_deagle", 375}, {"arccw_mifl_fas2_m1911", 50}
}

local function FinalPrice( index, amount )
	local price = ShipmentWepList[index][2]
	return ( price - ( price * ( amount * 0.05 ) ) ) * amount 
end

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Amount" )
	self:NetworkVar( "Int", 1, "Price" )
	self:NetworkVar( "Int", 2, "GunType" )
end

function ENT:Initialize()
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetModel( "models/Items/item_item_crate.mdl" )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self.Ready = false
	else
		self.Preview = ents.CreateClientProp()
		self.Preview:SetPos( self:GetPos() + Vector( 0, 0, 50 ) )
		self.Preview:SetParent( self )
		self.Preview:Spawn()
	end
 
    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

if SERVER then
	util.AddNetworkString( "OpenShipmentMenu" )
	util.AddNetworkString( "ApplyShipmentData" )
	function ENT:Use( ply )
		if self.Ready then
			local price = self:GetPrice()
			local wep = self:GetGunType()
			local name = ShipmentWepList[wep][1]
			if ply.WepBuyCooldown and ply.WepBuyCooldown > CurTime() then
				DarkRP.notify( ply, 1, 6, "Please wait 2 minutes before buying another weapon." )
				return
			end
			if ply:HasWeapon( name ) then
				DarkRP.notify( ply, 1, 6, "You already have this weapon. Drop it to buy another one." )
				return
			end
			if !ply:canAfford( price ) then
				DarkRP.notify( ply, 1, 6, "You can't afford this weapon." )
				return
			end
			ply:Give( name )
			self:SetAmount( self:GetAmount() - 1 )
			if self:GetOwner() == ply then
				DarkRP.notify( ply, 0, 6, "You have taken a weapon from your own shipment. You have not been charged." )
			else
				ply:addMoney( -price )
				self:GetOwner():addMoney( price )
				ply.WepBuyCooldown = CurTime() + 120
				DarkRP.notify( ply, 0, 6, "You have purchased a weapon for "..DarkRP.formatMoney( price ).."." )
				DarkRP.notify( self:GetOwner(), 0, 6, "You have received "..DarkRP.formatMoney( price ).." for a recent weapon purchase." )
			end
			if self:GetAmount() <= 0 then
				self:Remove()
			end
		else
			if ply:Team() == TEAM_GUN then
				net.Start( "OpenShipmentMenu" )
				net.WriteEntity( self )
				net.Send( ply )
			else
				DarkRP.notify( ply, 1, 6, "This shipment is not configured yet." )
			end
		end
	end

	net.Receive( "ApplyShipmentData", function( len, ply )
		local ent = net.ReadEntity()
		local amount = net.ReadInt( 6 )
		local price = net.ReadInt( 16 )
		local gun = net.ReadInt( 8 )
		local final = FinalPrice( gun, amount )
		if !ply:canAfford( final ) then
			DarkRP.notify( ply, 1, 6, "You cannot afford this shipment in it's current configuration." )
			return
		end
		ent:SetAmount( amount )
		ent:SetPrice( price )
		ent:SetGunType( gun )
		ent.Ready = true
		ply:addMoney( -final )
		DarkRP.notify( ply, 0, 6, "Weapon shipment successfully configured." )
	end )
end

if CLIENT then
	surface.CreateFont( "HLU_BoxFont", {
		font = "Arial",
		size = 30
	} )

	local GetStored = weapons.GetStored
	function ENT:Draw()
		self:DrawModel()
		local plyShootPos = LocalPlayer():GetShootPos()
		if self:GetPos():DistToSqr( plyShootPos ) < 562500 then
			local name = ShipmentWepList[self:GetGunType()]
			local data = name and GetStored( name[1] ) or nil
			local wepname = data and ( data.TrueName or data.PrintName ) or "Unconfigured"
			local title = wepname.." Weapon Box"
			local title2 = "Amount: "..self:GetAmount()
			local title3 = "Price: "..DarkRP.formatMoney( self:GetPrice() )
			local ang = self:GetAngles()
			ang:RotateAroundAxis( self:GetAngles():Right(), 270 )
			ang:RotateAroundAxis( self:GetAngles():Forward(), 90 )
			local pos = self:GetPos() + ang:Right() * -5 + ang:Up() * 17 + ang:Forward() * -25
			cam.Start3D2D( pos, ang, 0.1 )
				draw.RoundedBox( 0, 60, -120, 350, 100, color_theme )
				draw.SimpleText( title, "HLU_BoxFont", 240, -100, color_white, 1, 1 )
				draw.SimpleText( title2, "HLU_BoxFont", 240, -70, color_white, 1, 1 )
				draw.SimpleText( title3, "HLU_BoxFont", 240, -40, color_white, 1, 1 )
			cam.End3D2D()
		end
		if self.Preview and self.Preview:GetModel() != "" then
			local ang = self:GetAngles()
			ang:RotateAroundAxis( ang:Up(), ( CurTime() * 180 ) % 360 )
			self.Preview:SetAngles( ang )
		end
	end

	function ENT:OnRemove()
		if IsValid( self.Preview ) then
			self.Preview:Remove()
		end
	end

	net.Receive( "OpenShipmentMenu", function()
		local ent = net.ReadEntity()
		local menu1 = vgui.Create( "DFrame" )
		menu1:SetSize( 300, 220 )
		menu1:Center()
		menu1:SetTitle( "Customize Shipment" )
		menu1:MakePopup()
		menu1.Paint = function( self, w, h )
			draw.RoundedBox( 4, 0, 0, w, h, color_theme )
		end

		local weps = vgui.Create( "DComboBox", menu1 )
		weps:Dock( TOP )
		weps:DockMargin( 0, 0, 0, 5 )
		weps:SetSize( 375, 30 )
		weps:SetValue( "Select Weapon" )
		for k,v in ipairs( ShipmentWepList ) do
			local data = GetStored( v[1] )
			weps:AddChoice( data.TrueName or data.PrintName or "Undefined" )
		end

		local amountlabel = vgui.Create( "DLabel", menu1 )
		amountlabel:Dock( TOP )
		amountlabel:SetText( "Enter amount of weapons:" )
		local amount = vgui.Create( "DNumberWang", menu1 )
		amount:Dock( TOP )
		amount:DockMargin( 0, 0, 0, 5 )
		amount:SetSize( 375, 30 )

		local pricelabel = vgui.Create( "DLabel", menu1 )
		pricelabel:Dock( TOP )
		pricelabel:SetText( "Enter price per weapon:" )
		local price = vgui.Create( "DNumberWang", menu1 )
		price:Dock( TOP )
		price:DockMargin( 0, 0, 0, 5 )
		price:SetSize( 375, 30 )
		
		local submit = vgui.Create( "DButton", menu1 )
		submit:Dock( BOTTOM )
		submit:SetText( "Submit" )
		submit.DoClick = function()
			local amount = amount:GetValue()
			local price = price:GetValue()
			local wep = weps:GetSelectedID()
			if amount > 10 then
				surface.PlaySound( "buttons/button2.wav" )
				chat.AddText( "Max amount is 10." )
				return
			end
			if price > 15000 then
				surface.PlaySound( "buttons/button2.wav" )
				chat.AddText( "Max price is $15,000." )
				return
			end
			if amount < 1 or price < 1 or !wep then
				surface.PlaySound( "buttons/button2.wav" )
				chat.AddText( "Please fill out all fields." )
				return
			end

			local menu2 = vgui.Create( "DFrame" )
			menu2:SetSize( 300, 125 )
			menu2:Center()
			menu2:SetTitle( "Confirm Changes" )
			menu2:MakePopup()
			menu2.Paint = function( self, w, h )
				draw.RoundedBox( 4, 0, 0, w, h, color_theme )
			end
			local total2 = vgui.Create( "DLabel", menu2 )
			total2:Dock( TOP )
			total2:SetText( "You will be charged "..DarkRP.formatMoney( FinalPrice( wep, amount ) ).." for the whole shipment." )
			local note2 = vgui.Create( "DLabel", menu2 )
			note2:Dock( TOP )
			note2:SetSize( nil, 50 )
			note2:SetText( "Double check everything before submitting.\nThese settings cannot be changed later." )
			local submit2 = vgui.Create( "DButton", menu2 )
			submit2:Dock( BOTTOM )
			submit2:SetText( "Confirm" )
			submit2.DoClick = function()
				net.Start( "ApplyShipmentData" )
				net.WriteEntity( ent )
				net.WriteInt( amount, 6 )
				net.WriteInt( price, 16 )
				net.WriteInt( wep, 8 )
				net.SendToServer()
				if IsValid( menu1 ) then menu1:Close() end
				menu2:Close()
				ent.Preview:SetModel( GetStored( ShipmentWepList[wep][1] ).WorldModel )
			end
		end
	end )
end
