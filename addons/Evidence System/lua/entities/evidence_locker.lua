AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Evidence Locker"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Evidence"

function ENT:Initialize()
    self:SetModel( "models/props_c17/lockers001a.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetMaterial( "models/props_combine/metal_combinebridge001" )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		EvidenceLockerStash = {}
	end
    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	self.BreakOpenHealthMax = 15
	self.BreakOpenHealth = 15
	self.BreakOpenBroken = false
end

if SERVER then
	util.AddNetworkString( "OpenEvidenceMenu" )
	util.AddNetworkString( "SpawnEvidence" )
	function ENT:Use( ply )
		if table.IsEmpty( EvidenceLockerStash ) then
			DarkRP.notify( ply, 1, 6, "There is nothing in the evidence locker." )
			return
		end
		net.Start( "OpenEvidenceMenu" )
		net.WriteEntity( self )
		net.WriteTable( EvidenceLockerStash )
		net.Send( ply )
	end

	net.Receive( "SpawnEvidence", function( len, ply )
		local ent = net.ReadEntity()
		local tbl = net.ReadTable()
		local e = ents.Create( tbl[2] )
		if tbl[4] then
			e:SetWeaponClass( tbl[4] )
			e:SetModel( weapons.GetStored( tbl[4] ).WorldModel )
			e.nodupe = true
		else
			e:SetModel( tbl[3] )
		end
		e:SetPos( ent:GetPos() + ent:GetForward() * 30 )
		e:Spawn()
		e:CPPISetOwner( ply )
		ent:EmitSound( "doors/door_metal_thin_open1.wav" )
		for k,v in pairs( EvidenceLockerStash ) do
			if v[2] == tbl[2] then
				EvidenceLockerStash[k] = nil
				break
			end
		end
	end )

	function ENT:BreakOpen( ply )
		local e = ents.Create( "electronic" )
		e:SetPos( self:GetPos() + self:GetForward() * 30 )
		e:Spawn()
	end
end

if CLIENT then
	local color_light_red = Color( 230, 93, 80, 255 )
    function ENT:Draw()
        self:DrawModel()
		self:DrawNPCText( "Evidence Locker", Vector( 0, 0, 50 ) )
    end

	local function DrawItemMenu( ent, tbl )
		local ply = LocalPlayer()
		local mainframe = vgui.Create( "DFrame" )
		mainframe:SetTitle( "Evidence Locker" )
		mainframe:SetSize( 300, 500 )
		mainframe:Center()
		mainframe:MakePopup()
		mainframe.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_theme, 190 ) )
		end
	
		local listframe = vgui.Create( "DScrollPanel", mainframe )
		listframe:Dock( FILL )
		for k,v in pairs( tbl ) do
			local itembackground = vgui.Create( "DPanel", listframe )
			itembackground:SetPos( 0, 10 )
			itembackground:SetSize( 450, 80 )
			itembackground:Dock( TOP )
			itembackground:DockMargin( 0, 0, 0, 10 )
			itembackground:Center()
			itembackground.Paint = function()
				draw.RoundedBox( 0, 0, 0, itembackground:GetWide(), itembackground:GetTall(), color_transparent )
			end
			
			local mainbuttons = vgui.Create( "DButton", itembackground )
			if v[4] then
				mainbuttons:SetText( weapons.GetStored( v[4] ).PrintName.."\nClick to retrieve" )
			else
				mainbuttons:SetText( v[1].."\nClick to retrieve" )
			end
			mainbuttons:SetTextColor( color_white )
			mainbuttons:SetFont( "ItemNPCTitleFont" )
			mainbuttons:Dock( RIGHT )
			mainbuttons:SetSize( 180, 80 )
			mainbuttons.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, color_light_red )
			end
			mainbuttons.DoClick = function()
				net.Start( "SpawnEvidence" )
				net.WriteEntity( ent )
				net.WriteTable( v )
				net.SendToServer()
				mainframe:Close()
			end
			
			local itemicon = vgui.Create( "SpawnIcon", itembackground )
			itemicon:SetModel( v[3] )
			itemicon:SetToolTip( false )
			itemicon:SetSize( 80, 80 )
		end
	end
	
	net.Receive( "OpenEvidenceMenu", function( len, ply )
		local ent = net.ReadEntity()
		local tbl = net.ReadTable()
		DrawItemMenu( ent, tbl )
	end )
end
