
hook.Add( "PlayerSay", "PropRestrictBypass", function( ply, text, teamchat )
	if !ply:IsSuperAdmin() then return end
	if teamchat then return end
	if text == "!disableproppay" then
		SetGlobalBool( "PropRestrictBypass", true )
		DarkRP.notifyAll( 0, 6, "Prop paying has been disabled." )
		return ""
	end
end )

hook.Add( "PlayerSay", "PropUnrestrictBypass", function( ply, text, teamchat )
	if !ply:IsSuperAdmin() then return end
	if text == "!enableproppay" then
		SetGlobalBool( "PropRestrictBypass", false )
		DarkRP.notifyAll( 0, 6, "Prop paying has been enabled." )
		return ""
	end
end )

hook.Add( "PlayerSpawnProp", "RestrictPropSpawn", function( ply, model )
	local restrictbypass = GetGlobalBool( "PropRestrictBypass" )
	if !restrictbypass then
		if ply:Team() == TEAM_SHOP then
			local amount = 0
			if string.find( model:lower(), "models/props_*" ) then
				amount = 50
			else
				amount = 100
			end
			ply:addMoney( -amount )
			DarkRP.notify( ply, 0, 6, "You have purchased a prop for "..amount.."." )
			return true
		else
			DarkRP.notify( ply, 0, 6, "Only shopkeepers can spawn props!" )
			return false
		end
	else
		return true
	end
end )

hook.Add( "InitPostEntity", "KeepPropSpawnEnabled", function()
	SetGlobalBool( "PropRestrictBypass", true )
end )

MsgC( color_orange, "[CityRP] Loaded shopkeeper prop restriction functions." )