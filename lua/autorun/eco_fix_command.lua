
timer.Simple( 10.1, function()
	if SERVER then
		hook.Add( "PlayerSay", "playersayfixeco", function( ply, text, public )
			if ( text == "!fixeco" ) and ply:Team() == TEAM_MAYOR then
				if !timer.Exists("ecofix_cooldown") or GetGlobalInt("MAYOR_Money") <= 300 and GetGlobalInt("MAYOR_EcoPoints") >= -30 then
					ply:ConCommand( "fixeco" )
					return ""
				else
					DarkRP.notify(ply, 2, 6, "You cannot perform this action.")
					return ""
				end
			end
		end )
	end
end)

timer.Simple( 10, function()
	if SERVER then
		concommand.Add( "fixeco", function()
			if GetGlobalInt("MAYOR_Money") >= 1000 or GetGlobalInt("MAYOR_EcoPoints") < -30 or timer.Exists("ecofix_cooldown") then return end
			timer.Create("ecofix_cooldown", 600, 1, function() end )
			SetGlobalInt("MAYOR_EcoPoints", GetGlobalInt("MAYOR_EcoPoints") - 30 )
			SetGlobalInt("MAYOR_Money", GetGlobalInt("MAYOR_Money") + 1000 )
			for k,ply in pairs(player.GetAll()) do
				DarkRP.notify(ply, 1, 6, "The mayor has increased the city's bank, at the cost of reputation.")
			end
		end )
	end
end )