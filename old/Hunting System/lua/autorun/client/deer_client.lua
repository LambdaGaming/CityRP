
local function DeerMenu( ent )
	local Frame = vgui.Create( "DFrame" )
	Frame:SetTitle( "Deer Corpse Actions:" )
	Frame:SetSize( 300, 300 )
	Frame:Center()
	Frame:MakePopup()
	Frame.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 49, 53, 61, 200 ) )
	end
	
	local Button1 = vgui.Create( "DButton", Frame )
	Button1:SetText( "Cut Up Into Raw Meat" )
	Button1:SetTextColor( color_white )
	Button1:SetPos( 50, 50 )
	Button1:SetSize( 200, 30 )
	Button1.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 93, 80, 255 ) )
	end
	Button1.DoClick = function()
		net.Start( "DeerCut" )
		net.WriteEntity( ent )
		net.SendToServer()
		Frame:Remove()
	end
	
	local Button2 = vgui.Create( "DButton", Frame )
	Button2:SetText( "Take Head As Trophy And Dispose Of Body" )
	Button2:SetTextColor( color_white )
	Button2:SetPos( 25, 100 )
	Button2:SetSize( 250, 30 )
	Button2.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 93, 80, 255 ) )
	end
	Button2.DoClick = function()
		net.Start( "DeerHead" )
		net.WriteEntity( ent )
		net.SendToServer()
		Frame:Remove()
	end
	
	local Button3 = vgui.Create( "DButton", Frame )
	Button3:SetText( "Close Menu" )
	Button3:SetTextColor( color_white )
	Button3:SetPos( 100, 150 )
	Button3:SetSize( 100, 30 )
	Button3.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 93, 80, 255 ) )
	end
	Button3.DoClick = function()
		Frame:Remove()
	end
end

net.Receive( "DeerMenu", function( len, ply )
	local ent = net.ReadEntity()
	DeerMenu( ent )
end )