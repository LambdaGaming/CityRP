AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
    self:SetModel( "models/props/cs_office/computer.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:PhysWake()
end

util.AddNetworkString( "OpenDepositComputerMenu" )
function ENT:Use( ply )
	if ply:Team() != TEAM_BANKER then
		DarkRP.notify( ply, 1, 6, "Only bankers can access the bank computer." )
		return
	end
	local tbl = ReadLoanFile()
	net.Start( "OpenDepositComputerMenu" )
	net.WriteTable( tbl )
	net.Send( ply )
end
