local function RespawnDelay( ply )
	if !IsValid( ply ) then return end
	ply:Lock()
	timer.Simple( 5, function()
		if !IsValid( ply ) then return end
		ply:UnLock()
	end )
end
hook.Add( "PlayerDeath", "RespawnDelay", RespawnDelay )
