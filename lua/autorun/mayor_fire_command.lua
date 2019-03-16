
if SERVER then
	hook.Add( "PlayerSay", "playersayfiremayor", function( ply, text, public )
		if text == "!firemayor" and ply:Team() == TEAM_BOUNTY then
			for k,v in pairs( player.GetAll() ) do
				if v:Team() != TEAM_MAYOR then return end
				if v:Team() == TEAM_MAYOR then
					v:teamBan( TEAM_MAYOR, 600 )
					v:changeTeam( GAMEMODE.DefaultTeam, true, false )
				end
				DarkRP.notify( v, 0, 6, "Internal affairs has fired the mayor for being corrupt!" )
			end
			return ""
        end
	end )
end