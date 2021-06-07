local function PrecacheVehicles()
	local vehicles = list.Get( "Vehicles" )
	for k,v in pairs( vehicles ) do
		local model = v.Model
		util.PrecacheModel( model )
		print( "Precaching "..model )
	end
end
hook.Add( "InitPostEntity", "PrecacheVehicles", PrecacheVehicles )
