AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:SpawnFunction( ply, tr, name )
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 1
	local ent = ents.Create( name )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	ent:SpawnExtraBoxes() --Can't put this in ENT:Initialize since it creates an infinite spawn loop and crashes the server
	return ent
end

function ENT:Initialize()
    self:SetModel( "models/tobadforyou/deposit_box.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:SetTrigger( true )
	self:PhysWake()
	self:Open()
end

function ENT:Use( ply )
	if ply:Team() == TEAM_BANKER then
		if self.MoneyOwner and !self.MoneyOwner.PendingRequest then
			DarkRP.notify( ply, 0, 6, "Sending request to "..self.MoneyOwner:Nick().." to have their money withdrawn." )
			self.MoneyOwner:ChatPrint( "WARNING: The banker is attempting to withdraw money from your deposit box. If you authorized this, type !withdraw. Otherwise, you can safely ignore this message." )
			DarkRP.notify( self.MoneyOwner, 0, 10, "WARNING: The banker is attempting to withdraw money from your deposit box. If you authorized this, type !withdraw." )
			self.MoneyOwner.PendingRequest = true
			self.MoneyOwner.RequestedBox = self
			timer.Create( "WithdrawRequest"..self.MoneyOwner:EntIndex(), 60, 1, function()
				DarkRP.notify( ply, 1, 6, self.MoneyOwner:Nick().." did not accept your request." )
			end )
		else
			DarkRP.notify( ply, 1, 6, "This deposit box doesn't have an owner." )
		end
	else
		DarkRP.notify( ply, 1, 6, "Only bankers can withdraw money from deposit boxes. If you wish to rob this deposit box, use a lockpick." )
	end
end

util.AddNetworkString( "Deposit_GetNewOwner" )
util.AddNetworkString( "Deposit_UpdateAmount" )
function ENT:StartTouch( ent )
	local getbankers = team.GetPlayers( TEAM_BANKER )
	if self.Locked or #getbankers == 0 then return end
	local banker = getbankers[1]
	if ent:GetClass() == "spawned_money" and ent.MoneyOwner != banker then --Theres only 1 banker on the server at a time so this should work fine
		if ent.MoneyOwner.HasDeposit or ent.PickupOwner != banker then return end
		self.MoneyOwner = ent.MoneyOwner
		self.MoneyAmount = ent:Getamount()
		self.OriginalAmount = ent:Getamount()
		self.MoneyOwner.HasDeposit = true
		ent:Remove()
		self:Close()
		timer.Create( "InterestLoop"..self.MoneyOwner:EntIndex(), 300, 0, function()
			if self.MoneyAmount >= 50000 then
				DarkRP.notify( self.MoneyOwner, 1, 6, "Your deposit box has reached maximum capacity!" )
				return
			end
			local bankerincome = math.Round( self.MoneyAmount * 0.03 )
			local ownerincome = math.Round( self.MoneyAmount * 0.02 )
			banker:addMoney( bankerincome )
			self.MoneyAmount = self.MoneyAmount + ownerincome
			DarkRP.notify( banker, 0, 6, "You have received "..DarkRP.formatMoney( bankerincome ).." from "..self.MoneyOwner:Nick().."'s deposit box." )
			DarkRP.notify( self.MoneyOwner, 0, 6, "You have received "..DarkRP.formatMoney( ownerincome ).." from your deposit box." )
			net.Start( "Deposit_UpdateAmount" )
			net.WriteEntity( self )
			net.WriteInt( self.MoneyAmount, 32 )
			net.Broadcast()
		end )
		net.Start( "Deposit_GetNewOwner" )
		net.WriteEntity( ent.MoneyOwner )
		net.WriteEntity( self )
		net.WriteInt( self.OriginalAmount, 32 )
		net.Broadcast()
	end
end

function ENT:Open()
	local id, dur = self:LookupSequence( "Close" )
	self:ResetSequence( id )
	self:SetPlaybackRate( 0.75 )
	self.Locked = false
end

function ENT:Close()
	local id, dur = self:LookupSequence( "Open" )
	self:ResetSequence( id )
	self:SetPlaybackRate( 0.75 )
	self.Locked = true
end

function ENT:SpawnExtraBoxes()
	local pos = self:GetPos()
	local right = self:GetRight()
	local up = self:GetUp()
	local angles = self:GetAngles()
	local positions = {
		[1] = pos + up * 8,
		[2] = pos + right * 16,
		[3] = pos + up * 8 + right * 16,
		[4] = pos + up * 16,
		[5] = pos + up * 16 + right * 16,
		[6] = pos + up * 8 + right * 32,
		[7] = pos + right * 32,
		[8] = pos + up * 16 + right * 32
	}
	local tbl = {}
	self.Deposit = {}
	for i=1, 8 do
		self.Deposit[i] = ents.Create( "deposit_box" )
		self.Deposit[i]:SetPos( positions[i] )
		self.Deposit[i]:SetAngles( angles )
		self.Deposit[i]:Spawn()
		self.Deposit[i]:GetPhysicsObject():EnableMotion( false )
		self.Deposit[i]:Open()
		tbl[i] = self.Deposit[i]
	end
	for k,v in pairs( tbl ) do
		constraint.Weld( v, self, 0, 0, 0, 0, true )
		for a,b in pairs( tbl ) do
			constraint.Weld( v, b, 0, 0, 0, 0, true )
		end
	end
end
