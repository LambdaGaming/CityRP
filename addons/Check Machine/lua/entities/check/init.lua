AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self:SetModel( "models/props_lab/clipboard.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
 
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end
 
function ENT:Use( activator, caller )
	if IsValid(caller) and caller:IsPlayer() then
		if caller:IsEMS() or caller:isCP() or caller:Team() == TEAM_BANKER then return end
		caller:addMoney( 2000 )
		DarkRP.notify( caller, 0, 6, "You have collected $2000 from a bank check." )
		if self.IsEventCheck then
			ResetEventStatus()
			DarkRP.notifyAll( 1, 6, "The banker has failed to protect the check, it has been stolen!" )
		end
		self:Remove()
	end
end