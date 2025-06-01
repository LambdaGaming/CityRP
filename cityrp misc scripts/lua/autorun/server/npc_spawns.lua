local function CreateEnt( class, pos, ang, typ )
	local e = ents.Create( class )
	e:SetPos( pos )
	e:SetAngles( ang )
	e:Spawn()
	e:Activate()
	if typ then
		e:ApplyType( typ )
	end
	return e
end

local angle_ninety = Angle( 0, 90, 0 )
local angle_negninety = Angle( 0, -90, 0 )
local angle_oneeighty = Angle( 0, 180, 0 )
local nextPos = 1
local locations = {
	["rp_rockford_v2b"] = {
		{ Vector( -14512, 2331, 392 ), angle_negninety },
		{ Vector( -10394, 3400, 8 ), angle_zero },
		{ Vector( -4142, -4390, 8 ), angle_negninety },
		{ Vector( 13410, 7288, 1540 ), angle_zero }
	},
	["rp_southside_day"] = {
		{ Vector( 3741, 924, -96 ), angle_zero },
		{ Vector( -12633, 9493, 248 ), angle_zero },
		{ Vector( 3439, 5832, 24 ), angle_zero },
		{ Vector( 4214, 2962, -70 ), angle_negninety }
	},
	["rp_riverden_v1a"] = {
		{ Vector( -6674, 11404, 0 ), angle_zero },
		{ Vector( -198, 13682, 0 ), angle_zero },
		{ Vector( -4476, 1835, -256 ), angle_ninety },
		{ Vector( -8632, -5435, -264 ), angle_negninety }
	},
	["rp_truenorth_v1a"] = {
		{ Vector( 10564, 12476, 8 ), angle_ninety },
		{ Vector( 11584, 10942, 0 ), angle_zero },
		{ Vector( 1503, 83, 0 ), angle_ninety },
		{ Vector( -6261, -3112, 3329 ), Angle( 0, -175, 0 ) }
	}
}

hook.Add( "InitPostEntity", "LoadNPCsCityRP", function()
	local map = game.GetMap()
	if map == "rp_rockford_v2b" then
		CreateEnt( "smuggle_sell", Vector( -14461, 2342, 392 ), angle_negninety )
		CreateEnt( "npc_item", Vector( 1613, 6095, 574 ), angle_negninety, 1 )
		CreateEnt( "npc_item", Vector( -613, 6085, 536 ), angle_negninety, 2 )
		CreateEnt( "npc_item", Vector( -5808, -3152, 8 ), angle_oneeighty, 3 )
		CreateEnt( "npc_item", Vector( -8781, -5573, 8 ), angle_negninety, 4 )
		CreateEnt( "npc_item", Vector( -67, -5909, 64 ), angle_oneeighty, 6 )
		CreateEnt( "npc_item", Vector( -7288, 215, 8 ), angle_zero, 7 )
		CreateEnt( "npc_item", Vector( 1996, 3875, 544 ), angle_zero, 9 )
		local deposit = CreateEnt( "deposit_box", Vector( -3613, -3575, 68 ), angle_ninety )
		deposit:SpawnExtraBoxes()
	elseif map == "rp_southside_day" then
		CreateEnt( "smuggle_sell", Vector( 3711, 923, -96 ), angle_zero )
		CreateEnt( "npc_item", Vector( -5911, 1437, -22 ), angle_negninety, 1 )
		CreateEnt( "npc_item", Vector( 551, 13973, 128 ), angle_zero, 1 ) --2 supermarkets on southside
		CreateEnt( "npc_item", Vector( -9452, 1698, 0 ), angle_ninety, 2 )
		CreateEnt( "npc_item", Vector( 9858, 1085, 96 ), angle_oneeighty, 3 )
		CreateEnt( "npc_item", Vector( 7883, 8052, 200 ), angle_negninety, 4 )
		CreateEnt( "npc_item", Vector( 7518, 5420, -55 ), angle_negninety, 6 )
		CreateEnt( "npc_item", Vector( -2376, 6730, 24 ), angle_zero, 7 )
		CreateEnt( "npc_item", Vector( -2165, 10542, 133 ), angle_ninety, 9 )
		local deposit = CreateEnt( "deposit_box", Vector( -745, 2968, -42 ), angle_oneeighty )
		deposit:SpawnExtraBoxes()
	elseif map == "rp_riverden_v1a" then
		CreateEnt( "smuggle_sell", Vector( -6645, 11407, 0 ), angle_zero )
		CreateEnt( "npc_item", Vector( -5911, 1437, -22 ), angle_negninety, 1 )
		CreateEnt( "npc_item", Vector( 6616, -14356, 776 ), angle_zero, 1 ) --2 supermarkets on riverden
		CreateEnt( "npc_item", Vector( -1105, 2750, -236 ), angle_ninety, 2 )
		CreateEnt( "npc_item", Vector( -11795, 1640, -256 ), angle_ninety, 3 )
		CreateEnt( "npc_item", Vector( -8352, 10047, 0 ), angle_oneeighty, 4 )
		CreateEnt( "npc_item", Vector( -6080, 2132, -256 ), angle_zero, 6 )
		CreateEnt( "npc_item", Vector( -1960, 7342, -256 ), angle_oneeighty, 7 )
		CreateEnt( "npc_item", Vector( -4467, 8175, 0 ), angle_zero, 9 )
		local deposit = CreateEnt( "deposit_box", Vector( -10875, 14848, 40 ), angle_negninety )
		deposit:SpawnExtraBoxes()
	elseif map == "rp_truenorth_v1a" then
		CreateEnt( "smuggle_sell", Vector( 10563, 12505, 13 ), angle_ninety )
		CreateEnt( "npc_item", Vector( 15073, 9818, 8 ), angle_ninety, 1 )
		CreateEnt( "npc_item", Vector( 11848, 1789, -255 ), angle_negninety, 2 )
		CreateEnt( "npc_item", Vector( 13552, 10730, 8 ), angle_negninety, 3 )
		CreateEnt( "npc_item", Vector( 2294, 3243, 8 ), angle_ninety, 4 )
		CreateEnt( "npc_item", Vector( 13203, 12741, 64 ), angle_zero, 6 )
		CreateEnt( "npc_item", Vector( 9660, 13737, 0 ), angle_oneeighty, 7 )
		CreateEnt( "npc_item", Vector( 8707, 9919, 9 ), angle_zero, 9 )
		local deposit = CreateEnt( "deposit_box", Vector( 6485, 2800, 50 ), angle_negninety )
		deposit:SpawnExtraBoxes()
	end

	timer.Create( "NPCRelocate", 1800, 0, function()
		local smuggle = ents.FindByClass( "smuggle_sell" )[1]
		local contraband = NULL
		for k,v in ipairs( ents.FindByClass( "npc_item" ) ) do
			if v:GetNPCType() == 2 then
				contraband = v
				break
			end
		end

		local drugPos = locations[map][nextPos]
		local nextcontPos = nextPos == 4 and 1 or nextPos + 1
		local contPos = locations[map][nextcontPos]
		smuggle:SetPos( drugPos[1] )
		smuggle:SetAngles( drugPos[2] )
		contraband:SetPos( contPos[1] )
		contraband:SetAngles( contPos[2] )
		nextPos = nextPos == 4 and 1 or nextPos + 1
	end )

	MsgC( color_red, "[CityRP] Spawned NPCs." )
end )
