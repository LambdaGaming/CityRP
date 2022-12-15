local map = game.GetMap()

function ActiveShooter()
	local shooter = ents.Create( "npc_citizen" )
	shooter:SetPos( table.Random( EventPos[map].Shooter ) )
	shooter:Spawn()
	shooter:Activate()
	shooter:Give( "weapon_smg1" )
	shooter:SetHealth( math.random( 100, 500 ) )
	for k,v in ipairs( player.GetAll() ) do
		shooter:AddEntityRelationship( v, D_HT, 99 )
	end
	shooter.IsEventNPC = true
	
	SetGlobalBool( "EventActive", true )
	SetGlobalString( "ActiveEvent", "Active Shooter" )
	for k,v in ipairs( player.GetAll() ) do
		if v:isCP() then
			DarkRP.notify( v, 0, 6, "Shots fired reported somewhere in the city! Suspect is holding out in a nearby building!" )
		end
	end
end

function ActiveShooterEnd( killer )
	local numcp = 1
	for k,v in ipairs( player.GetAll() ) do
		if v:isCP() and v:Team() != TEAM_MAYOR then
			numcp = numcp + 1
		end
	end
	local reward = 12000 + ( numcp * 4000 )
	DarkRP.notify( killer, 0, 10, "You have been given $"..reward.." and a crafting blueprint for stopping the threat." )
	GiveReward( killer, reward )
	if numcp > 1 then
		DarkRP.notify( killer, 2, 10, "Please distribute these earnings among those who helped you." )
	end
	for k,v in ipairs( player.GetAll() ) do
		if v:isCP() then
			DarkRP.notify( v, 0, 10, "The active shooter has been dealt with and is no longer a threat!" )
		end
	end
	ActiveEvents[EVENT_ACTIVE_SHOOTER] = false
end

local function ActiveShooterRelationship( ply )
	if IsEventActive( EVENT_ACTIVE_SHOOTER ) or IsEventActive( EVENT_ROBBERY ) then
		for k,v in pairs( ents.FindByClass( "npc_citizen" ) ) do
			if v.IsEventNPC or v.IsRobber then
				v:AddEntityRelationship( ply, D_HT, 99 )
			end
		end
	end
end
hook.Add( "PlayerInitialSpawn", "ActiveShooterRelationship", ActiveShooterRelationship )

local function ShooterKilled( npc, attacker, inflictor )
	if npc:GetClass() == "npc_citizen" then
		if npc.IsEventNPC then
			ActiveShooterEnd( attacker )
			for k,v in pairs( ents.FindInSphere( npc:GetPos(), 50 ) ) do
				if v:GetClass() == "weapon_smg1" then
					v:Remove()
				end
			end
		end
		if npc.IsRobber then
			for k,v in pairs( ents.FindInSphere( npc:GetPos(), 50 ) ) do
				timer.Simple( 1, function()
					if IsValid( v ) then
						local weplist = {
							["weapon_smg1"] = true,
							["weapon_pistol"] = true,
							["weapon_shotgun"] = true
						}
						if weplist[v:GetClass()] and !IsValid( v:GetOwner() ) then
							v:Remove()
						end
					end
				end )
			end
			if attacker:IsPlayer() then
				DarkRP.notify( attacker, 0, 6, "You have been rewarded with $1500 and a crafting blueprint for killing a robber." )
				GiveReward( attacker, 1500 )
			end
			RobberyEventStats.RobberCount = RobberyEventStats.RobberCount - 1
			if RobberyEventStats.RobberCount == 0 then
				RobberyEnd()
			end
		end
	end
end
hook.Add( "OnNPCKilled", "ShooterKilled", ShooterKilled )
