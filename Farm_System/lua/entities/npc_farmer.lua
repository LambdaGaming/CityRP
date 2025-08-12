AddCSLuaFile()

ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "Farm NPC"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true 
ENT.AdminOnly = true
ENT.Category = "Farm System"
ENT.AutomaticFrameAdvance = true

function ENT:Initialize()
	self:SetModel( "models/Humans/Group02/male_06.mdl" )
	self:SetSolid( SOLID_BBOX )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:SetNPCState( NPC_STATE_SCRIPT )
	end
 
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:EnableMotion( false )
	end
end

function ENT:Use( activator, caller )
	DarkRP.notify( activator, 0, 6, "Press your use key on a farm crate to sell food." )
end

if CLIENT then
    function ENT:Draw()
		self:DrawModel()
		self:DrawOverheadText( "Farmer" )
    end
end
