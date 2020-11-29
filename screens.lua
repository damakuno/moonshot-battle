local Keybind = require "lib.utils.keybind"
local Timer = require "lib.utils.timer"
local Anime = require "lib.utils.anime"
local Dialog = require "lib.utils.dialog"
local Moonshot = require "lib.core.moonshot"

local Stage1 = require "screens.stage1"
local Stage2 = require "screens.stage2"
local Stage3 = require "screens.stage3"
local Stage4 = require "screens.stage4"
local Stage5 = require "screens.stage5"
local Stage6 = require "screens.stage6"

local Flow = {
    index = 1
}
local PrevFlow = {
    index = 1
}

local PrevStageIndex = 0

local screenArgs = {}

function loadStory(moonshotName)
    local story = {
        load = function()
            srcBGM1:setLooping(true)
            srcBGM1:play()
            storyend = false
            moonshot = Moonshot:new(moonshotName, dialog_font)
            moonshot:registerCallback("storyend", function()
                storyend = true
            end)
            moonshot:start()
            love.graphics.setBackgroundColor(30 / 255, 30 / 255, 30 / 255)
        end,
        draw = function()
            draws(moonshot)
        end,
        update = function(dt)
            updates(dt, moonshot)
        end,
        keyreleased = function(key)
            if key == keybind.SPACE then
                if storyend == true then
                    srcBGM1:stop()
                    nextScreen()
                else
                    moonshot:keyreleased(key, keybind)
                end
            end
            if key == keybind.S then
                srcBGM1:stop()
                nextScreen()
            end
        end
    }
    return story
end

local resetMenu = loadStory("resetMenu")
resetMenu.keyreleased = function(key)
    if key == keybind.SPACE then
        if storyend == true then
        else
            moonshot:keyreleased(key, keybind)
        end
    end
    if key == keybind.X then
        love.event.quit()
    end
    if key == keybind.R then
        srcBGM1:stop()
        Flow.index = PrevStageIndex
        Screens[Flow.index].load()
    end
    if key == keybind.S then
        srcBGM1:stop()
        Flow.index = 1
        Screens[Flow.index].load()
    end
end

local endScreen = loadStory("endScreen")
endScreen.keyreleased = function(key)
    if key == keybind.SPACE then
        if storyend == true then
        else
            moonshot:keyreleased(key, keybind)
        end
    end
    if key == keybind.X then
        love.event.quit()
    end
    if key == keybind.R then
        srcBGM1:stop()
        Flow.index = PrevStageIndex
        Screens[Flow.index].load()
    end
    if key == keybind.S then
        srcBGM1:stop()
        Flow.index = 1
        Screens[Flow.index].load()
    end
end

local Screens = {
    -- Intro
    [1] = loadStory("intro"),
    -- Round 1
    [2] = Stage1,
    -- Act 1
    [3] = loadStory("round1"),
    [4] = Stage2,
    [5] = loadStory("round2"),
    [6] = Stage3,
    [7] = loadStory("round3"),
    [8] = Stage4,
    [9] = loadStory("round4"),
    [10] = Stage5,
    [11] = loadStory("round5"),
    [12] = Stage6,
    [13] = loadStory("ending"),
    [14] = endScreen,
    [99] = loadStory("gameover"),
    -- TODO add menu/reset at index [100]
    [100] = resetMenu
}

function nextScreen(args)
    PrevFlow.index = Flow.index
    Flow.index = Flow.index + 1
    if args ~= nil then
        if args.gameover ~= nil then
            if args.gameover == true then
                Flow.index = 99
            end
        end
        if args.FlowIndex ~= nil then
            PrevStageIndex = args.FlowIndex
        end
    end
    screenArgs = args
    Screens[Flow.index].load()
end

return function()
    return Screens, Flow
end
