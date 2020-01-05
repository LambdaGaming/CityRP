
util.PrecacheModel( "models/props_interiors/pot02a.mdl" )

function CookInit(ply, before, after)
	if after == TEAM_COOK then ply.CookFish = 0 end
	
	if after != TEAM_COOK then ply.CookFish = nil end
end
hook.Add( "OnPlayerChangedTeam", "CookInit", CookInit )

MsgC( color_orange, "[CityRP] Loaded fish cooking initialization." )