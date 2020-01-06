
local policejob = {
	["Police Chief"] = true,
	["Police Officer"] = true,
	["Undercover Officer"] = true,
	["SWAT Commander"] = true,
	["SWAT"] = true,
	["Mayors Bodyguard"] = true,
	["Banker"] = true
}

local function PoliceNotify( ply, amount, wallet )
	for k,v in pairs( player.GetAll() ) do
		if policejob[team.GetName( v:Team() )] then
			if amount >= 10000 then
				DarkRP.notify(v, 1, 6, "Suspicious bank activity coming from "..ply:Nick().."." )
			end
		end
	end
end
hook.Add( "playerWalletChanged", "PoliceNotify", PoliceNotify )

MsgC( color_orange, "[CityRP] Loaded player wallet police notification." )