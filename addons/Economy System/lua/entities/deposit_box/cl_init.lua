include( "shared.lua" )

function ENT:Draw()
    self:DrawModel()

	if !self.Locked then return end
	local plyShootPos = LocalPlayer():GetShootPos()
	if self:GetPos():DistToSqr( plyShootPos ) < 562500 then
		local ang = self:GetAngles()
		ang:RotateAroundAxis( self:GetAngles():Right(), 270 )
		ang:RotateAroundAxis( self:GetAngles():Forward(), 90 )

		local pos = self:GetPos() + ang:Up() * 9 + ang:Right() * -5.5 + ang:Forward() * -8.5
		cam.Start3D2D( pos, ang, 0.1 )
			draw.RoundedBox( 0, 20, 20, 130, 70, color_theme )
			draw.SimpleText( "Owner:", "Trebuchet18", 90, 45, color_white, 1, 1 )
			draw.SimpleText( self.MoneyOwner:Nick(), "Trebuchet18", 90, 65, color_white, 1, 1 )
		cam.End3D2D()
	end
end

local function GetNewOwner()
	local ply = net.ReadEntity()
	local ent = net.ReadEntity()
	local amount = net.ReadInt( 32 )
	ent.Locked = true
	ent.MoneyOwner = ply
	ent.OriginalAmount = amount
	ent.MoneyAmount = amount
end
net.Receive( "Deposit_GetNewOwner", GetNewOwner )

local function DeleteOwner()
	local ent = net.ReadEntity()
	ent.Locked = false
	ent.MoneyOwner = nil
end
net.Receive( "Deposit_DeleteOwner", DeleteOwner )

local function UpdateAmount()
	local ent = net.ReadEntity()
	local amount = net.ReadInt( 32 )
	ent.MoneyAmount = amount
end
net.Receive( "Deposit_UpdateAmount", UpdateAmount )
