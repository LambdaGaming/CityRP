AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Purifier"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Drugs"

function ENT:SetupDataTables()
	self:NetworkVar( "Int", "Purity" )
	self:NetworkVar( "Int", "Fuel" )
	if SERVER then
		self:SetPurity( -1 )
		self:SetFuel( 0 )
	end
end

function ENT:Initialize()
    self:SetModel( "models/props_wasteland/laundry_washer003.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetTrigger( true )
		self:SetUseType( SIMPLE_USE )
		self:SetHealth( 300 )
		self:SetMaxHealth( 300 )
	end
	self:PhysWake()
end

if SERVER then
	function ENT:ExtractCoke()
		local e = ents.Create( "drug_cocaine" )
		e:SetPos( self:GetPos() + self:GetForward() * 70 )
		e:Spawn()
		e:SetPurity( self:GetPurity() )
		self:SetPurity( -1 )
		self.Purifying = nil
		self:EmitSound( "HL1/ambience/steamburst1.wav", 75, math.random( 75, 125 ) )
		if self.Snd then
			self.Snd:Stop()
		end
	end
	
	function ENT:Use( ply )
		if self.Purifying then
			self:ExtractCoke()
		else
			DarkRP.notify( ply, 1, 6, "There isn't any cocaine in the purifier to take out!" )
		end 
	end
	
	function ENT:StartTouch( ent )
		if ent:GetClass() == "raw_cocaine" and !self.Purifying then
			self.Purifying = true
			ent:Remove()
			self:EmitSound( "ambient/machines/combine_terminal_idle4.wav", 75, 70 )
			timer.Simple( 3, function()
				if !self.Snd or !self.Snd:IsPlaying() then
					self.Snd = CreateSound( self, "ambient/machines/laundry_machine1_amb.wav" )
					self.Snd:Play()
				end
			end )
		elseif ent:GetClass() == "ent_gauto_fuel" then
			self:EmitSound( "physics/metal/metal_barrel_impact_soft"..math.random( 1, 4 )..".wav" )
			self:SetFuel( 100 )
			ent:Remove()
		end
	end

	function ENT:Think()
		if self.Purifying then
			local rand = math.random( 1, 100 )
			if rand == 10 then
				self:Ignite()
			end
			self:SetPurity( self:GetPurity() + 1 )
			self:SetFuel( self:GetFuel() - 1 )
			if self:GetPurity() >= 100 or self:GetFuel() <= 0 then
				self:ExtractCoke()
			end
		end
		self:NextThink( CurTime() + 10 )
		return true
	end

	function ENT:OnTakeDamage( dmg )
		local d = dmg:GetDamage()
		local health = self:Health()
		if health > 0 then
			self:SetHealth( health - d )
		else
			local explosion = ents.Create( "env_explosion" )			
			explosion:SetPos( self:GetPos() )
			explosion:SetKeyValue( "iMagnitude", 200 )
			explosion:Spawn()
			explosion:Activate()
			explosion:Fire( "Explode", 0, 0 )
			self:Remove()
		end
	end

	function ENT:OnRemove()
		if self.Snd then
			self.Snd:Stop()
		end
	end
end

if CLIENT then
    function ENT:Draw()
		self:DrawModel()
		local plyShootPos = LocalPlayer():GetShootPos()
		if self:GetPos():DistToSqr( plyShootPos ) < 562500 then
			local pos = self:GetPos()
			pos.z = pos.z + 15
			local ang = self:GetAngles()
			
			surface.SetFont( "Bebas40Font" )
			local title = "Purifier"
			local tw = surface.GetTextSize( title )
			ang:RotateAroundAxis( ang:Forward(), 90 )
			ang:RotateAroundAxis( ang:Right(), 180 )
			
			local purity = self:GetPurity()
			cam.Start3D2D( pos + ang:Right() * -10, ang, 0.2 )
				draw.WordBox( 2, -tw *0.5 + 20, -130, title, "Bebas40Font", color_theme, color_white )
			cam.End3D2D()
			cam.Start3D2D( pos + ang:Right() * 1, ang, 0.2 )
			draw.WordBox( 2, -tw *0.5 - 70, -140, "Fuel: "..self:GetFuel().."%", "Bebas40Font", color_theme, color_white )
			if purity >= 0 then
				draw.WordBox( 2, -tw *0.5 - 70, -150, "Purity: "..self:GetPurity().."%", "Bebas40Font", color_theme, color_white )
			else
				draw.WordBox( 2, -tw *0.5 - 70, -150, "Insert raw cocaine to start purifying", "Bebas40Font", color_theme, color_white )
			end
			cam.End3D2D()
		end
	end
end
