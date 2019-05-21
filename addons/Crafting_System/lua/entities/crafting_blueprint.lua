
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Crafting Blueprint"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Superadmin Only"

function ENT:SpawnFunction( ply, tr )
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 1
	local ent = ents.Create( "crafting_blueprint" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "EntName" )
	self:NetworkVar( "String", 1, "RealName" )
end

function ENT:Initialize()
    self:SetModel( "models/props_lab/binderblue.mdl" )
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
	end
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use( caller, activator )
	DarkRP.notify( caller, 0, 6, "Place this near a crafting table to use it." )
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
		local plyShootPos = LocalPlayer():GetShootPos()
		if self:GetPos():DistToSqr( plyShootPos ) < 100000 then
			local Ang = self:GetAngles() + Angle(-90,0,0)

			surface.SetFont("Bebas40Font")
			local title = "Crafting Blueprint"
			local title2 = self:GetRealName()
			local tw = surface.GetTextSize(title)

			Ang:RotateAroundAxis(Ang:Forward(), 90)
			Ang:RotateAroundAxis(Ang:Right(), -90)
		
			cam.Start3D2D(self:GetPos() + ( self:GetUp() * 6 ) + self:GetRight() * -2, Ang, 0.05)
				draw.WordBox(2, -tw *0.5 + 5, -60, title, "Bebas40Font", VOTING.Theme.ControlColor, color_white)
				draw.WordBox(2, -tw *0.5 + 5, -20, title2, "Bebas40Font", VOTING.Theme.ControlColor, color_white)
			cam.End3D2D()
		end
    end
end
