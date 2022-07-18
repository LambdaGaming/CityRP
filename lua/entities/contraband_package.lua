AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Mysterious Package"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = false
ENT.AdminOnly = true

function ENT:SpawnFunction( ply, tr )
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal
	local ent = ents.Create( "contraband_package" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	e.Owner = ply
	return ent
end

function ENT:Initialize()
    self:SetModel( "models/props_junk/cardboard_box001a.mdl" )
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
	end
 
    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end

	timer.Simple( 1, function()
		if SERVER then
			local ply = self.Owner
			if !IsValid( ply ) then
				DarkRP.notifyAll( 1, 6, "ERROR: A contraband package was spawned but an owner wasn't assigned to it." )
				self:Remove()
				return
			end
			local randnpc = math.random( 1, 6 )
			if randnpc == 1 then
				self:SetNWInt( "TargetNPCType", 1 ) --Shop NPC
			elseif randnpc == 2 then
				self:SetNWInt( "TargetNPCType", 3 ) --Fire Truck NPC
			elseif randnpc == 3 then
				self:SetNWInt( "TargetNPCType", 4 ) --Gov Vehicle NPC
			elseif randnpc == 4 then
				self:SetNWInt( "TargetNPCType", 6 ) --Health NPC
			elseif randnpc == 5 then
				self:SetNWInt( "TargetNPCType", 7 ) --Tow Truck NPC
			else
				self:SetNWInt( "TargetNPCType", 8 ) --Truck NPC
			end
			local npctype = self:GetNWInt( "TargetNPCType" )
			DarkRP.notify( ply, 0, 8, "Take this package to the "..ItemNPCType[npctype].Name.." for a tier 2 crafting blueprint." )
		end
	end )
end

function ENT:Use( caller, activator )
	if SERVER then
		local foundrightnpc = false
		local npctype = self:GetNWInt( "TargetNPCType" )
		if caller != self.Owner then
			DarkRP.notify( caller, 0, 6, "You are not the owner of this contraband package. Setting owner to you..." )
			self.Owner = caller
			return
		end
		for k,v in pairs( ents.FindInSphere( self:GetPos(), 120 ) ) do
			if v:GetClass() == "npc_item" and npctype == v:GetNPCType() then
				local randwep = table.Random( BLUEPRINT_CONFIG_TIER2 )
				local e = ents.Create( "crafting_blueprint" )
				e:SetPos( self:GetPos() + Vector( 0, 0, 10 ) )
				e:Spawn()
				e:SetEntName( randwep[1] )
				e:SetRealName( randwep[2] )
				e:SetUses( 3 )
				DarkRP.notify( self.Owner, 0, 6, "You have successfully delivered the contraband package. You have been awarded with a tier 2 blueprint." )
				self.Owner:wanted( nil, "Delivering a suspicious package to the "..ItemNPCType[npctype].Name, 600 )
				self:Remove()
				foundrightnpc = true
				break
			end
		end
		if !foundrightnpc then
			DarkRP.notify( caller, 1, 6, "Target NPC not found. Reminder: Your target is the "..ItemNPCType[npctype].Name.."." )
		end
	end
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end
end