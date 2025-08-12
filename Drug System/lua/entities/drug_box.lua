AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Drug Box"
ENT.Author = "OPGman"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Drugs"

function ENT:Initialize()
	self:SetModel( "models/props/CS_militia/crate_extrasmallmill.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:SetTrigger( true )
		self.Drugs = {}
		self.MaxDrugs = 5
	end
	self:PhysWake()
end

local drugs = {
	["drug_weed"] = true,
	["drug_cocaine"] = true,
	["drug_meth"] = true
}

function ENT:StartTouch( ent )
	local class = ent:GetClass()
	if !drugs[class] or table.Count( self.Drugs ) >= self.MaxDrugs then return end
	local stat
	if class == "drug_weed" then
		stat = ent:GetWeedType()
	elseif class == "drug_cocaine" then
		stat = ent:GetPurity()
	else
		stat = ent.Quality
	end
	table.insert( self.Drugs, { Class = class, Stat = stat } )
	ent:Remove()
	self:EmitSound( "physics/cardboard/cardboard_box_impact_soft"..math.random( 1, 7 )..".wav" )
end

if CLIENT then
	local offset = Vector( 0, 0, 60 )
	function ENT:Draw()
		self:DrawModel()
		self:DrawOverheadText( "Drug Box", offset )
	end
end
