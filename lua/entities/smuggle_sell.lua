AddCSLuaFile()

ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Smuggler"
ENT.Category = "Misc NPCs"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = true

function ENT:Initialize()
	self:SetModel( "models/humans/group01/male_01.mdl" )
	if SERVER then
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_BBOX )
		self:SetCollisionGroup( COLLISION_GROUP_PLAYER )
	end
	local phys = self:GetPhysicsObject()
	if IsValid( phys ) then
		phys:Wake()
	end
end

if SERVER then
	local usecooldown
	function ENT:AcceptInput( name, caller )
		if usecooldown and usecooldown > CurTime() then return end
		if caller:IsCivilian() then
			usecooldown = CurTime() + 1
			local foundtruck = false
			local foundshipment = false
			local foundent
			for k,v in pairs( ents.FindInSphere( self:GetPos(), 500 ) ) do
				if v.SmuggleTruck then
					foundtruck = true
					foundent = v
					break
				elseif v:GetClass() == "custom_shipment" and v.Ready and v:GetOwner() != caller then
					foundshipment = true
					foundent = v
				end
			end
			if foundtruck then
				SmuggleEnd( caller )
				foundent:Remove()
				return
			elseif foundshipment then
				foundent:Remove()
				local amt = math.Round( foundent:GetAmount() / 2 )
				for i=1,amt do
					local class = ShipmentWepList[foundent:GetGunType()][1]
					local e = ents.Create( "spawned_weapon" )
					e:SetWeaponClass( class )
					e:SetModel( weapons.GetStored( class ).WorldModel )
					e:SetPos( self:GetPos() + ( self:GetForward() * 10 ) + Vector( 0, 0, i * 20 ) )
					e.nodupe = true
					e:Spawn()
				end
				DarkRP.notify( caller, 0, 6, "Successfully smuggled a weapon shipment." )
				return
			end
			DarkRP.notify( caller, 1, 6, "No item detected. Try moving it closer." )
		else
			DarkRP.notify( caller, 1, 6, "Only civilian jobs can use this NPC." )
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawNPCText( "Smuggler" )
	end
end
