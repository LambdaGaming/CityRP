AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Cooking Stove"
ENT.Author = "OPGman"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Cooking Stove"

function ENT:Initialize()
	self:SetModel( "models/props_wasteland/kitchen_stove001a.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self.Pots = {
			{ Pos = Vector( -5, 12, 45 ) },
			{ Pos = Vector( -5, 25, 45 ) },
			{ Pos = Vector( 6, 12, 45 ) },
			{ Pos = Vector( 6, 25, 45 ) }
		}
		self.TotalCooking = 0
		self.Snd = CreateSound( self, "ambient/levels/canals/toxic_slime_loop1.wav" )
	end
	self:PhysWake()
end

local food = {
	{
		Name = "Fish",
		Model = "models/props/CS_militia/fishriver01.mdl",
		Energy = 100
	},
	{
		Name = "Donut",
		Model = "models/noesis/donut.mdl",
		Energy = 15
	},
	{
		Name = "Hamburger",
		Model = "models/food/burger.mdl",
		Energy = 25
	},
	{
		Name = "Hot Dog",
		Model = "models/food/hotdog.mdl",
		Energy = 25
	}
}

if SERVER then
	util.AddNetworkString( "CookingStove" )
	function ENT:Use( ply )
		if ply:Team() != TEAM_COOK then DarkRP.notify( ply, 1, 6, "Only cooks can use this stove." ) return end
		if self.TotalCooking == 4 then DarkRP.notify( ply, 1, 6, "Please wait before cooking something else." ) return end
		net.Start( "CookingStove" )
		net.WriteEntity( self )
		net.Send( ply )
	end

	function ENT:OnRemove()
		self.Snd:Stop()
	end

	net.Receive( "CookingStove", function( len, ply )
		local self = net.ReadEntity()
		local index = net.ReadInt( 4 )
		local fd = food[index]
		if self.TotalCooking == 4 then
			DarkRP.notify( ply, 1, 6, "Please wait before cooking something else." )
			return
		end
		if index == 1 then
			if ply.CookFish <= 0 then
				DarkRP.notify( ply, 1, 6, "You need to catch some fish first!" )
				return
			end
			ply.CookFish = ply.CookFish - 1
		end

		local burner
		for k,v in pairs( self.Pots ) do
			if !v.Ent then
				burner = v
				break
			end			
		end

		local pot = ents.Create( "prop_dynamic" )
		pot:SetPos( self:LocalToWorld( burner.Pos ) )
		pot:SetModel( "models/props_c17/metalPot001a.mdl" )
		pot:SetModelScale( 0.75 )
		pot:SetParent( self )
		pot:Spawn()
		burner.Ent = pot
		self:EmitSound( "ambient/fire/mtov_flame2.wav" )
		self.Snd:PlayEx( 60, 150 )
		self.TotalCooking = self.TotalCooking + 1
		timer.Simple( 30, function()
			if !IsValid( self ) then return end
			local e = ents.Create( "food" )
			e:SetPos( self:LocalToWorld( Vector( -5, -14, 55 ) ) )
			e:Spawn()
			e:SetModel( fd.Model )
			e.Energy = fd.Energy
			self.TotalCooking = self.TotalCooking - 1
			burner.Ent:Remove()
			burner.Ent = nil
			self:EmitSound( "zpizmak/kitchentimer_ding.wav" )
			if self.TotalCooking == 0 then
				self.Snd:Stop()
			end
		end )
	end )
end

if CLIENT then
	local offset = Vector( 0, 0, 65 )
	function ENT:Draw()
		self:DrawModel()
		self:DrawOverheadText( "Cooking Stove", offset )
	end

	net.Receive( "CookingStove", function()
		local self = net.ReadEntity()
		local Frame = vgui.Create( "DFrame" )
		Frame:SetTitle( "Select food to cook:" )
		Frame:SetSize( 215, 215 )
		Frame:Center()
		Frame:MakePopup()
		Frame.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 49, 53, 61, 200 ) )
		end
		for k,v in ipairs( food ) do
			local b = vgui.Create( "DButton", Frame )
			b:SetText( v.Name )
			b:SetTextColor( color_white )
			b:Dock( TOP )
			b:DockMargin( 0, 0, 0, 20 )
			b:SetSize( nil, 30 )
			b.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 93, 80, 255 ) )
			end
			b.DoClick = function()
				net.Start( "CookingStove" )
				net.WriteEntity( self )
				net.WriteInt( k, 4 )
				net.SendToServer()
				Frame:Remove()
			end
		end
	end )
end
