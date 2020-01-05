AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

local cooldowntimer = 180

function ENT:Initialize()
	self:SetModel( "models/props_lab/reciever_cart.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)
	self:SetTrigger( true )

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

util.AddNetworkString( "CheckAccept" )
net.Receive( "CheckAccept", function( len, ply )
	local check = ents.Create("check")
	check:Spawn()
	check:SetPos( ply:GetPos() + Vector(30, 0, 0) )
	DarkRP.notify( ply, 0, 6, "Check successfully spawned." )
	SetGlobalInt( "Mayor_Money", GetGlobalInt( "Mayor_Money" ) - 300 )
end )

util.AddNetworkString( "CheckMenu" )
function ENT:Use( caller, activator )
	if caller:IsPlayer() and !timer.Exists("Check_Timer") then
		timer.Create("Check_Timer", cooldowntimer, 1, function() end )
		if caller:Team() == TEAM_BANKER or caller:isCP() then
			net.Start( "CheckMenu" )
			net.WriteEntity( self )
			net.Send( caller )
		end
	elseif timer.Exists("Check_Timer") then
		DarkRP.notify(caller, 1, 3, "Wait "..string.ToMinutesSeconds( timer.TimeLeft( "Check_Timer" ) ).." before spawning another check.")
	end
end

local cooldown = 0
function ENT:Touch( ent )
	if cooldown > CurTime() then return end
	if ent:GetClass() == "check" and ent.IsEventCheck then
		for a,ply in pairs( player.GetAll() ) do
			if ply:Team() == TEAM_BANKER then
				ply:addMoney( 400 )
				DarkRP.notify( ply, 0, 6, "Check successfully delivered. You have been awarded $400!" )
				ent:Remove()
				MoneyTransferEnd()
			end
		end
		cooldown = CurTime() + 3
	end
end
 
function ENT:OnRemove()
	timer.Remove("Check_Timer")
end