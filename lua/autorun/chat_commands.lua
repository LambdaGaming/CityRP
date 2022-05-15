if SERVER then
--!firemayor
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
				for k,v in ipairs( player.GetAll() ) do
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

--!addons
	util.AddNetworkString( "AddonCommand" )
	hook.Add( "PlayerSay", "playersaywebsiteaddons", function( ply, text, public )
		if text == "!addons" then
			net.Start( "AddonCommand" )
			net.Send( ply )
			return ""
		end
	end )

--!group
	util.AddNetworkString( "GroupCommand" )
	hook.Add( "PlayerSay", "playersaygroup", function( ply, text, public )
		if text == "!group" then
			net.Start( "GroupCommand" )
			net.Send( ply )
			return ""
		end
	end )

--!discord
	hook.Add( "PlayerSay", "playersaydiscord", function( ply, text, public )
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
	hook.Add( "PlayerSay", "playersayfixeco", function( ply, text, public )
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

--!showid
	hook.Add( "PlayerSay", "ShowID", function( ply, text )
		if text == "!showid" then
			local name = ply:Nick()
			local plyteam = ply:Team()
			local fakename = ply:GetNWString( "FakeName" )
			for k,v in pairs( ents.FindInSphere( ply:GetPos(), 250 ) ) do
				if v:IsPlayer() then
					DarkRP.talkToPerson( v, team.GetColor( plyteam ), "Real Name: ", color_white, name )
					if fakename == nil or fakename == "" or fakename == " " then
						DarkRP.talkToPerson( v, team.GetColor( plyteam ), "Fake Name: ", color_white, "N/A" )
					else
						DarkRP.talkToPerson( v, team.GetColor( plyteam ), "Fake Name: ", color_white, fakename )
					end
					DarkRP.talkToPerson( v, team.GetColor( plyteam ), "Occupation: ", color_white, team.GetName( plyteam ) )
					return ""
				end
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
