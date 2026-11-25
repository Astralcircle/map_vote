function ulx.rtv( calling_ply, should_cancel )
    if not should_cancel then
        MapVote.RTV.HandleRTVCommand( calling_ply )
    else
        MapVote.RTV.HandleUnRTVCommand( calling_ply )
    end
end

local rtv = ulx.command( "Utility", "rtv", ulx.rtv, "!rtv" )
rtv:addParam( { type = ULib.cmds.BoolArg, invisible = true } )
rtv:defaultAccess( ULib.ACCESS_ADMIN )
rtv:help( "Votes to change the map" )
rtv:setOpposite( "unrtv", { nil, true }, "!unrtv" )

function ulx.forcemapvote( calling_ply, votetime, should_cancel )
    if not should_cancel then
        MapVote.Start( votetime )
        ulx.fancyLogAdmin( calling_ply, "#A called a votemap" )
    else
        MapVote.Cancel()
        ulx.fancyLogAdmin( calling_ply, "#A canceled the votemap" )
    end
end

local forcemapvotecmd = ulx.command( "Utility", "startmapvote", ulx.forcemapvote, "!startmapvote" )
forcemapvotecmd:addParam( { type = ULib.cmds.NumArg, min = 15, default = 30, hint = "time", ULib.cmds.optional, ULib.cmds.round } )
forcemapvotecmd:addParam( { type = ULib.cmds.BoolArg, invisible = true } )
forcemapvotecmd:defaultAccess( ULib.ACCESS_ADMIN )
forcemapvotecmd:help( "Invokes the map vote logic" )
forcemapvotecmd:setOpposite( "stopmapvote", { nil, nil, true }, "!stopmapvote" )
