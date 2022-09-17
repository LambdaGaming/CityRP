hook.Add( "EntityTakeDamage", "FireFighterImmunity", function( target, dmg )
	if target:IsPlayer() and dmg:GetDamageType() == DMG_BURN and ( target:Team() == TEAM_FIREBOSS or target:Team() == TEAM_FIRE ) then
		return true
	end
end )
