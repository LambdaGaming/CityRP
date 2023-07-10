AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Zombie Node"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = false

function ENT:Initialize()
    self:SetModel( "models/hunter/plates/plate.mdl" )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_NONE )
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self:SetColor( color_transparent )
end

function ENT:Think()
	local pos = self:GetPos()
	local getents = ents.FindInSphere( pos, 200 )
	for k,v in ipairs( getents ) do
		if v:IsPlayer() and v:Alive() and !v.Infected then
			v.Infected = true
			timer.Create( "Regen"..v:SteamID64(), 1, 600, function()
				if !IsValid( v ) then return end
				v:TakeDamage( 2 )
			end )
			v:ScreenFade( SCREENFADE.IN, Color( 255, 0, 0, 128 ), 0.3, 0 )
			self:EmitSound( "vo/npc/male01/moan0"..math.random( 1, 5 )..".wav" )
		end
	end
	self:NextThink( CurTime() + 0.5 )
	return true
end
