
if SERVER then
	hook.Add( "PlayerSay", "playersaypersist", function( ply, text, public )
	    local entnum = string.Explode( " ", text )
	    local tbl = {}
		if entnum[1] == "!save" and ply:IsSuperAdmin() then --Checks to make sure the first word of the chat is '!save', also makes sure the player is a superadmin
			local tr = ply:GetEyeTrace().Entity
			local name = tr:GetClass()
			
			if not entnum[2] then ply:ChatPrint( "Please add an identifier as an argument." ) return end --Stops code if a second word (the target identifier) isnt detected
			if not IsValid( tr ) then ply:ChatPrint( "Save aborted. This entity doesn't exist according to the server." ) return end --Stops code if the server doesn't see the entity
			if tr:CreatedByMap() then ply:ChatPrint( "Save aborted. Cannot save entities created by the world." ) return end --Stops code if the target entity is part of the map and not spawned by a player or the server
			if tr:IsWorld() or tr:IsPlayer() then ply:ChatPrint( "Save aborted. Cannot save world or players." ) return end --Stops code if the map itself or other players are the target
			
			tbl = { tr:GetPos(), tr:GetAngles(), tr:GetModel() } --Puts the vector and angles of the target into a table for later use
			
		    file.CreateDir( "newpersist/"..game.GetMap() ) --Creates the filepath directory if it doesn't already exist
		    
		    file.Write( "newpersist/"..game.GetMap().."/"..name.."-"..entnum[2]..".txt", util.TableToJSON( tbl ) ) --Writes a txt file in JSON format, contains the table of vectors and angles from before
			
			ply:ChatPrint( [[Entity "]]..name..[[" saved successfully.]] )
			
			return ""
        end
	end )
	
	hook.Add( "InitPostEntity", "LoadNewPersist", function()
	    local files, directories = file.Find( "newpersist/"..game.GetMap().."/*.txt", "DATA" ) --Looks at all of the txt files in the specified directory
		for a,b in pairs( files ) do
			--print(b) --Testing purposes only, prints a list of found files to the console
			local readtxt = file.Read( "newpersist/"..game.GetMap().."/"..b, "DATA" ) --Reads the files that were found above
			local readunpack = util.JSONToTable( readtxt ) --Converts the JSON format back into a lua table
			local split = string.Explode( "-", b ) --Splits the file names for use below
			local e = ents.Create( split[1] ) --Creates the entity, the name is found by looking at the first word in the filename after splitting
			e:SetPos( readunpack[1] ) --Reads the vector, the first value in the table
			e:SetAngles( readunpack[2] ) --Reads the angle, the second value in the table
			e:SetModel( readunpack[3] )
			e:Spawn()
			e:Activate()
			e:SetMoveType( MOVETYPE_NONE )
			e:SetSolid( SOLID_VPHYSICS )
		end
    end )
end