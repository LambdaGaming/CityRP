
hook.Add( "PlayerSay", "CokeReset", function( ply, text )
	if text == "!cokereset"
		if !ply:IsSuperAdmin() then
			DarkRP.notify( ply, 1, 6, "Only superadmins can use this command!" )
			return ""
		end
		local rand = math.random( 70, 590 )
		file.Write( "cokekey.txt", rand )
		DarkRP.notify( ply, 0, 6, "You have successfully changed the pure number for the coke system." )
		return ""
	end
end )