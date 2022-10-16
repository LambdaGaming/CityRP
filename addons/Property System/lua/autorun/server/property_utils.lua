local map = game.GetMap()

function PropertySystemSave()
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
end
