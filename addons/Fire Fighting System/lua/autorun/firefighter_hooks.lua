hook.Add( "EntityTakeDamage", "FireFighterImmunity", function( target, dmg )
	if target:IsPlayer() and dmg:GetDamageType() == DMG_BURN and target:IsEMS() then
		return true
	end
end )
