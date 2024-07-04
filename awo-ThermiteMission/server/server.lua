local QBCore = exports['qb-core']:GetCoreObject()

local LastRob = 0

local isActive = false

function DiscordLog(message)
    local embed = {
        {
            ["color"] = 04255, 
            ["title"] = "CloudDevelopment Thermite Mission",
            ["description"] = message,
            ["url"] = "https://discord.gg/e4AYS3VE",
            ["footer"] = {
            ["text"] = "By CloudDevelopment",
            ["icon_url"] = Config.LogsImage
        },
            ["thumbnail"] = {
                ["url"] = Config.LogsImage,
            },
    }
}
    PerformHttpRequest(Config.WebHook, function(err, text, headers) end, 'POST', json.encode({username = 'awo-ThermiteMission', embeds = embed, avatar_url = Config.LogsImage}), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent('awo-ThermiteMission:server:GiveReward', function(SecurityCheck)
    local src = source
   if SecurityCheck then
        exports['qb-inventory']:AddItem(src, Config.ThermiteItem, math.random(Config.MinEarn, Config.MaxEarn), false, false)
        TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[Config.ThermiteItem], 'add')
    else
       --print("nem ide")
        QBCore.Functions.Kick(playerId, 'Bro Dont do that!', true, true)
    end
end)

--exports['qb-inventory']:AddItem(src, 'hb_baconroll', 2, false, false)

RegisterServerEvent("awo-ThermiteMission:Server:GuardsSync", function() 
    TriggerClientEvent("awo-ThermiteMission:GuardsSync", -1)
end) 

RegisterNetEvent('awo-ThermiteMission:server:SetActive', function(status)
    if status ~= nil then
        isActive = status
        TriggerClientEvent('awo-ThermiteMission:client:SetActive', -1, isActive)
    else
        TriggerClientEvent('awo-ThermiteMission:client:SetActive', -1, isActive)
    end
end)

RegisterNetEvent("awo-ThermiteMission:SendDiscordLog", function()
    local src = source
    local steamname = GetPlayerName(src)
    DiscordLog('Thermite Mission Started By: **'..steamname..'** ID: **' ..src..'**')
end)