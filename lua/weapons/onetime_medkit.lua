AddCSLuaFile()

SWEP.Author			= "Kanade (Modified by Lambda Gaming)"
SWEP.Contact		= "Look at this gamemode in workshop and search for creators"
SWEP.Purpose		= "Heal yourself or other people"

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel = Model( "models/weapons/c_medkit.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_medkit.mdl" )
SWEP.PrintName		= "First Aid Kit (One-time Use)"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "pistol"
SWEP.Spawnable		= true
SWEP.AdminSpawnable	= true
SWEP.UseHands = true

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
	if self.Owner:Health() / self.Owner:GetMaxHealth() <= 0.9 then
		if SERVER then
			self.Owner:SetHealth(self.Owner:GetMaxHealth())
			self.Owner:StripWeapon("onetime_medkit")
		end
	else
		if SERVER then
			self.Owner:PrintMessage(HUD_PRINTTALK, "You don't need healing yet")
		end
	end
end

function SWEP:SecondaryAttack()
	if SERVER then
		local ent = self.Owner:GetEyeTrace().Entity
		if ent:IsPlayer() then
			if(ent:GetPos():Distance(self.Owner:GetPos()) < 95) then
				if ent:Health() / ent:GetMaxHealth() <= 0.9 then
					ent:SetHealth(ent:GetMaxHealth())
					self.Owner:StripWeapon("onetime_medkit")
				else
					self.Owner:PrintMessage(HUD_PRINTTALK, ent:Nick() .. " doesn't need healing yet")
				end
			end
		end
	end
end