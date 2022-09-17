AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Fire Hose Node"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Superadmin Only"

function ENT:SpawnFunction( ply, tr, name )
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal
	local ent = ents.Create( name )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
    self:SetModel( "models/props_street/firehydrant.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
	end
 
    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	self.Connection = NULL
end

if SERVER then
	util.AddNetworkString( "OpenHoseNodeMenu" )
	function ENT:Use( activator, caller )
		net.Start( "OpenHoseNodeMenu" )
		net.WriteEntity( self )
		net.Send( activator )
	end

	util.AddNetworkString( "FireNodeAction" )
	net.Receive( "FireNodeAction", function( len, ply )
		local ent = net.ReadEntity()
		local int = net.ReadUInt( 3 )
		if int < 3 and IsValid( ent.Connection ) then
			DarkRP.notify( ply, 1, 6, "This node is already connected to something." )
			return
		end
		if int == 1 then
			for k,v in pairs( ents.FindInSphere( ent:GetPos(), 200 ) ) do
				if v:IsVehicle() and v:GetModel() == "models/noble/engine_32.mdl" then
					local constr, rope = constraint.Rope( v, ent, 0, 0, Vector( 55, -6, 45 ), Vector( 9, 0, 22 ), 400, 500, 1000, 10, "cable/cable2", false, color_white )
					ent.Connection = rope
					break
				end
			end
			if !IsValid( ent.Connection ) then
				DarkRP.notify( ply, 1, 6, "No fire truck detected." )
			end
		elseif int == 2 then
			for k,v in pairs( ents.FindInSphere( ent:GetPos(), 200 ) ) do
				if v:GetClass() == "fire_hose_node" and v != ent then
					local constr, rope = constraint.Rope( v, ent, 0, 0, Vector( 9, 0, 22 ), Vector( 9, 0, 22 ), 400, 500, 1000, 10, "cable/cable2", false, color_white )
					ent.Connection = rope
					break
				end
			end
			if !IsValid( ent.Connection ) then
				DarkRP.notify( ply, 1, 6, "No nodes detected." )
			end
		elseif int == 3 then
			if IsValid( ent.Connection ) then
				ent.Connection:Remove()
			end
		else
			ent:Remove()
		end
	end )
end

if CLIENT then
	local function OpenHoseNodeMenu( ent )
		local Frame = vgui.Create( "DFrame" )
		Frame:SetTitle( "Fire Hose Node" )
		Frame:SetSize( 215, 215 )
		Frame:Center()
		Frame:MakePopup()
		Frame.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 49, 53, 61, 200 ) )
		end
		
		local b1 = vgui.Create( "DButton", Frame )
		b1:SetText( "Attach to Nearest Fire Truck" )
		b1:SetTextColor( color_white )
		b1:Dock( TOP )
		b1:DockMargin( 0, 0, 0, 20 )
		b1:SetSize( nil, 30 )
		b1.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 93, 80, 255 ) )
		end
		b1.DoClick = function()
			net.Start( "FireNodeAction" )
			net.WriteEntity( ent )
			net.WriteUInt( 1, 3 )
			net.SendToServer()
			Frame:Remove()
		end
		
		local b2 = vgui.Create( "DButton", Frame )
		b2:SetText( "Attach to Nearest Node" )
		b2:SetTextColor( color_white )
		b2:Dock( TOP )
		b2:DockMargin( 0, 0, 0, 20 )
		b2:SetSize( nil, 30 )
		b2.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 93, 80, 255 ) )
		end
		b2.DoClick = function()
			net.Start( "FireNodeAction" )
			net.WriteEntity( ent )
			net.WriteUInt( 2, 3 )
			net.SendToServer()
			Frame:Remove()
		end
		
		local b3 = vgui.Create( "DButton", Frame )
		b3:SetText( "Detach Node" )
		b3:SetTextColor( color_white )
		b3:Dock( TOP )
		b3:DockMargin( 0, 0, 0, 20 )
		b3:SetSize( nil, 30 )
		b3.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 93, 80, 255 ) )
		end
		b3.DoClick = function()
			net.Start( "FireNodeAction" )
			net.WriteEntity( ent )
			net.WriteUInt( 3, 3 )
			net.SendToServer()
			Frame:Remove()
		end

		local b4 = vgui.Create( "DButton", Frame )
		b4:SetText( "Remove Node" )
		b4:SetTextColor( color_white )
		b4:Dock( TOP )
		b4:DockMargin( 0, 0, 0, 20 )
		b4:SetSize( nil, 30 )
		b4.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 93, 80, 255 ) )
		end
		b4.DoClick = function()
			net.Start( "FireNodeAction" )
			net.WriteEntity( ent )
			net.WriteUInt( 4, 3 )
			net.SendToServer()
			Frame:Remove()
		end
	end

	net.Receive( "OpenHoseNodeMenu", function()
		local ent = net.ReadEntity()
		OpenHoseNodeMenu( ent )
	end )
end
