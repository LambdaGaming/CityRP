PlantTypes = {
	{
		Name = "Apple",
		PlantModel = "models/props/cs_office/plant01.mdl",
		FoodModel = "models/props/de_inferno/crate_fruit_break_gib2.mdl",
		FoodMaterial = "",
		GrowthTime = 120,
		HarvestAmount = 6,
		HealthAmount = 25,
		SellPrice = 25,
		LabelColor = color_red,
		LabelTextColor = color_white
	},
	{
		Name = "Banana",
		PlantModel = "models/props/cs_office/plant01.mdl",
		FoodModel = "models/props/cs_italy/bananna.mdl",
		FoodMaterial = "models/props_c17/FurnitureMetal001a",
		GrowthTime = 480,
		HarvestAmount = 3,
		HealthAmount = 25,
		SellPrice = 225,
		LabelColor = color_yellow,
		LabelTextColor = color_black
	},
	{
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
	{
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
	{
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
