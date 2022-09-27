AddCSLuaFile()

SWEP.PrintName = "Confiscation Tool"
SWEP.Spawnable = true
SWEP.AdminOnly = true
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

local whitelist = {
	["keys"] = true,
	["weapon_physcannon"] = true,
	["gmod_camera"] = true,
	["gmod_tool"] = true,
	["weapon_physgun"] = true,
	["rphands"] = true,
	["itemstore_pickup"] = true,
	["weapon_handcuffed"] = true
}

function SWEP:PrimaryAttack()
	if SERVER then
		if self.cooldown > CurTime() then return end
		if IsFirstTimePredicted() then
			local tr = self.Owner:GetEyeTrace().Entity
			if tr:IsPlayer() and self.Owner:GetPos():DistToSqr( tr:GetPos() ) < 22500 then
				if tr:isCP() then
					DarkRP.notify( self:GetOwner(), 1, 6, "You cannot confiscate weapons from your colleagues!" )
				elseif !tr:IsHandcuffed() then
					DarkRP.notify( self:GetOwner(), 1, 6, "You need to cuff this person before you can search them." )
				else
					local foundwep = false
					local plyweps = tr:GetWeapons()
					for k,v in pairs( plyweps ) do
						if !whitelist[v:GetClass()] and !table.HasValue( tr:getJobTable().weapons, v:GetClass() ) then
							foundwep = true
							break
						end
					end
					if foundwep then
						net.Start( "ViewWeapons" )
						net.WriteEntity( tr )
						net.WriteTable( plyweps )
						net.Send( self:GetOwner() )
					else
						DarkRP.notify( self:GetOwner(), 1, 6, "No illegal weapons detected." )
					end
				end
			end
		end
		self.cooldown = CurTime() + 1
	end
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
			if whitelist[v:GetClass()] or table.HasValue( ply:getJobTable().weapons, v:GetClass() ) then
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
