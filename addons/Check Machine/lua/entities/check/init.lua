AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
 
	self:SetModel( "models/props_lab/clipboard.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)
 
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end
 
function ENT:Use( activator, caller )
	if IsValid(caller) and caller:IsPlayer() then
		--[[ for k, v in pairs(ents.FindInSphere(self:GetPos(), 100)) do
			if (v:GetClass() == "banker_npc") then
				if GetGlobalInt( "MAYOR_Money" ) <= 100 then activator:ChatPrint("You cannot cash this check in, there are not enough funds in the government bank!") return end
				caller:addMoney(5000)
				caller:ChatPrint("Cash-in successful, $5000 added to your wallet.")
				self:Remove()
				SetGlobalInt( "MAYOR_Money", GetGlobalInt( "MAYOR_Money" ) - 100 )
				if v:Team() == TEAM_MAYOR then
					DarkRP.notify( team.GetPlayers( TEAM_MAYOR ), 1, 5, "$100 has been removed from the bank due to a check cash-in." )
				end
			end
		end ]]
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