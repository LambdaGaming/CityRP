
include('shared.lua')

function ENT:Draw()
	self:DrawModel()
end

local DrawItems, DrawRecipes, DrawMainMenu

DrawItems = function( ent )
	local itemtable = {}
	local mainframe = vgui.Create( "DFrame" )
	mainframe:SetTitle( "Items currently on the table:" )
	mainframe:SetSize( 500, 500 )
	mainframe:Center()
	mainframe:MakePopup()
	mainframe.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, CRAFT_CONFIG_MENU_COLOR )
	end
	local backbutton = vgui.Create( "DButton", mainframe )
	backbutton:SetText( "Back" )
	backbutton:SetTextColor( CRAFT_CONFIG_BUTTON_TEXT_COLOR )
	backbutton:SetPos( 350, 3 )
	backbutton:SetSize( 50, 20 )
	backbutton.Paint = function( self, w, h )
		draw.RoundedBox( 10, 0, 0, w, h, CRAFT_CONFIG_BUTTON_COLOR )
	end
	backbutton.DoClick = function()
		mainframe:Close()
		DrawMainMenu( ent )
		surface.PlaySound( CRAFT_CONFIG_UI_SOUND )
	end

	local MenuReloadCooldown = 0
	local mainframescroll = vgui.Create( "DScrollPanel", mainframe )
	mainframescroll:Dock( FILL )
	for k,v in pairs( CraftingIngredient ) do
		if table.HasValue( itemtable, k ) then
			continue
		end --Prevents two or more of the same materials from being listed if they are used in more than one recipe
		local scrollbutton = vgui.Create( "DButton", mainframescroll )
		if ent:GetNWInt( "Craft_"..v.Name ) == nil then
			scrollbutton:SetText( v.Name..": 0" )
		else
			scrollbutton:SetText( v.Name..": "..ent:GetNWInt( "Craft_"..k ) )
		end
		scrollbutton:SetTextColor( CRAFT_CONFIG_BUTTON_TEXT_COLOR )
		scrollbutton:Dock( TOP )
		scrollbutton:DockMargin( 0, 0, 0, 5 )
		scrollbutton.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, CRAFT_CONFIG_BUTTON_COLOR )
		end
		scrollbutton.DoClick = function()
			if ent:GetNWInt( "Craft_"..k ) == nil or ent:GetNWInt( "Craft_"..k ) == 0 then
				surface.PlaySound( CRAFT_CONFIG_FAIL_SOUND )
				return
			end
			if MenuReloadCooldown > CurTime() then return end
			net.Start( "DropItem" )
			net.WriteEntity( ent )
			net.WriteString( k )
			net.SendToServer()
			timer.Simple( 0.3, function() --Small timer to let the net message go through
				mainframe:Close()
				DrawItems( ent )
			end )
			MenuReloadCooldown = CurTime() + 1
		end
		table.insert( itemtable, k )
	end
end

