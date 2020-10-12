util.AddNetworkString( "Deposit_DeleteOwner" )
local function DeleteAllOwners()
	for k,v in pairs( ents.FindByClass( "deposit_box" ) ) do
		if v.MoneyOwner then
			v.MoneyOwner:addMoney( v.MoneyAmount )
			DarkRP.notify( v.MoneyOwner, 0, 6, "The banker has either disconnected or changed jobs. Your deposit box money has been added to your wallet." )
			v.MoneyOwner.HasDeposit = false
			timer.Remove( "InterestLoop"..v.MoneyOwner:EntIndex() )
			v.MoneyOwner = nil
			v:Open()
			net.Start( "Deposit_DeleteOwner" )
			net.WriteEntity( v )
			net.Broadcast()
		end
	end
end

local function ChatCommands( ply, text )
	if text == "!withdraw" then
		if ply.PendingRequest and ply.RequestedBox then
			if ply.RequestedBox.MoneyOwner != ply then
				DarkRP.notifyAll( 1, 10, "Something went wrong and the deposit box owners ended up getting mismatched during the withdraw process. OP needs to fix this." )
				return ""
			end
			local e = ents.Create( "deposit_bag" )
			e:SetPos( ply.RequestedBox:GetPos() + Vector( 0, 0, 30 ) )
			e:SetAngles( ply.RequestedBox:GetAngles() )
			e:Spawn()
			e:SetColor( ply:GetPlayerColor():ToColor() )
			e.MoneyOwner = ply
			e.MoneyAmount = ply.RequestedBox.MoneyAmount
			ply.RequestedBox.MoneyOwner = nil
			ply.RequestedBox:Open()
			ply.PendingRequest = false
			ply.HasDeposit = false
			DarkRP.notify( team.GetPlayers( TEAM_BANKER )[1], 0, 6, "Successfully withdrew "..ply:Nick().."'s money." )
			DarkRP.notify( ply, 0, 6, "You have accepted the withdraw request." )
			timer.Remove( "WithdrawRequest"..ply:EntIndex() )
			timer.Remove( "InterestLoop"..ply:EntIndex() )
			net.Start( "Deposit_DeleteOwner" )
			net.WriteEntity( ply.RequestedBox )
			net.Broadcast()
		else
			DarkRP.notify( ply, 1, 6, "You have no pending withdraw requests." )
		end
		return ""
	end
end
hook.Add( "PlayerSay", "DepositChatCommands", ChatCommands )

local function DroppedMoneyOwner( ply, amount, ent )
	ent.MoneyOwner = ply
end
hook.Add( "playerDroppedMoney", "DroppedMoneyOwner", DroppedMoneyOwner )

local function BankerChangedTeam( ply, old, new )
	if old == TEAM_BANKER then
		DeleteAllOwners()
	end
end
hook.Add( "OnPlayerChangedTeam", "BankerChangedTeam", BankerChangedTeam )

local function BankerLeft( ply )
	if ply:Team() == TEAM_BANKER then
		DeleteAllOwners()
	end
end
hook.Add( "PlayerDisconnected", "BankerLeft", BankerLeft )

local function SetMoneyOwnerGrav( ply, ent )
	if ent:GetClass() == "spawned_money" then
		ent.PickupOwner = ply
	end
end
hook.Add( "GravGunOnPickedUp", "SetMoneyOwnerGrav", SetMoneyOwnerGrav )

local function SetMoneyOwnerPhys( ply, ent )
	if ent:GetClass() == "spawned_money" then
		ent.PickupOwner = ply
	end
end
hook.Add( "PhysgunPickup", "SetMoneyOwnerPhys", SetMoneyOwnerPhys )
