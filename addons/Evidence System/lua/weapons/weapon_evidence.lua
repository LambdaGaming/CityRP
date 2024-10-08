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

local entWhitelist = {
	["coca_plant"] = true, ["heat_lamp"] = true, ["pure_cocaine"] = true,
	["purifier"] = true, ["rp_weed"] = true, ["rp_weed_plant"] = true,
	["rp_meth"] = true, ["rp_chloride"] = true, ["rp_sodium"] = true,
	["spawned_weapon"] = true, ["money_printer_advanced"] = true,
	["printer_upgrade_paper"] = true, ["printer_upgrade_sound"] = true,
	["printer_upgrade_cooling"] = true, ["printer_upgrade_output"] = true,
	["dronesrewrite_console"] = true, ["rp_pot"] = true, ["rp_stove"] = true,
	["raw_cocaine"] = true, ["mediaplayer_tv"] = true, ["slot_machine"] = true
}

local wepWhitelist = {
	["keys"] = true,
	["weapon_physcannon"] = true,
	["gmod_camera"] = true,
	["gmod_tool"] = true,
	["weapon_physgun"] = true,
	["rphands"] = true,
	["itemstore_pickup"] = true,
	["weapon_handcuffed"] = true
}

local function CanConfiscateFrom( ply, target )
	if !target:IsPlayer() or ply:GetPos():DistToSqr( target:GetPos() ) > 10000 then return false end
	if !target:IsHandcuffed() then
		DarkRP.notify( ply, 1, 6, "You need to cuff this person before you can search them." )
		return false
	end
	return true
end

function SWEP:PrimaryAttack()
	if !IsFirstTimePredicted() or CLIENT then return end
	local ply = self:GetOwner()
    local tr = ply:GetEyeTrace().Entity

	if tr:IsPlayer() then
		if !CanConfiscateFrom( ply, tr ) then return end
		local foundwep = false
		local plyweps = tr:GetWeapons()
		for k,v in pairs( plyweps ) do
			if !wepWhitelist[v:GetClass()] and !table.HasValue( tr:getJobTable().weapons, v:GetClass() ) then
				foundwep = true
				break
			end
		end
		if foundwep then
			ply:EmitSound( "weapons/stunstick/alyx_stunner2.wav" )
			net.Start( "ViewWeapons" )
			net.WriteEntity( tr )
			net.WriteTable( plyweps )
			net.Send( self:GetOwner() )
		else
			ply:EmitSound( "buttons/combine_button_locked.wav" )
			DarkRP.notify( self:GetOwner(), 1, 6, "No illegal weapons detected." )
		end
		self:SetNextPrimaryFire( CurTime() + 1 )
		return
	end

	if !IsValid( tr ) or ply:GetPos():DistToSqr( tr:GetPos() ) > 40000 or !entWhitelist[tr:GetClass()] then
		ply:EmitSound( "buttons/combine_button_locked.wav" )
		DarkRP.notify( ply, 1, 6, "Invalid item detected." )
		self:SetNextPrimaryFire( CurTime() + 1 )
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

function SWEP:SecondaryAttack()
end

if CLIENT then
	local function WeaponList()
		local ply = net.ReadEntity()
		local weps = net.ReadTable()
		local mainframe = vgui.Create( "DFrame" )
		mainframe:SetTitle( "Illegal weapons:" )
		mainframe:SetSize( 200, 300 )
		mainframe:Center()
		mainframe:MakePopup()
		mainframe.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, CRAFT_CONFIG_MENU_COLOR )
		end
		local mainframescroll = vgui.Create( "DScrollPanel", mainframe )
		mainframescroll:Dock( FILL )
		for k,v in pairs( weps ) do
			if wepWhitelist[v:GetClass()] or table.HasValue( ply:getJobTable().weapons, v:GetClass() ) then
				continue
			end
			local scrollbutton = vgui.Create( "DButton", mainframescroll )
			scrollbutton:SetText( v:GetPrintName() )
			scrollbutton:SetTextColor( CRAFT_CONFIG_BUTTON_TEXT_COLOR )
			scrollbutton:Dock( TOP )
			scrollbutton:DockMargin( 5, 5, 5, 5 )
			scrollbutton.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, CRAFT_CONFIG_BUTTON_COLOR )
			end
			scrollbutton.DoClick = function()
				net.Start( "TakeWeapon" )
				net.WriteEntity( ply )
				net.WriteEntity( v )
				net.SendToServer()
				scrollbutton:Remove()
			end
		end
	end
	net.Receive( "ViewWeapons", WeaponList )
end

if SERVER then
	util.AddNetworkString( "TakeWeapon" )
	util.AddNetworkString( "ViewWeapons" )
	net.Receive( "TakeWeapon", function( len, ply )
		local target = net.ReadEntity()
		if ply:GetEyeTrace().Entity ~= target then return end
		if not CanConfiscateFrom( ply, target ) then return end
		local wep = net.ReadEntity()
		if ply:HasWeapon( wep:GetClass() ) then
			local e = ents.Create( "spawned_weapon" )
			e:SetModel( wep:GetModel() )
			e:SetWeaponClass( wep:GetClass() )
			e:SetPos( ply:GetPos() + Vector( 0, 0, 50 ) + ply:GetForward() * 10 )
			e.nodupe = true
			e:Spawn()
		else
			ply:Give( wep:GetClass() )
		end
		target:StripWeapon( wep:GetClass() )
		DarkRP.notify( ply, 0, 6, "Successfully confiscated a "..wep:GetPrintName().." from "..target:Nick() )
	end )
end
