local map = game.GetMap()

PizzaEventStats = {
	SetPizza = "",
	SetNPC = "",
	NPCType = 0
}

local pizzas = {
	"Margarita",
	"Spinach",
	"Salami",
	"Olive",
	"Boneless",
	"Bacon",
	"Egg",
	"Mushroom",
	"Hawaii",
	"Cheese"
}

local npcs = {
	{ "npc_item", 1 }, --Supermarket
	{ "npc_item", 3 }, --Firefighter
	{ "npc_item", 4 }, --Police Secretary
	{ "npc_item", 6 }, --Healer
	{ "npc_item", 7 }, --Tow Truck Driver
	{ "npc_item", 8 }, --Job Broker
	{ "npc_item", 9 }, --Smuggle Seller
	"rp_dealer",
	"npc_farmer",
	"npc_fishshop",
	"smuggle_sell"
}

function FoodDelivery()
	local randnpc = table.Random( npcs )
	local npcname = ""
	PizzaEventStats.SetPizza = table.Random( pizzas )
	if type( randnpc ) == "table" then
		PizzaEventStats.SetNPC = randnpc[1]
		PizzaEventStats.NPCType = randnpc[2]
		npcname = ItemNPCType[randnpc[2]].Name
	else
		PizzaEventStats.SetNPC = randnpc
		npcname = ents.FindByClass( randnpc )[1].PrintName
	end
	for k,v in pairs( team.GetPlayers( TEAM_COOK ) ) do
		v:ChatPrint( "Deliver a "..PizzaEventStats.SetPizza.." pizza to the "..npcname )
	end
end

function FoodDeliveryEnd()
	ActiveEvents[EVENT_FOOD_DELIVERY] = false
	for k,v in pairs( team.GetPlayers( TEAM_COOK ) ) do
		v:ChatPrint( "Thanks. Here's $3,000 and a crafting blueprint." )
		GiveReward( v, 3000 )
	end
	PizzaEventStats = {
		SetPizza = "",
		SetNPC = "",
		NPCType = 0
	}
end
