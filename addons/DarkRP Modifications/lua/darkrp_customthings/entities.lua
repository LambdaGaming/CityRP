DarkRP.createEntity( "Microwave", {
    ent = "microwave",
    model = "models/props/cs_office/microwave.mdl",
    price = 400,
    max = 2,
    cmd = "buythemicrowave",
	category = "Cooking Items",
    allowed = { TEAM_COOK }
} )

DarkRP.createEntity( "Keg", {
    ent = "rp_keg",
    model = "models/props_c17/woodbarrel001.mdl",
    price = 0,
    max = 2,
    cmd = "keg",
    category = "Cooking Items",
    allowed = { TEAM_COOK }
} )

DarkRP.createEntity( "Cooking Stove", {
    ent = "cooking_stove",
    model = "models/props_c17/furnitureStove001a.mdl",
    price = 0,
    max = 3,
    cmd = "fishstove",
    allowed = { TEAM_COOK },
	category = "Cooking Items"
} )

DarkRP.createEntity( "Car Bomb Protection", {
    ent = "anti_bomb",
    model = "models/props_junk/metal_paintcan001a.mdl",
    price = 800,
    max = 1,
    cmd = "bombprotection",
	allowed = { TEAM_TOWER },
	category = "RP Items"
} )

DarkRP.createEntity( "Fire Hose Node", {
    ent = "fire_hose_node",
    model = "models/props_street/firehydrant.mdl",
    price = 50,
    max = 5,
    cmd = "firenode",
	allowed = { TEAM_FIREBOSS },
	category = "RP Items"
} )

DarkRP.createEntity( "Weapon Shipment", {
    ent = "custom_shipment",
    model = "models/Items/item_item_crate.mdl",
    price = 0,
    max = 5,
    cmd = "customshipment",
	allowed = { TEAM_GUN },
	category = "RP Items",
	spawn = function( ply, tr )
		local e = ents.Create( "custom_shipment" )
		e:SetPos( tr.HitPos )
		e:SetOwner( ply )
		e:Spawn()
		return e
	end
} )
