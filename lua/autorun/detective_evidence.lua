DetectiveMarkers = {}
if CLIENT then
	local function SyncMarkers( len, ply )
		local tbl = net.ReadTable()
		DetectiveMarkers = tbl
	end
	net.Receive( "SyncMarkers", SyncMarkers )

	local mat = Material( "icon16/gun.png" )
	local function DrawMarkers()
		if table.IsEmpty( DetectiveMarkers ) then return end
		local pl = LocalPlayer()
		local shootPos = pl:GetShootPos()
		local plypos
		local hisPos = pl:GetShootPos()
		if pl:Team() == TEAM_DETECTIVE then
			for k,v in pairs( DetectiveMarkers ) do
				local pos = hisPos - shootPos
				local unitPos = pos:GetNormalized()
				local trace = util.QuickTrace( shootPos, pos, pl )
				plypos = v
				plypos = plypos:ToScreen()
				surface.SetMaterial( mat )
				surface.SetDrawColor( color_white )
				surface.DrawTexturedRect( plypos.x - 16, plypos.y - 74, 40, 40 )
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

	local function CreateMarkers( detective, killer )
		if !EcoPerkActive( "Increase Criminal Investigation Budget" ) then
			return
		end
		local id = killer:UniqueID()
		local pos = killer:GetPos()
		DetectiveMarkers[id] = pos
		StartSync()
		timer.Simple( 600, function()
			DetectiveMarkers[id] = nil
			StartSync()
		end )
	end
	hook.Add( "OnInvestigateEvidence", "CreateMarkers", CreateMarkers )
end
