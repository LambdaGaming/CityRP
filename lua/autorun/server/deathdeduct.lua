hook.Add( "PlayerDeath", "DeductMoney", function( ply, inf, attack )
	if !GetGlobalBool( "DarkRP_Purge" ) and !ply:isArrested() and !ply.HasLifeInsurance then
		local wallet = ply:getDarkRPVar( "money" )
		local walletpercent = math.Round( wallet * 0.012 ) --1.2% of the players wallet
		ply:addMoney( -walletpercent )
		DarkRP.notify( ply, 0, 6, "You have lost $"..walletpercent.." as a result of your death." )
	end
end )
