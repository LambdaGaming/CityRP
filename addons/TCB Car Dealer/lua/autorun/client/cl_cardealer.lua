/*---------------------------------------------------------------------------
	
	Creator: TheCodingBeast - TheCodingBeast.com
	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
	To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/
	
---------------------------------------------------------------------------*/

--[[---------------------------------------------------------
	Fonts
-----------------------------------------------------------]]
for i=0,24 do

	--> Size
	local size = 10+i

	--> Font
	surface.CreateFont("TCBDealer_"..size, {
		font = "Trebuchet24",
		size = size,
	})

end

--[[---------------------------------------------------------
	Convars
-----------------------------------------------------------]]
CreateClientConVar("tcb_cardealer_r", 0, true, true)
CreateClientConVar("tcb_cardealer_g", 0, true, true)
CreateClientConVar("tcb_cardealer_b", 0, true, true)

--[[---------------------------------------------------------
	Chat Text
-----------------------------------------------------------]]
local function chatText()
	chat.AddText(Color(52, 152, 219), "[Dealer]", color_white, " "..net.ReadString())
end
net.Receive("TCBDealerChat", chatText)


--[[---------------------------------------------------------
	Derma Blur - Credits: Mrkrabz
-----------------------------------------------------------]]
local blur = Material("pp/blurscreen")
local function DrawBlur(panel, amount)
	local x, y = panel:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()
	surface.SetDrawColor( color_white )
	surface.SetMaterial(blur)
	for i = 1, 3 do
		blur:SetFloat("$blur", (i / 3) * (amount or 6))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end

