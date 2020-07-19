
local function SilentUndercover( ply, text )
	if text == "!undercover" then
		if ply:Team() == TEAM_UNDERCOVER then
			DarkRP.notify( ply, 1, 6, "You are already an Undercover Officer!" )
			return
		end
		ply:changeTeam( TEAM_UNDERCOVER, false, true )
		ply:updateJob( "Citizen" )
		DarkRP.notify( ply, 0, 6, "You have secretly changed your job to Undercover Officer." )
	end	
end
hook.Add( "PlayerSay", "SilentUndercover", SilentUndercover )
