local prefixlist = { "/", "!", "@" }

timer.Create( "news_pay_loop", 60, 0, function()
	if team.NumPlayers( TEAM_CAMERA ) <= 0 then return end
	for k,v in ipairs( team.GetPlayers( TEAM_CAMERA ) ) do
		local tvs = #ents.FindByClass( "news_tv" )
		if tvs < 1 then
			DarkRP.notify( v, 1, 6, "You have received no news TV profits because nobody is tuned to your channel." )
			return
		end

		local total = 0
		for k,v in pairs( tvs ) do
			if v:GetOwner() != v then
				total = total + 50
			end
		end
		v:addMoney( total )
		DarkRP.notify( v, 0, 6, "You have received $"..total.." from news TV profits." )
	end
end )

hook.Add( "PlayerSay", "NewsText", function( ply, text, teamChat )
	if teamChat then return end
    if table.HasValue( prefixlist, string.sub( text, 0, 1 ) ) then return end
	local tvs = ents.FindByClass( "news_tv" )
	if #tvs < 1 then return end
	for c,d in pairs( ents.FindInSphere( ply:GetPos(), 150 ) ) do
		if d:IsPlayer() and d:Team() == TEAM_CAMERA and d:GetActiveWeapon():GetClass() == "news_camera" then
			for a,b in pairs( tvs ) do
				if !b:GetOn() or b:GetChannel() == 0 then return end
				for k,v in pairs( ents.FindInSphere( b:GetPos(), 150 ) ) do
					if v:IsPlayer() then
						DarkRP.talkToPerson( v, Color( 0, 180, 0 ), "[TV] "..ply:Nick(), color_white, text )
					end
				end
			end
		end
	end
end )
