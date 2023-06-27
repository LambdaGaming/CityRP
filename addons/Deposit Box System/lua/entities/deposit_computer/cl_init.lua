include( "shared.lua" )

local function DrawDepositMenu()
	local LoanData = net.ReadTable()
	local mainframe = vgui.Create( "DFrame" )
	mainframe:SetTitle( "City Bank:" )
	mainframe:SetSize( 350, 500 )
	mainframe:Center()
	mainframe:MakePopup()
	mainframe.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, CRAFT_CONFIG_MENU_COLOR )
	end

	local sheet = vgui.Create( "DPropertySheet", mainframe )
	sheet:Dock( FILL )

	local depositPanel = vgui.Create( "DScrollPanel", sheet )
	depositPanel:Dock( FILL )
	for k,v in pairs( ents.FindByClass( "deposit_box" ) ) do
		local mainlist = vgui.Create( "DPanelList" )
		mainlist:SetSpacing( 5 )
		mainlist:EnableHorizontal( false )

		local categorybutton = vgui.Create( "DCollapsibleCategory", depositPanel )
		categorybutton:SetLabel( "Deposit Box #"..k )
		categorybutton:Dock( TOP )
		categorybutton:DockMargin( 0, 15, 0, 5 )
		categorybutton:DockPadding( 5, 0, 5, 5 )
		categorybutton:SetContents( mainlist )
		categorybutton.Paint = function( self, w, h )
			draw.RoundedBox( 8, 0, 0, w, h, color_theme )
		end

		local owner
		local originalamt
		local currentamt
		if v.MoneyOwner then
			owner = v.MoneyOwner:Nick()
			originalamt = v.OriginalAmount
			currentamt = v.MoneyAmount
		else
			owner = "None"
			originalamt = "N/A"
			currentamt = "N/A"
		end
		local name = vgui.Create( "DLabel" )
		name:Dock( TOP )
		name:SetText( "Owner: "..owner )
		local original = vgui.Create( "DLabel" )
		original:Dock( TOP )
		original:SetText( "Original Amount: "..originalamt )
		local current = vgui.Create( "DLabel" )
		current:Dock( TOP )
		current:SetText( "Current Amount: "..currentamt )
		mainlist:AddItem( name )
		mainlist:AddItem( original )
		mainlist:AddItem( current )
	end
	sheet:AddSheet( "Deposit Box Management", depositPanel, "icon16/lock.png" )

	local loanPanel = vgui.Create( "DListView", sheet )
	loanPanel:Dock( FILL )
	loanPanel:SetMultiSelect( false )
	loanPanel:AddColumn( "Name" )
	loanPanel:AddColumn( "Borrowed" )
	loanPanel:AddColumn( "Paid" )
	loanPanel:AddColumn( "Remaining" )
	for k,v in ipairs( player.GetAll() ) do
		local data = LoanData[v:SteamID()]
		if data then
			local initial = DarkRP.formatMoney( data.Initial )
			local remaining = DarkRP.formatMoney( data.Remaining )
			local paid = DarkRP.formatMoney( data.Initial - data.Remaining )
			loanPanel:AddLine( v:Nick(), initial, paid, remaining )
		else
			loanPanel:AddLine( v:Nick(), "N/A", "N/A", "N/A" )
		end
	end
	function loanPanel:DoDoubleClick( id, line )
		local ply = DarkRP.findPlayer( line:GetColumnText( 1 ) )
		local amount = line:GetColumnText( 2 )
		if !IsValid( ply ) then
			LocalPlayer():ChatPrint( "Selected player does not exist. Try reopening the computer menu." )
			return
		end
		if amount != "N/A" then
			LocalPlayer():ChatPrint( "Selected player already has an active loan." )
			return
		end

		local amountFrame = vgui.Create( "DFrame" )
		amountFrame:SetTitle( "Set Loan Amount" )
		amountFrame:SetSize( 300, 100 )
		amountFrame:Center()
		amountFrame:MakePopup()
		amountFrame.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, CRAFT_CONFIG_MENU_COLOR )
		end

		local slider = vgui.Create( "DNumSlider", amountFrame )
		slider:Dock( TOP )
		slider:Center()
		slider:SetMin( 1000 )
		slider:SetMax( 100000 )
		slider:SetDecimals( 0 )

		local submit = vgui.Create( "DButton", amountFrame )
		submit:Dock( BOTTOM )
		submit:SetText( "Submit" )
		submit.DoClick = function()
			net.Start( "LoanConfirmation" )
			net.WriteEntity( ply )
			net.WriteInt( slider:GetValue(), 18 )
			net.SendToServer()
			amountFrame:Close()
			mainframe:Close()
		end
	end
	sheet:AddSheet( "Loan Management", loanPanel, "icon16/money.png" )
end
net.Receive( "OpenDepositComputerMenu", DrawDepositMenu )
