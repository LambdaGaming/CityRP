--Draw purge info
local function Purge()
    local chbxX, chboxY = chat.GetChatBoxPos()
    local Scrw, Scrh = ScrW(), ScrH()
    if GetGlobalBool( "DarkRP_Purge" ) then
        local shouldDraw = hook.Call( "HUDShouldDraw", GAMEMODE, "DarkRP_LockdownHUD" )
        if shouldDraw == false then return end
        local cin = ( math.sin( CurTime() ) + 1 ) / 2
        local chatBoxSize = math.floor( Scrh / 4 )
        draw.DrawNonParsedText(DarkRP.getPhrase( "purge_started" ), "ScoreboardSubtitle", chbxX, chboxY + chatBoxSize, Color( cin * 255, 0, 255 - ( cin * 255 ), 255 ), TEXT_ALIGN_LEFT )
    end
end

hook.Add( "HUDPaint", "PurgeParadeDraw", function()
	Purge()
end )

--Disable showing wanted text from across the map
local meta = FindMetaTable( "Player" )
meta.drawWantedInfo = function() end
