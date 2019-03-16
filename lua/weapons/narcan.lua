AddCSLuaFile()

SWEP.Author			= "Lambda Gaming"
SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel = Model( "models/weapons/c_medkit.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_medkit.mdl" )
SWEP.PrintName		= "Narcan"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "pistol"
SWEP.Spawnable		= true
SWEP.AdminOnly		= true
SWEP.UseHands 		= true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false

function SWEP:Deploy()
	self.Owner:DrawViewModel( true )
end

function SWEP:DrawWorldModel()
	if !IsValid(self.Owner) then
		self:DrawModel()
	end
end

function SWEP:Initialize()
	self:SetHoldType("pistol")
end

function SWEP:PrimaryAttack()
	if ( CLIENT ) then return end

	if ( self.Owner:IsPlayer() ) then
		self.Owner:LagCompensation( true )
	end

	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 64,
		filter = self.Owner
	} )

	if ( self.Owner:IsPlayer() ) then
		self.Owner:LagCompensation( false )
	end

	local ent = tr.Entity
	
	if !IsValid( ent ) then return end
	
	if ent:IsPlayer() and ent.od >= 5 then
		ent:SetRunSpeed( 245 )
		ent:SetWalkSpeed( 165 )
		ent:ChatPrint( "Your effects from the overdose have been cured by narcan." )
		self.Owner:ChatPrint( "The narcan successfully reversed the effects of the overdose." )
		ent.od = 0
	else
		self.Owner:ChatPrint( "This player does not appear to have overdosed." )
	end
end