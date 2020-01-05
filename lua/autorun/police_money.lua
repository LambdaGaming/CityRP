
local policejob = {
	[TEAM_POLICEBOSS] = true,
	[TEAM_OFFICER] = true,
	[TEAM_UNDERCOVER] = true,
	[TEAM_SWATBOSS] = true,
	[TEAM_SWAT] = true,
	[TEAM_FBI] = true,
	[TEAM_BANKER] = true
}

local function PoliceNotify( ply, amount, wallet )
	for k,v in pairs( player.GetAll() ) do
		if policejob[v:Team()] then
			if amount >= 10000 then
				DarkRP.notify(v, 1, 6, "Suspicious bank activity coming from "..ply:Nick().."." )
			end
		end
	end
end
hook.Add( "playerWalletChanged", "PoliceNotify", PoliceNotify )

MsgC( color_orange, "[CityRP] Loaded player wallet police notification." )