AddCSLuaFile()

ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Bus Passenger"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true 
ENT.Category = "Superadmin Only"

function ENT:Initialize()
	local models = {
		"models/player/group01/female_01.mdl",
		"models/player/group01/female_02.mdl",
		"models/player/group01/female_03.mdl",
		"models/player/group01/female_04.mdl",
		"models/player/group01/female_05.mdl",
		"models/player/group01/female_06.mdl",
		"models/player/group01/male_01.mdl",
		"models/player/group01/male_02.mdl",
		"models/player/group01/male_03.mdl",
		"models/player/group01/male_04.mdl",
		"models/player/group01/male_05.mdl",
		"models/player/group01/male_06.mdl",
		"models/player/group01/male_07.mdl",
		"models/player/group01/male_08.mdl",
		"models/player/group01/male_09.mdl"
	}
	self:SetModel( table.Random( models ) )
	if SERVER then
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_VPHYSICS )
	end
end

function ENT:Think()
	self:SetSequence( 9 )
	if SERVER then
		if self.OnBus then
			local bus = self.CurrentBus
			if self.FirstPassenger and bus.TotalPassengers == BusPassengerEventStats.TotalPassengers then
				local stopname = BusPassengerEventStats.DestinationName
				local driver = bus:GetDriver()
				if IsValid( driver ) and bus:GetVelocity():LengthSqr() == 0 then
					local dist = driver:GetPos():DistToSqr( BusDestinations[stopname][game.GetMap()] )
					if dist <= 250000 then
						local reward = 250 * BusPassengerEventStats.TotalPassengers
						DarkRP.notify( driver, 0, 6, "You have been given $"..reward.." for transporting these people." )
						GiveReward( driver, reward )
						EndBusPassenger()
					end
				end
			end
		else
			local bus = ents.FindInSphere( self:GetPos(), 200 )
			local foundbus = false
			for k,v in pairs( bus ) do
				if v:IsVehicle() and v:GetModel() == "models/tdmcars/bus.mdl" then
					foundbus = v
					break
				end
			end
			if foundbus and foundbus:GetVelocity():LengthSqr() == 0 and IsValid( foundbus:GetDriver() ) then
				local seat = foundbus.seat[self.PassengerID]
				local pos = seat:GetPos()
				self:SetPos( pos )
				self:SetAngles( foundbus:LocalToWorldAngles( Angle( 0, 90, 0 ) ) )
				self:SetParent( seat )
				self.OnBus = true
				self.CurrentBus = foundbus
				foundbus.TotalPassengers = ( foundbus.TotalPassengers or 0 ) + 1
				if foundbus.TotalPassengers == 1 then
					self.FirstPassenger = true
				end
				
				local driver = foundbus:GetDriver()
				if IsValid( driver ) then
					if foundbus.TotalPassengers == BusPassengerEventStats.TotalPassengers then
						DarkRP.notify( driver, 0, 6, "All passengers picked up! Proceed to the "..BusPassengerEventStats.DestinationName )
					else
						local remaining = BusPassengerEventStats.TotalPassengers - foundbus.TotalPassengers
						DarkRP.notify( driver, 0, 6, "Passenger picked up! "..remaining.." passengers remaining." )
					end
				end
			end
		end
		self:NextThink( CurTime() + 1 )
		return true
	end
end
