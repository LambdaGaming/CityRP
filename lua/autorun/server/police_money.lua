local policejob = {
	["Police Chief"] = true,
	["Police Officer"] = true,
	["Undercover Officer"] = true,
	["SWAT Commander"] = true,
	["SWAT"] = true,
	["Mayors Bodyguard"] = true,
	["Banker"] = true,
	["Detective"] = true
}

local function PoliceNotify( ply, amount, wallet )
	for k,v in ipairs( player.GetAll() ) do
		if policejob[team.GetName( v:Team() )] and amount >= 10000 then
			DarkRP.notify( v, 1, 6, "Suspicious bank activity coming from "..ply:Nick().."." )
		end
	end
end
hook.Add( "playerWalletChanged", "PoliceNotify", PoliceNotify )
