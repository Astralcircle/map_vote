local RTV = MapVote.RTV or {}
MapVote.RTV = RTV

function RTV.ShouldCountPlayer( ply )
    local result = hook.Run( "MapVote_RTVShouldCountPlayer", ply )
    if result ~= nil then return result end

    return true
end

function RTV.GetPlayerCount()
    local count = 0
    for _, ply in pairs( player.GetHumans() ) do
        if RTV.ShouldCountPlayer( ply ) then
            count = count + 1
        end
    end
    return count
end

function RTV.GetVoteCount()
    local count = 0
    for _, ply in pairs( player.GetHumans() ) do
        if RTV.ShouldCountPlayer( ply ) and ply.RTVVoted then
            count = count + 1
        end
    end
    return count
end

function RTV.GetThreshold()
    local conf = MapVote.GetConfig()
    local totalPlayers = RTV.GetPlayerCount()

    local threshold = totalPlayers * conf.RTVPercentPlayersRequired

    if conf.RTVPercentWhenOverpopulated > 0 then
        local mapsConfig = conf.MapConfig and conf.MapConfig[game.GetMap()] or nil
        if mapsConfig and mapsConfig.MaxPlayers and totalPlayers > mapsConfig.MaxPlayers then -- overpopulated map
            threshold = totalPlayers * conf.RTVPercentWhenOverpopulated
        end
    end

    return math.ceil( threshold )
end

function RTV.ShouldChange()
    if MapVote.state.isInProgress then return end
    local conf = MapVote.GetConfig()
    local totalVotes = RTV.GetVoteCount()
    local totalPlayers = RTV.GetPlayerCount()

    if totalPlayers < conf.RTVPlayerCount then return end

    if totalPlayers == 0 then return end

    return totalVotes >= RTV.GetThreshold()
end

function RTV.StartIfShouldChange()
    if RTV.ShouldChange() then
        RTV.Start()
    end
end

function RTV.Start()
    if hook.Run( "MapVote_RTVStart" ) == false then return end

    PrintMessage( HUD_PRINTTALK, "Игроки проголосовали за смену карты, голосование скоро начнется" )
    MapVote.Start()
end

function RTV.ResetVotes()
    for _, ply in ipairs( player.GetHumans() ) do
        ply.RTVVoted = nil
    end
end

function RTV.AddVote( ply )
    ply.RTVVoted = true
    ply.RTVVotedTime = CurTime()

    local threshold = RTV.GetThreshold()
    MsgN( ply:Nick() .. " has voted to change the map. (" .. RTV.GetVoteCount() .. "/" .. threshold .. ")" )
    PrintMessage( HUD_PRINTTALK, ply:Nick() .. " проголосовал за смену карты (" .. RTV.GetVoteCount() .. "/" .. threshold .. ")" )
end

hook.Add( "PlayerDisconnected", "Remove RTV", function()
    timer.Simple( 0.1, RTV.StartIfShouldChange )
end )

local function plural( n, one, few, many )
    local m10 = n % 10
    local m100 = n % 100

    if m10 == 1 and m100 ~= 11 then
        return one
    end

    if m10 >= 2 and m10 <= 4 and ( m100 < 10 or m100 >= 20 ) then
        return few
    end

    return many
end

local function niceTime( seconds )
    seconds = math.max( math.ceil( seconds ), 1 )

    if seconds >= 60 then
        local minutes = math.ceil( seconds / 60 )
        return minutes .. " " .. plural( minutes, "минуту", "минуты", "минут" )
    end

    return seconds .. " " .. plural( seconds, "секунду", "секунды", "секунд" )
end

function RTV.CanVote( ply )
    local conf = MapVote.GetConfig()

    if conf.RTVWait >= CurTime() then
        return false, "Подождите ещё " .. niceTime(conf.RTVWait - CurTime()) .. ", прежде чем голосовать за смену карты!"
    end

    if ply.RTVVotedTime and ply.RTVVotedTime + conf.PlyRTVCooldownSeconds >= CurTime() then
        return false, "Подождите ещё " .. niceTime(conf.PlyRTVCooldownSeconds - CurTime()) .. ", прежде чем голосовать снова!"
    end

    if GetGlobalBool( "In_Voting" ) then
        return false, "Голосование уже идёт!"
    end

    if ply.RTVVoted then
        return false,
            string.format( "Вы уже проголосовали за смену карты! (%s/%s)", RTV.GetVoteCount(),
                RTV.GetThreshold() )
    end

    if MapVote.state.isInProgress then
        return false,
            "Голосование уже идёт"
    end
    if RTV.GetPlayerCount() < conf.RTVPlayerCount then
        return false, "Для голосования за смену карты нужно больше игроков!"
    end

    return true
end

function RTV.StartVote( ply )
    if not IsValid( ply ) then return end
    local can, err = RTV.CanVote( ply )

    if not can then
        ply:PrintMessage( HUD_PRINTTALK, err )
        return
    end

    RTV.AddVote( ply )
    RTV.StartIfShouldChange()
end

function RTV.HandleRTVCommand( ply )
    RTV.StartVote( ply )
end

function RTV.HandleUnRTVCommand( ply )
    if not ply.RTVVoted then
        ply:PrintMessage( HUD_PRINTTALK, "Вы не голосовали за смену карты!" )
        return
    end

    ply.RTVVoted = false
    ply:PrintMessage( HUD_PRINTTALK, "Ваш голос отозван!" )
end
