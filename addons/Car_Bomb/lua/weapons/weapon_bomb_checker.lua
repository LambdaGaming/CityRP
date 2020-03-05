
AddCSLuaFile()

SWEP.PrintName = "Car Bomb Checker"
SWEP.Category = "Car Bomb"
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Base = "weapon_base"
SWEP.Author = "Lambda Gaming"
SWEP.Slot = 5

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

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
		if tr.HasCarBomb then
			self.Owner:EmitSound( "ambient/alarms/klaxon1.wav" )
			DarkRP.notify( self.Owner, 0, 6, "Vehicle has a car bomb! Right click with this tool to remove it!" )
		else
			self.Owner:EmitSound( "buttons/blip1.wav" )
			DarkRP.notify( self.Owner, 1, 6, "Vehicle does not have a car bomb." )
		end
	else
		DarkRP.notify( self.Owner, 1, 6, "No vehicle detected. Try moving closer if you are already looking at one." )
	end
    self:SetNextPrimaryFire( CurTime() + 0.5 )
end

function SWEP:SecondaryAttack()
	if !IsFirstTimePredicted() or CLIENT then return end
    local tr = self.Owner:GetEyeTrace().Entity
	if self.Owner:GetPos():DistToSqr( tr:GetPos() ) > 40000 or !IsValid( tr ) then return end
    if tr:IsVehicle() then
		if tr.HasCarBomb then
			tr.HasCarBomb = false
			self.Owner:EmitSound( "ambient/materials/dinnerplates"..math.random( 1, 5 )..".wav" )
			DarkRP.notify( self.Owner, 0, 6, "Car bomb successfully defused and removed." )
		else
			DarkRP.notify( self.Owner, 1, 6, "This vehicle does not have a car bomb." )
		end
	end
    self:SetNextSecondaryFire( CurTime() + 1 )
end
