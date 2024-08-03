local InZone = false
local ZoneName = nil
local zones = {}

local function Init()
    for index,data in pairs(Config.Zones) do
        zones[#zones + 1] = BoxZone:Create(
            vector3(data.panel.x, data.panel.y, data.panel.z), data.width, data.length, {
            name= "PlayZone_"..index,
            debugPoly = Config.Zones[index].debug,
            heading = data.panel.w,
            minZ = data.panel.z - 1,
            maxZ = data.panel.z + 1,
        })  
        local playzonescombo = ComboZone:Create(zones, {name = "playzonescombo", debugPoly = false})
        playzonescombo:onPlayerInOut(function(isPointInside, _, zone)
            if isPointInside then
                InZone, ZoneName = true, zone.name
                lib.showTextUI('[E] -> Manage')
            else
                InZone = false
                lib.hideTextUI()
            end
        end)
    end

    local sleep
    while true do
        sleep = 1000
        if InZone then
            sleep = 5
            if IsControlJustReleased(0, 38) then
                TriggerServerEvent('MusicPlayer:server:menu', ZoneName:gsub('%PlayZone_', ''))
            end
        end
        Wait(sleep)
    end
end

Citizen.CreateThread(function ()
    Init()
end)

local function InputURL()
    local input = lib.inputDialog('Paste URL', {
        {type = 'input', required = true},
    })
    if not input[1] then return end
    TriggerServerEvent('MusicPlayer:server:sync', 'play', input[1], ZoneName)
end

local function InputVolume()
    local input = lib.inputDialog('Change Volume', {
        {type = 'number', label = '0 / 100', required = true},
    })
    if not input[1] then return end
    TriggerServerEvent('MusicPlayer:server:sync', 'volume', tonumber(input[1]/100), ZoneName)
end

RegisterNetEvent('MusicPlayer:client:menu', function ()
    lib.registerMenu({
        id = 'MusicPlayer',
        title = 'Music Player',
        position = 'top-right',
        options = {
            {
                label = 'Paste URL',
                icon = 'fa-solid fa-link'
            },
            {
                label = 'Volume',
                icon = 'fa-solid fa-volume-low'
            },
            {
                label = 'Pause',
                icon = 'fa-solid fa-pause'
            },
            {
                label = 'Resume',
                icon = 'fa-solid fa-play'
            },
        }
    }, function(selected, scrollIndex, args)
        if selected == 1 then
            InputURL()
        elseif selected == 2 then
            InputVolume()
        elseif selected == 3 then
            TriggerServerEvent('MusicPlayer:server:sync', 'pause', nil, ZoneName)
        elseif selected == 4 then
            TriggerServerEvent('MusicPlayer:server:sync', 'resume', nil, ZoneName)
        end
    end)
    lib.showMenu('MusicPlayer')
end)