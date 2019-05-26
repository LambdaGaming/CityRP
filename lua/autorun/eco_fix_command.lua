
timer.Simple( 10, function()
	if SERVER then
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
	end
end )