if SERVER then
--!firemayor
	local TotalVotes = {}
	local VoteCooldown = 0
	SetGlobalBool( "MayorFireVoteActive", false )
	hook.Add( "PlayerSay", "FireMayorCommand", function( ply, text, public )
		if text == "!firemayor" then
			local availableply = player.GetCount()
			local mayor = TEAM_MAYOR
			local minvotes = math.Round( availableply * 0.75 ) - 1 --Subtract 1 for the mayor

			if ply:Team() == mayor then
				DarkRP.notify( ply, 1, 6, "Why do you wanna fire yourself?" )
				return ""
			end
			if team.NumPlayers( mayor ) == 0 then
				DarkRP.notify( ply, 1, 6, "There isn't a mayor to fire!" )
				return ""
			end
			if TotalVotes[ply:SteamID64()] then
				DarkRP.notify( ply, 1, 6, "Your vote is already counted!" )
				return ""
			end
			if VoteCooldown > CurTime() then
				DarkRP.notify( ply, 1, 6, "Wait for the cooldown to end before starting another vote." )
				return ""
			end

			TotalVotes[ply:SteamID64()] = true
			local numvotes = table.Count( TotalVotes )
			if numvotes == minvotes then
				for k,v in pairs( team.GetPlayers( TEAM_MAYOR ) ) do
					v:teamBan( mayor, 1800 )
					v:changeTeam( GAMEMODE.DefaultTeam, true, false )
					DarkRP.notifyAll( 0, 6, "The mayor has been voted out of office!" )
					SetGlobalBool( "MayorFireVoteActive", false )
					timer.Remove( "FireMayorTimer" )
					TotalVotes = {}
					VoteCooldown = CurTime() + 600
					return ""
				end
			else
				if GetGlobalBool( "MayorFireVoteActive" ) then
					DarkRP.notifyAll( 0, 6, ply:Nick().." has cast their vote to fire the mayor. "..minvotes - numvotes.." more vote(s) needed to pass." )
				else
					SetGlobalBool( "MayorFireVoteActive", true )
					DarkRP.notifyAll( 0, 12, ply:Nick().." has initialized a vote to fire the mayor. Type !firemayor to cast your vote. "..minvotes - numvotes.." more vote(s) needed to pass." )
					timer.Create( "FireMayorTimer", 300, 1, function()
						SetGlobalBool( "MayorFireVoteActive", false )
						DarkRP.notifyAll( 1, 6, "Not enough people voted. The mayor gets to remain in office." )
						VoteCooldown = CurTime() + 300
					end )
				end
			end
			return ""
		end
	end )

--!addons
	util.AddNetworkString( "AddonCommand" )
	hook.Add( "PlayerSay", "AddonCommand", function( ply, text, public )
		if text == "!addons" then
			net.Start( "AddonCommand" )
			net.Send( ply )
			return ""
		end
	end )

--!group
	util.AddNetworkString( "GroupCommand" )
	hook.Add( "PlayerSay", "GroupCommand", function( ply, text, public )
		if text == "!group" then
			net.Start( "GroupCommand" )
			net.Send( ply )
			return ""
		end
	end )

--!discord
	hook.Add( "PlayerSay", "DiscordCommand", function( ply, text, public )
		if text == "!discord" then
			ply:ChatPrint( "https://discord.gg/9RGdUS2" )
			return ""
		end
	end )

--!rules
	util.AddNetworkString( "RulesCommand" )
	hook.Add( "PlayerSay", "RulesCommand", function( ply, text, public )
		if text == "!rules" then
			net.Start( "RulesCommand" )
			net.Send( ply )
			return ""
		end
	end )

--!fireoff
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

if CLIENT then
--!addons
	net.Receive( "AddonCommand", function( len, ply )
		gui.OpenURL( "https://steamcommunity.com/sharedfiles/filedetails/?id=629442313" )
	end )

--!group
	net.Receive( "GroupCommand", function( len, ply )
		gui.OpenURL( "http://steamcommunity.com/groups/lambdaG" )
	end )

--!rules
	net.Receive( "RulesCommand", function( len, ply ) 
		gui.OpenURL( "https://lambdagaming.github.io/cityrp/main.html" );
	end )
end
