function GetVaultAmount()
	return GetGlobalInt( "CityVaultMoney" )
end

function GetCityIncome()
	local income = GetGlobalInt( "CityIncome" )
	local govmoney = GetGlobalInt( "CityGovPayout" )
	return income + govmoney
end

function GetEcoPoints()
	return GetGlobalInt( "CityEcoPoints" )
end

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

if SERVER then
	local function CalculateEcoPoints()
		local income = math.Clamp( math.Round( ( GetCityIncome() + 5000 ) * 25 / 5000 - 25 ), -25, 25 )
		local funds = math.Clamp( math.Round( ( GetVaultAmount() + 50000 ) * 25 / 75000 - 25 ), -25, 25 )
		return income + funds
	end

	local function CheckMayorModel()
		if GetEcoPoints() >= 45 then
			local mayor = team.GetPlayers( TEAM_MAYOR )[1]
			mayor:SetModel( "models/Gigabreen/Gigabreen.mdl" )
		end
	end

	local function UpdateGovPayout()
		local govmoney = 0
		for k,v in ipairs( player.GetAll() ) do
			if v:isCP() then
				govmoney = govmoney - DarkRP.retrieveSalary( v )
			end
			if EcoPerkActive( "Double Gov Paychecks" ) then
				govmoney = govmoney * 2
			elseif EcoPerkActive( "Cut Gov Paychecks In Half" ) then
				govmoney = math.Round( govmoney / 2 )
			elseif EcoPerkActive( "Eliminate Gov Paychecks" ) then
				govmoney = 0
			end
		end
		SetGlobalInt( "CityGovPayout", govmoney )
	end

	function SetVaultAmount( amount )
		SetGlobalInt( "CityVaultMoney", amount )
		SetGlobalInt( "CityEcoPoints", CalculateEcoPoints() )
		CheckMayorModel()
	end

	function AddVaultFunds( amount )
		SetGlobalInt( "CityVaultMoney", GetGlobalInt( "CityVaultMoney" ) + amount )
		SetGlobalInt( "CityEcoPoints", CalculateEcoPoints() )
		CheckMayorModel()
	end

	function SetCityIncome( amount )
		SetGlobalInt( "CityIncome", amount )
		SetGlobalInt( "CityEcoPoints", CalculateEcoPoints() )
		CheckMayorModel()
	end

	function AddCityIncome( amount )
		SetGlobalInt( "CityIncome", GetGlobalInt( "CityIncome" ) + amount )
		SetGlobalInt( "CityEcoPoints", CalculateEcoPoints() )
		CheckMayorModel()
	end

	SetVaultAmount( 25000 )
	timer.Create( "CityIncomeLoop", 300, 0, function()
		local income = GetCityIncome()
		if income != 0 then
			local mayor = team.GetPlayers( TEAM_MAYOR )[1]
			local term = income > 0 and "gained" or "lost"
			AddVaultFunds( income )
			if IsValid( mayor ) then
				DarkRP.notify( mayor, 0, 6, "The city has "..term.." "..DarkRP.formatMoney( math.abs( income ) ) )
			end
		end
	end )

	hook.Add( "playerGetSalary", "ModifyGovSalary", function( ply, amount )
		if ply:isCP() then
			if amount > GetVaultAmount() then
				return false, "You do not receive a paycheck this cycle because the city is out of money.", 0
			end
			AddVaultFunds( -amount )
			return false, "[Paycheck] You have received "..DarkRP.formatMoney( amount ).." from your government salary.", amount
		end
	end )

	hook.Add( "OnPlayerChangedTeam", "UpdateCityIncome", UpdateGovPayout )
	hook.Add( "PlayerDisconnected", "UpdateCityIncomeDisconnect", UpdateGovPayout )
	hook.Add( "OnPerkChange", "PerkGovUpdate", UpdateGovPayout )
end
