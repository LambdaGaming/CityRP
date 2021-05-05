
local GasPumpMaps = {
	["rp_rockford_v2b"] = "models/statua/shell/shellpump1.mdl",
	["rp_southside"] = "models/unioncity2/props_unioncity/gas_pump.mdl",
	["rp_riverden_v1a"] = "models/unioncity2/props_unioncity/gaspump_712.mdl",
	["rp_florida_v2"] = "models/props_equipment/gas_pump.mdl",
	["rp_truenorth_v1a"] = "models/props_equipment/gas_pump.mdl",
	["rp_newexton2_v4h"] = "models/props_equipment/gas_pump.mdl"
}

hook.Add( "InitPostEntity", "GasPumpSpawn", function()
	if game.GetMap() == "rp_newexton2_v4h" then --New exton is special since it's gas station doesn't have pumps
		local e = ents.Create( "gas_pump" )
		e:SetPos( Vector( 3861, 5117, 1024 ) )
		e:SetAngles( angle_zero )
		e:Spawn()
		e:SetModel( GasPumpMaps[game.GetMap()] )
		return
	end
	for k,v in pairs( ents.FindByModel( GasPumpMaps[game.GetMap()] ) ) do
		if v:CreatedByMap() then
			local pos, ang = v:GetPos(), v:GetAngles()
			v:Remove()
			
			local e = ents.Create( "gas_pump" )
			e:SetPos( pos )
			e:SetAngles( ang )
			e:Spawn()
			e:SetModel( GasPumpMaps[game.GetMap()] )
		end
	end
end )