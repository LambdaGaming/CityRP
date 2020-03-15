
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Gas Pump"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = false

function ENT:Initialize()
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
	end
 
    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:EnableMotion( false )
	end
end

function ENT:Use( activator, caller )
	local price
	if activator:isCP() then
		price = 0
	else
		price = 300
	end
	if activator:canAfford( price ) then
		local pos = self:GetPos()
		local findveh = ents.FindInSphere( pos, 300 )
		local totalveh = 0
		for k,v in pairs( findveh ) do
			if v:GetClass() == "prop_vehicle_jeep" then
				totalveh = totalveh + 1
				v:SetNWInt( "AM_FuelAmount", 100 )
				activator:addMoney( -price )
				DarkRP.notify( activator, 0, 6, "You have purchased a full fuel tank for $"..price.."." )
				break
			end
		end
		if #findveh == 0 or totalveh == 0 then
			DarkRP.notify( activator, 1, 6, "No vehicle detected. Move it closer." )
		end
	else
		DarkRP.notify( activator, 1, 6, "You don't have enough money to purchase fuel!" )
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end