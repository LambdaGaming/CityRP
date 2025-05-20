PlantTypes = {
	{
		Name = "Apple",
		PlantModel = "models/props/cs_office/plant01.mdl",
		FoodModel = "models/props/de_inferno/crate_fruit_break_gib2.mdl",
		GrowthTime = 100,
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
		GrowthTime = 400,
		HarvestAmount = 3,
		HealthAmount = 25,
		SellPrice = 225,
		LabelColor = color_yellow,
		LabelTextColor = color_black
	},
	{
		Name = "Cantaloupe",
		PlantModel = "models/props/de_inferno/largebush02.mdl",
		FoodModel = "models/hunter/misc/sphere025x025.mdl",
		FoodMaterial = "models/props_c17/FurnitureMetal001a",
		GrowthTime = 500,
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
		GrowthTime = 300,
		HarvestAmount = 6,
		HealthAmount = 25,
		SellPrice = 50,
		LabelColor = Color( 43, 29, 14 ),
		LabelTextColor = color_white
	},
	{
		Name = "Watermelon",
		PlantModel = "models/props/de_inferno/largebush02.mdl",
		FoodModel = "models/props_junk/watermelon01.mdl",
		GrowthTime = 600,
		HarvestAmount = 1,
		HealthAmount = 50,
		SellPrice = 800,
		LabelColor = color_green,
		LabelTextColor = color_white
	},
	{
		Name = "Cannabis (Normal)",
		PlantModel = "models/props/de_inferno/flower_barrel.mdl",
		GrowthTime = 300,
		HarvestAmount = 3,
		LabelColor = Color( 11, 102, 35 ),
		LabelTextColor = color_white,
		HarvestOverride = function( plant, count )
			local e = ents.Create( "drug_weed" )
			e:SetPos( plant:GetPos() + Vector( 0, 0, count * 5 ) )
			e:SetWeedType( "normal" )
			e:Spawn()
		end
	},
	{
		Name = "Cannabis (Spicy)",
		PlantModel = "models/props/de_inferno/flower_barrel.mdl",
		GrowthTime = 300,
		HarvestAmount = 1,
		LabelColor = Color( 11, 102, 35 ),
		LabelTextColor = color_white,
		HarvestOverride = function( plant, count )
			local e = ents.Create( "drug_weed" )
			e:SetPos( plant:GetPos() + Vector( 0, 0, 5 ) )
			e:SetWeedType( "spicy" )
			e:Spawn()
		end
	},
	{
		Name = "Coca Plant",
		PlantModel = "models/props/cs_office/plant01.mdl",
		GrowthTime = 900,
		HarvestAmount = 1,
		LabelColor = color_white,
		LabelTextColor = color_black,
		HarvestOverride = function( plant, count )
			local e = ents.Create( "raw_cocaine" )
			e:SetPos( plant:GetPos() + Vector( 0, 0, 5 ) )
			e:Spawn()
		end
	}
}

hook.Add( "ItemStoreCanPickup", "Farm_NoPlantInventory", function( ply, item, ent )
	if ent:GetClass() == "farm_plant" and ent:GetPlanted() then return false end
end )
