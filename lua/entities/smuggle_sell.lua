AddCSLuaFile()

ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Smuggler"
ENT.Category = "Misc NPCs"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = true

function ENT:Initialize()
	self:SetModel( "models/humans/group01/male_01.mdl" )
	if SERVER then
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_BBOX )
		self:SetCollisionGroup( COLLISION_GROUP_PLAYER )
	end
	local phys = self:GetPhysicsObject()
	if IsValid( phys ) then
		phys:Wake()
	end
end

if SERVER then
	local usecooldown
	function ENT:AcceptInput( name, caller )
		if usecooldown and usecooldown > CurTime() then return end
		local allowed = {
			[TEAM_CITIZEN] = true,
			[TEAM_TOWER] = true,
			[TEAM_CAMERA] = true,
			[TEAM_BUS] = true,
			[TEAM_HITMAN] = true
		}
		if allowed[caller:Team()] then
			local foundtruck = false
			local truckent
			for k,v in pairs( ents.FindInSphere( self:GetPos(), 500 ) ) do
				if v.SmuggleTruck then
					foundtruck = true
					truckent = v
					break
				end
			end
			if foundtruck then
				SmuggleEnd( caller )
				truckent:Remove()
				usecooldown = CurTime() + 1
				return
			end
			DarkRP.notify( caller, 1, 6, "Truck not detected. Try moving it closer." )
		end
		usecooldown = CurTime() + 1
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawNPCText( "Smuggler" )
	end
end
