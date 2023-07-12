AddCSLuaFile()

SWEP.PrintName = "Evidence Wand"
SWEP.Category = "Evidence"
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Base = "weapon_base"
SWEP.Author = "Lambda Gaming"
SWEP.Slot = 3
SWEP.ViewModel = "models/weapons/v_stunbaton.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"

SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false

local whitelist = {
	["coca_plant"] = true, ["heat_lamp"] = true, ["pure_cocaine"] = true,
	["purifier"] = true, ["rp_weed"] = true, ["rp_weed_plant"] = true,
	["rp_meth"] = true, ["rp_chloride"] = true, ["rp_sodium"] = true,
	["spawned_weapon"] = true, ["money_printer_advanced"] = true,
	["printer_upgrade_paper"] = true, ["printer_upgrade_sound"] = true,
	["printer_upgrade_cooling"] = true, ["printer_upgrade_output"] = true,
	["dronesrewrite_console"] = true, ["rp_pot"] = true, ["rp_stove"] = true,
	["raw_cocaine"] = true, ["mediaplayer_tv"] = true, ["slot_machine"] = true
}

function SWEP:PrimaryAttack()
	if !IsFirstTimePredicted() or CLIENT then return end
	local ply = self:GetOwner()
    local tr = ply:GetEyeTrace().Entity
	if !IsValid( tr ) or ply:GetPos():DistToSqr( tr:GetPos() ) > 40000 or !whitelist[tr:GetClass()] then
		ply:EmitSound( "buttons/combine_button_locked.wav" )
		DarkRP.notify( ply, 1, 6, "Invalid item detected." )
		return
	end
	local tbl = {
		tr.PrintName or tr:GetClass(),
		tr:GetClass(),
		tr:GetModel(),
		tr:GetClass() == "spawned_weapon" and tr:GetWeaponClass() or nil
	}
	table.insert( EvidenceLockerStash, tbl )
	tr:SetNoDraw( true )
	local ed = EffectData()
	ed:SetOrigin( tr:GetPos() )
	ed:SetEntity( tr )
	util.Effect( "entity_remove", ed, true, true )
	timer.Simple( 1, function() if IsValid( tr ) then tr:Remove() end end )
	ply:EmitSound( "weapons/stunstick/alyx_stunner2.wav" )
	DarkRP.notify( ply, 0, 6, "Successfully transfered item to evidence locker." )
    self:SetNextPrimaryFire( CurTime() + 1 )
end
