AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Coca Plant"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Drugs"

function ENT:Initialize()
    self:SetModel( "models/props/cs_office/plant01.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:SetHealth( 100 )
		self:SetMaxHealth( 100 )
		self:PrecacheGibs()
	end
	self:PhysWake()
	self:SetNWInt( "Growth", 0 )
end

function ENT:FullyGrown()
	return self:GetNWInt( "Growth" ) == 1200
end

if SERVER then
	function ENT:Use( ply )
		if self:FullyGrown() then
			local e = ents.Create( "raw_cocaine" )
			e:SetPos( self:GetPos() )
			e:Spawn()
			self:EmitSound( "physics/glass/glass_impact_soft"..math.random( 1, 3 )..".wav" )
			self:Remove()
		else
			DarkRP.notify( ply, 1, 6, "You cannot harvest this plant yet." )
		end
	end

	function ENT:Think()
		local growth = self:GetNWInt( "Growth" )
		if growth == 1200 then return end
		local tr = util.TraceLine( {
			start = self:GetPos() + Vector( 0, 0, 50 ),
			endpos = self:GetPos() + self:GetAngles():Up() * 200
		} )
		if IsValid( tr.Entity ) and tr.Entity:GetClass() == "heat_lamp" and tr.Entity:GetActive() then
			local amount = 1
			if EcoPerkActive( "Cut Agricultural Budget" ) then
				amount = 0.5
			elseif EcoPerkActive( "Increase Agricultural Budget" ) then
				amount = 2
			end
			self:SetNWInt( "Growth", math.Clamp( growth + amount, 0, 1200 ) )
		end
		self:NextThink( CurTime() + 1 )
		return true
	end

	function ENT:OnTakeDamage( dmg )
		local d = dmg:GetDamage()
		local health = self:Health()
		if health > 0 then
			self:SetHealth( health - d )
		else
			self:GibBreakClient( vector_origin )
			self:Remove()
		end
	end
end

if CLIENT then
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
			local growth = self:GetNWInt( "Growth" )
			surface.SetFont("Bebas40Font")
			local title = "Coca Plant"
			local title2 = "Progress: "..CalcPercentage( growth, 1200 ).."%"
			
			local ang = self:GetAngles()
			ang:RotateAroundAxis( self:GetAngles():Right(), 270 )
			ang:RotateAroundAxis( self:GetAngles():Forward(), 90 )
			local pos = self:GetPos() + ang:Right() * -20 + ang:Up() * 26 + ang:Forward() * -25
			cam.Start3D2D( pos, ang, 0.1 )
				draw.RoundedBox( 0, 85, -120, 300, 80, Color( 38, 41, 49, 220 ) )
				draw.SimpleText( title, "Bebas40Font", 240, -100, color_white, 1, 1 )
				if self:GetNWInt( "Growth" ) == 1200 then
					draw.SimpleText( title2, "Bebas40Font", 240, -70, Color( 15, 120, 0, 255 ), 1, 1 )
				else
					draw.SimpleText( title2, "Bebas40Font", 240, -70, color_white, 1, 1 )
				end
			cam.End3D2D()
		end
    end
end
