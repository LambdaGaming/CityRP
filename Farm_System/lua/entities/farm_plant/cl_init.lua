include( "shared.lua" )

local function CalcPercentage( y, x )
	local p = y / x
	local realp = p * 100
	local roundp = math.Round( realp, 0 )
	return roundp
end

function ENT:Draw()
	self:DrawModel()
	local plyShootPos = LocalPlayer():GetShootPos()
	if self:GetPos():DistToSqr( plyShootPos ) < 562500 then
		local PlantType = self:GetPlantType()
		local PlantTable = PlantTypes[PlantType]
		if !PlantTable then return end
		if self:GetPlanted() then
			local growth = self:GetGrowth()
			local GrowTime = PlantTable.GrowthTime
			local title = PlantTable.Name.." Plant"
			local title2 = "Progress: "..CalcPercentage( growth, GrowTime ).."%"
			
			local ang = self:GetAngles()
			ang:RotateAroundAxis( self:GetAngles():Right(), 270 )
			ang:RotateAroundAxis( self:GetAngles():Forward(), 90 )
			local pos = self:GetPos() + ang:Right() * -20 + ang:Up() * 26 + ang:Forward() * -25
			cam.Start3D2D( pos, ang, 0.1 )
				surface.SetFont( "FarmFont" )
				draw.RoundedBox( 0, 115, -120, 250, 70, PlantTable.LabelColor )
				draw.SimpleText( title, "FarmFont", 240, -100, PlantTable.LabelTextColor, 1, 1 )
				draw.SimpleText( title2, "FarmFont", 240, -70, PlantTable.LabelTextColor, 1, 1 )
			cam.End3D2D()
		else
			local GrowTime = PlantTable.GrowthTime
			local title = PlantTable.Name.." Seed"
			
			local ang = self:GetAngles()
			ang:RotateAroundAxis( self:GetAngles():Right(), 270 )
			ang:RotateAroundAxis( self:GetAngles():Forward(), 90 )
			local pos = self:GetPos() + ang:Forward() * -25
			cam.Start3D2D( pos, ang, 0.1 )
				surface.SetFont( "FarmFont" )
				draw.RoundedBox( 0, 155, -120, 250, 45, PlantTable.LabelColor )
				draw.SimpleText( title, "FarmFont", 280, -100, PlantTable.LabelTextColor, 1, 1 )
			cam.End3D2D()
		end
	end
end
