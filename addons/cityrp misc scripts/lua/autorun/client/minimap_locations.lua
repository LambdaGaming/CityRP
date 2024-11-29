hook.Add( "Initialize", "PopulateMinimapLocations", function()
	local map = game.GetMap()
	local blips = {
		["rp_rockford_v2b"] = {
			{ Vector( 1861, 3915, 544 ), "icon16/user_suit.png" }, --Clothing shop
			{ Vector( -3188, -3185, 32 ), "icon16/money_dollar.png" }, --Bank
			{ Vector( -4647, -862, 0 ), "icon16/car.png" }, --Car dealer
			{ Vector( -5982, -3228, 8 ), "icon16/fire.png" }, --Fire station
			{ Vector( -298, -5853, 64 ), "icon16/pill.png" }, --Hospital
			{ Vector( 13009, -12885, 248 ), "icon16/water.png" }, --Dock
			{ Vector( -7963, 9266, 8 ), "icon16/cog.png" }, --Smelter
			{ Vector( -8039, -5791, 0 ), "icon16/shield.png" }, --Police station
			{ Vector( -4632, -5484, 64 ), "icon16/star.png" }, --City hall
			{ Vector( -14555, -11601, 0 ), "icon16/ruby.png" }, --Rock and tree grinders
			{ Vector( -7286, -66, 8 ), "icon16/wrench.png" }, --Mechanic's shop
			{ Vector( 1448, 6055, 574 ), "icon16/cart.png" }, --Supermarket
		},
		["rp_truenorth_v1a"] = {
			{ Vector( 8726, 9778, 8 ), "icon16/user_suit.png" },
			{ Vector( 6909, 2590, 8 ), "icon16/money_dollar.png" },
			{ Vector( 6194, 13036, 8 ), "icon16/car.png" },
			{ Vector( 13067, 11662, 8 ), "icon16/fire.png" },
			{ Vector( 13311, 13179, 64 ), "icon16/pill.png" },
			{ Vector( 12043, -7519, 5346 ), "icon16/water.png" },
			{ Vector( 12900, -11312, 0 ), "icon16/cog.png" },
			{ Vector( 2306, 3367, 8 ), "icon16/shield.png" },
			{ Vector( 5062, 3327, 72 ), "icon16/star.png" },
			{ Vector( -8504, 14609, 0 ), "icon16/ruby.png" },
			{ Vector( 9510, 13659, 0 ), "icon16/wrench.png" },
			{ Vector( 14936, 9923, 8 ), "icon16/cart.png" },
		},
		["rp_southside_day"] = {
			{ Vector( -2094, 10753, 128 ), "icon16/user_suit.png" },
			{ Vector( -1533, 2305, -104 ), "icon16/money_dollar.png" },
			{ Vector( -7184, 1582, -32 ), "icon16/car.png" },
			{ Vector( 9251, 1540, -104 ), "icon16/fire.png" },
			{ Vector( 7413, 5116, -56 ), "icon16/pill.png" },
			{ Vector( 5231, -5173, -320 ), "icon16/water.png" },
			{ Vector( -12409, 9515, 248 ), "icon16/cog.png" },
			{ Vector( 7949, 7898, 200 ), "icon16/shield.png" },
			{ Vector( 3001, 5061, 0 ), "icon16/star.png" },
			{ Vector( -14129, -9443, -174 ), "icon16/ruby.png" },
			{ Vector( -2203, 6545, 24 ), "icon16/wrench.png" },
			{ Vector( -5954, 1326, -24 ), "icon16/cart.png" },
			{ Vector( 617, 14146, 128 ), "icon16/cart.png" }, --Extra supermarket
		},
		["rp_riverden_v1a"] = {
			{ Vector( -4269, 8438, 0 ), "icon16/user_suit.png" },
			{ Vector( -11881, 14406, 0 ), "icon16/money_dollar.png" },
			{ Vector( -4146, 11029, 1 ), "icon16/car.png" },
			{ Vector( -12319, 1445, -256 ), "icon16/fire.png" },
			{ Vector( -6055, 1913, -256 ), "icon16/pill.png" },
			{ Vector( 12560, 3439, 679 ), "icon16/water.png" },
			{ Vector( -8494, 9993, 1 ), "icon16/shield.png" },
			{ Vector( -11071, 12337, 128 ), "icon16/star.png" },
			{ Vector( 11160, 6239, 780 ), "icon16/ruby.png" },
			{ Vector( -2099, 6844, -250 ), "icon16/wrench.png" },
			{ Vector( -9408, 1209, -256 ), "icon16/cart.png" },
			{ Vector( 6765, -14291, 776 ), "icon16/cart.png" }, --Extra supermarket
		}
	}
	for k,v in pairs( blips[map] ) do
		local showalt = map == "rp_truenorth_v1a"
		GMinimap:AddBlip( {
			position = v[1],
			icon = v[2],
			scale = 1,
			indicateAlt = showalt
		} )
	end
end )
