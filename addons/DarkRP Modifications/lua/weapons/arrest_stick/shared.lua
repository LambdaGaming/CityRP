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
local quickarrest = false

if SERVER then
	util.AddNetworkString( "ArrestNet" )
	net.Receive( "ArrestNet", function( len, ply )
		local quick = net.ReadBool()
		if quick then
			quickarrest = true
		end
		arrestok = true
	end )
end

local function ArrestTime()
    if CLIENT then
        local Frame = vgui.Create( "DFrame" )
        Frame:SetTitle( "Select arrest type:" )
        Frame:SetSize( 250, 150 )
        Frame:Center()
        Frame:MakePopup()
        Frame.Paint = function( self, w, h )
        	draw.RoundedBox( 0, 0, 0, w, h, Color( 49, 53, 61, 255 ) )
        end

		local Button1 = vgui.Create( "DButton", Frame )
        Button1:SetText( "Reduced Sentence\n(Suspect sits in jail for 5 minutes then gets\nautomatically released back to spawn.)" )
        Button1:SetTextColor( color_white )
		Button1:Dock( TOP )
        Button1:SetPos( 25, 50 )
        Button1:SetSize( 100, 50 )
        Button1.Paint = function( self, w, h )
        	draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 93, 80, 255 ) )
        end
        Button1.DoClick = function()
        	net.Start( "ArrestNet" )
        	net.WriteBool( true )
        	net.SendToServer()
			Frame:Remove()
        end
		
        local Button2 = vgui.Create( "DButton", Frame )
        Button2:SetText( "Full Sentence\n(Suspect sits in jail with no time limit to await\ntrial, questioning, or manual release.)" )
        Button2:SetTextColor( color_white )
		Button2:DockMargin( 0, 10, 0, 0 )
		Button2:Dock( TOP )
        Button2:SetPos( 25, 100 )
        Button2:SetSize( 100, 50 )
        Button2.Paint = function( self, w, h )
        	draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 93, 80, 255 ) )
        end
        Button2.DoClick = function()
        	net.Start( "ArrestNet" )
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
	if arrestok then self:DoArrest() end
	self:NextThink( 0.5 )
	return true
end

function SWEP:DoArrest()
	entarrest:ChatPrint( "You have been arrested by "..self:GetOwner():Nick().."." )
	if quickarrest then
		entarrest:arrest( 300, self:GetOwner() )
		entarrest:ChatPrint( "You are serving a reduced sentence. You will be automatically released in 5 minutes, though you may be manually released early." )
	else
		entarrest:setDarkRPVar( "Arrested", true )
		entarrest:Spawn()
		entarrest:ChatPrint( "You are serving a full sentence, most likely to be questioned or have a trial. An officer will meet with you shortly." )
		entarrest:ChatPrint( "If you are not released after 20 minutes, contact an admin." )
		entarrest:setDarkRPVar( "Arrested", false )
	end
	arrestok = false
	quickarrest = false
	if self:GetOwner().SteamName then
		DarkRP.log(self:GetOwner():Nick() .. " (" .. self:GetOwner():SteamID() .. ") arrested " .. entarrest:Nick(), Color(0, 255, 255))
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