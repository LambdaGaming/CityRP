function ActiveShooter()
	local map = game.GetMap()
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
	shooter.Participants = {}
	
	SetGlobalBool( "EventActive", true )
	SetGlobalString( "ActiveEvent", "Active Shooter" )
	for k,v in ipairs( player.GetAll() ) do
		if v:isCP() then
			DarkRP.notify( v, 0, 6, "Shots fired reported somewhere in the city! Suspect is holding out in a nearby building!" )
		end
	end
end

function ActiveShooterEnd( npc )
	for k,v in pairs( npc.Participants ) do
		DarkRP.notify( v, 0, 10, "You have been given $12,000 and a crafting blueprint for helping stop the threat." )
		GiveReward( v, 12000 )
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
	if npc.IsEventNPC then
		ActiveShooterEnd( npc )
		for k,v in pairs( ents.FindInSphere( npc:GetPos(), 50 ) ) do
			if v:GetClass() == "weapon_smg1" then
				v:Remove()
			end
		end
	elseif npc.IsRobber then
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
hook.Add( "OnNPCKilled", "ShooterKilled", ShooterKilled )

hook.Add( "EntityTakeDamage", "ShooterCountDamage", function( target, dmg )
	if target.IsEventNPC and !table.HasValue( target.Participants, dmg:GetAttacker() ) then
		table.insert( target.Participants, dmg:GetAttacker() )
	end
end )
