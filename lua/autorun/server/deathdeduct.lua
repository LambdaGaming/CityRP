hook.Add( "PlayerDeath", "DeductMoney", function( ply, inf, attack )
	if GetGlobalBool( "DarkRP_LockDown" ) then return end
	if ply:isArrested() then return end
	local wallet = ply:getDarkRPVar( "money" )
	local walletpercent = math.Round( wallet * 0.012 ) --1.2% of the players wallet
	ply:addMoney( -walletpercent )
	DarkRP.notify( ply, 0, 6, "You have lost $"..walletpercent.." as a result of your death." )
end )
