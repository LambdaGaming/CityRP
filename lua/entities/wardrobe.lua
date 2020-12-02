
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Wardrobe"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Mining System"

function ENT:SpawnFunction( ply, tr, name )
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 2
	local ent = ents.Create( name )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
    self:SetModel( "models/props_c17/FurnitureDrawer001a.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
	end
end

if SERVER then
	util.AddNetworkString( "OpenPACEditor" )
	function ENT:Use( caller, activator )
		net.Start( "OpenPACEditor" )
		net.Send( caller )
		self:EmitSound( "doors/door_wood_close1.wav" )
	end
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end

	local function OpenPACEditor()
		pace.OpenEditor()
	end
	net.Receive( "OpenPACEditor", OpenPACEditor )
end
