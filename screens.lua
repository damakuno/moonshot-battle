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

local Screens = {
    -- Intro
    [1] = {
        load = function()
            storyend = false
            moonshot = Moonshot:new("intro", dialog_font)
            moonshot:registerCallback(
                "storyend",
                function()
                    storyend = true
                end
            )
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
        end
    },
    -- Round 1
    [2] = Stage1
}

function nextScreen(args)
    Flow.index = Flow.index + 1
    screenArgs = args
    Screens[Flow.index].load()
end

return function()
    return Screens, Flow
end
