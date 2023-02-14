if SERVER then
	function SetVaultAmount( amount )
		SetGlobalInt( "CityVaultMoney", amount )
	end

	function AddVaultFunds( amount )
		SetGlobalInt( "CityVaultMoney", GetGlobalInt( "CityVaultMoney" ) + amount )
	end

	SetVaultAmount( 100000 )
end

function GetVaultAmount()
	return GetGlobalInt( "CityVaultMoney" )
end
