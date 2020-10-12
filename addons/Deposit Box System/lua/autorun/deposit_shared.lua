local function CanLockpick( ply, ent, tr )
	if ply:Team() != TEAM_BANKER and ent:GetClass() == "deposit_box" and ent.Locked then
		return true
	end
end
hook.Add( "canLockpick", "DepositCanLockpick", CanLockpick )

local function LockpickCompleted( ply, success, ent )
	if success and ent:GetClass() == "deposit_box" then
		if SERVER then
			local banker = team.GetPlayers( TEAM_BANKER )[1]
			ent:Open()
			timer.Remove( "InterestLoop"..ent.MoneyOwner:EntIndex() )
			DarkRP.notify( ent.MoneyOwner, 1, 6, "Your deposit box was broken into!" )
			DarkRP.notify( banker, 1, 6, "One of your deposit boxes was broken into!" )
			ply:wanted( banker, "Robbing a deposit box.", 600 )
			local e = ents.Create( "deposit_bag" )
			e:SetPos( ent:GetPos() + Vector( 0, 0, 30 ) )
			e:SetAngles( ent:GetAngles() )
			e:Spawn()
			e:SetColor( ent.MoneyOwner:GetPlayerColor():ToColor() )
			e.MoneyOwner = ply
			e.MoneyAmount = ent.MoneyAmount
			ent:Open()
			ent.MoneyOwner.HasDeposit = false
			ent.MoneyOwner = nil
			timer.Remove( "WithdrawRequest"..ply:EntIndex() )
			timer.Remove( "InterestLoop"..ply:EntIndex() )
			net.Start( "Deposit_DeleteOwner" )
			net.WriteEntity( ply.RequestedBox )
			net.Broadcast()
		end
		ent.MoneyOwner = nil
		ent.Locked = false
	end
end
hook.Add( "onLockpickCompleted", "DepositLockpickCompleted", LockpickCompleted )
