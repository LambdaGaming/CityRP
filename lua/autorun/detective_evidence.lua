
DetectiveMarkers = {}

if CLIENT then
	local mat = Material( "icon16/gun.png" )
	local matcar = Material( "icon16/car.png" )
	local realmat

	local function SyncMarkers( len, ply )
		local tbl = net.ReadTable()
		DetectiveMarkers = tbl
	end
	net.Receive( "SyncMarkers", SyncMarkers )

	local function DrawMarkers()
		if table.IsEmpty( DetectiveMarkers ) then return end
		local pl = LocalPlayer()
		local shootPos = pl:GetShootPos()
		local plypos
		local hisPos = pl:GetShootPos()
		if pl:Team() == TEAM_DETECTIVE then
			for k,v in pairs( DetectiveMarkers ) do
				for a,b in pairs( v ) do
					if b[2] then
						realmat = matcar
					else
						realmat = mat
					end
					local pos = hisPos - shootPos
					local unitPos = pos:GetNormalized()
					local trace = util.QuickTrace( shootPos, pos, pl )
					plypos = b[1]
					plypos = plypos:ToScreen()
					surface.SetMaterial( realmat )
					surface.SetDrawColor( color_white )
					surface.DrawTexturedRect( plypos.x - 16, plypos.y - 74, 40, 40 )
				end
			end
		end
	end
	hook.Add( "HUDPaint", "drawRankIconsHUD", DrawMarkers )
end

if SERVER then
	util.AddNetworkString( "SyncMarkers" )
	local function StartSync()
		net.Start( "SyncMarkers" )
		net.WriteTable( DetectiveMarkers )
		net.Broadcast()
	end

	local function CreateMarkers( ply, inflictor, attacker )
		if !attacker:IsPlayer() then return end
		local pos
		local id = attacker:UniqueID()
		timer.Create( "KillerMarker"..id, 30, 1, function()
			pos = attacker:GetPos()
			DetectiveMarkers[id] = {}
			table.insert( DetectiveMarkers[id], { pos, false } )
			StartSync()
		end )
		timer.Simple( 600, function()
			DetectiveMarkers[id] = {}
			StartSync()
		end )
	end
	hook.Add( "PlayerDeath", "CreateMarkers", CreateMarkers )

	local function CreateVehicleMarker( ply, veh )
		local pos
		local id = ply:UniqueID()
		if timer.Exists( "KillerMarker"..id ) then
			pos = ply:GetPos()
			DetectiveMarkers[id] = {}
			table.insert( DetectiveMarkers[id], { pos, true } )
			StartSync()
			timer.Remove( "KillerMarker"..id )
			timer.Simple( 600, function()
				DetectiveMarkers[id] = {}
				StartSync()
			end )
		end
	end
	hook.Add( "PlayerEnteredVehicle", "CreateVehicleMarker", CreateVehicleMarker )
end
