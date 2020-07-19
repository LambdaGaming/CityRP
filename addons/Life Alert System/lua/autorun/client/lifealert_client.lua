
net.Receive( "LifeAlertSound", function( len, ply )
	surface.PlaySound( "police_bloop.wav" )
	timer.Simple( 0.5, function() surface.PlaySound( "police_bloop.wav" ) end )
end )

local mat = Material( "icon16/bullet_error.png" )
local function AlertImage()
    local pl = LocalPlayer()
    local shootPos = pl:GetShootPos()
	local ply = player.GetAll()
	local plypos = vector_origin
	local hisPos = pl:GetShootPos()
	local emsjobs = {
		[TEAM_FIREBOSS] = true,
		[TEAM_FIRE] = true
	}
	if pl:isCP() or emsjobs[pl:Team()] then
		for k,v in pairs( ply ) do
			if v:GetNWBool( "LifeAlertActiveDeath" ) then
				local pos = hisPos - shootPos
				local unitPos = pos:GetNormalized()
				local trace = util.QuickTrace( shootPos, pos, pl )
				plypos = v:GetPos()
				plypos.z = plypos.z + 15
				plypos = plypos:ToScreen()
			elseif v:GetNWBool( "LifeAlertActive" ) then
				local pos = hisPos - shootPos
				local unitPos = pos:GetNormalized()
				local trace = util.QuickTrace( shootPos, pos, pl )
				plypos = v:GetNWVector( "LifeAlertDeathPos" )
				plypos.z = plypos.z + 15
				plypos = plypos:ToScreen()
			end
			surface.SetMaterial( mat )
			surface.SetDrawColor( color_white )
			surface.DrawTexturedRect(plypos.x - 16, plypos.y - 74, 40, 40)
		end
	end
end
hook.Add("HUDPaint","drawRankIconsHUD", AlertImage)