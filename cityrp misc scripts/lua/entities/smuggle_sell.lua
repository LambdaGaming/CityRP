AddCSLuaFile()

ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Smuggler"
ENT.Category = "Misc NPCs"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = true

local locations = {
	["rp_rockford_v2b"] = {
		{ Vector( -14512, 2331, 392 ), Angle( 0, -90, 0 ) },
		{ Vector( -10394, 3400, 8 ), angle_zero },
		{ Vector( -4142, -4390, 8 ), Angle( 0, -90, 0 ) },
		{ Vector( 13410, 7288, 1540 ), angle_zero }
	},
	["rp_southside_day"] = {
		{ Vector( 3741, 924, -96 ), angle_zero },
		{ Vector( -12633, 9493, 248 ), angle_zero },
		{ Vector( 3439, 5832, 24 ), angle_zero },
		{ Vector( 4214, 2962, -70 ), Angle( 0, -90, 0 ) }
	},
	["rp_riverden_v1a"] = {
		{ Vector( -6674, 11404, 0 ), angle_zero },
		{ Vector( -198, 13682, 0 ), angle_zero },
		{ Vector( -4476, 1835, -256 ), Angle( 0, 90, 0 ) },
		{ Vector( -8632, -5435, -264 ), Angle( 0, -90, 0 ) }
	},
	["rp_truenorth_v1a"] = {
		{ Vector( 10564, 12476, 8 ), Angle( 0, 90, 0 ) },
		{ Vector( 11584, 10942, 0 ), angle_zero },
		{ Vector( 1503, 83, 0 ), Angle( 0, 90, 0 ) },
		{ Vector( -6261, -3112, 3329 ), Angle( 0, -175, 0 ) }
	}
}

function ENT:Initialize()
	self:SetModel( "models/humans/group03/male_01.mdl" )
	if SERVER then
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_BBOX )
		self:SetUseType( SIMPLE_USE )
		self:SetCollisionGroup( COLLISION_GROUP_PLAYER )
		timer.Create( "SmugglerRelocate", 1800, 0, function()
			local randlocation = table.Random( locations[game.GetMap()] )
			self:SetPos( randlocation[1] )
			self:SetAngles( randlocation[2] )
		end )
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
