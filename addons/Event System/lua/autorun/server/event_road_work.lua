local map = game.GetMap()

function RoadWork()
	local e = ents.Create( "pot_hole" )
	e:SetPos( table.Random( EventPos[map].Road ) )
	e:Spawn()
	NotifyJob( TEAM_TOWER, 0, 10, "Citizens have reported a large pothole in the area. Find and repair it." )
end

function RoadWorkEnd( ply, ent )
	DarkRP.notify( ply, 0, 10, "You have been rewarded with $4500 and a crafting blueprint for removing a pothole." )
	GiveReward( ply, 4500 )
	ActiveEvents[EVENT_ROAD_WORK] = false
end
