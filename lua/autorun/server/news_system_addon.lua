local prefixlist = { ["/"] = true, ["!"] = true, ["@"] = true }

timer.Create( "news_pay_loop", 60, 0, function()
	if team.NumPlayers( TEAM_CAMERA ) <= 0 then return end
	for k,v in ipairs( team.GetPlayers( TEAM_CAMERA ) ) do
		local tvs = ents.FindByClass( "news_tv" )
		if #tvs < 1 then
			DarkRP.notify( v, 1, 6, "You have received no news TV profits because nobody is tuned to your channel." )
			return
		end

		local total = 0
		for k,v in pairs( tvs ) do
			if v:GetOwner() != v and v:GetOn() and v:GetChannel() != 0 then
				total = total + 50
			end
		end
		v:addMoney( total )
		DarkRP.notify( v, 0, 6, "You have received $"..total.." from news TV profits." )
	end
end )

local tvcolor = Color( 0, 180, 0 )
local radiocolor = Color( 0, 0, 255 )
hook.Add( "PlayerSay", "NewsRadioText", function( ply, text, teamChat )
	if prefixlist[string.sub( text, 0, 1 )] then return end
	if teamChat then
		local radios = ents.FindByClass( "police_scanner" )
		if #radios < 1 or ( !ply:isCP() and !ply:IsEMS() ) then return end
		for a,b in ipairs( radios ) do
			if !b.On then continue end
			for k,v in ipairs( ents.FindInSphere( b:GetPos(), 150 ) ) do
				if v:IsPlayer() then
					DarkRP.talkToPerson( v, radiocolor, "[Police Scanner] "..ply:Nick(), color_white, text )
				end
			end
		end
		return
	end

	local tvs = ents.FindByClass( "news_tv" )
	if #tvs < 1 then return end
	local cameraman = team.GetPlayers( TEAM_CAMERA )[1]
	if !IsValid( cameraman ) or cameraman:GetActiveWeapon():GetClass() != "news_camera" or ply:GetPos():DistToSqr( cameraman:GetPos() ) > 22500 then return end
	for a,b in ipairs( tvs ) do
		if !b:GetOn() or b:GetChannel() == 0 then continue end
		for k,v in ipairs( ents.FindInSphere( b:GetPos(), 150 ) ) do
			if v:IsPlayer() then
				DarkRP.talkToPerson( v, tvcolor, "[TV] "..ply:Nick(), color_white, text )
			end
		end
	end
end )
