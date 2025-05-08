AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Purifier"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Drugs"

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
 
    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

if SERVER then
	function ENT:ExtractCoke()
		timer.Pause( "CokeTimer"..self:EntIndex() )
		if SERVER then
			local purity = 2700 - math.Round( math.abs( timer.TimeLeft( "CokeTimer"..self:EntIndex() ) ) )
			local e = ents.Create( "pure_cocaine" )
			e:SetPos( self:GetPos() + self:GetForward() * 70 )
			e:Spawn()
			e:SetNWInt( "Purity", purity )
			if purity >= 2400 then
				e:SetColor( color_black )
			end
		end
		self:SetNWInt( "StartTime", 0 )
		self.Purifying = nil
		self:EmitSound( "HL1/ambience/steamburst1.wav", 75, math.random( 75, 125 ) )
		if self.Snd then
			self.Snd:Stop()
		end
		timer.Remove( "CokeTimer"..self:EntIndex() )
	end
	
	function ENT:Use( ply )
		if timer.Exists( "CokeTimer"..self:EntIndex() ) and timer.TimeLeft( "CokeTimer"..self:EntIndex() ) > 2100 then
			DarkRP.notify( ply, 1, 6, "Please wait at least 10 minutes before taking out your pure cocaine." )
			return
		end
		if self.Purifying then
			self:ExtractCoke()
		else
			DarkRP.notify( ply, 1, 6, "There isn't any cocaine in the purifier to take out!" )
		end 
	end
	
	function ENT:StartTouch( ent )
		if ent:GetClass() == "raw_cocaine" and !self.Purifying then
			self:SetNWInt( "StartTime", CurTime() )
			self.Purifying = true
			ent:Remove()
			self:EmitSound( "ambient/machines/combine_terminal_idle4.wav", 75, 70 )
			timer.Simple( 3, function()
				if !self.Snd or !self.Snd:IsPlaying() then
					self.Snd = CreateSound( self, "ambient/machines/laundry_machine1_amb.wav" )
					self.Snd:Play()
				end
			end )
			timer.Create( "CokeTimer"..self:EntIndex(), 2700, 1, function()
				if !IsValid( self ) then return end
				self:ExtractCoke()
			end )
		end
	end

	function ENT:Think()
		if self.Purifying then
			local rand = math.random( 1, 100 )
			if rand <= 5 then
				self:Ignite()
			end
		end
		self:NextThink( CurTime() + 150 )
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
			
			local start = self:GetNWInt( "StartTime" )
			local time = start > 0 and CurTime() - start or 0
			cam.Start3D2D( pos + ang:Right() * -10, ang, 0.2 )
				draw.WordBox( 2, -tw *0.5 + 20, -130, title, "Bebas40Font", color_theme, color_white )
			cam.End3D2D()
			cam.Start3D2D( pos + ang:Right() * 1, ang, 0.2 )
				draw.WordBox( 2, -tw *0.5 - 70, -140, "Purify Time: "..string.ToMinutesSeconds( time ), "Bebas40Font", color_theme, color_white )
			cam.End3D2D()
		end
	end
end
