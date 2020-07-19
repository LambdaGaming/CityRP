
AddCSLuaFile()

ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Gas Pump"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = false

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
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		for k,v in RandomPairs( Stops ) do
			self:SetNWString( "SetStop", k )
			break
		end
	end
end

function ENT:Think()
	self:SetSequence( "idle_all_02" )
end

function ENT:AcceptInput( name, caller )
	if CLIENT then return end
	if caller.buscooldown and caller.buscooldown > CurTime() then return end
	if !caller:IsPlayer() then return end
	if caller:Team() == TEAM_BUS and GetGlobalString( "ActiveEvent" ) == "Bus Passenger" then
		local bus = ents.FindInSphere( self:GetPos(), 200 )
		local foundbus = false
		for k,v in pairs( bus ) do
			if v:IsVehicle() and v:GetModel() == "models/tdmcars/bus.mdl" then
				foundbus = v
				break
			end
		end
		if foundbus then
			foundbus.HasPassenger = true
			foundbus.SetStop = self:GetNWString( "SetStop" )
			DarkRP.notify( caller, 0, 10, "The passenger is on your bus. Type !busstop when you arrive at the destination to let them know to get off." )
			self:Remove()
		else
			DarkRP.notify( caller, 1, 6, "Move your bus closer to the passenger to let them board." )
		end
	else
		DarkRP.notify( caller, 1, 6, "Only bus drivers can use this NPC." )
	end
	caller.buscooldown = CurTime() + 1
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()

		local plyShootPos = LocalPlayer():GetShootPos()
		if self:GetPos():DistToSqr( plyShootPos ) < 562500 then
			local pos = self:GetPos()
			pos.z = pos.z + 15
			local ang = self:GetAngles()
			
			surface.SetFont("Bebas40Font")
			local title = "Take me to the "..self:GetNWString( "SetStop" ).." for cash."
			local tw = surface.GetTextSize(title)
			
			ang:RotateAroundAxis(ang:Forward(), 90)
			ang:RotateAroundAxis(ang:Right(), -90)
			local textang = ang
			
			cam.Start3D2D(pos + ang:Right() * -30, ang, 0.2)
				draw.WordBox(2, -tw *0.5 + 5, -180, title, "Bebas40Font", color_theme, color_white)
			cam.End3D2D()
		end
	end
end