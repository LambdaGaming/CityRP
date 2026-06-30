AddCSLuaFile()

ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Car Dealer"
ENT.AutomaticFrameAdvance = true

function ENT:Initialize()
	self:SetModel( "models/Characters/Hostage_02.mdl" )
	if SERVER then
		self:SetHullType( HULL_HUMAN )
		self:SetHullSizeNormal()
		self:SetNPCState( NPC_STATE_SCRIPT )
		self:SetSolid( SOLID_BBOX )
		self:CapabilitiesAdd( bit.bor( CAP_ANIMATEDFACE, CAP_TURN_HEAD ) )
		self:SetUseType( SIMPLE_USE )
		self:DropToFloor()
	end
end

if SERVER then
	function ENT:AcceptInput( name, activator, caller )
		if name == "Use" and IsValid( caller ) then
			local vehicles = {}
			MySQLite.query( string.format( [[SELECT * FROM tcb_cardealer WHERE steamID = %s]], MySQLite.SQLStr( caller:SteamID() ) ), function( data )
				for k, v in pairs( data or {} ) do
					table.insert( vehicles, v.vehicle )
				end
				if caller:Team() == TEAM_TOWER then
					net.Start( "TCBDealerMenuRent" )
					net.WriteTable( vehicles )
					net.WriteInt( self.id, 32 )
					net.WriteEntity( self )
					net.WriteTable( FindVehicles( caller ) )
					net.Send( caller )
				else
					net.Start( "TCBDealerMenu" )
					net.WriteTable( vehicles )
					net.WriteInt( self.id, 32 )
					net.Send( caller )
				end
			end )
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
		self:DrawOverheadText( TCBDealer.settings.frameTitle )
	end
end
