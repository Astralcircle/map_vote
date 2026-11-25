MapVote = {}
MapVote.config = {}

local function runOnDir( dir, action )
    local files = file.Find( dir .. "/*.lua", "LUA" )
    for _, filename in pairs( files ) do
        action( dir .. "/" .. filename )
    end
end

if SERVER then
    AddCSLuaFile()
    AddCSLuaFile( "includes/modules/schemavalidator.lua" )

    runOnDir( "mapvote/shared/modules", function( f )
        AddCSLuaFile( f )
        include( f )
    end )

    -- load modules
    runOnDir( "mapvote/server/modules", include )
    -- add cs lua
    runOnDir( "mapvote/client/modules", AddCSLuaFile )
    runOnDir( "mapvote/client/vgui", AddCSLuaFile )
else
    -- load modules and vgui
    runOnDir( "mapvote/shared/modules", include )
    runOnDir( "mapvote/client/modules", include )
    runOnDir( "mapvote/client/vgui", include )
end

hook.Run( "MapVote_Loaded" )
