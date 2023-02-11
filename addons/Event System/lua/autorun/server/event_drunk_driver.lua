local map = game.GetMap()

function DrunkDriver()
	local e = ents.Create( "reckless_dr_isaac_kleiner" )
	e:SetPos( table.Random( EventPos[map].Road ) + Vector( 0, 0, 10 ) )
	e:Spawn()
	e:Activate()
	NotifyCops( 0, 10, "Citizens are reporting a drunk driver in the area. Be on the lookout." )
end

function EndDrunkDriver( ent, ply )
	local numcp = 1
	for k,v in ipairs( player.GetAll() ) do
		if v:isCP() and v:Team() != TEAM_MAYOR then
			numcp = numcp + 1
		end
	end
	local reward = 12000 + ( numcp * 4000 )
	ent:Remove()
	DarkRP.notify( ply, 0, 10, "You have been rewarded with $"..reward.." and a crafting blueprint for arresting the drunk driver." )
	if numcp > 1 then
		DarkRP.notify( ply, 2, 10, "Please distribute these earnings among those who helped you." )
	end
	GiveReward( ply, reward )
	ActiveEvents[EVENT_DRUNK_DRIVER] = false
end

local usecooldown = 0
hook.Add( "PlayerUse", "DrunkDriverUse", function( ply, ent )
	if usecooldown < CurTime() and ent:GetNWBool( "_OwnedByRecklessDriverKleiner" ) then
		if ply:isCP() then
			if ent:GetVelocity():Length() <= 10 then
				EndDrunkDriver( ent, ply )
			else
				DarkRP.notify( ply, 1, 6, "Slow the car down before attempting to remove the driver." )
			end
		else
			DarkRP.notify( ply, 0, 6, "This driver appears to be impaired. Call the police." )
		end
		usecooldown = CurTime() + 1
	end
end )
