local Keybind = require "lib.utils.keybind"
local Timer = require "lib.utils.timer"
local Anime = require "lib.utils.anime"
local Dialog = require "lib.utils.dialog"
local Moonshot = require "lib.core.moonshot"

local Stage1 = require "screens.stage1"

local Flow = {
    index = 1
}

local screenArgs = {}

function loadStory(moonshotName)
    local story = {
        load = function()
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
                    nextScreen()
                else
                    moonshot:keyreleased(key, keybind)
                end
            end
            if key == keybind.S then
                nextScreen()
            end
        end
    }

    return story
end

local Screens = {
    -- Intro
    [1] = loadStory("intro"),
    -- Round 1
    [2] = Stage1,
    -- Act 1
    [3] = loadStory("round1"),
    [99] = loadStory("gameover")
    -- TODO add menu/reset at index [100]
}

function nextScreen(args)
    Flow.index = Flow.index + 1
    if args ~= nil then
        if args.gameover ~= nil then
            if args.gameover == true then
                Flow.index = 99
            end
        end
    end
    screenArgs = args
    Screens[Flow.index].load()
end

return function()
    return Screens, Flow
end
