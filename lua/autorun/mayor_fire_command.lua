
if SERVER then
	local TotalVotes = {}
	SetGlobalBool( "MayorFireVoteActive", false )
	hook.Add( "PlayerSay", "playersayfiremayor", function( ply, text, public )
		local availableply = player.GetCount()
		local mayor = TEAM_MAYOR
		local minvotes = math.Round( availableply * 0.75 ) - 2 --Subtract 2 for IA agent and mayor
		if text == "!firemayor" then
			if ply:Team() == TEAM_BOUNTY then
				if team.NumPlayers( mayor ) == 0 then
					DarkRP.notify( ply, 1, 6, "There isn't a mayor to fire!" )
					return ""
				end
				if availableply <= 1 then
					DarkRP.notify( ply, 1, 6, "You and the mayor are the only two players on the server." )
					return ""
				end
				SetGlobalBool( "MayorFireVoteActive", true )
				DarkRP.notifyAll( 0, 12, "Internal affairs has initialized a vote to fire the mayor. Type !firevote in chat to add your vote." )
				return ""
			else
				DarkRP.notify( ply, 1, 6, "You must be an IA Agent to initialize a vote to fire the mayor!" )
				return ""
			end
        end
		if text == "!firevote" then
			local numvotes = #TotalVotes
			if !GetGlobalBool( "MayorFireVoteActive" ) then
				DarkRP.notify( ply, 1, 6, "There is no vote currently active!" )
				return ""
			end
			if ply:Team() == TEAM_BOUNTY or table.HasValue( TotalVotes, ply:UniqueID() ) then
				DarkRP.notify( ply, 1, 6, "Your vote is already counted!" )
				return ""
			end
			table.insert( TotalVotes, ply:UniqueID() )
			if numvotes == minvotes then
				for k,v in pairs( player.GetAll() ) do
					if v:Team() == mayor then
						v:teamBan( mayor, 600 )
						v:changeTeam( GAMEMODE.DefaultTeam, true, false )
						DarkRP.notifyAll( 0, 6, "The mayor has been voted out of office!" )
						SetGlobalBool( "MayorFireVoteActive", false )
						TotalVotes = {}
						return ""
					end
				end
			else
				DarkRP.notifyAll( 0, 6, ply:Nick().." has voted to fire the mayor. "..minvotes - numvotes.." more vote(s) needed to pass." )
				return ""
			end
			DarkRP.notify( ply, 0, 6, "Your vote to fire the mayor has been added!" )
			return ""
		end
	end )
end

MsgC( color_orange, "[CityRP] Loaded mayor fire chat commands." )