EVENT_OVERTURNED_TRUCK = 1
EVENT_ACTIVE_SHOOTER = 2
EVENT_HOUSE_FIRE = 3
EVENT_MONEY_TRANSFER = 4
EVENT_FOOD_DELIVERY = 5
EVENT_ROAD_WORK = 6
EVENT_ROBBERY = 7
EVENT_DRUNK_DRIVER = 8
EVENT_BUS_PASSENGER = 9

EventList = {
	[EVENT_OVERTURNED_TRUCK] = {
		Name = "Overturned Truck",
		Desc = "A semi truck took a curve too fast and overturned. The road is blocked and needs cleared. The truck is also leaking fuel and may combust if not cleaned up quickly.",
		Func = OverturnedTruck,
		Teams = { TEAM_TOWER }
	},
	[EVENT_ACTIVE_SHOOTER] = {
		Name = "Active Shooter",
		Desc = "A gunman is going on a rampage shooting at anything that moves. His current location is unknown, but according to witnesses he is targeting popular buildings.",
		Func = ActiveShooter,
		Teams = { TEAM_OFFICER, TEAM_UNDERCOVER, TEAM_POLICEBOSS },
		Min = 2
	},
	[EVENT_HOUSE_FIRE] = {
		Name = "House Fire",
		Desc = "A fire has broken out in a residential structure. It needs taken care of before it spreads out of control.",
		Func = HouseFire,
		Teams = { TEAM_FIRE, TEAM_FIREBOSS }
	},
	[EVENT_MONEY_TRANSFER] = {
		Name = "Tax Collection",
		Desc = "Pickup a money bag from a local business and safely deliver it to the bank vault.",
		Func = MoneyTransfer,
		Teams = { TEAM_BANKER }
	},
	[EVENT_FOOD_DELIVERY] = {
		Name = "Food Delivery",
		Desc = "A customer is requesting a pizza. Make the correct type and deliver it to them.",
		Func = FoodDelivery,
		Teams = { TEAM_COOK }
	},
	[EVENT_ROAD_WORK] = {
		Name = "Road Work",
		Desc = "A massive pothole has appeared on one of the main roads in the city. Shut down the affected road and make repairs before it damages someone's vehicle.",
		Func = RoadWork,
		Teams = { TEAM_TOWER }
	},
	[EVENT_ROBBERY] = {
		Name = "Bank Robbery",
		Desc = "Armed thugs are currently robbing the bank. Stop them before they can escape with a large amount of cash!",
		Func = Robbery,
		Teams = { TEAM_BANKER, TEAM_OFFICER, TEAM_UNDERCOVER, TEAM_POLICEBOSS },
		Min = 2
	},
	[EVENT_DRUNK_DRIVER] = {
		Name = "Drunk Driver",
		Desc = "Citizens are reporting a drunk person driving recklessly in the area. Attempt to locate and arrest them.",
		Func = DrunkDriver,
		Teams = { TEAM_OFFICER, TEAM_UNDERCOVER, TEAM_POLICEBOSS }
	},
	[EVENT_BUS_PASSENGER] = {
		Name = "Passenger Pickup",
		Desc = "Drive around the city and pickup people and take them to a central location.",
		Func = DrunkDriver,
		Teams = { TEAM_BUS }
	}
}
