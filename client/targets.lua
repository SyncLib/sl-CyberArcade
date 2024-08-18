-- QBCore Exports --
local QBCore = exports['qb-core']:GetCoreObject()

-- Load Model --
local function LoadModel(PedModel)
    RequestModel(PedModel)
    while not HasModelLoaded(PedModel) do
        Citizen.Wait(100)
    end
end

-- Unload Model --
local function UnloadModel(PedModel)
    SetModelAsNoLongerNeeded(PedModel)
end

-- Fade in Ped --
local function FadePedIn(ped)
    for alpha = 0, 255, 5 do
        SetEntityAlpha(ped, alpha, false)
        Citizen.Wait(10)
    end
end

-- Fade out Ped --
local function FadePedOut(ped)
    for alpha = 255, 0, -5 do
        SetEntityAlpha(ped, alpha, false)
        Citizen.Wait(10)
    end
end

-- Machine Zones & Ped Rendering based on Player Proximity --
local function MachineZones()
    -- Add Target Models (qb-target) --
    exports['qb-target']:AddTargetModel(Config.MachineProps, {
        options = {
            {
                type = 'client',
                event = 'sl-CyberArcade:client:ArcadeMachineMenu',
                icon = Config.MachineIcon,
                label = Config.Label
            },
        },
        distance = Config.InteractionDistance, -- Interaction distance
    })

    -- Ped Data for MLO Configuration --
    local PedData = Config.PedList[Config.MLO]

    PedData.isRendered = false
    local PedModel = GetHashKey(PedData.model)
    LoadModel(PedModel)

    -- Initial Rendering based on Distance
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    if #(PlayerCoords - PedData.coords) < Config.FadeDistance then
        -- Create Ped & Configure Properties --
        PedData.ped = CreatePed(4, PedModel, PedData.coords, PedData.heading, false, true)
        SetEntityInvincible(PedData.ped, true)
        FreezeEntityPosition(PedData.ped, true)
        SetBlockingOfNonTemporaryEvents(PedData.ped, true)
        TaskStartScenarioInPlace(PedData.ped, PedData.scenarios[math.random(1, #PedData.scenarios)], -1, true)
        PedData.isRendered = true
        UnloadModel(PedModel)

        -- Add Target Entity (qb-target) --
        exports['qb-target']:AddTargetEntity(PedData.ped, {
            options = {
                {
                    icon = PedData.icon,
                    label = PedData.label,
                    type = 'server',
                    event = 'sl-CyberArcade:server:ArcadeShop',
                },
            },
            distance = Config.InteractionDistance, -- Interaction distance
        })

        FadePedIn(PedData.ped)
    end

    --  Manage Ped Rendering based on Player Distance --
    while true do
        local PlayerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(PlayerCoords - PedData.coords)
        if distance < Config.FadeDistance and not PedData.isRendered then
            -- Create & Render Ped if Within Distance --
            LoadModel(GetHashKey(PedData.model))
            PedData.ped = CreatePed(4, GetHashKey(PedData.model), PedData.coords, PedData.heading, false, true)
            SetEntityInvincible(PedData.ped, true)
            FreezeEntityPosition(PedData.ped, true)
            SetBlockingOfNonTemporaryEvents(PedData.ped, true)
            TaskStartScenarioInPlace(PedData.ped, PedData.scenarios[math.random(1, #PedData.scenarios)], -1, true)
            PedData.isRendered = true
            UnloadModel(GetHashKey(PedData.model))

            -- Add Target Entity (qb-target) --
            exports['qb-target']:AddTargetEntity(PedData.ped, {
                options = {
                    {
                        icon = PedData.icon,
                        label = PedData.label,
                        type = 'server',
                        event = 'sl-CyberArcade:server:ArcadeShop',
                    },
                },
                distance = Config.InteractionDistance, -- Interaction distance
            })

            FadePedIn(PedData.ped)
        elseif distance >= Config.FadeDistance and PedData.isRendered then
            -- Remove Ped if Out of Range --
            FadePedOut(PedData.ped)
            DeleteEntity(PedData.ped)
            PedData.isRendered = false
        end
        Citizen.Wait(1000) -- Check Every Second
    end
end

-- Remove Zones & Peds --
local function RemoveZonesAndPeds()
    -- Remove Target Models
    exports['qb-target']:RemoveTargetModel(Config.MachineProps, 'Play Machine')

    -- Ped Data for MLO Configuration --
    local PedData = Config.PedList[Config.MLO]

    -- Remove Ped if it Exists & is Rendered --
    if PedData.isRendered and DoesEntityExist(PedData.ped) then
        FadePedOut(PedData.ped)
        DeleteEntity(PedData.ped)
        PedData.isRendered = false
    end
end

-- Event Handler for Resource Start to add PolyZones & Peds --
AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() == resource then
        MachineZones() -- Initialize Machine Zones & Peds
    end
end)

-- Event Handler for Resource Stop to remove PolyZones & Peds --
AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() == resource then
        RemoveZonesAndPeds() -- Delete Machine Zones & Peds
    end
end)

-- Event Handler for Player Loaded to add PolyZones & Peds --
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    MachineZones() -- Initialize Machine Zones & Peds
end)

-- Event Handler for Player Unloaded to remove PolyZones & Peds --
RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    RemoveZonesAndPeds() -- Delete Machine Zones & Peds
end)