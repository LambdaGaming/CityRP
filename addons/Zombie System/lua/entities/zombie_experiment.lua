AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Experimental Steroids"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Superadmin Only"

function ENT:Initialize()
    self:SetModel( "models/props_lab/jar01b.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:SetTrigger( true )
	end
    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:Use( ply )
	if self.Infected then
		ply.Infected = true
		timer.Create( "Regen"..ply:SteamID64(), 1, 600, function()
			if !IsValid( ply ) then return end
			ply:TakeDamage( 2 )
		end )
		ply:ScreenFade( SCREENFADE.IN, Color( 255, 0, 0, 50 ), 0.8, 0 )
		self:EmitSound( "vo/npc/male01/moan0"..math.random( 1, 5 )..".wav" )
		self:Remove()
		return
	end
	if timer.Exists( "Regen"..ply:SteamID64() ) then
		self:EmitSound( "items/medshotno1.wav" )
		return
	end

	local regen = math.random( 1, 100 ) > 5
	timer.Create( "Regen"..ply:SteamID64(), 1, 600, function()
		if !IsValid( ply ) then return end
		if regen then
			ply:SetHealth( math.Clamp( ply:Health() + 3, 0, ply:GetMaxHealth() ) )
		else
			ply:TakeDamage( 3 )
		end
	end )
	self:EmitSound( "items/medshot4.wav" )
	self:Remove()
end

function ENT:StartTouch( ent )
	if ent:GetClass() == "rp_weed" and !self.Infected then
		ent:Remove()
		self:EmitSound( "ambient/levels/canals/toxic_slime_gurgle"..math.random( 2, 8 )..".wav" )
		self:SetColor( color_green )
		self.Infected = true
	end
end
