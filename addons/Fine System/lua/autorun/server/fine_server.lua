util.AddNetworkString( "VehicleFine" )
local function VehicleFine( len, ply )
	local veh = net.ReadEntity()
	local ply = net.ReadEntity()
	local price = net.ReadInt( 32 )
	local reason = net.ReadString()
	veh.Fined = {}
	veh.Fined.Officer = ply
	veh.Fined.Price = price
	veh.Fined.Reason = reason
	DarkRP.notify( ply, 0, 6, "You have fined an empty vehicle. The owner will be notified once they return." )
end
net.Receive( "VehicleFine", VehicleFine )

util.AddNetworkString( "SendFine" )
util.AddNetworkString( "SendFineClient" )
local function SendFine( len, ply )
	local receiver = net.ReadEntity()
	local price = net.ReadInt( 32 )
	local reason = net.ReadString()
	net.Start( "SendFineClient" )
	net.WriteEntity( ply )
	net.WriteInt( price, 32 )
	net.WriteString( reason )
	net.Send( receiver )
end
net.Receive( "SendFine", SendFine )

local function VehicleFineEnter( ply, veh )
	if veh.Fined then
		net.Start( "SendFineClient" )
		net.WriteEntity( veh.Fined.Officer )
		net.WriteInt( veh.Fined.Price, 32 )
		net.WriteString( veh.Fined.Reason )
		net.Send( ply )
		veh.Fined = nil
		return false
	end
end
hook.Add( "CanPlayerEnterVehicle", "VehicleFineEnter", VehicleFineEnter )

util.AddNetworkString( "AcceptFine" )
local function AcceptFine( len, ply )
	local price = net.ReadInt( 32 )
	local sender = net.ReadEntity()
	local refuse = net.ReadBool()
	if refuse then
		ply:wanted( nil, "Refusing to pay fine.", 600 )
		return
	end
	ply:addMoney( -price )
	AddVaultFunds( price )
	DarkRP.notify( ply, 0, 6, "You have paid the $"..price.." fine." )
	DarkRP.notify( sender, 0, 6, ply:Nick().." has paid their $"..price.." fine." )
end
net.Receive( "AcceptFine", AcceptFine )

util.AddNetworkString( "FineButton" )
local function FineButton( ply )
	local tr = ply:GetEyeTrace().Entity
	if !IsValid( tr ) or ply:GetPos():DistToSqr( tr:GetPos() ) > 10000 then return end
	
	local allowedteamsply = {
		[TEAM_POLICEBOSS] = true,
		[TEAM_OFFICER] = true,
		[TEAM_UNDERCOVER] = true
	}

	local allowedteamsveh = {
		[TEAM_POLICEBOSS] = true,
		[TEAM_OFFICER] = true,
		[TEAM_UNDERCOVER] = true,
		[TEAM_TOWER] = true
	}

	if tr:IsPlayer() and allowedteamsply[ply:Team()] then
		net.Start( "FineButton" )
		net.WriteEntity( tr )
		net.Send( ply )
	elseif tr:IsVehicle() and allowedteamsveh[ply:Team()] then
		if !IsValid( tr:GetDriver() ) then
			local owner = tr:GetNWEntity( "VehicleOwner" )
			if ply == owner then
				DarkRP.notify( ply, 1, 6, "You can't fine your own vehicle!" )
				return
			end
			net.Start( "FineButton" )
			net.WriteEntity( owner )
			net.WriteBool( true )
			net.WriteEntity( tr )
			net.Send( ply )
			return
		end
		net.Start( "FineButton" )
		net.WriteEntity( tr:GetDriver() )
		net.Send( ply )
	end
end
hook.Add( "ShowSpare1", "FineButtonHook", FineButton )
