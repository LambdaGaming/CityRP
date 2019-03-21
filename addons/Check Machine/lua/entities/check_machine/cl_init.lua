include('shared.lua')

function ENT:Draw()
    self:DrawModel()

	local plyShootPos = LocalPlayer():GetShootPos()
	if self:GetPos():DistToSqr( plyShootPos ) < 562500 then
		local pos = self:GetPos()
		pos.z = (pos.z + 15)
		local ang = self:GetAngles()
		
		surface.SetFont("Bebas40Font")
		local title = "Check Machine"
		local tw = surface.GetTextSize(title)
		
		ang:RotateAroundAxis(ang:Forward(), 90)
		ang:RotateAroundAxis(ang:Right(), -90)
		local textang = ang
		
		cam.Start3D2D(pos + ang:Right() * 0, ang, 0.2)
			draw.WordBox(2, -tw *0.5 + 5, -180, title, "Bebas40Font", VOTING.Theme.ControlColor, color_white)
		cam.End3D2D()
	end
end

local function CheckMenu()
	local frame = vgui.Create( "DFrame" )
	frame:SetTitle( "Check Machine Warning:" )
	frame:SetSize( 300, 300 )
	frame:Center()
	frame:MakePopup()
	frame.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 49, 53, 61, 200 ) ) --Warns the player about the usage of the check machine
		draw.SimpleText( "This machine generates checks worth $2000 each,", "Trebuchet18", 150, 45, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 25, 25, 25 ) )
		draw.SimpleText( "and it is only to be used in emergencies,", "Trebuchet18", 150, 58, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 25, 25, 25 ) )
		draw.SimpleText( "such as hostage situations. Do you wish to proceed?", "Trebuchet18", 150, 71, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 25, 25, 25 ) )
	end
	
	local button = vgui.Create( "DButton", frame )
	button:SetText( "Proceed to produce check." )
	button:SetTextColor( color_white )
	button:SetPos( 25, 100 )
	button:SetSize( 250, 30 )
	button.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 93, 80, 255 ) )
	end
	button.DoClick = function()
		net.Start( "CheckAccept" )
		net.SendToServer() --Sends the spawn request to the server if the player clicks the proceed button
		frame:Close()
	end
end

net.Receive( "CheckMenu", function( len, ply )
	CheckMenu()
end )
