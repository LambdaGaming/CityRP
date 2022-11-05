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
				if !isvector( property.BoundaryUpper ) then continue end
				if v.Owner == ply:SteamID64() and ent:GetPos():WithinAABox( property.BoundaryUpper, property.BoundaryLower ) then
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
	end
} )

if CLIENT then
	net.Receive( "SyncPropertyTables", function()
		local tbl = net.ReadTable()
		local owned = net.ReadTable()
		PropertyTable = tbl
		OwnedProperties = owned
	end )
end

if SERVER then
	util.AddNetworkString( "SyncPropertyTables" )
	function SyncPropertyTable( ply )
		net.Start( "SyncPropertyTables" )
		net.WriteTable( PropertyTable )
		net.WriteTable( OwnedProperties )
		net.Send( ply or player.GetAll() )
	end
end
