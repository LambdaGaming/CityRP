local map = game.GetMap()

function DrunkDriver()
	local e = ents.Create( "reckless_dr_isaac_kleiner" )
	e:SetPos( table.Random( EventPos[map].Road ) + Vector( 0, 0, 10 ) )
	e:Spawn()
	e:Activate()
	NotifyCops( 0, 10, "Citizens are reporting a drunk driver in the area. Be on the lookout." )
end

function EndDrunkDriver( ent, ply )
	local pos = ent:GetPos()
	ent:Remove()
	for k,v in pairs( ents.FindInSphere( pos, 800 ) ) do
		if v:IsPlayer() and v:isCPNoMayor() then
			DarkRP.notify( ply, 0, 10, "You have been rewarded with $4,000 and a crafting blueprint for helping stop the drunk driver." )
			GiveReward( ply, 4000 )
		end
	end
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
