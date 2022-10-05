AddCSLuaFile()

ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Jailbreaker"
ENT.Category = "Misc NPCs"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = true

function ENT:Initialize()
	self:SetModel( "models/Humans/Group03/male_03.mdl" )
	if SERVER then
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_BBOX )
		self:SetCollisionGroup( COLLISION_GROUP_PLAYER )
		self:SetUseType( SIMPLE_USE )
		self:DropToFloor()
	end
	self.beingused = false
end

local function StartCooldown( self )
	timer.Create( "BreakoutCooldown", 180, 1, function() end )
	hook.Remove( "Think", "BreakoutThink" )
	timer.Remove( "BreakoutTimer" )
	timer.Remove( "BreakoutLoop" )
end

function ENT:AcceptInput( inputname, caller )
	if !caller:IsPlayer() then return end
	if !caller:isArrested() and !caller:IsHandcuffed() then
		DarkRP.notify( caller, 1, 6, "You must be arrested or cuffed to use this NPC." )
		return
	end
	if timer.Exists( "BreakoutCooldown" ) then
		DarkRP.notify( caller, 1, 6, "Cooldown timer: "..string.ToMinutesSeconds( ( timer.TimeLeft( "BreakoutCooldown" ) ) ) )
		return
	end
	if self.beingused then
		DarkRP.notify( caller, 1, 6, "This NPC is already being used!" )
		return
	end
	caller:wanted( nil, "Breaking out of jail." )
	DarkRP.notify( caller, 0, 6, "Please wait for your release." )
	self.beingused = true
	self:StartRelease( caller, self )
	timer.Create( "BreakoutTimer", 180, 1, function() 
		if self.beingused then
			caller:ChatPrint( "Release complete. You have been rewarded $500." )
			caller:addMoney( 500 )
			if caller:isWanted() then caller:unWanted() end
			StartCooldown( self )
			if caller:isArrested() then
				caller:unArrest()
			elseif caller:IsHandcuffed() then
				caller:StripWeapon( "weapon_handcuffed" )
			end
			self.beingused = false
		end
	end )
	timer.Create( "BreakoutLoop", 30, 9, function()
		DarkRP.notify( caller, 1, 6, "Breakout timer: "..string.ToMinutesSeconds( timer.TimeLeft( "BreakoutTimer" ) ) )
	end )
end

function ENT:StartRelease( caller, self )
	if IsValid( caller ) and self.beingused then
		hook.Add( "Think", "BreakoutThink", function()
			if caller:GetPos():DistToSqr( self:GetPos() ) > 250000 then
				DarkRP.notifyAll( 1, 5, caller:Nick()..' exited the release area!' )
				StartCooldown( self )
			end
		end )
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawNPCText( "Jailbreaker" )
	end
end