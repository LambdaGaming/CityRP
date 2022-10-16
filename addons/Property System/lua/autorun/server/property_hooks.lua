PropertyTable = {}
OwnedProperties = {}

hook.Add( "playerBuyDoor", "PropertySystemBuyDoor", function( ply, ent )
	if ent.IsSubDoor then
		return false, "Buy the main door to own the whole property."
	elseif ent.IsMainDoor then
		if OwnedProperties[ent:doorIndex()] then
			return false, "This property is owned by a disconnected player."
		end
		local index = ent:doorIndex()
		for k,v in pairs( PropertyTable[index].SubDoors ) do
			local e = DarkRP.doorIndexToEnt( v )
			e:keysOwn( ply )
		end
		OwnedProperties[index] = {
			Owner = ply:SteamID64(),
			Saved = {}
		}
		PropertySystemSave()
	end
	return true
end )

hook.Add( "playerSellDoor", "PropertySystemSellDoor", function( ply, ent )
	if ent.IsSubDoor then
		return false, "Sell the main door to sell the whole property."
	elseif ent.IsMainDoor then
		local index = ent:doorIndex()
		for k,v in pairs( PropertyTable[index].SubDoors ) do
			local e = DarkRP.doorIndexToEnt( v )
			e:keysUnOwn( ply )
			e:setKeysTitle( nil )
			DarkRP.storeDoorData( e )
		end
		ent:setKeysTitle( nil )
		DarkRP.storeDoorData( ent )
		timer.Simple( 1, function()
			ent:setKeysTitle( PropertyTable[index].Name )
		end )
		OwnedProperties[index] = nil
		PropertySystemSave()
	end
	return true
end )

hook.Add( "InitPostEntity", "PropertySystemApplyDoorStats", function()
	--Override DarkRP function for getting door cost
	function GAMEMODE:getDoorCost( ply, ent )
		local tbl = PropertyTable[ent:doorIndex()]
		return tbl and tbl.Price or 100
	end

	PropertySystemLoad()
	for k,v in pairs( PropertyTable ) do
		local main = DarkRP.doorIndexToEnt( k )
		main.IsMainDoor = true
		main:keysLock()
		if !IsValid( main:getKeysTitle() ) then
			if OwnedProperties[k] then
				main:setKeysTitle( v.Name )
			else
				main:setKeysTitle( v.Name.."\nFor Sale: "..DarkRP.formatMoney( v.Price or 0 ) )
			end
		end
		if v.SubDoors then
			for a,b in pairs( v.SubDoors ) do
				local sub = DarkRP.doorIndexToEnt( b )
				sub.IsSubDoor = true
				sub:keysLock()
			end
		end
	end
end )

hook.Add( "PlayerInitialSpawn", "PropertySystemPlayerSpawn", function( ply )
	timer.Simple( 5, function()
		for k,v in pairs( OwnedProperties ) do
			if v.Owner == ply:SteamID64() then
				local ent = DarkRP.doorIndexToEnt( k )
				local index = ent:doorIndex()
				ent:keysOwn( ply )
				for k,v in pairs( PropertyTable[index].SubDoors ) do
					local e = DarkRP.doorIndexToEnt( v )
					e:keysOwn( ply )
				end
			end
		end
	end )
end )

hook.Add( "PlayerDisconnected", "PropertySystemPlayerDisconnect", function( ply )

end )

hook.Add( "canPropertyTax", "PropertySystemTaxes", function( ply, tax )
	local total = 0
	for k,v in pairs( OwnedProperties ) do
		if PropertyTable[k] and v.Owner == ply:SteamID64() then
			total = total + ( PropertyTable[k].Price * 0.01 ) --TODO: Make it so the mayor can change the property tax
		end
	end
	return true, total
end )

--Redefine DarkRP set door title function to make it compatible with this system
hook.Add( "InitPostEntity", "PropertySystemTitleOverride", function()
	local function SetDoorTitle( ply, args )
		local trace = ply:GetEyeTrace()
		local ent = trace.Entity

		if not IsValid( ent ) or !ent:isKeysOwnable() or ply:GetPos():DistToSqr( ent:GetPos() ) >= 40000 then
			DarkRP.notify( ply, 1, 4, DarkRP.getPhrase( "must_be_looking_at", DarkRP.getPhrase( "door_or_vehicle" ) ) )
			return ""
		end

		if ent:isKeysOwnedBy( ply ) then
			ent:setKeysTitle( args )
			DarkRP.storeDoorData( trace.Entity )
			return ""
		end

		local function onCAMIResult( allowed )
			if !allowed then
				DarkRP.notify( ply, 1, 6, DarkRP.getPhrase( "no_privilege" ) )
				return
			end

			local hasTeams = !fn.Null( ent:getKeysDoorTeams() or {} )
			if ent:isKeysOwned() or ent:getKeysNonOwnable() or ent:getKeysDoorGroup() or hasTeams then
				ent:setKeysTitle( args )
			end
			DarkRP.storeDoorData( trace.Entity )
		end
		CAMI.PlayerHasAccess( ply, "DarkRP_ChangeDoorSettings", onCAMIResult )
		return ""
	end
	DarkRP.defineChatCommand( "title", SetDoorTitle )
end )