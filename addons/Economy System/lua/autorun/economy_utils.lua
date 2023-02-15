if SERVER then
	EconomyPerks = {}

	local function CalculateEcoPoints()
		local income = math.Clamp( math.Round( ( GetCityIncome() + 5000 ) * 25 / 5000 - 25 ), -25, 25 )
		local funds = math.Clamp( math.Round( ( GetVaultAmount() + 50000 ) * 25 / 100000 - 25 ), -25, 25 )
		return income + funds
	end

	function SetVaultAmount( amount )
		SetGlobalInt( "CityVaultMoney", amount )
		SetGlobalInt( "CityEcoPoints", CalculateEcoPoints() )
	end

	function AddVaultFunds( amount )
		SetGlobalInt( "CityVaultMoney", GetGlobalInt( "CityVaultMoney" ) + amount )
		SetGlobalInt( "CityEcoPoints", CalculateEcoPoints() )
	end

	function SetCityIncome( amount )
		SetGlobalInt( "CityIncome", amount )
		SetGlobalInt( "CityEcoPoints", CalculateEcoPoints() )
	end

	function AddCityIncome( amount )
		SetGlobalInt( "CityIncome", GetGlobalInt( "CityIncome" ) + amount )
		SetGlobalInt( "CityEcoPoints", CalculateEcoPoints() )
	end

	SetVaultAmount( 50000 )
	timer.Create( "CityIncomeLoop", 300, 0, function()
		local income = GetCityIncome()
		if income > 0 then
			local mayor = team.GetPlayers( TEAM_MAYOR )[1]
			AddVaultFunds( income )
		end
	end )
end

function GetVaultAmount()
	return GetGlobalInt( "CityVaultMoney" )
end

function GetCityIncome()
	return GetGlobalInt( "CityIncome" )
end

function GetEcoPoints()
	return GetGlobalInt( "CityEcoPoints" )
end
