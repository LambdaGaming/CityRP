function MoneyTransfer()
	for k,v in ipairs( player.GetAll() ) do
		if v:isCP() or v:Team() == TEAM_BANKER then
			DarkRP.notify( v, 0, 6, "A check needs transferred from the banker NPC to the check machine!" )
		end
	end
end

function MoneyTransferEnd()
	for k,v in pairs( ents.FindByClass( "banker_npc" ) ) do
		v.checkused = false
	end
	ActiveEvents[EVENT_MONEY_TRANSFER] = false
end
