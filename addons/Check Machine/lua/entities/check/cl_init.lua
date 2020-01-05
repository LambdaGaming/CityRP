include('shared.lua')

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