-- QBCore Exports --
local QBCore = exports['qb-core']:GetCoreObject()

local function GenerateMenu(menuType)
    local menus = {
        QBCore = {
            {
                header = 'Main Menu',
                txt = '(return to main dashboard)',
                icon = 'fas fa-home',
                params = { event = 'sl-CyberArcade:client:ArcadeMachineMenu' }
            },
            {
                header = 'Key Press Minigame',
                icon = 'fas fa-key',
                params = { event = 'sl-CyberArcade:client:QBCoreMinigames', args = { MinigameType = 'KeyMinigame' } }
            },
            {
                header = 'Lockpicking Minigame',
                icon = 'fas fa-lock',
                params = { event = 'sl-CyberArcade:client:QBCoreMinigames', args = { MinigameType = 'Lockpick' } }
            },
            {
                header = 'Hacking Minigame',
                icon = 'fas fa-laptop-code',
                params = { event = 'sl-CyberArcade:client:QBCoreMinigames', args = { MinigameType = 'Hacking' } }
            },
            {
                header = 'Skillcheck Minigame',
                icon = 'fas fa-tachometer-alt',
                params = { event = 'sl-CyberArcade:client:QBCoreMinigames', args = { MinigameType = 'Skillbar' } }
            },
        },
        Haaasib = {
            {
                header = 'Main Menu',
                txt = '(return to main dashboard)',
                icon = 'fas fa-home',
                params = { event = 'sl-CyberArcade:client:ArcadeMachineMenu' }
            },
            {
                header = 'Alphabet Minigame',
                icon = 'fas fa-font',
                params = { event = 'sl-CyberArcade:client:HaaasibMinigames', args = { MinigameType = 'Alphabet' } }
            },
            {
                header = 'Direction Minigame',
                icon = 'fas fa-compass',
                params = { event = 'sl-CyberArcade:client:HaaasibMinigames', args = { MinigameType = 'Direction' } }
            },
            {
                header = 'Flip Minigame',
                icon = 'fas fa-sync-alt',
                params = { event = 'sl-CyberArcade:client:HaaasibMinigames', args = { MinigameType = 'Flip' } }
            },
            {
                header = 'Lockpicking Minigame',
                icon = 'fas fa-unlock-alt',
                params = { event = 'sl-CyberArcade:client:HaaasibMinigames', args = { MinigameType = 'Lockpick' } }
            },
            {
                header = 'Same Game Minigame',
                icon = 'fas fa-clone',
                params = { event = 'sl-CyberArcade:client:HaaasibMinigames', args = { MinigameType = 'Same' } }
            },
            {
                header = 'Untangle Minigame',
                icon = 'fas fa-project-diagram',
                params = { event = 'sl-CyberArcade:client:HaaasibMinigames', args = { MinigameType = 'Untangle' } }
            },
            {
                header = 'Words Minigame',
                icon = 'fas fa-book',
                params = { event = 'sl-CyberArcade:client:HaaasibMinigames', args = { MinigameType = 'Words' } }
            },
            {
                header = 'Flood Minigame',
                icon = 'fas fa-water',
                params = { event = 'sl-CyberArcade:client:HaaasibMinigames', args = { MinigameType = 'Flood' } }
            },
        },
        ProjectSloth = {
            {
                header = 'Main Menu',
                txt = '(return to main dashboard)',
                icon = 'fas fa-home',
                params = { event = 'sl-CyberArcade:client:ArcadeMachineMenu' }
            },
            {
                header = 'Skillcheck Minigame',
                icon = 'fas fa-circle-notch',
                params = { event = 'sl-CyberArcade:client:ProjectSlothMinigames', args = { MinigameType = 'Circle' } }
            },
            {
                header = 'Number Maze Minigame',
                icon = 'fas fa-sort-numeric-down',
                params = { event = 'sl-CyberArcade:client:ProjectSlothMinigames', args = { MinigameType = 'Maze' } }
            },
            {
                header = 'VAR Minigame',
                icon = 'fas fa-code',
                params = { event = 'sl-CyberArcade:client:ProjectSlothMinigames', args = { MinigameType = 'Var' } }
            },
            {
                header = 'Thermite Minigame',
                icon = 'fas fa-fire-alt',
                params = { event = 'sl-CyberArcade:client:ProjectSlothMinigames', args = { MinigameType = 'Thermite' } }
            },
            {
                header = 'Scrambler Minigame',
                icon = 'fas fa-random',
                params = { event = 'sl-CyberArcade:client:ProjectSlothMinigames', args = { MinigameType = 'Scrambler' } }
            },
        },
        Utkuali = {
            {
                header = 'Main Menu',
                txt = '(return to main dashboard)',
                icon = 'fas fa-home',
                params = { event = 'sl-CyberArcade:client:ArcadeMachineMenu' }
            },
            {
                header = 'Fingerprint Minigame',
                icon = 'fas fa-fingerprint',
                params = { event = 'sl-CyberArcade:client:UtkualiMinigames', args = { MinigameType = 'Fingerprint' } }
            },
        }
    }

    return menus[menuType]
end

RegisterNetEvent('sl-CyberArcade:client:ArcadeMachineMenu', function()
    local Header = {
        {
            header = 'Arcade Games',
            txt = '(play various arcade games)',
            icon = 'fas fa-gamepad',
            isMenuHeader = true,
        },
    }

    if Config.QBCoreHacks then
        table.insert(Header, {
            header = 'Arcade: QBCore',
            icon = 'fas fa-toolbox',
            params = { event = 'sl-CyberArcade:client:ArcadeMachineMenuQBCore' }
        })
    end

    if Config.HaaasibHacks then
        table.insert(Header, {
            header = 'Arcade: Haaasib',
            icon = 'fas fa-user-secret',
            params = { event = 'sl-CyberArcade:client:ArcadeMachineMenuHaaasib' }
        })
    end

    if Config.PSHacks then
        table.insert(Header, {
            header = 'Arcade: PS',
            icon = 'fas fa-puzzle-piece',
            params = { event = 'sl-CyberArcade:client:ArcadeMachineMenuProjectSloth' }
        })
    end

    if Config.Utkuali then
        table.insert(Header, {
            header = 'Arcade: Utkuali',
            icon = 'fas fa-code-branch',
            params = { event = 'sl-CyberArcade:client:ArcadeMachineMenuUtkuali' }
        })
    end

    exports['qb-menu']:openMenu(Header)
end)

RegisterNetEvent('sl-CyberArcade:client:ArcadeMachineMenuQBCore', function()
    exports['qb-menu']:openMenu(GenerateMenu('QBCore'))
end)

RegisterNetEvent('sl-CyberArcade:client:ArcadeMachineMenuHaaasib', function()
    exports['qb-menu']:openMenu(GenerateMenu('Haaasib'))
end)

RegisterNetEvent('sl-CyberArcade:client:ArcadeMachineMenuProjectSloth', function()
    exports['qb-menu']:openMenu(GenerateMenu('ProjectSloth'))
end)

RegisterNetEvent('sl-CyberArcade:client:ArcadeMachineMenuUtkuali', function()
    exports['qb-menu']:openMenu(GenerateMenu('Utkuali'))
end)