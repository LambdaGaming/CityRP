local map = game.GetMap()
local FirePicked = false

local function FireEventCreate( fire, parent )
	if !FirePicked then
		fire.IsEventFire = true
		FirePicked = true
	end
end

local function FireEventRemove( fire, parent )
	if fire.IsEventFire then
		HouseFireEnd()
	end
end

function HouseFire()
	hook.Add( "vFireCreated", "FireEventCreate", FireEventCreate )
	hook.Add( "vFireRemoved", "FireEventRemove", FireEventRemove )
	CreateVFireBall( 1200, 200, table.Random( EventPos[map].Fire ) + Vector( 0, 0, 100 ), Vector( 0, 0, 0 ), nil )
	for k,v in ipairs( player.GetAll() ) do
		if v:IsEMS() then
			DarkRP.notify( v, 0, 6, "A fire has been reported to have broken out in a residential building. Find the fire and put it out!" )
		end
	end
end

function HouseFireEnd()
    for k,v in ipairs( player.GetAll() ) do
    	if v:IsEMS() then
    		v:addMoney( 300 )
    		DarkRP.notify( v, 0, 6, "You have been rewarded with $300 and a crafting blueprint for helping extinguish a building fire." )
			local randwep = table.Random( BLUEPRINT_CONFIG_TIER2 )
			local e = ents.Create( "crafting_blueprint" )
			e:SetPos( v:GetPos() + Vector( 0, 30, 0 ) )
			e:Spawn()
			e:SetEntName( randwep[1] )
			e:SetRealName( randwep[2] )
			e:SetUses( 3 )
    	end
	end
	hook.Remove( "vFireCreated", "FireEventCreate" )
	hook.Remove( "vFireRemoved", "FireEventRemove" )
	FirePicked = false
	ActiveEvents[EVENT_HOUSE_FIRE] = false
end
