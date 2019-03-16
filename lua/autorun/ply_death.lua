
CreateConVar("respawnsecs", 5, FCVAR_NOTIFY)

function SetRespawnSeconds(ply, cmd, args)
	if ply:IsSuperAdmin() then
		RunConsoleCommand("respawnsecs", tonumber(args[1]))
	end 
end
concommand.Add("setrespawnsecs", SetRespawnSeconds)

function ForcePlayerRespawn(ply)
	if !IsValid( ply ) then return end
	if GetConVarNumber("respawnsecs") != 0 then
		ply:Lock()
		ply:ChatPrint("You have to wait " .. GetConVarNumber("respawnsecs") .. " seconds before you can respawn")
		timer.Simple( GetConVarNumber("respawnsecs"), function()
			if !IsValid( ply ) then return end
			ply:UnLock()
			ply:ChatPrint("You can respawn now")
		end )
	end
end
hook.Add("PlayerDeath", "ForcePlayerRespawn", ForcePlayerRespawn)