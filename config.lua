Config = {}

-- PolyZone Debug Mode --
Config.Debug = true

-- Ped Interaction & Fade in & out Distance --
Config.InteractionDistance = 2.5
Config.FadeDistance = 2.5

-- Enable or Disable various Supported Hacks --
Config.QBCoreHacks = true -- Default QBCore Hacks (https://github.com/qbcore-framework/qb-minigames)
Config.HaaasibHacks = true -- NoPixel 4.0 Hacks (https://github.com/Haaasib/skillchecks)
Config.PSHacks = true -- Project Sloth Hacks (https://github.com/Project-Sloth/ps-ui)
Config.Utkuali = true -- Fingerprint Hack (https://github.com/utkuali/Finger-Print-Hacking-Game)

-- MLO Configuration: (simply copy and paste Config.PedList.Kiiya and edit any parameters necessary)
Config.MLO = 'Kiiya'
-- Kiiya: (https://gta5-mods.com/maps/arcade-bar-interior-mlo-fivem-sp)

-- List of Ped Models & Properties --
Config.PedList = {
    Kiiya = {
        model = 's_m_y_valet_01', -- Ped Model (https://docs.fivem.net/docs/game-references/ped-models/)
        coords = vector3(-1276.3, -296.81, 35.05), -- Ped Coordinates (/vector3)
        heading = 205.7, -- Ped Heading (/heading)
        isRendered = false, -- Ped is not rendered
        icon = 'fas fa-coins', -- Icon (https://fontawesome.com/)
        label = 'Arcade Tokens', -- Third-Eye Text
        scenarios = { -- Ped Scenarios (https://pastebin.com/6mrYTdQv)
            'WORLD_HUMAN_CLIPBOARD',
            'WORLD_HUMAN_GUARD_STAND',
            'WORLD_HUMAN_JANITOR',
            'WORLD_HUMAN_TOURIST_MAP',
        },
    },
}

-- Arcade Tokens Shop --
Config.ArcadeShop = {
    { name = 'arcadetokens', amount = 500, price = 1} -- Item for purchase in the arcade shop
}

-- Cost Configuration for Special Option Minigames --
Config.Cost = {
    BaseCost = math.random(6, 12), -- Base cost  (all machines)
    difficulty = {
        easy = math.random(6, 9),
        medium = math.random(9, 12),
        hard = math.random(15, 18),
    },
    variation = {
        alphabet = math.random(3, 6),
        numeric = math.random(6, 9),
        alphanumeric = math.random(9, 12),
        greek = math.random(12, 15),
        braille = math.random(15, 18),
        runes = math.random(18, 21),
    },
    mirrored = {
        ['0'] = math.random(3, 6),
        ['1'] = math.random(6, 12),
        ['2'] = math.random(15, 18),
    },
}

-- Configuration for Randomizing Minigames --
Config.Randomize = true -- Enable or Disable
Config.RandomValues = {
    numCycles = { min = 1, max = 10 },
    numAttempts = { min = 1, max = 10 },
    blockSize = { min = 1, max = 5 },
    numKeys = { min = 1, max = 25 },
    numCorrect = { min = 1, max = 5 },
    minGrid = { min = 1, max = 3 },
    maxGrid = { min = 4, max = 6 },
    gridSize = { min = 5, max = 10 },
    gridSizeX = { min = 5, max = 10 },
    gridSizeY = { min = 5, max = 10 },
    numLocks = { min = 3, max = 12 },
    numLevels = { min = 1, max = 10 },
    numPoints = { min = 3, max = 5 },
    numCircles = { min = 2, max = 6 },
    numBlocks = { min = 3, max = 8 },
    incorrectBlocks = { min = 1, max = 5 },
    numLifes = { min = 1, max = 3 },
    solveTime = { min = 10, max = 60 }
}

-- Configuration Progress Bars --
Config.Progressbar = { -- Progress Bar Length (in seconds)
    InsertToken = {
        Length = math.random(5, 9), -- Length of Progress Bar for Inserting Tokens
    },
}

-- Arcade Machine Props --
Config.MachineProps = {
    -- Single Machines
    'vw_prop_vw_arcade_01a',
    'vw_prop_vw_arcade_02a',
    'vw_prop_vw_arcade_02b',
    'vw_prop_vw_arcade_02c',
    'vw_prop_vw_arcade_02d',
    'ch_prop_arcade_monkey_01a',
    'ch_prop_arcade_space_01a',
    'sum_prop_arcade_qub3d_01a',
    'ch_prop_arcade_wizard_01a',
    'ch_prop_arcade_degenatron_01a',
    'ch_prop_arcade_invade_01a',
    'ch_prop_arcade_penetrator_01a',
    'ch_prop_arcade_street_01a',
    'ch_prop_arcade_street_01b',
    'ch_prop_arcade_street_01c',
    'ch_prop_arcade_street_01d',
    'ch_prop_arcade_street_02b',
    'ch_prop_arcade_street_01a_off',
    'ch_prop_arcade_street_01b_off',
    'ch_prop_arcade_street_01c_off',
    'ch_prop_arcade_street_01d_off',
    -- Dual / Other Machines
    'ch_prop_arcade_love_01a',
    'ch_prop_arcade_fortune_01a',
    'ch_prop_arcade_fortune_door_01a',
    'ch_prop_arcade_gun_01a',
    'ch_prop_arcade_race_02a',
    'sum_prop_arcade_strength_01a',
    'ch_prop_arcade_race_01a',
    'ch_prop_arcade_race_01b',
    'ch_prop_arcade_race_02a',
    'ch_prop_arcade_claw_01a',
}

-- Icon and label for Arcade Machines --
Config.MachineIcon = 'fas fa-gamepad' -- Icon for Arcade Machines ((https://fontawesome.com/))
Config.Label = 'Play Machine' -- Third-Eye Text