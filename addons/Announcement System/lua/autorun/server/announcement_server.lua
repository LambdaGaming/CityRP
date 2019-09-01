
hook.Add( "PlayerCanHearPlayersVoice", "AnnouncementSystemVoice", function( listener, talker )
	local wep = talker:GetActiveWeapon()
	if !IsValid( wep ) or wep:GetClass() != "weapon_announcement" then return end
	for k,v in pairs( ents.FindByClass( "announcement_speaker" ) ) do
		local wepchannel = v:GetNWInt( "Channel" )
		local entchannel = wep:GetNWInt( "Channel" )
		local pos = listener:GetPos()
		local entpos = v:GetPos()
		if wepchannel == entchannel and pos:DistToSqr( entpos ) < 640000 then
			return true
		end
	end
end )