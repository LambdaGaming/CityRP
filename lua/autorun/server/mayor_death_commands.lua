local function EndEvents( ply )
	if ply:Team() == TEAM_MAYOR then
		if GetGlobalBool( "DarkRP_Purge" ) then DarkRP.endPurge( ply ) end
		if GetGlobalBool( "DarkRP_Parade" ) then DarkRP.endParade( ply ) end
	end
end
hook.Add( "DoPlayerDeath", "MayorEndCommands", EndEvents )
hook.Add( "PlayerDisconnected", "MayorEndCommandsDisconnect", EndEvents )
