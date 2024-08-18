-- QBCore Exports --
local QBCore = exports['qb-core']:GetCoreObject()
local InputDialog = nil

-- Helper function to add inputs to MinigameConfigs
local function addInputs(config, inputs)
    for _, input in ipairs(inputs) do
        table.insert(config.inputs, input)
    end
end

-- Calculate Cost Function --
local function TotalCost(InputDialog, ExtraCosts)
    local TotalCost = Config.Cost.BaseCost

    local CostValues = {
        'numCycles', 'numAttempts', 'blockSize', 'numKeys', 'numCorrect', 'minGrid',
        'maxGrid', 'gridSize', 'gridSizeX', 'gridSizeY', 'numLocks', 'numLevels',
        'numPoints', 'numCircles', 'numBlocks', 'incorrectBlocks', 'numLifes', 'solveTime'
    }

    -- Generate Cost Inputted by Player
    for _, value in ipairs(CostValues) do
        if InputDialog[value] then
            TotalCost = TotalCost + tonumber(InputDialog[value])
        end
    end

    -- Extra Costs (difficulty, variation, or mirrored) (Config.Cost)
    for key, CostTable in pairs(ExtraCosts) do
        if InputDialog[key] then
            TotalCost = TotalCost + (CostTable[InputDialog[key]] or 0)
        end
    end

    return TotalCost
end

