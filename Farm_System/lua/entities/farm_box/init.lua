AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
    self:SetModel( "models/props_junk/wood_crate002a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:SetTrigger( true )
	self:PhysWake()
	self.Empty = true
end

function ENT:Use( ply )
	for k,v in pairs( ents.FindInSphere( self:GetPos(), 200 ) ) do
		if v:GetClass() == "npc_farmer" then
			if self.Empty then
				DarkRP.notify( ply, 1, 6, "There isn't any food in the crate!" )
				v:EmitSound( "vo/npc/male01/sorry0"..math.random( 1, 3 )..".wav" )
				return
			end
			local total = 0
			local numplants = 0
			for k,v in pairs( PlantTypes ) do
				total = total + ( self:GetNWInt( v.Name ) * v.SellPrice )
				numplants = numplants + 1
			end
			ply:addMoney( total )
			DarkRP.notify( ply, 0, 6, "You have sold "..numplants.." farm food(s) for "..DarkRP.formatMoney( total ).."." )
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
