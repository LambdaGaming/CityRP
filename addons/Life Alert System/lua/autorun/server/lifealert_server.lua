util.AddNetworkString( "LifeAlertSound" )
local function LifeAlert( ply, type )
	ply:SetNWBool( "LifeAlertActive", true )
	for k,v in ipairs( player.GetAll() ) do
		if v:isCPNoMayor() or v:IsEMS() then
			local types = { "Death", "Injury", "Manual Alert" }
			DarkRP.talkToPerson( v, Color( 255, 0, 0 ), "[Life Alert]", color_white, "A life alert owned by "..ply:Nick().." has just been activated. It has been marked on your screen. Reason: "..types[type] )
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

hook.Add( "DoPlayerDeath", "LifeAlertReset", function( ply )
	local pos = ply:GetPos()
	if ply.haslifealert then
		ply:SetNWBool( "LifeAlertActiveDeath", true )
		ply:SetNWVector( "LifeAlertDeathPos", pos )
		LifeAlert( ply, 1 )
		ply.haslifealert = false
	end
end )

hook.Add( "PostEntityTakeDamage", "LifeAlertDamage", function( ent, dmg, took )
	if ent:IsPlayer() and ent.haslifealert and took then
		if ent.LifeAlertCooldown and ent.LifeAlertCooldown > CurTime() then
			return
		end
		LifeAlert( ent, 2 )
		ent.LifeAlertCooldown = CurTime() + 120
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
			LifeAlert( ply, 3 )
		elseif ply:GetNWBool( "LifeAlertActive" ) then
			ply:ChatPrint( "Your life alert is already active!" )
		else
			ply:ChatPrint( "You do not have life alert!" )
		end
		return ""
	end
end )
