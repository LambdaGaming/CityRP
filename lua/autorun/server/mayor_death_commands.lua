
hook.Add( "DoPlayerDeath", "MayorEndCommands", function( ply )
	if ply:Team() == TEAM_MAYOR then
		if GetGlobalBool( "DarkRP_Purge" ) then DarkRP.endPurge( ply ) end
		if GetGlobalBool( "DarkRP_Parade" ) then DarkRP.endParade( ply ) end
	end
end )

MsgC( color_orange, "[CityRP] Loaded mayor death initialization." )