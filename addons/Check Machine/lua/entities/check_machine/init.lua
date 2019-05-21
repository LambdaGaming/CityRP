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
	if (phys:IsValid()) then
		phys:Wake()
	end
end

util.AddNetworkString( "CheckAccept" )
net.Receive( "CheckAccept", function( len, ply )
	local check = ents.Create("check")
	check:Spawn() --Spawns the check once the player clicks the proceed button
	check:SetPos( ply:GetPos() + Vector(30, 0, 0) )
	DarkRP.notify( ply, 0, 6, "Check successfully spawned." )
	SetGlobalInt( "Mayor_Money", GetGlobalInt( "Mayor_Money" ) - 300 ) --Removes 300 from the mayor funds
end )

util.AddNetworkString( "CheckMenu" )
function ENT:Use( caller, activator )
	if caller:IsPlayer() and !timer.Exists("Check_Timer") then
		timer.Create("Check_Timer", cooldowntimer, 1, function() end )
		--[[ local check = ents.Create("check") --Old function to spawn a check
		check:Spawn()
		check:SetPos( caller:GetPos() + Vector(30, 0, 0) )
		DarkRP.notify(caller, 1, 6, "Check successfully spawned.")
		for k,v in pairs( player.GetAll() ) do
			if v:Team() == TEAM_CITIZEN or v:Team() == TEAM_TOWER or v:Team() == TEAM_CAMERA then
				DarkRP.notify( v, 1, 6, "The check machine has just produced a check." )
			end
		end ]]
		if caller:Team() == TEAM_BANKER or caller:isCP() then --Only allows cops and bankers to spawn checks
			net.Start( "CheckMenu" ) --Opens the warning menu
			net.WriteEntity( self )
			net.Send( caller )
		end
	elseif timer.Exists("Check_Timer") then --Cooldown timer, probably doesn't need to be a timer function
		DarkRP.notify(caller, 1, 3, "Wait "..string.ToMinutesSeconds( math.Round( timer.TimeLeft( "Check_Timer" ) ) ).." minutes before spawning another check.")
	end
end

local cooldown = 0
function ENT:Touch( ent )
	if cooldown > CurTime() then return end
	if ent:GetClass() == "check" and ent.IsEventCheck then --Only passes if the check was spawned through the banker event
		for a,ply in pairs( player.GetAll() ) do
			if ply:Team() == TEAM_BANKER then --Only allows the banker to deliver the check to the machine. If players wish to steal the check, they can press their use key on it to get the money
				ply:addMoney( 400 )
				DarkRP.notify( ply, 0, 6, "Check successfully delivered. You have been awarded $400!" )
				local randwep = table.Random( BLUEPRINT_CONFIG_TIER2 )
				local e = ents.Create( "crafting_blueprint" )
				e:SetPos( self:GetPos() + Vector( 0, 30, 0 ) )
				e:SetAngles( self:GetAngles() + Angle( 0, 180, 0 ) )
				e:Spawn()
				e:SetEntName( randwep[1] )
				e:SetRealName( randwep[2] )
				DarkRP.notify( ply, 0, 6, "You have also been rewarded with a crafting blueprint." )
				ent:Remove()
				MoneyTransferEnd() --Calls the end of the banker event
			end
		end
		cooldown = CurTime() + 3
	end
end
 
function ENT:OnRemove()
	timer.Remove("Check_Timer")
end
