local map = game.GetMap()

function RoadWork()
	local e = ents.Create( "pot_hole" )
	e:SetPos( table.Random( EventPos[map].Road ) )
	e:Spawn()
	DarkRP.notify( team.GetPlayers( TEAM_TOWER ), 0, 6, "Citizens have reported a large pothole in the area. Find and repair it." )
end

function RoadWorkEnd( ply, ent )
	local pos = ent:GetPos()
	ply:addMoney( 400 )
	DarkRP.notify( ply, 0, 6, "You have been rewarded with $400 and a crafting blueprint for removing a pothole." )
	local randwep = table.Random( BLUEPRINT_CONFIG_TIER2 )
	local e = ents.Create( "crafting_blueprint" )
	e:SetPos( pos + Vector( 0, 30, 0 ) )
	e:Spawn()
	e:SetEntName( randwep[1] )
	e:SetRealName( randwep[2] )
	e:SetUses( 3 )
	ActiveEvents[EVENT_ROAD_WORK] = false
end
