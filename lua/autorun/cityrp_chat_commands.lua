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

--!fixeco
	hook.Add( "PlayerSay", "FixEcoCommand", function( ply, text, public )
		if text == "!fixeco" and ply:Team() == TEAM_MAYOR then
			local eco = GetGlobalInt( "MAYOR_EcoPoints" )
			local funds = GetGlobalInt( "MAYOR_Money" )
			if !timer.Exists("ecofix_cooldown") then
				if funds >= 300 then
					if eco < 0 then
						timer.Create("ecofix_cooldown", 600, 1, function() end )
						SetGlobalInt("MAYOR_EcoPoints", eco + 30 )
						SetGlobalInt("MAYOR_Money", funds - 300 )
						DarkRP.notifyAll( 0, 6, "The mayor has increased the economy by 30 points at the cost of $300 from the mayor funds.")
						return ""
					else
						DarkRP.notify( ply, 1, 6, "You cannot fix the eco at this time. The eco isn't low enough to require a fix." )
						return ""
					end
				else
					DarkRP.notify( ply, 1, 6, "You cannot fix the eco at this time. Not enough money in the mayor funds." )
					return ""
				end
			else
				DarkRP.notify( ply, 1, 6, "You cannot fix the eco at this time. The 10 minute cooldown is still in effect." )
				return ""
			end
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

--!undercover
	hook.Add( "PlayerSay", "SilentUndercover", function( ply, text )
		if text == "!undercover" then
			if ply:Team() == TEAM_UNDERCOVER then
				DarkRP.notify( ply, 1, 6, "You are already an Undercover Officer!" )
				return
			end
			if !ply:changeAllowed( TEAM_UNDERCOVER ) then
				DarkRP.notify( ply, 1, 6, "Please wait before changing jobs again." )
				return
			end
			ply:changeTeam( TEAM_UNDERCOVER, false, true )
			ply:updateJob( "Citizen" )
			DarkRP.notify( ply, 0, 6, "You have secretly changed your job to Undercover Officer." )
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
