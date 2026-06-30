--We use Galactic HUD so these need to be disabled
local hideHUDElements = {
	["DarkRP_LocalPlayerHUD"] = true,
	["DarkRP_Hungermod"] = true,
	["DarkRP_Agenda"] = true
}

hook.Add( "HUDShouldDraw", "HideDefaultDarkRPHud", function( name )
	if hideHUDElements[name] then return false end
end )
