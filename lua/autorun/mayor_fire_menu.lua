
if CLIENT then
	local MenuColor = Color( 49, 53, 61, 200 )
	local ButtonColor = Color( 230, 93, 80, 255 )
	local blacklist = {
		["IA Agent"] = true,
		["Mayor"] = true
	}
	local ems = {
		["ER Commander"] = true,
		["Emergency Responder"] = true
	}
	local function OpenFireMenu( ply )
		local menu = vgui.Create( "DFrame" )
		menu:SetTitle( "Double click on a player to fire them:" )
		menu:SetSize( ScrW() * 0.5, ScrH() * 0.5 )
		menu:Center()
		menu:MakePopup()
		menu.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, MenuColor )
		end
		menu.OnClose = function()
			ply.FireMenuOpen = false
		end

		local plylist = vgui.Create( "DListView", menu )
		plylist:Dock( FILL )
		plylist:SetMultiSelect( false )
		plylist:AddColumn( "Name" )
		plylist:AddColumn( "Job" )
		plylist:AddColumn( "Index" )
		for k,v in pairs( player.GetAll() ) do
			local name = team.GetName( v:Team() )
			if ( v:isCP() and !blacklist[name] ) or ems[name] then
				plylist:AddLine( v:Nick(), name, v:EntIndex() )
			end
		end
		function plylist:DoDoubleClick( id, line )
			net.Start( "FirePlayer" )
			net.WriteInt( line:GetValue( 3 ), 32 )
			net.SendToServer()
			menu:Close()
		end

		ply.FireMenuOpen = true
	end

	hook.Add( "PlayerButtonDown", "OpenFireMenu", function( ply, button )
		if !IsFirstTimePredicted() or ply.FireMenuOpen then return end
		if button == KEY_F6 and ply:Team() == TEAM_MAYOR then
			OpenFireMenu( ply )
		end
	end )
end

if SERVER then
	util.AddNetworkString( "FirePlayer" )
	net.Receive( "FirePlayer", function( len, ply )
		local index = net.ReadInt( 32 )
		if ply:Team() == TEAM_MAYOR then
			local ent = ents.GetByIndex( index )
			if IsValid( ent ) and ent:isCP() then
				ent:teamBan( ent:Team(), 600 )
				ent:changeTeam( TEAM_CITIZEN, true, true )
				DarkRP.notify( ent, 1, 6, "You have been fired by the mayor. You may attempt to return to your job after 10 minutes." )
				DarkRP.notify( ply, 0, 6, "You have fired "..ent:Nick().."." )
			end
		end
	end )
end
