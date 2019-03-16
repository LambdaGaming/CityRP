AddCSLuaFile()

ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Breakout NPC"
ENT.Category = "Superadmin Only"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = true

function ENT:Initialize()
	self:SetModel( "models/Humans/Group03/male_03.mdl" )
	if SERVER then
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid( SOLID_BBOX )
		self:SetCollisionGroup(COLLISION_GROUP_PLAYER)
		self:SetUseType(SIMPLE_USE)
		self:DropToFloor()
	end
	beingused = false
end

local function StartCooldown( self )
	timer.Create( "BreakoutCooldown", 180, 1, function() end )
	hook.Remove( "Think", "BreakoutThink" )
	timer.Remove( "BreakoutTimer" )
	timer.Remove( "BreakoutLoop" )
end

function ENT:AcceptInput(inputname, caller)
	if !caller:IsPlayer() then return end
	if !caller:isArrested() then
		DarkRP.notify( caller, 1, 6, "You must be arrested to use this NPC." )
		return
	end
	if timer.Exists( "BreakoutCooldown" ) then
		DarkRP.notify( caller, 1, 6, "Cooldown timer: "..string.ToMinutesSeconds( ( timer.TimeLeft( "BreakoutCooldown" ) ) ) )
		return
	end
	if beingused then
		DarkRP.notify( caller, 1, 6, "This NPC is already being used!")
		return
	end
	caller:wanted(nil, "Breaking out of jail.") --Wants the player through DarkRP if they are a criminal job.
	DarkRP.notify( caller, 0, 6, "Please wait for your release.")
	beingused = true
	self:StartRelease( caller, self )
	timer.Create( "BreakoutTimer", 180, 1, function() 
		if beingused then
			caller:ChatPrint( "Release complete. You have been rewarded $500." )
			caller:addMoney( 500 )
			if caller:isWanted() then caller:unWanted() end
			StartCooldown( self )
			if caller:isArrested() then
				caller:unArrest()
			elseif caller:IsHandcuffed() then
				caller:StripWeapon( "weapon_handcuffed" )
			end
			beingused = false
		end
	end )
	timer.Create( "BreakoutLoop", 30, 9, function()
		DarkRP.notify( caller, 1, 6, "Breakout timer: "..string.ToMinutesSeconds( timer.TimeLeft( "BreakoutTimer" ) ) )
	end )
end

function ENT:StartRelease( caller, self )
	if IsValid( caller ) and beingused then
		hook.Add( "Think", "BreakoutThink", function()
			if caller:GetPos():DistToSqr( self:GetPos() ) > 250000 then --DistToSqr is better for performance than just Distance
				DarkRP.notifyAll(1, 5, caller:Nick()..' exited the release area!')
				StartCooldown( self )
			end
		end )
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()

		local pos = self:GetPos()
		pos.z = (pos.z + 15)
		local ang = self:GetAngles()
		
		surface.SetFont("Bebas40Font")
		local title = "Release NPC"
		local tw = surface.GetTextSize(title)
		
		ang:RotateAroundAxis(ang:Forward(), 90)
		ang:RotateAroundAxis(ang:Right(), -90)
		local textang = ang
		
		cam.Start3D2D(pos + ang:Right() * -30, ang, 0.2)
			draw.WordBox(2, -tw *0.5 + 5, -180, title, "Bebas40Font", VOTING.Theme.ControlColor, color_white)
		cam.End3D2D()
	end
end