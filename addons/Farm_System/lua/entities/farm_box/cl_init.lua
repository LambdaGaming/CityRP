include( "shared.lua" )

surface.CreateFont( "FarmFont", {
	font = "Arial",
	size = 34,
	weight = 800
} )

surface.CreateFont( "FarmFontSmallBox", {
	font = "Arial",
	size = 26,
	weight = 800
} )

local TextYPositions = {
	[1] = -35,
	[2] = 0,
	[3] = 35,
	[4] = 70,
	[5] = 110
}

function ENT:Draw()
	self:DrawModel()
	local plyShootPos = LocalPlayer():GetShootPos()
	if self:GetPos():DistToSqr( plyShootPos ) < 562500 then
		local pos = self:GetPos()
		local ang = self:GetAngles()
		
		ang:RotateAroundAxis( ang:Up(), 90 )
		ang:RotateAroundAxis( ang:Forward(), 90 )

		cam.Start3D2D( pos + self:GetForward() * 20 + self:GetUp() * 7.5, ang, 0.15 )
			surface.SetDrawColor( ColorAlpha( color_theme, 150 ) )
			surface.DrawRect( -200, -55, 402, 210 )
			for i=1, #PlantTypes do
				draw.SimpleTextOutlined( PlantTypes[i].Name..": "..self:GetNWInt( PlantTypes[i].Name ).."/5", "FarmFontSmallBox", -190, TextYPositions[i], PlantTypes[i].LabelColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0, Color( 25, 25, 25, 100 ) )
			end
		cam.End3D2D()
		cam.Start3D2D( pos + self:GetForward() * 21 + self:GetUp() * 7.5, ang, 0.15 )
			local ply = self:GetNWEntity( "owner" )
			if !IsValid( ply ) or !ply:IsPlayer() then
				draw.SimpleTextOutlined( "Farm Box", "FarmFont", 0, -70, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, color_black )
			else
				draw.SimpleTextOutlined( ply:Nick().."'s Box", "FarmFont", 0, -70, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, color_black )
			end
		cam.End3D2D()
	end
end