DrawRecipes = function( ent )
	local ply = LocalPlayer()
	local mainframe = vgui.Create( "DFrame" )
	mainframe:SetTitle( "Choose an item to craft:" )
	mainframe:SetSize( 500, 500 )
	mainframe:Center()
	mainframe:MakePopup()
	mainframe.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, CRAFT_CONFIG_MENU_COLOR )
	end
	local backbutton = vgui.Create( "DButton", mainframe )
	backbutton:SetText( "Back" )
	backbutton:SetTextColor( CRAFT_CONFIG_BUTTON_TEXT_COLOR )
	backbutton:SetPos( 350, 3 )
	backbutton:SetSize( 50, 20 )
	backbutton.Paint = function( self, w, h )
		draw.RoundedBox( 10, 0, 0, w, h, CRAFT_CONFIG_BUTTON_COLOR )
	end
	backbutton.DoClick = function()
		mainframe:Close()
		DrawMainMenu( ent )
		surface.PlaySound( CRAFT_CONFIG_UI_SOUND )
	end
	local mainframescroll = vgui.Create( "DScrollPanel", mainframe )
	mainframescroll:Dock( FILL )
	for a,b in ipairs( CraftingCategory ) do
		local mainlist = vgui.Create( "DPanelList" )
		mainlist:SetSpacing( 5 )
		mainlist:EnableHorizontal( false )

		local categorybutton = vgui.Create( "DCollapsibleCategory", mainframescroll )
		categorybutton:SetLabel( b.Name )
		categorybutton:Dock( TOP )
		categorybutton:DockMargin( 0, 15, 0, 5 )
		categorybutton:DockPadding( 5, 0, 5, 5 )
		categorybutton:SetContents( mainlist )
		categorybutton.Paint = function( self, w, h )
			draw.RoundedBox( 8, 0, 0, w, h, b.Color )
		end
		if b.StartCollapsed then
			categorybutton:SetExpanded( false )
		end
		categorybutton.NumEntries = 0
		for k,v in pairs( CraftingTable ) do --Looks over all recipes in the main CraftingTable table
			if v.Category != b.Name then --Puts items into their respective categories
				continue
			end
			local mainbuttons = vgui.Create( "DButton", mainframescroll )
			mainbuttons:SetText( v.Name )
			mainbuttons:SetTextColor( CRAFT_CONFIG_BUTTON_TEXT_COLOR )
			mainbuttons.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, CRAFT_CONFIG_BUTTON_COLOR )
			end
			mainbuttons.DoClick = function()
				chat.AddText( Color( 100, 100, 255 ), "[Crafting Table]: ", Color( 100, 255, 100 ), "<"..v.Name.."> ", color_white, v.Description )
				ply.SelectedCraftingItem = tostring( k ) --Temporarily saves the entity class name for the net message that goes through when the player presses the craft button
				ply.SelectedCraftingItemName = v.Name --Temporarily saves the actual name so it doesn't print the entity class name
				surface.PlaySound( CRAFT_CONFIG_SELECT_SOUND )
				mainframe:Close()
				DrawRecipes( ent ) --Refreshes the button so it shows the currently selected item
			end
			mainlist:AddItem( mainbuttons )
			categorybutton.NumEntries = categorybutton.NumEntries + 1

			local totalrequired = 0
			local totalamount = 0
			local amountimage = vgui.Create( "DImage", mainbuttons )
			amountimage:SetSize( 16, 16 )
			amountimage:CenterVertical()
			for c,d in pairs( v.Materials ) do
				if ent:GetNWInt( "Craft_"..c ) >= d then
					totalamount = totalamount + 1
				end
				totalrequired = totalrequired + 1
			end
			if totalamount >= totalrequired then
				amountimage:SetImage( "icon16/accept.png" )
			elseif math.Round( totalamount / totalrequired ) >= 0.50 then
				amountimage:SetImage( "icon16/error.png" )
			else
				amountimage:SetImage( "icon16/delete.png" )
			end
		end
		if categorybutton.NumEntries == 0 then
			categorybutton:Remove() --Remove the category if no recipes are using it
		end
	end
	local selectedbutton = vgui.Create( "DButton", mainframe )
	if ply.SelectedCraftingItemName then
		selectedbutton:SetText( "Currently Selected Item: "..ply.SelectedCraftingItemName )
	else
		selectedbutton:SetText( "Currently Selected Item: N/A" )
	end
	selectedbutton:SetTextColor( CRAFT_CONFIG_BUTTON_TEXT_COLOR )
	selectedbutton:SetPos( 5, 465 )
	selectedbutton:SetSize( 245, 30 )
	selectedbutton.Paint = function( self, w, h )
		draw.RoundedBoxEx( 10, 0, 0, w, h, CRAFT_CONFIG_BUTTON_COLOR, true, false, true, false )
	end
	local craftbutton = vgui.Create( "DButton", mainframe )
	craftbutton:SetText( "Craft Selected Item" )
	craftbutton:SetTextColor( CRAFT_CONFIG_BUTTON_TEXT_COLOR )
	craftbutton:Dock( BOTTOM )
	craftbutton:DockMargin( 250, 0, 0, 0 )
	craftbutton:SetSize( 245, 30 )
	craftbutton.Paint = function( self, w, h )
		draw.RoundedBoxEx( 10, 0, 0, w, h, CRAFT_CONFIG_BUTTON_COLOR, false, true, false, true )
	end
	craftbutton.DoClick = function()
		if !ply.SelectedCraftingItem then
			chat.AddText( Color( 100, 100, 255 ), "[Crafting Table]: ", color_white, "Please select an item to craft." )
			surface.PlaySound( CRAFT_CONFIG_FAIL_SOUND )
			return
		end
		net.Start( "StartCrafting" )
		net.WriteEntity( ent )
		net.WriteString( ply.SelectedCraftingItem )
		net.WriteString( ply.SelectedCraftingItemName )
		net.SendToServer()
		mainframe:Close()
		ply.SelectedCraftingItem = nil
		ply.SelectedCraftingItemName = nil
	end
