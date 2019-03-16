
local policejob = {
	TEAM_POLICEBOSS,
	TEAM_OFFICER,
	TEAM_UNDERCOVER,
	TEAM_SWATBOSS,
	TEAM_SWAT,
	TEAM_FBI,
	TEAM_BANKER
}

local function PoliceNotify( ply, amount, wallet )
	for k,v in pairs( player.GetAll() ) do
		if table.HasValue( policejob, v:Team() ) then
			if amount >= 10000 then
				DarkRP.notify(v, 1, 6, "Suspicious bank activity coming from "..ply:Nick().."." )
			end
		end
	end
end

hook.Add( "playerWalletChanged", "PoliceNotify", PoliceNotify )