
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
	local ent = ents.Create( "crafting_book" )
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

	//self:SetEntName( "wrench" )
	//self:SetRealName( "Wrench" )
end

function ENT:Use( caller, activator )

end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
		local Ang = self:GetAngles() + Angle(-90,0,0)

		Ang:RotateAroundAxis(Ang:Forward(), 90)
		Ang:RotateAroundAxis(Ang:Right(), -90)
	
		cam.Start3D2D(self:GetPos() + (self:GetUp() * 6), Ang, 0.1)
			draw.SimpleText( "Crafting Blueprint", "Trebuchet22", 10, 0, Color(0, 0, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(25, 25, 25) )
			draw.SimpleText( self:GetRealName(), "Trebuchet22", 10, 10, Color(0, 0, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(25, 25, 25) )
		cam.End3D2D()
    end
end