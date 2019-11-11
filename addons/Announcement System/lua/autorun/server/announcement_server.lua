
hook.Add( "PlayerCanHearPlayersVoice", "AnnouncementSystemVoice", function( listener, talker )
	local wep = talker:GetActiveWeapon()
	for k,v in pairs( ents.FindByClass( "announcement_speaker" ) ) do
		local wepchannel = v:GetNWInt( "Announce_Channel" )
		local entchannel = wep:GetNWInt( "Announce_Channel" )
		local pos = listener:GetPos()
		local entpos = v:GetPos()
		if wepchannel == entchannel and pos:DistToSqr( entpos ) < 640000 then
			return true
		end
	end
end )