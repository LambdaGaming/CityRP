AddCSLuaFile()

SWEP.Author			= "Lambda Gaming"
SWEP.ViewModel 		= ""
SWEP.WorldModel 	= ""
SWEP.PrintName		= "Announcement Microphone"
SWEP.Slot			= 2
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
	self.Owner:DrawViewModel( false )
	if IsFirstTimePredicted() and SERVER then
		self.Owner:ChatPrint( "Current Channel: "..self:GetNWInt( "Announce_Channel" ) )
	end
end

function SWEP:DrawWorldModel()
	return false
end

function SWEP:Initialize()
	self:SetHoldType("magic")
	self:SetNWInt( "Announce_Channel", 1 )
end

function SWEP:PrimaryAttack()
	if IsFirstTimePredicted() and SERVER then
		local channel = self:GetNWInt( "Announce_Channel" )
		if channel == 5 then
			self:SetNWInt( "Announce_Channel", 1 )
		else
			self:SetNWInt( "Announce_Channel", channel + 1 )
		end
		self.Owner:ChatPrint( "New Channel: "..channel )
	end
	self:SetNextPrimaryFire( CurTime() + 1 )
end

function SWEP:SecondaryAttack()
	if IsFirstTimePredicted() and SERVER then
		local channel = self:GetNWInt( "Announce_Channel" )
		if channel == 1 then
			self:SetNWInt( "Announce_Channel", 5 )
		else
			self:SetNWInt( "Announce_Channel", channel - 1 )
		end
		self.Owner:ChatPrint( "New Channel: "..channel )
	end
	self:SetNextSecondaryFire( CurTime() + 1 )
end