AddCSLuaFile()

ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Smuggler"
ENT.Category = "Drugs"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = true

function ENT:Initialize()
	self:SetModel( "models/humans/group03/male_01.mdl" )
	if SERVER then
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_BBOX )
		self:SetUseType( SIMPLE_USE )
		self:SetCollisionGroup( COLLISION_GROUP_PLAYER )
	end
	self:PhysWake()
end

function ENT:Use( ply )
	local foundItem = false
	local pos = self:GetPos()
	local numply = 0
	for k,v in ipairs( ents.FindInSphere( pos, 500 ) ) do
		if v:IsPlayer() then
			numply = numply + 1
		end
	end
	if numply > 1 then
		ply:ChatPrint( "There's too many people around here! Come back later." )
		return
	end
	for k,v in ipairs( ents.FindInSphere( pos, 500 ) ) do
		--TODO: Drug stuff
		if v.SmuggleTruck then
			if !ply:IsCivilian() then
				DarkRP.notify( ply, 1, 6, "Only civilians can smuggle things!" )
				return
			end
			SmuggleEnd( ply )
			v:Remove()
			return
		elseif v:GetClass() == "custom_shipment" and v.Ready and v:GetOwner() != ply then
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
			DarkRP.notify( ply, 0, 6, "Successfully smuggled a weapon shipment." )
			return
		end
	end
	if !foundItem then
		DarkRP.notify( ply, 1, 6, "No item detected. Try moving it closer." )
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawNPCText( "Smuggler" )
	end
end
