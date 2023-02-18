local map = game.GetMap()
PropertyTaxWarnings = {}

function PropertySystemSaveEnts( id )
	for k,v in pairs( OwnedProperties ) do
		v.Saved = {}
		if IsValid( player.GetBySteamID64( id or v.Owner ) ) then
			for a,b in pairs( ents.FindInBox( PropertyTable[k].BoundaryUpper, PropertyTable[k].BoundaryLower ) ) do
				if b:GetNWString( "SavedProperty" ) != "" then
					table.insert( v.Saved, duplicator.CopyEntTable( b ) )
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

function FreezePropertyEnt( ent )
	local phys = ent:GetPhysicsObject()
	if IsValid( phys ) then
		phys:EnableMotion( false )
	end
end

function UnfreezePropertyEnt( ent )
	local phys = ent:GetPhysicsObject()
	if IsValid( phys ) then
		phys:EnableMotion( true )
	end
end
