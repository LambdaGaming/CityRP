hook.Add( "PlayerSay", "playersaypersist", function( ply, text, public )
	local entnum = string.Explode( " ", text )
	local tbl = {}
	if entnum[1] == "!save" and ply:IsSuperAdmin() then
		local tr = ply:GetEyeTrace().Entity
		local name = tr:GetClass()
		
		if not entnum[2] then ply:ChatPrint( "Please add an identifier as an argument." ) return end
		if not IsValid( tr ) then ply:ChatPrint( "Save aborted. This entity doesn't exist according to the server." ) return end
		if tr:CreatedByMap() then ply:ChatPrint( "Save aborted. Cannot save entities created by the world." ) return end
		if tr:IsWorld() or tr:IsPlayer() then ply:ChatPrint( "Save aborted. Cannot save world or players." ) return end
		
		tbl = { tr:GetPos(), tr:GetAngles(), tr:GetModel(), tr:GetMaterial(), tr:GetColor() }
		file.CreateDir( "newpersist/"..game.GetMap() )
		file.Write( "newpersist/"..game.GetMap().."/"..name.."-"..entnum[2]..".txt", util.TableToJSON( tbl ) )
		ply:ChatPrint( [[Entity "]]..name..[[" saved successfully.]] )
		return ""
	end
end )

hook.Add( "InitPostEntity", "LoadNewPersist", function()
	local files, directories = file.Find( "newpersist/"..game.GetMap().."/*.txt", "DATA" )
	for k,v in pairs( files ) do
		local readtxt = file.Read( "newpersist/"..game.GetMap().."/"..v, "DATA" )
		local readunpack = util.JSONToTable( readtxt )
		local split = string.Explode( "-", v )
		local e = ents.Create( split[1] )
		e:SetPos( readunpack[1] )
		e:SetAngles( readunpack[2] )
		e:Spawn()
		e:Activate()
		if readunpack[3] then
			e:SetModel( readunpack[3] )
		end
		if readunpack[4] then
			e:SetMaterial( readunpack[4] )
		end
		if readunpack[5] then
			e:SetColor( readunpack[5] )
		end
		e:SetMoveType( MOVETYPE_NONE )
		if scripted_ents.IsBasedOn( e:GetClass(), "base_anim" ) or e:GetClass() == "prop_physics" then
			e:SetSolid( SOLID_VPHYSICS )
		end
		e.IsPermaProp = true
	end
	MsgC( color_red, "\n[CityRP] Loaded perma props.\n" )
end )
