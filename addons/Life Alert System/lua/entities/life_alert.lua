
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Life Alert"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Life Alert System"
ENT.DoNotDuplicate = true

function ENT:SpawnFunction( ply, tr )
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 1
	local ent = ents.Create( "life_alert" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
    self:SetModel( "models/props_lab/reciever01d.mdl" )
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
	end
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use( activator, caller )
	if IsValid( caller ) and caller:IsPlayer() then
		if caller.haslifealert then
			caller:ChatPrint( "You already have life alert!" )
		else
			caller.haslifealert = true
			caller:ChatPrint( "You now have life alert!" )
			self:EmitSound( "buttons/button18.wav" )
			self:Remove()
		end
	end
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end
end
