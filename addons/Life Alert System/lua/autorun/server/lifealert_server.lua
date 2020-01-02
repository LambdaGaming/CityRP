
util.AddNetworkString( "LifeAlertSound" )
local function LifeAlert( ply )
	ply:SetNWBool( "LifeAlertActive", true )
	local emsjobs = {
		[TEAM_FIREBOSS] = true,
		[TEAM_FIRE] = true
	}
	for k,v in pairs( player.GetAll() ) do
		if v:isCP() or emsjobs[v:Team()] then
			DarkRP.talkToPerson( v, Color( 255, 0, 0 ), "[Life Alert]", color_white, "A life alert owned by "..ply:Nick().." has just been activated. It has been marked on your screen. Respond code 3." )
			net.Start( "LifeAlertSound" )
			net.Send( v )
		end
	end
	timer.Simple( 180, function()
		ply:SetNWBool( "LifeAlertActive", false )
		ply:SetNWBool( "LifeAlertActiveDeath", false )
		ply:SetNWVector( "LifeAlertDeathPos", nil )
	end )
end

hook.Add( "PlayerDeath", "LifeAlertReset", function( ply )
	local pos = ply:GetPos()
	if ply.haslifealert then
		ply:SetNWBool( "LifeAlertActiveDeath", true )
		ply:SetNWVector( "LifeAlertDeathPos", pos )
		LifeAlert( ply )
		ply.haslifealert = false
	end
end )

hook.Add( "PlayerSpawn", "LifeAlertRespawn", function( ply )
	ply:SetNWBool( "LifeAlertActive", false )
	ply:SetNWBool( "LifeAlertActiveDeath", false )
	ply:SetNWVector( "LifeAlertDeathPos", nil )
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