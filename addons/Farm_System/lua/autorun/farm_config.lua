
PlantTypes = {
	[1] = {
		Name = "Apple", --Name of output food
		PlantModel = "models/props/cs_office/plant01.mdl", --Model of the grown plant
		FoodModel = "models/props/de_inferno/crate_fruit_break_gib2.mdl", --Model of the harvested food
		FoodMaterial = "", --Material of the harvested food
		GrowthTime = 120, --Time in seconds it takes to grow this plant
		HarvestAmount = 6, --Number of food items that spawn when harvesting this plant
		HealthAmount = 25, --Amount of health each food item from this plant restores when eaten
		SellPrice = 25, --Sell price of each food item
		LabelColor = color_red, --Color of the info label on the plant and seeds
		LabelTextColor = color_white --Color of the info label text
	},
	[2] = {
		Name = "Cabbage",
		PlantModel = "models/props/de_inferno/fountain_bowl_p10.mdl",
		FoodModel = "models/hunter/misc/sphere025x025.mdl",
		FoodMaterial = "models/props_c17/FurnitureMetal001a",
		GrowthTime = 480,
		HarvestAmount = 1,
		HealthAmount = 25,
		SellPrice = 225,
		LabelColor = Color( 177, 222, 160, 255 ),
		LabelTextColor = color_black
	},
	[3] = {
		Name = "Cantaloupe",
		PlantModel = "models/props/de_inferno/fountain_bowl_p10.mdl",
		FoodModel = "models/hunter/misc/sphere025x025.mdl",
		FoodMaterial = "models/props_c17/FurnitureMetal001a",
		GrowthTime = 600,
		HarvestAmount = 1,
		HealthAmount = 25,
		SellPrice = 500,
		LabelColor = color_orange,
		LabelTextColor = color_white
	},
	[4] = {
		Name = "Potato",
		PlantModel = "models/props/de_inferno/largebush02.mdl",
		FoodModel = "models/props/cs_italy/orange.mdl",
		FoodMaterial = "",
		GrowthTime = 360,
		HarvestAmount = 6,
		HealthAmount = 25,
		SellPrice = 50,
		LabelColor = Color( 43, 29, 14 ),
		LabelTextColor = color_white
	},
	[5] = {
		Name = "Watermelon",
		PlantModel = "models/props/de_inferno/fountain_bowl_p10.mdl",
		FoodModel = "models/props_junk/watermelon01.mdl",
		FoodMaterial = "",
		GrowthTime = 960,
		HarvestAmount = 1,
		HealthAmount = 50,
		SellPrice = 800,
		LabelColor = color_green,
		LabelTextColor = color_white
	}
}

hook.Add( "ItemStoreCanPickup", "Farm_NoPlantInventory", function( ply, item, ent )
	if ent:GetClass() == "farm_plant" and ent:GetPlanted() then return false end
end )