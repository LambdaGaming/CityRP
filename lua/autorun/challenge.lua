
ischallenged = false

hook.Add( "PlayerSpawn", "CheckChallenge", function( ply )
	if !file.Exists( "challenge", "DATA" ) then
		file.CreateDir( "challenge" )
	end
	if !file.Exists( "challenge/"..ply:SteamID64()..".txt", "DATA" ) then
		file.Write( "challenge/"..ply:SteamID64()..".txt", 0 )
	end
	if file.Read( "challenge/"..ply:SteamID64()..".txt", "DATA" ) == 1 then
		ply.ischallenged = true
	else
		ply.ischallenged = false
	end
end )

function Challenged( ply )
	ply.ischallenged = true
	file.Write( "challenge/"..ply:SteamID64()..".txt", 1 )
end

function UnChallenged() --Testing purposes only, formats everyone's challenged status back to 0
	for k,v in pairs( player.GetAll() ) do
		v.ischallenged = false
		file.Write( "challenge/"..v:SteamID64()..".txt", 0 )
	end
end