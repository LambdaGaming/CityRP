function DarkRP.purge( ply )
    if GetGlobalBool( "DarkRP_Purge" ) then
        DarkRP.notify( ply, 1, 6, "The purge is already active!" )
        return ""
    end
    if !ply:isMayor() then
        DarkRP.notify( ply, 1, 6, "Only the mayor can start the purge!" )
        return ""
    end
    for _,v in ipairs( player.GetAll() ) do
        v:ConCommand( "play purge/purge_announcement.mp3" )
    end
    DarkRP.printMessageAll( HUD_PRINTTALK, "The purge has started!" )
    SetGlobalBool( "DarkRP_Purge", true )
    DarkRP.notifyAll( 0, 3, "The purge has started!" )
    return ""
end
DarkRP.defineChatCommand( "purge", DarkRP.purge )

function DarkRP.endPurge( ply )
    if !GetGlobalBool( "DarkRP_Purge" ) then
        DarkRP.notify( ply, 1, 6, "The purge is not active." )
        return ""
    end
    if !ply:isMayor() then
        DarkRP.notify( ply, 1, 6, "Only the mayor can end the purge!" )
        return ""
    end
    DarkRP.printMessageAll( HUD_PRINTTALK, "The purge has ended!" )
    DarkRP.notifyAll( 0, 3, "The purge has ended!" )
    SetGlobalBool( "DarkRP_Purge", false )
    return ""
end
DarkRP.defineChatCommand( "endpurge", DarkRP.endPurge )

function DarkRP.parade( ply )
    if !ply:isMayor() then
        DarkRP.notify( ply, 1, 6, "Only the mayor can start a parade!" )
        return ""
    end
    for _,v in ipairs( player.GetAll() ) do
        v:ConCommand( "play parade/parade.mp3" )
    end
    DarkRP.printMessageAll( HUD_PRINTTALK, "A parade has started!")
    SetGlobalBool( "DarkRP_Parade", true )
    DarkRP.notifyAll( 0, 3, "A parade has started!" )
    return ""
end
DarkRP.defineChatCommand( "parade", DarkRP.parade )
