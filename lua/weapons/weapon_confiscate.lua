
AddCSLuaFile()

SWEP.PrintName = "Confiscation Tool"
SWEP.Category = "Automod"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Base = "weapon_base"
SWEP.Author = "Lambda Gaming"
SWEP.Slot = 3

SWEP.ViewModel = ""
SWEP.WorldModel = ""

SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false

SWEP.cooldown = 0
SWEP.TakenWeapons = {}
SWEP.Confiscated = false

local defaultweapons = {
	"weapon_physgun",
	"pocket",
	"gmod_tool",
	"gmod_camera",
	"weapon_physcannon",
	"rphands",
	"itemstore_pickup",
	"weapon_keypadchecker",
	"keys"
}

if SERVER then
	function SWEP:PrimaryAttack()
		if self.cooldown > CurTime() then return end
		if IsFirstTimePredicted() then
			if self.Confiscated then self.Owner:ChatPrint( "You already holding confiscated weapons! Give them back or destroy them to confiscate new ones." ) return end
			local tr = self.Owner:GetEyeTrace().Entity
			if tr:IsPlayer() and self.Owner:GetPos():DistToSqr( tr:GetPos() ) < 22500 then
				if tr:isCP() then
					self.Owner:ChatPrint( "You cannot confiscate weapons from fellow officers!" )
					return
				else
					for k,v in pairs( tr:GetWeapons() ) do
						local wep = v:GetClass()
						if !table.HasValue( defaultweapons, wep ) then
							if k == 1 then
								self.Owner:ChatPrint( "List of weapons you confiscated from "..tr:Nick()..":" )
							end
							tr:StripWeapon( wep )
							self.Owner:ChatPrint( wep )
							table.insert( self.TakenWeapons, wep )
							self.TakenOwner = tr:UniqueID()
							self.Confiscated = true
						end
					end
				end
			end
		end
		self.cooldown = CurTime() + 1
	end

	function SWEP:SecondaryAttack()
		if self.cooldown > CurTime() then return end
		if IsFirstTimePredicted() then
			local tr = self.Owner:GetEyeTrace().Entity
			if tr:IsPlayer() then
				if tr:UniqueID() == self.TakenOwner then
					for k,v in pairs( self.TakenWeapons ) do
						tr:Give( v )
					end
					table.Empty( self.TakenWeapons )
					self.Owner:ChatPrint( "Successfully returned confiscated weapons." )
					self.Confiscated = false
					self.TakenOwner = nil
				elseif !self.Confiscated and self.TakenOwner == nil then
					self.Owner:ChatPrint( "You don't have any confiscated weapons to return." )
				else
					self.Owner:ChatPrint( "Incorrect owner of confiscated weapons! Either return them to the correct owner or press reload to destroy the weapons." )
				end
			end
		end
		self.cooldown = CurTime() + 1
	end

	function SWEP:Reload()
		if self.cooldown > CurTime() then return end
		if IsFirstTimePredicted() then
			if table.Count( self.TakenWeapons ) > 0 then
				table.Empty( self.TakenWeapons )
				self.Confiscated = false
				self.TakenOwner = nil
				self.Owner:ChatPrint( "Confiscated weapons successfully destroyed." )
			else
				self.Owner:ChatPrint( "You don't have any confiscated weapons to destroy!" )
			end
		end
		self.cooldown = CurTime() + 1
	end
end