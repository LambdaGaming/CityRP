AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:SpawnFunction( ply, tr, name )
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 1
	local ent = ents.Create( name )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
    self:SetModel( "models/props_junk/wood_crate002a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:SetTrigger( true )

    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	self.Empty = true
end

function ENT:Use( activator, caller )
	for k,v in pairs( ents.FindInSphere( self:GetPos(), 200 ) ) do
		if v:GetClass() == "npc_farmer" then
			if self.Empty then
				DarkRP.notify( activator, 1, 6, "There isn't any food in the crate!" )
				v:EmitSound( "vo/npc/male01/sorry0"..math.random( 1, 3 )..".wav" )
				return
			end
			local total = 0
			for k,v in pairs( PlantTypes ) do
				total = total + ( self:GetNWInt( v.Name ) * v.SellPrice )
			end
			activator:addMoney( total )
			DarkRP.notify( activator, 0, 6, "You have sold farm foods for "..DarkRP.formatMoney( total ).."." )
			self:EmitSound( "items/ammocrate_open.wav" )
			for k,v in pairs( PlantTypes ) do
				self:SetNWInt( v.Name, 0 )
			end
			self.Empty = true
		end
	end
end

function ENT:StartTouch( ent )
	if ent:GetClass() == "farm_food" then
		local PlantType = ent:GetPlantType()
		local NumPlants = self:GetNWInt( PlantTypes[PlantType].Name )
		if NumPlants >= 5 then return end
		self:SetNWInt( PlantTypes[PlantType].Name, math.Clamp( NumPlants + 1, 0, 5 ) )
		self:EmitSound( "physics/wood/wood_box_impact_soft"..math.random( 1, 3 )..".wav" )
		ent:Remove()
		self.Empty = false
	end
end