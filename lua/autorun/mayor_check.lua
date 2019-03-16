
timer.Create( "MayorCheck", 300, 0, function()
	if team.NumPlayers( TEAM_MAYOR ) < 1 then
		if GetGlobalInt( "MAYOR_EcoPoints" ) >= -45 then
			if player.GetCount() <= 4 then return end
			if player.GetCount() == 5 then
				SetGlobalInt( "MAYOR_EcoPoints", GetGlobalInt( "MAYOR_EcoPoints" ) - 1 )
			elseif player.GetCount() >= 6 then
				SetGlobalInt( "MAYOR_EcoPoints", GetGlobalInt( "MAYOR_EcoPoints" ) - 2 )
				if SERVER then
					DarkRP.notifyAll( 1, 6, "The economy is going down because there is no mayor!" )
				end
			end
		end
	end
end )