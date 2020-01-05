
if SERVER then
	hook.Add( "PlayerSay", "playersayfireoff", function( ply, text, public )
		if text == "!fireoff" then
			if ply:IsSuperAdmin() then
				RunConsoleCommand( "vfire_remove_all" )
				DarkRP.notifyAll( 0, 6, ply:Nick().." turned off all fires." )
			else
				DarkRP.notify( ply, 1, 6, "This command is superadmin only." )
			end
			return ""
        end
	end )
end

MsgC( color_orange, "[CityRP] Loaded !fireoff chat command." )