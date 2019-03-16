
util.AddNetworkString( "LifeAlertSound" )
local function LifeAlert( ply )
	ply:SetNWBool( "LifeAlertActive", true )
	local emsjobs = {
		TEAM_FIREBOSS,
		TEAM_FIRE
	}
	for k,v in pairs( player.GetAll() ) do
		if v:isCP() or table.HasValue( emsjobs, v:Team() ) then
			DarkRP.talkToPerson( v, Color( 255, 0, 0 ), "[Life Alert]", color_white, "A life alert owned by "..ply:Nick().." has just been activated. It has been marked on your screen. Respond code 3." )
			net.Start( "LifeAlertSound" )
			net.Send( v )
		end
	end
	timer.Simple( 180, function() ply:SetNWBool( "LifeAlertActive", false ) end )
end

hook.Add( "PlayerDeath", "LifeAlertReset", function( ply )
	if ply.haslifealert then
		ply.haslifealert = false
		ply:SetNWBool( "LifeAlertActive", false )
		--if ply:GetNWBool( "LifeAlertActive" ) then return end
		--LifeAlert( ply ) --Death alert disabled until I can find a way to get the death pos
	end
end )

hook.Add( "PlayerSay", "LifeAlertCheck", function( ply, text, public )
	if text == "!alertcheck" then
		if ply.haslifealert then
			ply:ChatPrint( "You have life alert." )
		else
			ply:ChatPrint( "You do not have life alert." )
		end
		return ""
	end
	if text == "!alert" then
		if ply.haslifealert and ply:Alive() then
			ply:ChatPrint( "Life alert activated. Police and EMS have been notified of your location." )
			LifeAlert( ply )
		elseif ply:GetNWBool( "LifeAlertActive" ) then
			ply:ChatPrint( "Your life alert is already active!" )
		else
			ply:ChatPrint( "You do not have life alert!" )
		end
		return ""
	end
end )