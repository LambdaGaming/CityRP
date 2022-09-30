AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Purifier"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Crime+"

function ENT:SpawnFunction( ply, tr, name )
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 1
	local ent = ents.Create( name )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
    self:SetModel( "models/props_wasteland/laundry_washer003.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetTrigger( true )
		self:SetUseType( SIMPLE_USE )
	end
 
    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	self:SetNWInt( "CokePurity", 0 )
	self:SetNWBool( "HasCocaine", false )
end

function ENT:Use( activator, caller )
	if self:GetNWBool( "HasCocaine" ) then
		if timer.TimeLeft( "CokeTimer"..self:EntIndex() ) > 540 then
			DarkRP.notify( activator, 1, 6, "Please wait at least 60 seconds before taking out your pure cocaine." )
			return
		end
		timer.Remove( "CokeIncrement"..self:EntIndex() )
		timer.Adjust( "CokeTimer"..self:EntIndex(), 0.1 )
	else
		DarkRP.notify( activator, 1, 6, "There isn't any cocaine in the purifier to take out!" )
	end 
end

function ENT:StartTouch( ent )
	if ent:GetClass() == "raw_cocaine" and !self:GetNWBool( "HasCocaine" ) then
		self:SetNWBool( "HasCocaine", true )
		ent:Remove()
		self:EmitSound( "ambient/machines/combine_terminal_idle4.wav", 75, 70 )
		timer.Simple( 3, function()
			if !self.Snd or !self.Snd:IsPlaying() then
				self.Snd = CreateSound( self, "ambient/machines/laundry_machine1_amb.wav" )
				self.Snd:Play()
			end
		end )
		timer.Create( "CokeIncrement"..self:EntIndex(), 1, 600, function() self:SetNWInt( "CokePurity", self:GetNWInt( "CokePurity" ) + 1 ) end )
		timer.Create( "CokeTimer"..self:EntIndex(), 600, 1, function()
			local e = ents.Create( "pure_cocaine" )
			e:SetPos( self:GetPos() + self:GetForward() * 70 )
			e:Spawn()
			e:SetNWInt( "Purity", self:GetNWInt( "CokePurity" ) )
			self:SetNWInt( "HasCocaine", false )
			self:EmitSound( "HL1/ambience/steamburst1.wav", 75, math.random( 75, 125 ) )
			if self.Snd then
				self.Snd:Stop()
			end
		end )
	end
end

if CLIENT then
	local function BoolToNumber( bool )
		return bool and 1 or 0
	end

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
			local textang = ang
			
			cam.Start3D2D( pos + ang:Right() * -10, ang, 0.2 )
				draw.WordBox( 2, -tw *0.5 + 20, -130, title, "Bebas40Font", color_theme, color_white )
			cam.End3D2D()
			cam.Start3D2D( pos + ang:Right() * 1, ang, 0.2 )
				draw.WordBox( 2, -tw *0.5 - 135, -140, "Current Cocaine Amount: "..BoolToNumber( self:GetNWBool( "HasCocaine" ) ).."/1", "Bebas40Font", color_theme, color_white )
			cam.End3D2D()
		end
	end
end
