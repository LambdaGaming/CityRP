AddCSLuaFile()

ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Banker NPC"
ENT.Category = "Misc NPCs"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = true

function ENT:Initialize()
	self:SetModel( "models/player/group01/male_02.mdl" )
	if SERVER then
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_BBOX )
		self:SetCollisionGroup( COLLISION_GROUP_PLAYER )
	end
	local phys = self:GetPhysicsObject()
	if IsValid( phys ) then
		phys:Wake()
	end
	
	self.checkused = false
end

function ENT:AcceptInput( activator, caller )
	if !caller:IsPlayer() then return end
	if caller:Team() == TEAM_BANKER and GetGlobalString( "ActiveEvent" ) == "Money Transfer" and !self.checkused then
		local check = ents.Create( "check" )
		check:Spawn()
		check:SetPos( caller:GetPos() + Vector(30, 0, 0) )
		check.IsEventCheck = true
		DarkRP.notify( caller, 0, 6, "Take this check to the check machine to for a reward." )
		self.checkused = true
	end
end

function ENT:Think()
	self:SetSequence("idle_all_02")
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
		local plyShootPos = LocalPlayer():GetShootPos()
		if self:GetPos():DistToSqr( plyShootPos ) < 562500 then
			local pos = self:GetPos()
			pos.z = pos.z + 15
			local ang = self:GetAngles()
			
			surface.SetFont( "Bebas40Font" )
			local title = "Banker"
			local tw = surface.GetTextSize( title )
			
			ang:RotateAroundAxis( ang:Forward(), 90 )
			ang:RotateAroundAxis( ang:Right(), -90 )
			local textang = ang
			
			cam.Start3D2D( pos + ang:Right() * -30, ang, 0.2 )
				draw.WordBox( 2, -tw * 0.5 + 5, -180, title, "Bebas40Font", color_theme, color_white )
			cam.End3D2D()
		end
	end
end