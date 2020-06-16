
local function PhotonSuppress( ent )
	if ent:GetClass() == "prop_vehicle_jeep" then
		ent.PhotonAlertedMissingRequirements = true --Cheap way of disabling the photon missing component warnings since there's no config for it
	end
end
hook.Add( "OnEntityCreated", "PhotonSuppress", PhotonSuppress )
