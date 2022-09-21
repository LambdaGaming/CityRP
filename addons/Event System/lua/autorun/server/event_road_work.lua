local map = game.GetMap()

function RoadWork()
	local e = ents.Create( "pot_hole" )
	e:SetPos( table.Random( EventPos[map].Road ) )
	e:Spawn()
	for k,v in pairs( team.GetPlayers( TEAM_TOWER ) ) do
		DarkRP.notify( v, 0, 10, "Citizens have reported a large pothole in the area. Find and repair it." )
	end
end

function RoadWorkEnd( ply, ent )
	local pos = ent:GetPos()
	DarkRP.notify( ply, 0, 10, "You have been rewarded with $4500 and a crafting blueprint for removing a pothole." )
	GiveReward( ply, 4500 )
	ActiveEvents[EVENT_ROAD_WORK] = false
end
