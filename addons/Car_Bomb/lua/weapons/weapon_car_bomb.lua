AddCSLuaFile()

SWEP.PrintName = "Car Bomb"
SWEP.Category = "Car Bomb"
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Base = "weapon_base"
SWEP.Author = "Lambda Gaming"
SWEP.Slot = 4
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_c4.mdl"
SWEP.WorldModel = "models/weapons/w_c4.mdl"

SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false

SWEP.SelectedType = 1

local BombType = {
	"Instant detonation as soon as the engine starts.",
	"Detonation 1 minute after engine starts.",
	"Detonation 5 minutes after engine starts.",
	"Detonation when the vehicle reaches 20 MPH.",
	"Detonation when the vehicle reaches 50 MPH."
}

function SWEP:Deploy()
	if IsFirstTimePredicted() and SERVER then
		self.Owner:ChatPrint( "Bomb Type: "..BombType[self.SelectedType] )
	end
end

function SWEP:PrimaryAttack()
	if !IsFirstTimePredicted() or CLIENT then return end
    local tr = self.Owner:GetEyeTrace().Entity
	if self.Owner:GetPos():DistToSqr( tr:GetPos() ) > 40000 or !IsValid( tr ) then return end
    if tr:IsVehicle() then
		if tr.hasbombprotection then
			DarkRP.notify( self.Owner, 1, 6, "You cannot place the bomb on this vehicle as it has bomb protection." )
			self:SetNextPrimaryFire( CurTime() + 0.5 )
			return
		end
		tr.HasCarBomb = true
		tr.CarBombType = self.SelectedType
		self.Owner:EmitSound( "physics/metal/metal_box_impact_soft"..math.random( 1, 3 )..".wav" )
		DarkRP.notify( self.Owner, 0, 6, "Car bomb successfully planted." )
		self:Remove()
	else
		DarkRP.notify( self.Owner, 1, 6, "You must be looking at a vehicle to plant the bomb." )
	end
    self:SetNextPrimaryFire( CurTime() + 0.5 )
end

function SWEP:SecondaryAttack()
	if !IsFirstTimePredicted() or CLIENT then return end
	if self.SelectedType == 5 then
		self.SelectedType = 1
	else
		self.SelectedType = self.SelectedType + 1
	end
	self.Owner:ChatPrint( "Bomb Type: "..BombType[self.SelectedType] )
end
