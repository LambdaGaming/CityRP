DarkRP.createCategory{
    name = "Emergency Response",
    categorises = "jobs",
    startExpanded = true,
    color = Color( 255, 0, 0, 255 ),
    canSee = function( ply ) return true end,
    sortOrder = 400,
}

DarkRP.createCategory{
    name = "Government & Police",
    categorises = "jobs",
    startExpanded = true,
    color = Color( 0, 0, 255, 255 ),
    canSee = function( ply ) return true end,
    sortOrder = 500,
}

DarkRP.createCategory{
    name = "RP Items",
    categorises = "entities",
    startExpanded = true,
    color = color_black,
    canSee = function( ply ) return true end,
    sortOrder = 0
}

DarkRP.createCategory{
	name = "Cooking Items",
	categorises = "entities",
	startExpanded = true,
	color = Color( 255, 107, 0, 255 ),
	canSee = function( ply ) return true end,
	sortOrder = 104,
}