--[[---------------------------------------------------------
	Dealer Menu
-----------------------------------------------------------]]
local function carDealer( ownedTable, dealerID )
	--> Variables
	local vehiclesTable = TCBDealer.vehicleTable

	if !ownedTable or !dealerID then
		ownedTable 	= net.ReadTable()

		dealerID = net.ReadInt(32)
	end

	local w = 450
	local h = 602

	--> Frame
	local frame = vgui.Create("DFrame")
	frame:SetPos(ScrW()/2-w/2, ScrH())
	frame:SetSize(w, h)
	frame:SetTitle("")
	frame:SetDraggable(false)
	frame:ShowCloseButton(false)
	frame:MakePopup()
	frame:MoveTo(ScrW()/2-w/2, ScrH()/2-h/2, 0.2, 0, -1)
	
	frame.Paint = function(pnl, w, h)

		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
		draw.RoundedBox(0, 1, 1, w-2, h-2, ColorAlpha( color_theme, 220 ))

		draw.RoundedBox(0, 1, 1, w-2, 40, color_theme)
		draw.SimpleText(TCBDealer.settings.frameTitle, "TCBDealer_24", 11, 41-20, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	end

	--> Close
	local close = vgui.Create("DButton", frame)
	close:SetPos(w-65-7, 41/2-24/2)
	close:SetSize(65, 26)
	close:SetText("")

	close.DoClick = function()

		frame:MoveTo(ScrW()/2-w/2, ScrH(), 0.2, 0, -1, function()
			frame:Remove()
		end)

	end

	close.Paint = function(pnl, w, h)

		draw.RoundedBox(3, 0, 0, w, h, Color(244, 67, 54, 255))
		draw.SimpleText("x", "TCBDealer_24", w/2, h/2-1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if close.Hovered then
			draw.RoundedBox(3, 0, 0, w, h, Color(255, 255, 255, 6))
		end

	end

	--> Color Picker
	if TCBDealer.settings.colorPicker then

		--> Convars
		local clrValR = GetConVar("tcb_cardealer_r"):GetInt() or 0
		local clrValG = GetConVar("tcb_cardealer_g"):GetInt() or 0
		local clrValB = GetConVar("tcb_cardealer_b"):GetInt() or 0

		--> Variables
		local pickerExapnded = false

		local pickerPanel = nil
		local pickerColor = Color(clrValR, clrValG, clrValB, 255)

		--> Color
		local color = vgui.Create("DButton", frame)
		color:SetPos(w-26-12-close:GetWide(), 41/2-24/2)
		color:SetSize(26, 26)
		color:SetText("")

		color.DoClick = function()

			if pickerExapnded then

				--> Variables
				pickerPanel:Remove()
				pickerExapnded = false

			else

				--> Variables
				pickerExapnded = true

				--> Panel
				local colorPanel = vgui.Create("DPanel", frame)
				colorPanel:SetSize(200, 200)
				colorPanel:SetPos(w-277, 40-11)

				colorPanel.Paint = function(pnl, w, h)
					draw.RoundedBox(3, 0, 0, w, h, Color(0, 0, 0, 100))
					draw.RoundedBoxEx(3, 2, 2, w-4, h-4, pickerColor, true, false, true, true)
					draw.RoundedBox(0, w-24, 0, 22, 2, pickerColor)
				end

				pickerPanel = colorPanel

				--> Mixer
				local mixer = vgui.Create("DColorMixer", colorPanel)
				mixer:Dock(FILL)
				mixer:DockPadding(10, 10, 10, 10)
				mixer:SetWangs(false)
				mixer:SetAlphaBar(false)
				mixer:SetPalette(false)
				mixer:SetColor(pickerColor)

				--> Change
				mixer.ValueChanged = function()
					local clr = mixer:GetColor()
					pickerColor = clr

					RunConsoleCommand("tcb_cardealer_r", clr.r)
					RunConsoleCommand("tcb_cardealer_g", clr.g)
					RunConsoleCommand("tcb_cardealer_b", clr.b)
				end

			end

		end

		color.Paint = function(pnl, w, h)

			draw.RoundedBox(3, 0, 0, w, h, Color(0, 0, 0, 100))
			draw.RoundedBox(3, 2, 2, w-4, h-4, pickerColor)

			if color.Hovered then
				draw.RoundedBox(3, 2, 2, w-4, h-4, Color(255, 255, 255, 6))
			end

		end

	end

	--> Panel
	local panel = vgui.Create("DScrollPanel", frame)
	panel:SetPos(1, 41)
	panel:SetSize(w-2, h-2-40)

	panel.VBar.Paint 			= function( pnl, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 50) ) end 
	panel.VBar.btnUp.Paint 		= function( pnl, w, h ) draw.RoundedBox( 0, 2, 2, w - 4, h - 4, Color( 0, 0, 0, 25 ) ) draw.DrawText( "▲", "HudHintTextSmall", 3, 2, color_white ) end
	panel.VBar.btnDown.Paint 	= function( pnl, w, h ) draw.RoundedBox( 0, 2, 2, w - 4, h - 4, Color( 0, 0, 0, 25 ) ) draw.DrawText( "▼", "HudHintTextSmall", 3, 2, color_white ) end
	panel.VBar.btnGrip.Paint 	= function( pnl, w, h ) draw.RoundedBox( 4, 3, 2, w - 6, h - 4, Color( 63, 81, 181, 255 ) ) end

	--> Slide EWW :(
	local slide = vgui.Create("DPanel", panel)
	slide:SetPos(0, 0)
	slide:SetSize(1, panel:GetTall()+1)

	--> Store
	local cvehicle = nil
	local currentVehicle = LocalPlayer():GetNWEntity("currentVehicle")
	if IsValid(currentVehicle) and LocalPlayer():GetPos():DistToSqr(currentVehicle:GetPos()) <= TCBDealer.settings.storeDistance * TCBDealer.settings.storeDistance then
		cvehicle = currentVehicle
	end

	local posY = 0
	if cvehicle then

		--> Panel
		local store = vgui.Create("DPanel", panel)
		store:SetPos(0, posY)
		store:SetSize((w-2)-16, 80)

		store.Paint = function(pnl, w, h)

			--> Background
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 25))
			draw.RoundedBox(0, 0, h-1, w, 1, Color(0, 0, 0, 50))

			--> Model
			--draw.RoundedBox(2, 4, 4, h-8, h-8, Color(0, 0, 0, 40))

			--> Title
			draw.SimpleText("Closest Vehicle", "TCBDealer_24", w/2-15, 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			--> Name
			draw.SimpleText(cvehicle:GetNWString("dealerName"), "TCBDealer_22", w/2-15, 55, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		end

		--> Store
		local storeBtn = vgui.Create("DButton", store)
		storeBtn:SetSize(100, store:GetTall()/2-5)
		storeBtn:SetPos(store:GetWide()-104, 4+storeBtn:GetTall()/2+1)
		storeBtn:SetText("")

		storeBtn.DoClick = function()
			net.Start("TCBDealerStore")
				net.WriteInt(dealerID, 32)
			net.SendToServer(LocalPlayer())

			frame:MoveTo(ScrW()/2-w/2, ScrH(), 0.2, 0, -1, function()
				frame:Remove()
			end)
		end

		storeBtn.Paint = function(pnl, w, h)

			draw.RoundedBox(3, 0, 0, w, h, Color(231, 76, 60, 255))
			draw.SimpleText("Store Vehicle", "DermaDefaultBold", w/2, h/2-1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			if storeBtn.Hovered then
				draw.RoundedBox(3, 0, 0, w, h, Color(255, 255, 255, 6))
			end

		end

		--> Position
		posY = posY + store:GetTall()

	end

	--> Vehicles
	local count = 0
	for k,v in SortedPairsByMemberValue(vehiclesTable, "price", true) do

		--> Check
		if v.customCheck and !v.customCheck(LocalPlayer()) then continue end

		--> Count
		count = count + 1

		--> Vehicle Info
		local vehicleInfo = {}
		if !v.name or !v.mdl then
			vehicleInfo = list.GetForEdit("Vehicles")[k]
			if !vehicleInfo then continue end
		end

		local vehName = v.name or vehicleInfo.Name
		local vehMdl = v.mdl or vehicleInfo.Model

		--> Vehicle Panel
		local vehicle = vgui.Create("DPanel", panel)
		vehicle:SetPos(0, posY)
		vehicle:SetSize((w-2)-16, 80)
		vehicle.count = count

		vehicle.Paint = function(pnl, w, h)
			--> Stripe
			if vehicle.count % 2 == 0 then
				draw.RoundedBox(0, 0, 0, w, h, ColorAlpha( color_white, 15 ))
			end

			--> Model
			--draw.RoundedBox(2, 4, 4, h-8, h-8, Color(0, 0, 0, 40))

			--> Name
			draw.SimpleText(vehName, "TCBDealer_20", w/2-15, 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			--> Price
			draw.SimpleText("Price: "..DarkRP.formatMoney(v.price), "TCBDealer_18", w/2-15, 55, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		--> Buttons
		if !table.HasValue(ownedTable, k) then

			--> Purchase
			local purchase = vgui.Create("DButton", vehicle)
			purchase:SetSize(100, vehicle:GetTall()/2-6)
			purchase:SetPos(vehicle:GetWide()-104, 4)
			purchase:SetText("")

			purchase.DoClick = function()
				net.Start("TCBDealerPurchase")
					net.WriteString(k)
				net.SendToServer(LocalPlayer())

				frame:MoveTo(ScrW()/2-w/2, ScrH(), 0.2, 0, -1, function()
					frame:Remove()
				end)
			end

			purchase.Paint = function(pnl, w, h)

				draw.RoundedBox(3, 0, 0, w, h, Color(46, 204, 113, 255))
				draw.SimpleText("Purchase", "DermaDefaultBold", w/2, h/2-1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				if purchase.Hovered then
					draw.RoundedBox(3, 0, 0, w, h, Color(255, 255, 255, 6))
				end

			end

			--> Preview
			local preview = vgui.Create("DButton", vehicle)
			preview:SetSize(100, vehicle:GetTall()/2-6)
			preview:SetPos(vehicle:GetWide()-104, purchase:GetTall()+8)
			preview:SetText("")

			preview.DoClick = function()
				net.Start("TCBDealerSpawn")
					net.WriteString(k)
					net.WriteInt(dealerID, 32)
					net.WriteBool(true)
				net.SendToServer(LocalPlayer())

				frame:MoveTo(ScrW()/2-w/2, ScrH(), 0.2, 0, -1, function()
					frame:Remove()
				end)
			end

			preview.Paint = function(pnl, w, h)

				draw.RoundedBox(3, 0, 0, w, h, Color(52, 152, 219, 255))
				draw.SimpleText("Test Drive", "DermaDefaultBold", w/2, h/2-1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				if preview.Hovered then
					draw.RoundedBox(3, 0, 0, w, h, Color(255, 255, 255, 6))
				end

			end

		else

			--> Spawn
			local spawn = vgui.Create("DButton", vehicle)
			spawn:SetSize(100, vehicle:GetTall()/2-6)
			spawn:SetPos(vehicle:GetWide()-104, 4)
			spawn:SetText("")

			spawn.DoClick = function()
				net.Start("TCBDealerSpawn")
					net.WriteString(k)
					net.WriteInt(dealerID, 32)
					net.WriteBool(false)
				net.SendToServer(LocalPlayer())

				frame:MoveTo(ScrW()/2-w/2, ScrH(), 0.2, 0, -1, function()
					frame:Remove()
				end)
			end

			spawn.Paint = function(pnl, w, h)

				draw.RoundedBox(3, 0, 0, w, h, Color(46, 204, 113, 255))
				draw.SimpleText("Spawn", "DermaDefaultBold", w/2, h/2-1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				if spawn.Hovered then
					draw.RoundedBox(3, 0, 0, w, h, Color(255, 255, 255, 6))
				end

			end

			--> Sell
			local sell = vgui.Create("DButton", vehicle)
			sell:SetSize(100, vehicle:GetTall()/2-6)
			sell:SetPos(vehicle:GetWide()-104, spawn:GetTall()+8)
			sell:SetText("")

			sell.DoClick = function()

				local cover = vgui.Create("DPanel", frame)
				cover:SetSize(w, h)
				cover:SetPos(0, 0)

				cover.Paint = function(pnl, w, h)

					draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))
					DrawBlur(pnl, 1)

				end

				local coverFront = vgui.Create("DPanel", cover)
				coverFront:SetSize(cover:GetWide(), 100)
				coverFront:SetPos(-500, 40+((cover:GetTall()-40)/2-(100/2)))
				coverFront:MoveTo(0, 40+((cover:GetTall()-40)/2-(100/2)), 0.2)

				coverFront.Paint = function(pnl, w, h)

					draw.RoundedBox(0, 0, 0, w, h, Color(63, 81, 181, 255))

					draw.SimpleText("Are you sure you want to sell this vehicle for "..DarkRP.formatMoney(v.price*(TCBDealer.settings.salePercentage/100)).."?", "TCBDealer_22", w/2, 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				end

				--> Yes
				local yes = vgui.Create("DButton", coverFront)
				yes:SetSize(coverFront:GetWide()/2-30, 30)
				yes:SetPos(20, 50)
				yes:SetText("")

				yes.DoClick = function()
					net.Start("TCBDealerSell")
						net.WriteString(k)
					net.SendToServer(LocalPlayer())

					frame:MoveTo(ScrW()/2-w/2, ScrH(), 0.2, 0, -1, function()
						frame:Remove()
					end)
				end

				yes.Paint = function(pnl, w, h)

					draw.RoundedBox(3, 0, 0, w, h, Color(231, 76, 60, 255))
					draw.SimpleText("Yes", "DermaDefaultBold", w/2, h/2-1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

					if yes.Hovered then
						draw.RoundedBox(3, 0, 0, w, h, Color(255, 255, 255, 6))
					end

				end

				--> Cancel
				local cancel = vgui.Create("DButton", coverFront)
				cancel:SetSize(coverFront:GetWide()/2-30, 30)
				cancel:SetPos(40+yes:GetWide(), 50)
				cancel:SetText("")

				cancel.DoClick = function()
					coverFront:MoveTo(-500, 40+((cover:GetTall()-40)/2-(100/2)), 0.2, 0, -1, function()
						cover:Remove()
					end)
				end

				cancel.Paint = function(pnl, w, h)

					draw.RoundedBox(3, 0, 0, w, h, Color(46, 204, 113, 255))
					draw.SimpleText("Cancel", "DermaDefaultBold", w/2, h/2-1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

					if cancel.Hovered then
						draw.RoundedBox(3, 0, 0, w, h, Color(255, 255, 255, 6))
					end
				end
			end
			sell.Paint = function(pnl, w, h)
				draw.RoundedBox(3, 0, 0, w, h, Color(231, 76, 60, 255))
				draw.SimpleText("Sell ("..DarkRP.formatMoney(v.price*(TCBDealer.settings.salePercentage/100))..")", "DermaDefaultBold", w/2, h/2-1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				if sell.Hovered then
					draw.RoundedBox(3, 0, 0, w, h, Color(255, 255, 255, 6))
				end
			end
		end
		--> Position
		posY = posY + vehicle:GetTall()
	end
end
net.Receive("TCBDealerMenu", carDealer)

local menucolor = Color( 49, 53, 61, 200 )
local buttoncolor = Color( 230, 93, 80, 255 )
local function DrawSellMenu( foundtable )
	local ply = LocalPlayer()
	local mainframe = vgui.Create( "DFrame" )
	mainframe:SetTitle( "Sell a Vehicle" )
	mainframe:SetSize( 500, 800 )
	mainframe:Center()
	mainframe:MakePopup()
	mainframe.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, menucolor )
	end

	local listframe = vgui.Create( "DScrollPanel", mainframe )
	listframe:Dock( FILL )
	for k,v in ipairs( foundtable, "price", true ) do
		local vehclass = v:GetNWString( "dealerClass" )
		if !vehclass or vehclass == "" then return end
		local vehtable = list.GetForEdit( "Vehicles" )[vehclass]
		local itembackground = vgui.Create( "DPanel", listframe )
		itembackground:SetPos( 0, 10 )
		itembackground:SetSize( 450, 100 )
		itembackground:Dock( TOP )
		itembackground:DockMargin( 0, 0, 0, 10 )
		itembackground:Center()
		itembackground.Paint = function()
			draw.RoundedBox( 0, 0, 0, itembackground:GetWide(), itembackground:GetTall(), menucolor )
		end

		local mainbuttons = vgui.Create( "DButton", itembackground )
		mainbuttons:SetText( vehtable.Name )
		mainbuttons:SetTextColor( color_white )
		mainbuttons:SetFont( "ItemNPCTitleFont" )
		mainbuttons:Dock( TOP )
		mainbuttons.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, buttoncolor )
		end
		mainbuttons.DoClick = function()
			net.Start( "SellVehicle" )
			net.WriteEntity( v )
			net.SendToServer()
			mainframe:Close()
		end

		if vehtable.Model then
			local itemicon = vgui.Create( "SpawnIcon", itembackground )
			itemicon:SetPos( 10, 30 )
			itemicon:SetModel( vehtable.Model )
			itemicon:SetToolTip( false )
			itemicon:SetSize( 60, 60 )
			itemicon.DoClick = function()
				mainframe:ToggleVisible()

				local modelpanel = vgui.Create( "DFrame" )
				modelpanel:SetTitle( vehtable.Name )
				modelpanel:SetSize( 350, 350 )
				modelpanel:Center()
				modelpanel:MakePopup()
				modelpanel.OnClose = function()
					mainframe:ToggleVisible()
				end
				modelpanel.Paint = function( self, w, h )
					draw.RoundedBox( 0, 0, 0, w, h, menucolor )
				end

				local modelpanel2 = vgui.Create( "DAdjustableModelPanel", modelpanel )
				modelpanel2:SetPos( 0, 0 )
				modelpanel2:SetSize( 320, 320 )
				modelpanel2:SetLookAt( Vector( 0, 0, 10 ) )
				modelpanel2:SetCamPos( Vector( -10, 0, 0 ) )
				modelpanel2:SetModel( vehtable.Model )
			end
		end

		local itemprice = vgui.Create( "DLabel", itembackground )
		itemprice:SetFont( "Trebuchet24" )
		itemprice:SetColor( color_white )
		local vehprice = TCBDealer.vehicleTable[vehclass].price * 0.05
		itemprice:SetText( "Sell Price: "..DarkRP.formatMoney( vehprice ) )
		itemprice:SizeToContents()

		if vehtable.Model then
			itemprice:SetPos( 85, 45 )
		else
			itemprice:SetPos( 5, 45 )
		end
	end
end

local function DrawRentalMenu()
	local ply = LocalPlayer()
	local mainframe = vgui.Create( "DFrame" )
	mainframe:SetTitle( "Rent a Vehicle" )
	mainframe:SetSize( 500, 800 )
	mainframe:Center()
	mainframe:MakePopup()
	mainframe.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, menucolor )
	end

	local listframe = vgui.Create( "DScrollPanel", mainframe )
	listframe:Dock( FILL )
	for k,v in pairs( TCBDealer.vehicleTableRent ) do
		local vehtable = list.GetForEdit( "Vehicles" )[k]
		local itembackground = vgui.Create( "DPanel", listframe )
		itembackground:SetPos( 0, 10 )
		itembackground:SetSize( 450, 100 )
		itembackground:Dock( TOP )
		itembackground:DockMargin( 0, 0, 0, 10 )
		itembackground:Center()
		itembackground.Paint = function()
			draw.RoundedBox( 0, 0, 0, itembackground:GetWide(), itembackground:GetTall(), menucolor )
		end

		local mainbuttons = vgui.Create( "DButton", itembackground )
		mainbuttons:SetText( vehtable.Name )
		mainbuttons:SetTextColor( color_white )
		mainbuttons:SetFont( "ItemNPCTitleFont" )
		mainbuttons:Dock( TOP )
		mainbuttons.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, buttoncolor )
		end
		mainbuttons.DoClick = function()
			net.Start( "RentVehicle" )
			net.WriteString( k )
			net.SendToServer()
			mainframe:Close()
		end

		if vehtable.Model then
			local itemicon = vgui.Create( "SpawnIcon", itembackground )
			itemicon:SetPos( 10, 30 )
			itemicon:SetModel( vehtable.Model )
			itemicon:SetToolTip( false )
			itemicon:SetSize( 60, 60 )
			itemicon.DoClick = function()
				mainframe:ToggleVisible()

				local modelpanel = vgui.Create( "DFrame" )
				modelpanel:SetTitle( vehtable.Name )
				modelpanel:SetSize( 350, 350 )
				modelpanel:Center()
				modelpanel:MakePopup()
				modelpanel.OnClose = function()
					mainframe:ToggleVisible()
				end
				modelpanel.Paint = function( self, w, h )
					draw.RoundedBox( 0, 0, 0, w, h, menucolor )
				end

				local modelpanel2 = vgui.Create( "DAdjustableModelPanel", modelpanel )
				modelpanel2:SetPos( 0, 0 )
				modelpanel2:SetSize( 320, 320 )
				modelpanel2:SetLookAt( Vector( 0, 0, 10 ) )
				modelpanel2:SetCamPos( Vector( -10, 0, 0 ) )
				modelpanel2:SetModel( vehtable.Model )
			end
		end

		local itemprice = vgui.Create( "DLabel", itembackground )
		itemprice:SetFont( "Trebuchet24" )
		itemprice:SetColor( color_white )
		if v.price <= 0 then
			itemprice:SetText( "Price: Free" )
		else
			itemprice:SetText( "Price: "..DarkRP.formatMoney( v.price ) )
		end
		itemprice:SizeToContents()

		if vehtable.Model then
			itemprice:SetPos( 85, 45 )
		else
			itemprice:SetPos( 5, 45 )
		end
	end
end

local function DrawMainMenu()
	local table = net.ReadTable()
	local id = net.ReadInt( 32 )
	local ent = net.ReadEntity()
	local foundtable = net.ReadTable()
	local mainframe = vgui.Create( "DFrame" )
	mainframe:SetTitle( "Car Dealer" )
	mainframe:SetSize( 300, 200 )
	mainframe:Center()
	mainframe:MakePopup()
	mainframe.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, menucolor )
	end
	local recipesbutton = vgui.Create( "DButton", mainframe )
	recipesbutton:SetText( "Buy Menu" )
	recipesbutton:SetTextColor( color_white )
	recipesbutton:SetPos( 25, 50 )
	recipesbutton:SetSize( 250, 30 )
	recipesbutton:CenterHorizontal()
	recipesbutton.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, buttoncolor )
	end
	recipesbutton.DoClick = function()
		carDealer( table, id )
		mainframe:Close()
		surface.PlaySound( CRAFT_CONFIG_UI_SOUND )
    end
	local itemsbutton = vgui.Create( "DButton", mainframe )
	itemsbutton:SetText( "Rent Menu" )
	itemsbutton:SetTextColor( color_white )
	itemsbutton:SetPos( 25, 100 )
	itemsbutton:SetSize( 250, 30 )
	itemsbutton:CenterHorizontal()
	itemsbutton.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, buttoncolor )
	end
	itemsbutton.DoClick = function()
		DrawRentalMenu()
		mainframe:Close()
		surface.PlaySound( CRAFT_CONFIG_UI_SOUND )
	end
	local sellbutton = vgui.Create( "DButton", mainframe )
	sellbutton:SetText( "Sell Menu" )
	sellbutton:SetTextColor( color_white )
	sellbutton:SetPos( 25, 150 )
	sellbutton:SetSize( 250, 30 )
	sellbutton:CenterHorizontal()
	sellbutton.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, buttoncolor )
	end
	sellbutton.DoClick = function()
		DrawSellMenu( foundtable )
		mainframe:Close()
		surface.PlaySound( CRAFT_CONFIG_UI_SOUND )
	end
end
net.Receive("TCBDealerMenuRent", DrawMainMenu)