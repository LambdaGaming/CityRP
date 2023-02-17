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
		end
	end )

	hook.Add( "OnPlayerChangedTeam", "UpdateCityIncome", function()
		UpdateGovPayout()
	end )

	hook.Add( "PlayerDisconnected", "UpdateCityIncomeDisconnect", function()
		UpdateGovPayout()
	end )
end
