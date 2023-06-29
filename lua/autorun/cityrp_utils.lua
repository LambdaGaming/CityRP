if SERVER then
	--Spawn blueprint function
	function SpawnBlueprint( owner, uses )
		local randwep = table.Random( BLUEPRINT_TABLE )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( owner:GetPos() + Vector( 0, 0, 35 ) )
		e:SetAngles( owner:GetAngles() )
		e:Spawn()
		e:SetOwner( owner )
		e:SetEntName( randwep[1] )
		e:SetRealName( randwep[2] )
		e:SetUses( uses )
	end

	local angle_ninety = Angle( 0, 90, 0 )
	local angle_ninety_neg = Angle( 0, -90, 0 )
	local angle_one_eighty = Angle( 0, 180, 0 )
	local rockford = "rp_rockford_v2b"
	local southside = "rp_southside_day"
	local riverden = "rp_riverden_v1a"
	local truenorth = "rp_truenorth_v1a"
	local map = game.GetMap()
	local VehicleSpawns = {
		[1] = { --Police spawns
			[rockford] = { Vector( -8248, -5485, 0 ), angle_zero },
			[southside] = { Vector( 8688, 8619, -127 ), angle_ninety },
			[riverden] = { Vector( -8703, 8141, -264 ), angle_one_eighty },
			[truenorth] = { Vector( 3238, 3914, 0 ), angle_zero }
		},
		[2] = { --Fire spawns
			[rockford] = { Vector( -5257, -3349, 8 ), angle_one_eighty },
			[southside] = { Vector( 9431, 1260, -103 ), angle_ninety_neg },
			[riverden] = { Vector( -12202, 1422, -256 ), angle_one_eighty },
			[truenorth] = { Vector( 13135, 11426, 8 ), angle_ninety }
		},
		[3] = { --Smuggle truck spawns
			[rockford] = { Vector( -2893, -6357, 0 ) , angle_ninety_neg },
			[southside] = { Vector( -7011, -3749, -319 ), angle_one_eighty },
			[riverden] = { Vector( -4213, 2226, -264 ), angle_one_eighty },
			[truenorth] = { Vector( 6137, 8882, 0 ), angle_zero }
		},
		[4] = { --Tow truck spawns
			[rockford] = { Vector( -7564, 680, 3 ), angle_zero },
			[southside] = { Vector( -1656, 6421, 14 ), angle_zero },
			[riverden] = { Vector( -1820, 6037, -264 ), angle_zero },
			[truenorth] = { Vector( 8909, 12963, 0 ), angle_zero }
		}
	}

	function SpawnVehicle( ply, class, type, noenter, pos, ang )
		local vehlist = list.GetForEdit( "Vehicles" )[class]
		if !vehlist then
			print( "Tried to spawn a vehicle but its class ("..class..") doesn't exist." )
			return
		end
	
		local spawn = VehicleSpawns[type][map]
		local realpos = spawn[1]
		if vehlist.Model == "models/tdmcars/dod_ram_3500.mdl" then --Fix for this truck since it spawns below the map for some reason
			realpos = realpos + Vector( 0, 0, 50 )
		end
	
		local e = ents.Create( vehlist.Class )
		e:SetPos( pos or realpos )
		e:SetAngles( ang or spawn[2] )
		e:SetModel( vehlist.Model )
		if vehlist.KeyValues then
			for k,v in pairs( vehlist.KeyValues ) do
				e:SetKeyValue( k, v )
			end
		end
		e.VehicleTable = vehlist
		e:Spawn()
		e:Activate()
		e:SetNWEntity( "VehicleOwner", ply )
		if !noenter then
			ply:EnterVehicle( e )
		end

		if !ply.VehicleList then ply.VehicleList = {} end
		if table.Count( ply.VehicleList ) >= 3 then --Limit active vehicles
			local found = false
			for k,v in pairs( ply.VehicleList ) do
				if !IsValid( v ) then
					ply.VehicleList[k] = e
					found = true
					break
				end
			end
			if !found then
				ply.VehicleList[1]:Remove()
				ply.VehicleList[1] = e
			end
		else
			table.insert( ply.VehicleList, e )
		end
		return e
	end

	function NotifyCops( typ, time, text, nomayor )
		for k,v in ipairs( player.GetAll() ) do
			if v:isCP() then
				if v:Team() == TEAM_MAYOR and nomayor then
					continue
				end
				DarkRP.notify( v, typ, time, text )
			end
		end
	end

	function NotifyEMS( typ, time, text )
		for k,v in ipairs( player.GetAll() ) do
			if v:IsEMS() then
				DarkRP.notify( v, typ, time, text )
			end
		end
	end

	function NotifyCivilians( typ, time, text )
		for k,v in ipairs( player.GetAll() ) do
			if !v:isCP() and !v:IsEMS() then
				DarkRP.notify( v, typ, time, text )
			end
		end
	end

	function NotifyJob( job, typ, time, text )
		for k,v in ipairs( team.GetPlayers( job ) ) do
			DarkRP.notify( v, typ, time, text )
		end
	end
else
	--NPC text drawing function, modified from https://github.com/Bhoonn/bh_accessories/blob/main/lua/entities/bh_acc_vendor/cl_init.lua
	local ent = FindMetaTable( "Entity" )
	local offset = Vector( 0, 0, 80 )
	local Draw_SimpleText = draw.SimpleText
	local surface_SetFont = surface.SetFont
	local surface_GetTextSize = surface.GetTextSize

	function ent:DrawNPCText( text, override )
		self:DrawModel()

		local origin = self:GetPos()
		local ply = LocalPlayer()
		if ply:GetPos():DistToSqr( origin ) >= 589824 then return end

		local pos = origin + ( override or offset )
		local ang = ( ply:EyePos() - pos ):Angle()
		ang.p = 0
		ang:RotateAroundAxis( ang:Right(), 90 )
		ang:RotateAroundAxis( ang:Up(), 90 )
		ang:RotateAroundAxis( ang:Forward(), 180 )
		cam.Start3D2D( pos, ang, 0.035 )
			surface_SetFont( "BHACC_VendorTextFont" )
			local tw, th = surface_GetTextSize( text )
			Draw_SimpleText( text, "BHACC_VendorTextFont", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		cam.End3D2D()
	end
end

local meta = FindMetaTable( "Player" )
function meta:IsEMS()
	return self:Team() == TEAM_FIREBOSS or self:Team() == TEAM_FIRE
end

function meta:IsCivilian()
	local allowed = {
		[TEAM_CITIZEN] = true,
		[TEAM_TOWER] = true,
		[TEAM_CAMERA] = true,
		[TEAM_BUS] = true,
		[TEAM_HITMAN] = true,
		[TEAM_GUN] = true,
		[TEAM_UNDERCOVER] = true
	}
	return allowed[self:Team()]
end

function meta:isCPNoMayor()
	return self:isCP() and self:Team() != TEAM_MAYOR
end
