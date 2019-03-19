
if SERVER then
	hook.Add( "PlayerSay", "playersayfiremayor", function( ply, text, public )
		if text == "!firemayor" then
			if ply:Team() == TEAM_BOUNTY then
				if team.NumPlayers( TEAM_MAYOR ) == 0 then
					DarkRP.notify( ply, 1, 6, "There isn't a mayor to fire!" )
					return ""
				end
				local mayor = team.GetPlayers( TEAM_MAYOR )
				mayor:teamBan( TEAM_MAYOR, 600 )
				mayor:changeTeam( GAMEMODE.DefaultTeam, true, false )
				DarkRP.notifyAll( 0, 6, "Internal affairs has fired the mayor for being corrupt!" )
				return ""
			else
				DarkRP.notify( ply, 1, 6, "You must be an IA Agent to fire the mayor!" )
				return ""
			end
        	end
	end )
end
