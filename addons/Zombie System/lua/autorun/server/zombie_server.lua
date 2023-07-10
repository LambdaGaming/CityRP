hook.Add( "EntityTakeDamage", "CheckZombieDamage", function( ent, dmg )
	if ent.Infected and ent:IsNPC() and dmg:IsDamageType( DMG_BURN + DMG_SLOWBURN ) then
		ent.Infected = false
	end
end )

hook.Add( "OnNPCKilled", "CheckZombieDeath", function( npc, attacker, inflictor )
	if npc.Infected then
		local node = ents.Create( "zombie_node" )
		node:SetPos( npc:GetPos() )
		node:Spawn()
		timer.Simple( 30, function()
			if !IsValid( node ) then return end
			node:Remove()
		end )
	end
end )

hook.Add( "DoPlayerDeath", "PlayerZombieDeath", function( ply, attacker, dmg )
	if ply.Infected and !dmg:IsDamageType( DMG_BURN + DMG_SLOWBURN ) then
		local e = ents.Create( "npc_zombie" )
		e:SetPos( ply:GetPos() )
		e:SetAngles( ply:GetAngles() )
		e:Spawn()
		e:SetHealth( 1000 )
		e.Infected = true
		local node = ents.Create( "zombie_node" )
		node:SetPos( e:GetPos() )
		node:Spawn()
		node:SetParent( e )
		ply.Infected = false
	end
	timer.Remove( "Regen"..ply:SteamID64() )
end )
