--NPC text drawing function, modified from https://github.com/Bhoonn/bh_accessories/blob/main/lua/entities/bh_acc_vendor/cl_init.lua

local ent = FindMetaTable( "Entity" )
local offset = Vector( 0, 0, 80 )
local Draw_SimpleText = draw.SimpleText
local surface_SetMaterial = surface.SetMaterial
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local surface_SetFont = surface.SetFont
local surface_GetTextSize = surface.GetTextSize

function ent:DrawNPCText( text, override )
	self:DrawModel()

	local origin = self:GetPos()
	local ply = LocalPlayer()
	if ply:GetPos():DistToSqr( origin ) >= ( 768 * 768 ) then return end

	local pos = origin + ( override or offset )
	local ang = ( ply:EyePos() - pos ):Angle()
	ang.p = 0
	ang:RotateAroundAxis( ang:Right(), 90 )
	ang:RotateAroundAxis( ang:Up(), 90 )
	ang:RotateAroundAxis( ang:Forward(), 180 )
	cam.Start3D2D(pos, ang, 0.035)
        surface_SetFont( "BHACC_VendorTextFont" )
        local tw, th = surface_GetTextSize( text )
		Draw_SimpleText( text, "BHACC_VendorTextFont", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
	cam.End3D2D()
end
