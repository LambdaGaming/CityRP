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

function ENT:Use( ply )
	if EcoPerkActive( "Cut Oil and Gas Budget" ) then
		DarkRP.notify( ply, 1, 6, "Fuel cannot be bought from here at this time." )
		return
	end
	local pos = self:GetPos()
	local findveh = ents.FindInSphere( pos, 300 )
	local foundveh = false
	for k,v in pairs( findveh ) do
		if v:GetClass() == "prop_vehicle_jeep" and v:GetNWEntity( "VehicleOwner" ) == ply then
			local tax = GetGlobalInt( "MAYOR_SalesTax" )
			local required = 100 - v:GetNWInt( "AM_FuelAmount" )
			local discount = ply:isCP() and tax < 50
			local price = discount and 0 or required * 3
			price = price + ( price * ( tax * 0.01 ) )
			if required == 0 then
				DarkRP.notify( ply, 1, 6, "Your vehicle's fuel tank is already full!" )
				return
			end
			if ply:canAfford( price ) then
				v:SetNWInt( "AM_FuelAmount", 100 )
				ply:addMoney( -price )
				if price <= 0 then
					DarkRP.notify( ply, 0, 6, "You have purchased a full fuel tank. You have not been charged." )
				else
					DarkRP.notify( ply, 0, 6, "You have purchased a full fuel tank for $"..price.."." )
				end
				foundveh = true
			else
				DarkRP.notify( ply, 1, 6, "You don't have enough money to purchase fuel!" )
			end
			break
		end
	end
	if !foundveh then
		DarkRP.notify( ply, 1, 6, "No vehicle detected. Move it closer." )
	end
end
