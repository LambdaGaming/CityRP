
surface.CreateFont( "FineMenuText", {
	font = "Arial",
	size = 16,
	weight = 600
} )

local MenuColor = Color( 49, 53, 61, 200 )
local ButtonColor = Color( 230, 93, 80, 255 )
local function FineMenu( ply, receiver, vehicle, veh )
	gui.EnableScreenClicker( false )
	local menu = vgui.Create( "DFrame" )
	menu:SetTitle( "Fine "..receiver:Nick() )
	menu:SetSize( 350, 150 )
	menu:Center()
	menu:MakePopup()
	menu.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, MenuColor )
	end
	menu.OnClose = function()
		ply.MenuOpen = false
	end
	
	local price = vgui.Create( "DTextEntry", menu )
	price:SetPos( 30, 30 )
	price:SetSize( 65, 20 )
	price:SetNumeric( true )
	price:SetPlaceholderText( "Fine amount" )

	local reason = vgui.Create( "DTextEntry", menu )
	reason:SetPos( 30, 60 )
	reason:SetSize( 150, 80 )
	reason:SetMultiline( true )
	reason:SetPlaceholderText( "Reason for fine" )

	local confirm = vgui.Create( "DButton", menu )
	confirm:SetText( "Confirm" )
	confirm:SetTextColor( color_white )
	confirm:SetPos( 230, nil )
	confirm:SetSize( 60, 40 )
	confirm:CenterVertical()
	confirm.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, ButtonColor )
	end
	confirm.DoClick = function()
		if tonumber( price:GetValue() ) == nil then
			chat.AddText( "Please enter a number for the price." )
			return
		end
		if tonumber( price:GetValue() ) > 500 then
			chat.AddText( "Please enter a number less than or equal to 500." )
			return
		end
		if reason:GetValue() == "" then
			chat.AddText( "Please add a reason for the fine." )
			return
		end
		if !ply:Alive() then
			chat.AddText( "You can't fine a player while you are dead!" )
			return
		end
		if receiver:IsPlayer() and !receiver:Alive() then
			chat.AddText( "The player you tried to fine is dead!" )
			return
		end
		if vehicle then
			net.Start( "VehicleFine" )
			net.WriteEntity( veh )
			net.WriteEntity( ply )
			net.WriteInt( price:GetValue(), 32 )
			net.WriteString( reason:GetValue() )
			net.SendToServer()
			menu:Close()
			return
		end
		net.Start( "SendFine" )
		net.WriteEntity( receiver )
		net.WriteInt( price:GetValue(), 32 )
		net.WriteString( reason:GetValue() )
		net.SendToServer()
		menu:Close()
	end
	ply.MenuOpen = true
end

local function FineMenuPay()
	gui.EnableScreenClicker( false )
	local sender = net.ReadEntity()
	local price = net.ReadInt( 32 )
	local reason = net.ReadString()
	local ply = LocalPlayer()
	local menu = vgui.Create( "DFrame" )
	menu:SetTitle( "" )
	menu:SetSize( 350, 150 )
	menu:Center()
	menu:MakePopup()
	menu:ShowCloseButton( false )
	menu.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, MenuColor )
	end
	menu.OnClose = function()
		ply.MenuOpen = false
	end
	
	local label = vgui.Create( "DLabel", menu )
	label:CenterHorizontal()
	label:SetPos( nil, 10 )
	label:SetSize( 330, 50 )
	label:SetWrap( true )
	label:SetAutoStretchVertical( true )
	label:SetFont( "FineMenuText" )
	label:SetText( "You have been fined $"..price.." by "..sender:Nick()..".\nReason: "..reason )

	local pay = vgui.Create( "DButton", menu )
	pay:SetText( "Pay Fine" )
	pay:SetTextColor( color_white )
	pay:SetPos( 50, 100 )
	pay:SetSize( 100, 40 )
	pay.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, ButtonColor )
	end
	pay.DoClick = function()
		net.Start( "AcceptFine" )
		net.WriteInt( price, 32 )
		net.WriteEntity( sender )
		net.SendToServer()
		menu:Close()
	end
	if !ply:canAfford( price ) then
		pay:SetEnabled( false )
	end

	local refuse = vgui.Create( "DButton", menu )
	refuse:SetText( "Refuse to pay" )
	refuse:SetTextColor( color_white )
	refuse:SetPos( 210, 100 )
	refuse:SetSize( 100, 40 )
	refuse.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, ButtonColor )
	end
	refuse.DoClick = function()
		net.Start( "AcceptFine" )
		net.WriteInt( price, 32 )
		net.WriteEntity( sender )
		net.WriteBool( true )
		net.SendToServer()
		menu:Close()
	end
	ply.MenuOpen = true
	ply.GettingFined = true
end
net.Receive( "SendFineClient", FineMenuPay )

local function FineButton()
	local tr = net.ReadEntity()
	local vehicle = net.ReadBool()
	local veh = net.ReadEntity()
	local ply = LocalPlayer()
	if ply.MenuOpen then return end
	if vehicle then
		FineMenu( ply, tr, true, veh )
		return
	end
	FineMenu( ply, tr )
end
net.Receive( "FineButton", FineButton )
