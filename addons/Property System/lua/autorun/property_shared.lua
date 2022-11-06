PropertyTable = {}
OwnedProperties = {}

properties.Add( "propertysave", {
	MenuLabel = "Save To Property",
	Order = 1,
	MenuIcon = "icon16/database_save.png",
	Filter = function( self, ent, ply )
		local owner = IsValid( ent:GetOwner() ) and ent:GetOwner() or ent:CPPIGetOwner()
		if IsValid( owner ) and owner == ply then
			local onproperty
			for k,v in pairs( OwnedProperties ) do
				local property = PropertyTable[k]
				local upper = property.BoundaryUpper
				local lower = property.BoundaryLower
				if !upper or !isvector( upper ) or v.Saved >= 15 then continue end
				local center = ent:LocalToWorld( ent:OBBCenter() )
				if v.Owner == ply:SteamID64() and center:WithinAABox( upper, lower ) then
					onproperty = true
					ent.PropertyIndex = k
					break
				end
			end
			return hook.Run( "CanProperty", ply, "propertysave", ent ) and ent:GetNWString( "SavedProperty" ) == "" and onproperty
		end
		return false
	end,
	Action = function( self, ent )
		self:MsgStart()
		net.WriteEntity( ent )
		net.WriteString( ent.PropertyIndex )
		self:MsgEnd()
	end,
	Receive = function( self, len, ply )
		local ent = net.ReadEntity()
		local index = net.ReadString()
		ent:SetNWString( "SavedProperty", index )
		FreezePropertyEnt( ent )
		PropertySystemSaveEnts()
		DarkRP.notify( ply, 0, 6, "Entity "..ent:GetClass().." successfully saved." )
	end
} )

properties.Add( "propertyremovesave", {
	MenuLabel = "Remove From Property",
	Order = 1,
	MenuIcon = "icon16/database_delete.png",
	Filter = function( self, ent, ply )
		local owner = IsValid( ent:GetOwner() ) and ent:GetOwner() or ent:CPPIGetOwner()
		if IsValid( owner ) and owner == ply then
			return hook.Run( "CanProperty", ply, "propertyremovesave", ent ) and ent:GetNWString( "SavedProperty" ) != ""
		end
		return false
	end,
	Action = function( self, ent )
		self:MsgStart()
		net.WriteEntity( ent )
		self:MsgEnd()
	end,
	Receive = function( self, len, ply )
		local ent = net.ReadEntity()
		ent:SetNWString( "SavedProperty", "" )
		UnfreezePropertyEnt( ent )
		PropertySystemSaveEnts()
		DarkRP.notify( ply, 0, 6, "Entity "..ent:GetClass().." successfully unsaved." )
	end
} )

if CLIENT then
	net.Receive( "SyncPropertyTables", function()
		local tbl = net.ReadTable()
		local owned = net.ReadTable()
		PropertyTable = tbl
		OwnedProperties = owned
	end )

	net.Receive( "ViewPropertyBoundaries", function()
		local ply = LocalPlayer()
		if ply.ViewingProperties then
			hook.Remove( "PreDrawEffects", "ViewPropertyBoundaries" )
			ply.ViewingProperties = false
		else
			hook.Add( "PreDrawEffects", "ViewPropertyBoundaries", function()
				for k,v in pairs( PropertyTable ) do
					render.DrawWireframeBox( vector_origin, angle_zero, v.BoundaryLower, v.BoundaryUpper, color_green )
				end
			end )
			ply.ViewingProperties = true
		end
	end )
end

if SERVER then
	util.AddNetworkString( "ViewPropertyBoundaries" )
	util.AddNetworkString( "SyncPropertyTables" )
	function SyncPropertyTable( ply )
		local owned = table.Copy( OwnedProperties )
		for k,v in pairs( owned ) do
			v.Saved = #OwnedProperties[k].Saved
		end
		net.Start( "SyncPropertyTables" )
		net.WriteTable( PropertyTable )
		net.WriteTable( owned )
		net.Send( ply or player.GetAll() )
	end
end
