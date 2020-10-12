include( "shared.lua" )

function ENT:Draw()
    self:DrawModel()
end

local function DrawDepositMenu()
	local mainframe = vgui.Create( "DFrame" )
	mainframe:SetTitle( "Deposit Box Stats:" )
	mainframe:SetSize( 250, 500 )
	mainframe:Center()
	mainframe:MakePopup()
	mainframe.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, CRAFT_CONFIG_MENU_COLOR )
	end

	local mainframescroll = vgui.Create( "DScrollPanel", mainframe )
	mainframescroll:Dock( FILL )
	for k,v in pairs( ents.FindByClass( "deposit_box" ) ) do
		local mainlist = vgui.Create( "DPanelList" )
		mainlist:SetSpacing( 5 )
		mainlist:EnableHorizontal( false )

		local categorybutton = vgui.Create( "DCollapsibleCategory", mainframescroll )
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
end
net.Receive( "OpenDepositComputerMenu", DrawDepositMenu )
