local map = game.GetMap()

function PropertySystemSaveEnts( id )
	local entlist = ents.GetAll()
	for k,v in pairs( OwnedProperties ) do
		v.Saved = {}
	end
	for k,v in ipairs( entlist ) do
		for a,b in pairs( OwnedProperties ) do
			if IsValid( player.GetBySteamID64( id or b.Owner ) ) then
				local index = v:GetNWString( "SavedProperty" )
				if index == tostring( a ) then
					table.insert( b.Saved, duplicator.CopyEntTable( v ) )
				end
			end
		end
	end
	SyncPropertyTable()
	PropertySystemSaveFile()
end

function PropertySystemSaveFile()
	local json = util.TableToJSON( OwnedProperties, true )
	file.Write( "properties/saved/"..map..".json", json )
end

function PropertySystemLoad()
	if file.Exists( "properties/default/"..map..".json", "DATA" ) then
		PropertyTable = util.JSONToTable( file.Read( "properties/default/"..map..".json" ) )
	end
	if file.Exists( "properties/saved/"..map..".json", "DATA" ) then
		OwnedProperties = util.JSONToTable( file.Read( "properties/saved/"..map..".json" ) )
	end
	SyncPropertyTable()
end
