
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
		if GetGlobalInt( "MAYOR_SalesTax" ) >= 50 then
			price = 300
		else
			price = 0
		end
	else
		price = 300
	end
	if activator:canAfford( price ) then
		local pos = self:GetPos()
		local findveh = ents.FindInSphere( pos, 300 )
		local totalveh = 0
		price = price + ( price * ( GetGlobalInt( "MAYOR_SalesTax" ) * 0.01 ) )
		for k,v in pairs( findveh ) do
			if v:GetClass() == "prop_vehicle_jeep" then
				totalveh = totalveh + 1
				v:SetNWInt( "AM_FuelAmount", 100 )
				activator:addMoney( -price )
				if price == 0 then
					DarkRP.notify( activator, 0, 6, "You have purchased a full fuel tank. You have not been charged." )
				else
					DarkRP.notify( activator, 0, 6, "You have purchased a full fuel tank for $"..price.."." )
				end
				break
			end
		end
		if totalveh == 0 then
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