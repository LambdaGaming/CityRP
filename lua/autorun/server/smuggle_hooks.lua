local function Confiscate( ply, veh )
	if veh.SmuggleTruck then
		if ply:isCP() then
			DarkRP.notify( ply, 0, 6, "You have successfully seized this smuggle truck. You have been awarded with $500." )
			ply:addMoney( 500 )
			DarkRP.notify( veh.SmuggleOwner, 1, 6, "The police have seized your smuggle truck." )
			veh:Remove()
			return
		end
		if ply != veh.SmuggleOwner then
			veh.SmuggleOwner = ply
			DarkRP.notify( ply, 0, 6, "You have taken ownership of this smuggle truck." )
		end
	end
end
hook.Add( "PlayerEnteredVehicle", "SmuggleConfiscate", Confiscate )