-- Randomize Input Values (if selected) --
local function RandomizeInputs(config)
    local RandomInputs = {}
    for _, input in ipairs(config.inputs) do
        if input.type == 'number' then
            local randomConfig = Config.RandomValues[input.name]
            RandomInputs[input.name] = math.random(randomConfig.min, randomConfig.max)
        elseif input.type == 'radio' then
            RandomInputs[input.name] = input.options[math.random(#input.options)].value
        end
    end
    return RandomInputs
end

local function ConvertSolveTime(solveTime)
    return solveTime * 1000
end

-- Confirmation Dialog for Users to Pay --
local function ShowDialogStartMinigame(MinigameConfigs, MinigameType, MinigameExports)
    local config = MinigameConfigs[MinigameType]
    if not config then
        QBCore.Functions.Notify('Minigame invalid', 'error')
        return
    end

    -- Minigame Randomizer Input Option (Config.Randomize)
    if Config.Randomize then
        addInputs(config, {
            {
                text = 'Minigame Randomizer',
                name = 'randomizeInputs',
                type = 'select',
                options = {
                    { value = 'on', text = 'On' },
                    { value = 'off', text = 'Off' }
                },
                isRequired = true,
                default = 'off'
            }
        })
    end

    -- Show Input Dialog to User --
    InputDialog = exports['qb-input']:ShowInput(config)
    if not InputDialog then
        QBCore.Functions.Notify('Input required', 'error')
        return
    end

    -- Randomize Inputs if Option Enabled --
    if InputDialog.randomizeInputs == 'on' then
        local RandomInputs = RandomizeInputs(config)
        for key, value in pairs(RandomInputs) do
            InputDialog[key] = value
        end
    end

    -- Execute Cost Function based on Inputs --
    local cost = TotalCost(InputDialog, {
        difficulty = Config.Cost.difficulty,
        variation = Config.Cost.variation,
        mirrored = Config.Cost.mirrored
    })

    -- Show Pay Confirmation Dialog --
    local ConfirmDialog = exports['qb-input']:ShowInput({
        header = 'Minigame Confirmation',
        submitText = 'Pay',
        inputs = {
            {
                text = 'Cost: ' .. cost .. ' tokens',
                name = 'confirm',
                type = 'radio',
                options = {
                    { value = 'yes', text = 'Yes' },
                    { value = 'no', text = 'No' }
                },
                isRequired = true
            }
        }
    })

    -- Handle User Confirmation or Cancellation --
    if ConfirmDialog and ConfirmDialog.confirm == 'yes' then
        QBCore.Functions.TriggerCallback('sl-CyberArcade:server:PayTokens', function(Item)
            if Item then
                -- Progress Bar to Insert Tokens (qb-progressbar) --
                QBCore.Functions.Progressbar('inserting_tokens', 'Inserting tokens', Config.Progressbar.InsertToken.Length * 1000, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true
                }, {
                    animDict = 'anim_casino_a@amb@casino@games@arcadecabinet@maleleft',
                    anim = 'insert_coins',
                    flags = 1
                }, {}, {}, function()
                    ClearPedTasks(PlayerPedId())
                    local Minigame = MinigameExports[MinigameType]
                    if Minigame then
                        Minigame()
                    else
                        QBCore.Functions.Notify('Minigame invalid', 'error')
                    end
                end, function()
                    ClearPedTasks(PlayerPedId())
                    QBCore.Functions.Notify('Canceled', 'error')
                end)
            else
                QBCore.Functions.Notify('Tokens required', 'error')
                return
            end
        end, 'arcadetokens', cost)
    else
        QBCore.Functions.Notify('Minigame canceled', 'error')
    end
end

local function QBCoreMinigames(MinigameType)
    local MinigameConfigs = {
        KeyMinigame = {
            header = 'Minigame Configuration',
            submitText = 'Start',
            inputs = {
                { text = '# of Cycles', name = 'numCycles', type = 'number' }
            }
        },
        Lockpick = {
            header = 'Minigame Configuration',
            submitText = 'Start',
            inputs = {
                { text = '# of Attempts', name = 'numAttempts', type = 'number' }
            }
        },
        Hacking = {
            header = 'Minigame Configuration',
            submitText = 'Start',
            inputs = {
                { text = 'Code block size', name = 'blockSize', type = 'number' },
                { text = 'Seconds to Solve', name = 'solveTime', type = 'number' }
            }
        },
        Skillbar = {
            header = 'Minigame Configuration',
            submitText = 'Start',
            inputs = {
                {
                    text = 'Difficulty',
                    name = 'difficulty',
                    type = 'radio',
                    options = {
                        { value = 'easy', text = 'Easy' },
                        { value = 'medium', text = 'Medium' },
                        { value = 'hard', text = 'Hard' }
                    }
                }
            }
        }
    }

    local MinigameExports = {
        KeyMinigame = function() exports['qb-minigames']:KeyMinigame(tonumber(InputDialog.numCycles)) end,
        Lockpick = function() exports['qb-minigames']:Lockpick(tonumber(InputDialog.numAttempts)) end,
        Hacking = function() exports['qb-minigames']:Hacking(tonumber(InputDialog.blockSize), tonumber(InputDialog.solveTime)) end,
        Skillbar = function() exports['qb-minigames']:Skillbar(tonumber(InputDialog.difficulty)) end
    }

    ShowDialogStartMinigame(MinigameConfigs, MinigameType, MinigameExports)
end

local function HaaasibMinigames(MinigameType)
    local MinigameConfigs = {
        Alphabet = {
            header = 'Minigame Configuration',
            submitText = 'Start',
            inputs = {
                { text = '# of Keys', name = 'numKeys', type = 'number' },
                { text = 'Seconds to Solve', name = 'solveTime', type = 'number' }
            }
        },
        Direction = {
            header = 'Minigame Configuration',
            submitText = 'Start',
            inputs = {
                { text = '# of correct choices', name = 'numCorrect', type = 'number' },
                { text = 'Min Grid Size', name = 'minGrid', type = 'number' },
                { text = 'Max Grid Size', name = 'maxGrid', type = 'number' },
                { text = 'Seconds to Solve', name = 'solveTime', type = 'number' }
            }
        },
        Flip = {
            header = 'Minigame Configuration',
            submitText = 'Start',
            inputs = {
                { text = 'Grid Size', name = 'gridSize', type = 'number' },
                { text = 'Seconds to Solve', name = 'solveTime', type = 'number' }
            }
        },
        Lockpick = {
            header = 'Minigame Configuration',
            submitText = 'Start',
            inputs = {
                { text = '# of Locks', name = 'numLocks', type = 'number' },
                { text = '# of Levels', name = 'numLevels', type = 'number' },
                { text = 'Seconds to Solve', name = 'solveTime', type = 'number' }
            }
        },
        Same = {
            header = 'Minigame Configuration',
            submitText = 'Start',
            inputs = {
                { text = 'Grid size X', name = 'gridSizeX', type = 'number' },
                { text = 'Grid size Y', name = 'gridSizeY', type = 'number' },
                { text = 'Seconds to Solve', name = 'solveTime', type = 'number' }
            }
        },
        Untangle = {
            header = 'Minigame Configuration',
            submitText = 'Start',
            inputs = {
                { text = '# of Points', name = 'numPoints', type = 'number' },
                { text = 'Seconds to Solve', name = 'solveTime', type = 'number' }
            }
        },
        Words = {
            header = 'Minigame Configuration',
            submitText = 'Start',
            inputs = {
                { text = '# of correct choices', name = 'numCorrect', type = 'number' },
                { text = 'Seconds to Solve', name = 'solveTime', type = 'number' }
            }
        },
        Flood = {
            header = 'Minigame Configuration',
            submitText = 'Start',
            inputs = {
                { text = '# of correct choices', name = 'numCorrect', type = 'number' },
                { text = 'Grid Size', name = 'gridSize', type = 'number' },
                { text = 'Seconds to Solve', name = 'solveTime', type = 'number' }
            }
        }
    }

    local MinigameExports = {
        Alphabet = function() exports['skillchecks']:startAlphabetGame(ConvertSolveTime(tonumber(InputDialog.solveTime)), tonumber(InputDialog.numKeys)) end,
        Direction = function() exports['skillchecks']:startDirectionGame(ConvertSolveTime(tonumber(InputDialog.solveTime)), tonumber(InputDialog.numCorrect), tonumber(InputDialog.minGrid), tonumber(InputDialog.maxGrid)) end,
        Flip = function() exports['skillchecks']:startFlipGame(ConvertSolveTime(tonumber(InputDialog.solveTime)), tonumber(InputDialog.gridSize)) end,
        Lockpick = function() exports['skillchecks']:startLockpickingGame(ConvertSolveTime(tonumber(InputDialog.solveTime)), tonumber(InputDialog.numLocks), tonumber(InputDialog.numLevels)) end,
        Same = function() exports['skillchecks']:startSameGame(ConvertSolveTime(tonumber(InputDialog.solveTime)), tonumber(InputDialog.gridSizeX), tonumber(InputDialog.gridSizeY)) end,
        Untangle = function() exports['skillchecks']:startUntangleGame(ConvertSolveTime(tonumber(InputDialog.solveTime)), tonumber(InputDialog.numPoints)) end,
        Words = function() exports['skillchecks']:startWordsGame(ConvertSolveTime(tonumber(InputDialog.solveTime)), tonumber(InputDialog.numCorrect)) end,
        Flood = function() exports['skillchecks']:startFloodGame(ConvertSolveTime(tonumber(InputDialog.solveTime)), tonumber(InputDialog.numCorrect), tonumber(InputDialog.gridSize)) end
    }

    ShowDialogStartMinigame(MinigameConfigs, MinigameType, MinigameExports)
end

local function ProjectSlothMinigames(MinigameType)
    local MinigameConfigs = {
        Circle = {
            header = 'Minigame Configuration',
            submitText = 'Start',
            inputs = {
                { text = '# of Circles', name = 'numCircles', type = 'number' },
                { text = 'Seconds to Solve', name = 'solveTime', type = 'number' }
            }
        },
        Maze = {
            header = 'Minigame Configuration',
            submitText = 'Start',
            inputs = {
                { text = 'Seconds to Solve', name = 'solveTime', type = 'number' }
            }
        },
        Var = {
            header = 'Minigame Configuration',
            submitText = 'Start',
            inputs = {
                { text = '# of Blocks', name = 'numBlocks', type = 'number' },
                { text = 'Seconds to Solve', name = 'solveTime', type = 'number' }
            }
        },
        Thermite = {
            header = 'Minigame Configuration',
            submitText = 'Start',
            inputs = {
                { text = 'Grid Size', name = 'gridSize', type = 'number' },
                { text = 'Incorrect Blocks', name = 'incorrectBlocks', type = 'number' },
                { text = 'Seconds to Solve', name = 'solveTime', type = 'number' }
            }
        },
        Scrambler = {
            header = 'Minigame Configuration',
            submitText = 'Start',
            inputs = {
                { text = 'Variation', name = 'variation', type = 'radio', options = {
                    { value = 'none', text = 'None' },
                    { value = 'alphabet', text = 'Alphabet' },
                    { value = 'numeric', text = 'Numeric' },
                    { value = 'alphanumeric', text = 'Alphanumeric' },
                    { value = 'greek', text = 'Greek' },
                    { value = 'braille', text = 'Braille' },
                    { value = 'runes', text = 'Runes' }
                }},
                { text = 'Mirrored', name = 'mirrored', type = 'radio', options = {
                    { value = '0', text = 'Normal' },
                    { value = '1', text = 'Normal + Mirrored' },
                    { value = '2', text = 'Mirrored Only' }
                }},
                { text = 'Seconds to Solve', name = 'solveTime', type = 'number' }
            }
        }
    }

    local MinigameExports = {
        Circle = function()
            exports['ps-ui']:Circle(function(success)
                QBCore.Functions.Notify(success and 'Minigame successful' or 'Minigame failed', success and 'success' or 'error')
            end, tonumber(InputDialog.numCircles), tonumber(InputDialog.solveTime))
        end,
        Maze = function()
            exports['ps-ui']:Maze(function(success)
                QBCore.Functions.Notify(success and 'Minigame successful' or 'Minigame failed', success and 'success' or 'error')
            end, tonumber(InputDialog.solveTime))
        end,
        Var = function()
            exports['ps-ui']:VarHack(function(success)
                QBCore.Functions.Notify(success and 'Minigame successful' or 'Minigame failed', success and 'success' or 'error')
            end, tonumber(InputDialog.numBlocks), tonumber(InputDialog.solveTime))
        end,
        Thermite = function()
            exports['ps-ui']:Thermite(function(success)
                QBCore.Functions.Notify(success and 'Minigame successful' or 'Minigame failed', success and 'success' or 'error')
            end, tonumber(InputDialog.gridSize), tonumber(InputDialog.incorrectBlocks), tonumber(InputDialog.solveTime))
        end,
        Scrambler = function()
            exports['ps-ui']:Scrambler(function(success)
                QBCore.Functions.Notify(success and 'Minigame successful' or 'Minigame failed', success and 'success' or 'error')
            end, tonumber(InputDialog.variation), tonumber(InputDialog.solveTime), tonumber(InputDialog.mirrored))
        end
    }

    ShowDialogStartMinigame(MinigameConfigs, MinigameType, MinigameExports)
end

local function UtkualiMinigames(MinigameType)
    local MinigameConfigs = {
        Fingerprint = {
            header = 'Minigame Configuration',
            submitText = 'Start',
            inputs = {
                { text = '# of Levels', name = 'numLevels', type = 'number' },
                { text = '# of Lifes', name = 'numLifes', type = 'number' },
                { text = 'Minutes to Solve', name = 'solveTime', type = 'number' }
            }
        }
    }

    local MinigameExports = {
        Fingerprint = function()
            TriggerEvent('utk_fingerprint:Start', tonumber(InputDialog.numLevels), tonumber(InputDialog.numLifes), tonumber(InputDialog.solveTime), function(outcome)
                QBCore.Functions.Notify(outcome and 'Minigame successful' or 'Minigame failed', outcome and 'success' or 'error')
            end)
        end
    }

    ShowDialogStartMinigame(MinigameConfigs, MinigameType, MinigameExports)
end

RegisterNetEvent('sl-CyberArcade:client:QBCoreMinigames', function(data)
    QBCoreMinigames(data.MinigameType)
end)

RegisterNetEvent('sl-CyberArcade:client:HaaasibMinigames', function(data)
    HaaasibMinigames(data.MinigameType)
end)

RegisterNetEvent('sl-CyberArcade:client:ProjectSlothMinigames', function(data)
    ProjectSlothMinigames(data.MinigameType)
end)

RegisterNetEvent('sl-CyberArcade:client:UtkualiMinigames', function(data)
    UtkualiMinigames(data.MinigameType)
end)