end

DrawMainMenu = function( ent )
	local mainframe = vgui.Create( "DFrame" )
	mainframe:SetTitle( "Crafting Table - Main Menu" )
	mainframe:SetSize( 300, 150 )
	mainframe:Center()
	mainframe:MakePopup()
	mainframe.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, CRAFT_CONFIG_MENU_COLOR )
	end
	local recipesbutton = vgui.Create( "DButton", mainframe )
	recipesbutton:SetText( "View Recipes/Craft an Item" )
	recipesbutton:SetTextColor( CRAFT_CONFIG_BUTTON_TEXT_COLOR )
	recipesbutton:SetPos( 25, 50 )
	recipesbutton:SetSize( 250, 30 )
	recipesbutton:CenterHorizontal()
	recipesbutton.Paint = function( self, w, h )
		draw.RoundedBox( 10, 0, 0, w, h, CRAFT_CONFIG_BUTTON_COLOR )
	end
	recipesbutton.DoClick = function()
		DrawRecipes( ent )
		mainframe:Close()
		surface.PlaySound( CRAFT_CONFIG_UI_SOUND )
    end
	local itemsbutton = vgui.Create( "DButton", mainframe )
	itemsbutton:SetText( "View Items Currently on the Table" )
	itemsbutton:SetTextColor( CRAFT_CONFIG_BUTTON_TEXT_COLOR )
	itemsbutton:SetPos( 25, 100 )
	itemsbutton:SetSize( 250, 30 )
	itemsbutton:CenterHorizontal()
	itemsbutton.Paint = function( self, w, h )
		draw.RoundedBox( 10, 0, 0, w, h, CRAFT_CONFIG_BUTTON_COLOR )
	end
	itemsbutton.DoClick = function()
		DrawItems( ent )
		mainframe:Close()
		surface.PlaySound( CRAFT_CONFIG_UI_SOUND )
	end
end

net.Receive( "CraftingTableMenu", function( len ) --Receiving the net message to open the main crafting table menu
	local ent = net.ReadEntity()
	local ply = net.ReadEntity()
	local trace = ply:GetEyeTrace().Entity
	if trace != ent then return end
	DrawMainMenu( ent )
end )

net.Receive( "CraftMessage", function( len, ply ) --Have to network the entname into here since the client can't see it serverside
	local validfunction = net.ReadBool()
	local entname = net.ReadString()
	if validfunction then
		chat.AddText( Color( 100, 100, 255 ), "[Crafting Table]: ", color_white, "Successfully crafted a "..entname.." ." )
	else
		chat.AddText( Color( 100, 100, 255 ), "[Crafting Table]: ", color_white, "ERROR! Missing SpawnFunction for "..entname )
	end
end )