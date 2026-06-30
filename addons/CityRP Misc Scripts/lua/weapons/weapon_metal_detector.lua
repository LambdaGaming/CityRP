AddCSLuaFile()

SWEP.PrintName = "Metal Detector"
SWEP.Category = "DarkRP (Utility)"
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Base = "weapon_base"
SWEP.Author = "OPGman"
SWEP.Slot = 3
SWEP.ViewModel = "models/weapons/Custom/scanner.mdl"
SWEP.WorldModel = "models/weapons/Custom/w_scanner.mdl"
SWEP.UseHands = true
SWEP.HoldType = "Pistol"

SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false

local allowed = {
	["itemstore_pickup"] = true,
	["keys"] = true,
	["weapon_physcannon"] = true,
	["gmod_camera"] = true,
	["gmod_tool"] = true,
	["pocket"] = true,
	["weapon_physgun"] = true,
	["weapon_keypadchecker"] = true,
	["weapon_hl2pickaxe"] = true,
	["weapon_hl2axe"] = true,
	["rphands"] = true,
	["weapon_handcuffed"] = true,
	["fish_finder"] = true,
	["fishing_rod_physics"] = true,
	["weapon_extinguisher"] = true,
	["usm_c4"] = true,
	["weapon_slam"] = true,
	["weapon_car_bomb"] = true,
	["weapon_vfire_molly"] = true,
	["weapon_vfire_gascan"] = true,
	["weapon_agent"] = true,
	["weapon_metal_detector"] = true
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
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self:SetNextPrimaryFire( CurTime() + 1 )
	self:SetNextSecondaryFire( CurTime() + 1 )
	if SERVER then
		local owner = self:GetOwner()
		local tr = owner:GetEyeTrace().Entity
		if !tr:IsPlayer() or owner:GetPos():DistToSqr( tr:GetPos() ) > 10000 then return end
		local weps = tr:GetWeapons()
		local found = {}
		for k,v in pairs( weps ) do
			local class = v:GetClass()
			if !allowed[class] and !table.HasValue( tr:getJobTable().weapons, class ) then
				table.insert( found, v:GetPrintName() )
			end
		end
		if table.IsEmpty( found ) then
			owner:ChatPrint( "No weapons detected." )
		else
			local txt = ""
			for i = 1, #found do
				if i != #found then
					txt = txt..found[i]..", "
				else
					txt = txt..found[i]
				end
			end
			owner:ChatPrint( "Weapons found!" )
			owner:ChatPrint( txt )
			owner:EmitSound( "buttons/blip2.wav" )
		end
	end
end

function SWEP:SecondaryAttack()
	if !IsFirstTimePredicted() or CLIENT then return end
	local ply = self:GetOwner()
    local tr = ply:GetEyeTrace().Entity
	if !CanConfiscateFrom( ply, tr ) then return end
	local foundwep = false
	local weps = tr:GetWeapons()
	for k,v in pairs( weps ) do
		local class = v:GetClass()
		if !allowed[class] and !table.HasValue( tr:getJobTable().weapons, class ) then
			foundwep = true
			break
		end
	end
	if foundwep then
		ply:EmitSound( "weapons/stunstick/alyx_stunner2.wav" )
		net.Start( "ViewWeapons" )
		net.WriteEntity( tr )
		net.WriteTable( weps )
		net.Send( self:GetOwner() )
	else
		ply:EmitSound( "buttons/combine_button_locked.wav" )
		DarkRP.notify( self:GetOwner(), 1, 6, "No weapons detected." )
	end
	self:SetNextPrimaryFire( CurTime() + 1 )
	self:SetNextSecondaryFire( CurTime() + 1 )
	return
end

if CLIENT then
	local function WeaponList()
		local ply = net.ReadEntity()
		local weps = net.ReadTable()
		local mainframe = vgui.Create( "DFrame" )
		mainframe:SetTitle( "Found weapons:" )
		mainframe:SetSize( 200, 300 )
		mainframe:Center()
		mainframe:MakePopup()
		mainframe.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, CRAFT_CONFIG_MENU_COLOR )
		end
		local mainframescroll = vgui.Create( "DScrollPanel", mainframe )
		mainframescroll:Dock( FILL )
		for k,v in pairs( weps ) do
			local class = v:GetClass()
			if allowed[class] or table.HasValue( ply:getJobTable().weapons, class ) then
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
