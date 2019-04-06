AddCSLuaFile()

if CLIENT then
    SWEP.PrintName = "Arrest Baton"
    SWEP.Slot = 1
    SWEP.SlotPos = 3
end

--[[
	This is a modified version of the DarkRP arrest stick that allows players to select a
	specific arrest time from a menu that ranges from 1 minute to 20 minutes. Credit goes
	to the DarkRP developers for the original code.
]]

DEFINE_BASECLASS("stick_base")

SWEP.Instructions = "Left click to arrest\nRight click to switch batons"
SWEP.IsDarkRPArrestStick = true

SWEP.Spawnable = true
SWEP.Category = "DarkRP (Utility)"

SWEP.StickColor = Color(255, 0, 0)

SWEP.Switched = true

DarkRP.hookStub{
    name = "canArrest",
    description = "Whether someone can arrest another player.",
    parameters = {
        {
            name = "arrester",
            description = "The player trying to arrest someone.",
            type = "Player"
        },
        {
            name = "arrestee",
            description = "The player being arrested.",
            type = "Player"
        }
    },
    returns = {
        {
            name = "canArrest",
            description = "A yes or no as to whether the arrester can arrest the arestee.",
            type = "boolean"
        },
        {
            name = "message",
            description = "The message that is shown when they can't arrest the player.",
            type = "string"
        }
    },
    realm = "Server"
}

function SWEP:Deploy()
    self.Switched = true
    return BaseClass.Deploy(self)
end

local arrestok = false
local jailtime = 0

if SERVER then
	util.AddNetworkString( "ArrestNet" )
	net.Receive( "ArrestNet", function( len, ply )
		local int = net.ReadString()
		jailtime = tonumber( int )
		arrestok = true
	end )
end

local function ArrestTime()
    if CLIENT then
        local Frame = vgui.Create( "DFrame" )
        Frame:SetTitle( "Select a Jail Time:" )
        Frame:SetSize( 300, 300 )
        Frame:Center()
        Frame:MakePopup()
        Frame.Paint = function( self, w, h )
        	draw.RoundedBox( 0, 0, 0, w, h, Color( 49, 53, 61, 200 ) )
        end
        
		local Button1 = vgui.Create( "DButton", Frame )
        Button1:SetText( "1 Minute" )
        Button1:SetTextColor( color_white )
        Button1:SetPos( 25, 50 )
        Button1:SetSize( 100, 30 )
        Button1.Paint = function( self, w, h )
        	draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 93, 80, 255 ) )
        end
        Button1.DoClick = function()
        	net.Start( "ArrestNet" )
        	    net.WriteString( "60" )
        	net.SendToServer()
			Frame:Remove()
        end
		
        local Button2 = vgui.Create( "DButton", Frame )
        Button2:SetText( "2 Minutes" )
        Button2:SetTextColor( color_white )
        Button2:SetPos( 25, 100 )
        Button2:SetSize( 100, 30 )
        Button2.Paint = function( self, w, h )
        	draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 93, 80, 255 ) )
        end
        Button2.DoClick = function()
        	net.Start( "ArrestNet" )
        	    net.WriteString( "120" )
        	net.SendToServer()
			Frame:Remove()
        end
		
		local Button3 = vgui.Create( "DButton", Frame )
        Button3:SetText( "3 Minutes" )
        Button3:SetTextColor( color_white )
        Button3:SetPos( 25, 150 )
        Button3:SetSize( 100, 30 )
        Button3.Paint = function( self, w, h )
        	draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 93, 80, 255 ) )
        end
        Button3.DoClick = function()
        	net.Start( "ArrestNet" )
        	    net.WriteString( "180" )
        	net.SendToServer()
			Frame:Remove()
        end
		
		local Button4 = vgui.Create( "DButton", Frame )
        Button4:SetText( "4 Minutes" )
        Button4:SetTextColor( color_white )
        Button4:SetPos( 25, 200 )
        Button4:SetSize( 100, 30 )
        Button4.Paint = function( self, w, h )
        	draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 93, 80, 255 ) )
        end
        Button4.DoClick = function()
        	net.Start( "ArrestNet" )
        	    net.WriteString( "240" )
        	net.SendToServer()
			Frame:Remove()
        end
		
		local Button5 = vgui.Create( "DButton", Frame )
        Button5:SetText( "5 Minutes" )
        Button5:SetTextColor( color_white )
        Button5:SetPos( 25, 250 )
        Button5:SetSize( 100, 30 )
        Button5.Paint = function( self, w, h )
        	draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 93, 80, 255 ) )
        end
        Button5.DoClick = function()
        	net.Start( "ArrestNet" )
        	    net.WriteString( "300" )
        	net.SendToServer()
			Frame:Remove()
        end
		
		local Button6 = vgui.Create( "DButton", Frame )
        Button6:SetText( "8 Minutes" )
        Button6:SetTextColor( color_white )
        Button6:SetPos( 175, 50 )
        Button6:SetSize( 100, 30 )
        Button6.Paint = function( self, w, h )
        	draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 93, 80, 255 ) )
        end
        Button6.DoClick = function()
        	net.Start( "ArrestNet" )
        	    net.WriteString( "480" )
        	net.SendToServer()
			Frame:Remove()
        end
		
		local Button7 = vgui.Create( "DButton", Frame )
        Button7:SetText( "10 Minutes" )
        Button7:SetTextColor( color_white )
        Button7:SetPos( 175, 100 )
        Button7:SetSize( 100, 30 )
        Button7.Paint = function( self, w, h )
        	draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 93, 80, 255 ) )
        end
        Button7.DoClick = function()
        	net.Start( "ArrestNet" )
        	    net.WriteString( "600" )
        	net.SendToServer()
			Frame:Remove()
        end
		
		local Button8 = vgui.Create( "DButton", Frame )
        Button8:SetText( "12 Minutes" )
        Button8:SetTextColor( color_white )
        Button8:SetPos( 175, 150 )
        Button8:SetSize( 100, 30 )
        Button8.Paint = function( self, w, h )
        	draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 93, 80, 255 ) )
        end
        Button8.DoClick = function()
        	net.Start( "ArrestNet" )
        	    net.WriteString( "720" )
        	net.SendToServer()
			Frame:Remove()
        end
		
		local Button9 = vgui.Create( "DButton", Frame )
        Button9:SetText( "15 Minutes" )
        Button9:SetTextColor( color_white )
        Button9:SetPos( 175, 200 )
        Button9:SetSize( 100, 30 )
        Button9.Paint = function( self, w, h )
        	draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 93, 80, 255 ) )
        end
        Button9.DoClick = function()
        	net.Start( "ArrestNet" )
        	    net.WriteString( "900" )
        	net.SendToServer()
			Frame:Remove()
        end
		
		local Button10 = vgui.Create( "DButton", Frame )
        Button10:SetText( "20 Minutes" )
        Button10:SetTextColor( color_white )
        Button10:SetPos( 175, 250 )
        Button10:SetSize( 100, 30 )
        Button10.Paint = function( self, w, h )
        	draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 93, 80, 255 ) )
        end
        Button10.DoClick = function()
        	net.Start( "ArrestNet" )
        	    net.WriteString( "1200" )
        	net.SendToServer()
			Frame:Remove()
        end
    end
