
hook.Add( "DoPlayerDeath", "MayorEndCommands", function( ply )
	if GetGlobalBool("DarkRP_Purge") then DarkRP.endPurge( ply ) end
	if GetGlobalBool("DarkRP_Parade") then DarkRP.endParade( ply ) end
end )