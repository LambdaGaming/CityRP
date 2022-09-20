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
	DarkRP.notifyAll( 0, 6, "Shots fired reported somewhere in the city! Suspect is holding out in a nearby building!" )
end

function ActiveShooterEnd( killer )
	killer:addMoney( 600 )
	DarkRP.notify( killer, 0, 6, "You have been rewarded with $600 and a crafting blueprint for stopping the threat." )
	local randwep = table.Random( BLUEPRINT_CONFIG_TIER2 )
	local e = ents.Create( "crafting_blueprint" )
	e:SetPos( killer:GetPos() + Vector( 0, 30, 0 ) )
	e:SetAngles( killer:GetAngles() + Angle( 0, 180, 0 ) )
	e:Spawn()
	e:SetEntName( randwep[1] )
	e:SetRealName( randwep[2] )
	e:SetUses( 3 )
	for k,v in ipairs( player.GetAll() ) do
		if v != killer then
			DarkRP.notify( v, 0, 6, killer:Nick().." has killed the active shooter and ended the threat!" )
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
				attacker:addMoney( 200 )
				DarkRP.notify( attacker, 0, 6, "You have been rewarded with $200 and a crafting blueprint for killing a robber." )
				local randwep = table.Random( BLUEPRINT_CONFIG_TIER2 )
				local e = ents.Create( "crafting_blueprint" )
				e:SetPos( attacker:GetPos() + Vector( 0, 30, 0 ) )
				e:SetAngles( attacker:GetAngles() + Angle( 0, 180, 0 ) )
				e:Spawn()
				e:SetEntName( randwep[1] )
				e:SetRealName( randwep[2] )
				e:SetUses( 3 )
			end
			RobberCount = RobberCount - 1
			if RobberCount == 0 then
				RobberyEnd()
			end
		end
	end
end
hook.Add( "OnNPCKilled", "ShooterKilled", ShooterKilled )
