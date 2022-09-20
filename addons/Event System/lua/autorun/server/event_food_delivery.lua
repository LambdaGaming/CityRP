local map = game.GetMap()

function FoodDelivery()
	local e = ents.Create( "npc_pizza" )
	e:SetPos( table.Random( EventPos[map].Food ) )
	e:Spawn()
	e:Activate()
	DarkRP.notify( team.GetPlayers( TEAM_COOK ), 0, 6, "A hungry customer wants a "..e:GetNWString( "SetPizza" ).."!" )
end

function FoodDeliveryEnd()
	ActiveEvents[EVENT_FOOD_DELIVERY] = false
	for k,v in pairs( team.GetPlayers( TEAM_COOK ) ) do
		DarkRP.notify( v, 0, 6, "The hungry customer has been served!" )
	end
end
