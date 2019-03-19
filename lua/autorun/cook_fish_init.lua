
util.PrecacheModel( "models/props_interiors/pot02a.mdl" ) --We need to precache the pot model so it can be spawned on the stove when the player uses it

function CookInit(ply, before, after)
	if after == TEAM_COOK then ply.CookFish = 0 end --Init the CookFish variable for this player if they changed their job to cook
	
	if after != TEAM_COOK then ply.CookFish = nil end --Remove the CookFish variable from this player if they changed from a cook to a different job
end
hook.Add( "OnPlayerChangedTeam", "CookInit", CookInit )
