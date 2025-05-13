ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Check"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Check Machine"

if SERVER then
	function ENT:Initialize()
		self:SetModel( "models/props_lab/clipboard.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:PhysWake()
	end
	
	function ENT:Use( activator, caller )
		if IsValid(caller) and caller:IsPlayer() then
			if caller:IsEMS() or caller:isCP() or caller:Team() == TEAM_BANKER then return end
			caller:addMoney( 2000 )
			DarkRP.notify( caller, 0, 6, "You have collected $2000 from a bank check." )
			MoneyTransferEnd()
			NotifyJob( TEAM_BANKER, 1, 6, "You have failed to protect the check. It has been stolen!" )
			self:Remove()
		end
	end
end

if CLIENT then
	surface.CreateFont( "CheckText", {
		font = "Arial",
		size = 22
	} )
	
	function ENT:Draw()
		self:DrawModel()
		local Ang = self:GetAngles() + Angle(-90,0,0)
		Ang:RotateAroundAxis(Ang:Forward(), 90)
		Ang:RotateAroundAxis(Ang:Right(), -90)
		cam.Start3D2D(self:GetPos() + (self:GetUp() * 3), Ang, 0.1)
			draw.SimpleText("Bank Check Amount: $2000", "CheckText", 0, 0, Color(0, 0, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(25, 25, 25))
		cam.End3D2D()
	end
end
