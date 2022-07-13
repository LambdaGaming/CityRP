AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Pot Hole"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Superadmin Only"

function ENT:SpawnFunction( ply, tr, name )
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal - 5
	local ent = ents.Create( name )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
    self:SetModel( "models/props_debris/plaster_floor003a.mdl" )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:SetUseType( SIMPLE_USE )
		self:SetTrigger( true )
		self:SetHealth( 50 )
	end
end

function ENT:Use( caller, activator )
	if SERVER then
		if caller:Team() == TEAM_TOWER then
			DarkRP.notify( caller, 0, 6, "Use a pickaxe on this pothole to even out the road surface." )
		else
			DarkRP.notify( caller, 0, 6, "Contact a mechanic to have them repair this pothole." )
		end
	end
end

function ENT:StartTouch( ent )
	if ent:IsVehicle() and SERVER then
		local rand = math.random( 1, 10 )
		if rand == 1 then
			AM_PopTire( ent, 1 ) --10% chance of the pothole popping a tire
		end
	end
end

function ENT:OnTakeDamage( damage )
	local ply = damage:GetAttacker()
	local wep = ply:GetActiveWeapon():GetClass()
	local hp = self:Health()
	if ply:IsPlayer() and ply:Team() == TEAM_TOWER and wep == "mgs_pickaxe" then
		local randinterval = math.random( 1, 5 )
		self:SetHealth( hp - randinterval )
	end
	if hp <= 0 then
		RoadWorkEnd( ply, self )
		self:Remove()
	end
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end
end
