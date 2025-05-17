function MoneyTransfer()
	local npcs = ents.FindByClass( "npc_item" )
	local randNpc = table.Random( npcs )
	local npcName = ItemNPCType[randNPC:GetNPCType()].Name
	randNpc.HasMoneyBag = true
	NotifyJob( TEAM_BANKER, 0, 10, "Pickup a money bag from the "..npcName.." and deliver it to the bank vault." )
end

function MoneyTransferEnd()
	for k,v in ipairs( ents.FindByClass( "npc_item" ) ) do
		v.HasMoneyBag = nil
	end
	ActiveEvents[EVENT_MONEY_TRANSFER] = false
end

hook.Add( "PlayerUse", "BankerTransferUse", function( ply, ent )
	if ent:GetClass() == "npc_item" and ent.HasMoneyBag then
		local e = ents.Create( "bank_money" )
		e:SetPos( ent:GetPos() + ent:GetForward() * 10 )
		e:SetMoney( 2000 )
		e:Spawn()
		e.Legal = true
		ent.HasMoneyBag = nil
		DarkRP.notify( ply, 0, 6, "Take this money bag to the bank vault." )
		return false
	end
end )
