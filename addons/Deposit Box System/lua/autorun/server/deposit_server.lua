CreateConVar( "BankLoanRate", 0.005, FCVAR_UNLOGGED, "Percentage of the loan that the player has to pay back every 5 minutes.", 0.001, 0.01 )

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

function ReadLoanFile()
	if !file.Exists( "loans.json", "DATA" ) then
		file.Write( "loans.json", "[]" )
	end
	local json = file.Read( "loans.json", "DATA" )
	local tbl = util.JSONToTable( json )
	return tbl
end

local function UpdateLoanFile( tbl )
	if !file.Exists( "loans.json", "DATA" ) then
		file.Write( "loans.json", "[]" )
	end
	local json = util.TableToJSON( tbl )
	file.Write( "loans.json", json )
end

util.AddNetworkString( "LoanConfirmation" )
net.Receive( "LoanConfirmation", function( len, ply )
	local target = net.ReadEntity()
	local amount = net.ReadInt( 18 )
	DarkRP.notify( ply, 0, 6, "Awaiting confirmation from "..target:Nick().."..." )
	DarkRP.notify( target, 0, 10, "The banker has signed you up for a loan of "..DarkRP.formatMoney( amount )..". To confirm, type !confirmloan in chat." )
	target.PendingLoan = amount
	timer.Simple( 30, function()
		if !IsValid( target ) or !IsValid( ply ) then return end
		if target.AwaitingLoanConfirmation then
			DarkRP.notify( ply, 1, 6, ply:Nick().." never confirmed the loan!" )
			target.PendingLoan = nil
		end
	end )
end )

hook.Add( "PlayerSay", "LoanConfirmChat", function( ply, text )
	if text == "!confirmloan" and ply.PendingLoan then
		local banker = team.GetPlayers( TEAM_BANKER )[1]
		if !IsValid( banker ) then return end
		local tbl = ReadLoanFile()
		if tbl[ply:SteamID()] then
			DarkRP.notify( ply, 0, 6, "You cannot accept this loan as you already have one. If you're seeing this message it means OP screwed up." )
			ply.PendingLoan = nil
			return
		end
		ply:addMoney( ply.PendingLoan )
		DarkRP.notify( ply, 0, 6, "Loan accepted!" )
		DarkRP.notify( banker, 0, 6, ply:Nick().." has accepted the loan!" )
		tbl[ply:SteamID()] = {
			Initial = ply.PendingLoan,
			Remaining = ply.PendingLoan
		}
		ply.PendingLoan = nil
		UpdateLoanFile( tbl )
		return ""
	end
end )

timer.Create( "LoanLoop", 300, 0, function()
	local tbl = ReadLoanFile()
	local rate = GetConVar( "BankLoanRate" ):GetFloat()
	for k,v in ipairs( player.GetAll() ) do
		local entry = tbl[v:SteamID()]
		if entry then
			local ratevalue = entry.Initial * rate
			local realvalue = 0
			if entry.Remaining <= ratevalue then
				realvalue = entry.Remaining
			else
				realvalue = math.Round( ratevalue )
			end
			entry.Remaining = entry.Remaining - realvalue
			DarkRP.notify( v, 0, 6, "You have paid "..DarkRP.formatMoney( realvalue ).." toward your loan." )
			if entry.Remaining <= 0 then
				tbl[v:SteamID()] = nil
				DarkRP.notify( v, 0, 6, "You have fully paid off your loan!" )
			end
		end
	end
	UpdateLoanFile( tbl )
end )
