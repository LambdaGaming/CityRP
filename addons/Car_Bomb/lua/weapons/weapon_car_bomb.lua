
AddCSLuaFile()

SWEP.PrintName = "Car Bomb"
SWEP.Category = "Car Bomb"
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Base = "weapon_base"
SWEP.Author = "Lambda Gaming"
SWEP.Slot = 5
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

function SWEP:PrimaryAttack()
	if !IsFirstTimePredicted() or CLIENT then return end
    local tr = self.Owner:GetEyeTrace().Entity
	if self.Owner:GetPos():DistToSqr( tr:GetPos() ) > 40000 or !IsValid( tr ) then return end
    if tr:IsVehicle() then
		tr.HasCarBomb = true
		self.Owner:EmitSound( "physics/metal/metal_box_impact_soft"..math.random( 1, 3 )..".wav" )
		DarkRP.notify( self.Owner, 0, 6, "Car bomb successfully planted." )
		self:Remove()
	else
		DarkRP.notify( self.Owner, 1, 6, "You must be looking at a vehicle to plant the bomb." )
	end
    self:SetNextPrimaryFire( CurTime() + 0.5 )
end
