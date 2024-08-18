-- QBCore Exports --
local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('sl-CyberArcade:server:ArcadeShop', function()
    local src = source
    local ArcadeShop = Config.ArcadeShop
    local playerCoords = GetEntityCoords(GetPlayerPed(src))

    exports['qb-inventory']:CreateShop({
        name = 'ArcadeShop',
        label = 'Arcade Tokens',
        coords = playerCoords,
        slots = #ArcadeShop,
        items = ArcadeShop
    })

    exports['qb-inventory']:OpenShop(src, 'ArcadeShop')
end)

QBCore.Functions.CreateCallback('sl-CyberArcade:server:PayTokens', function(source, cb, item, cost)
    local Player = QBCore.Functions.GetPlayer(source)
    local Tokens = Player.Functions.GetItemByName(item)

    if Tokens and Tokens.amount >= cost then
        Player.Functions.RemoveItem(item, cost)
        TriggerClientEvent('qb-inventory:client:ItemBox', source, QBCore.Shared.Items[item], 'remove', cost)
        cb(true)
    else
        cb(false)
    end
end)