local QBCore = exports['qb-core']:GetCoreObject()


RegisterNetEvent('MusicPlayer:server:sync', function (type, input, zonename)
    if not zonename then return end
    local index = zonename:gsub('%PlayZone_', '')
    index = tonumber(index)
    if type == 'play' then
        exports['xsound']:PlayUrlPos(-1, zonename, input, 0.2, Config.Zones[index].sound, true, {})
        exports['xsound']:Distance(-1, zonename, Config.Zones[index].distance)
    elseif type == 'pause' then
        exports['xsound']:Pause(-1, zonename)
    elseif type == 'resume' then
        exports['xsound']:Resume(-1, zonename)
    elseif type == 'volume' then
        exports['xsound']:setVolume(-1, zonename, input)
    end
end)

RegisterNetEvent('MusicPlayer:server:menu', function (index)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local reqJob = Config.Zones[tonumber(index)].job
    if not reqJob or xPlayer.PlayerData.job.name == reqJob then
        TriggerClientEvent('MusicPlayer:client:menu', src)
    end
end)