end
usermessage.Hook("JailTimeMenu", ArrestTime)

local trace
local entarrest

function SWEP:PrimaryAttack()
    BaseClass.PrimaryAttack(self)

    if CLIENT then return end

    self:GetOwner():LagCompensation(true)
    trace = util.QuickTrace(self:GetOwner():EyePos(), self:GetOwner():GetAimVector() * 90, {self:GetOwner()})
    self:GetOwner():LagCompensation(false)

    entarrest = trace.Entity
    if IsValid(entarrest) and entarrest.onArrestStickUsed then
        entarrest:onArrestStickUsed(self:GetOwner())
        return
    end

    entarrest = self:GetOwner():getEyeSightHitEntity(nil, nil, function(p) return p ~= self:GetOwner() and p:IsPlayer() and p:Alive() and p:IsSolid() end)
	
    local stickRange = self.stickRange * self.stickRange
    if not IsValid(entarrest) or (self:GetOwner():EyePos():DistToSqr(entarrest:GetPos()) > 10000) then
		return
    end

    local canArrest, message = hook.Call("canArrest", DarkRP.hooks, self:GetOwner(), entarrest)
    if not canArrest then
        if message then DarkRP.notify(self:GetOwner(), 1, 5, message) end
        return
    end
	
	umsg.Start("JailTimeMenu", self.Owner)
	umsg.End()
end

function SWEP:Think()
	if arrestok and jailtime > 0 then self:PlzWork() end
	self:NextThink( 0.5 )
	return true
end

function SWEP:PlzWork()
	if arrestok and jailtime > 0 then
        entarrest:arrest(jailtime, self:GetOwner())
        DarkRP.notify(entarrest, 0, 20, DarkRP.getPhrase("youre_arrested_by", self:GetOwner():Nick()))
		jailtime = 0
		arrestok = false
    
        if self:GetOwner().SteamName then
            DarkRP.log(self:GetOwner():Nick() .. " (" .. self:GetOwner():SteamID() .. ") arrested " .. entarrest:Nick(), Color(0, 255, 255))
        end
    else
        print( "Something went wrong and the arrest couldnt go through." )
    end
end

function SWEP:startDarkRPCommand(usrcmd)
    if game.SinglePlayer() and CLIentarrest then return end
    if usrcmd:KeyDown(IN_ATTACK2) then
        if not self.Switched and self:GetOwner():HasWeapon("unarrest_stick") then
            usrcmd:SelectWeapon(self:GetOwner():GetWeapon("unarrest_stick"))
        end
    else
        self.Switched = false
    end
end