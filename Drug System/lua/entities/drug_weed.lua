AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Weed"
ENT.Author = "OPGman"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Drugs"

function ENT:SetupDataTables()
	self:NetworkVar( "Int", "WeedType" )
	if SERVER then
		self:SetWeedType( 1 )
	end
end

function ENT:Initialize()
    self:SetModel( "models/props/cs_office/trash_can_p5.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetColor( color_green )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
	end
	self:PhysWake()
end

function ENT:Use( ply )
	local hp = ply:Health()
	if hp < 200 then
		ply:SetHealth( hp + 5 )
	end
	if self:GetWeedType() == 2 then
		ply:GodEnable()
		ply:Ignite( 180, 50 )
	end
	ply:AddOD( 1 )
	ply:DrugEffect()
	ply:SetDSP( 6 )
	timer.Simple( 180, function()
		if IsValid( ply ) then
			ply:GodDisable()
			ply:DrugEffect( true )
			ply:SetDSP( 1 )
		end
	end )
	self:Remove()
end
