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
            moonshot = Moonshot:new("intro", dialog_font)
            moonshot:registerCallback(
                "storyend",
                function()
                    local f = function(t)
                        nextScreen()
                        t.enabled = false
                    end
                    local t = Timer:new(2, f)                                        
                    table.insert(globalUpdates, t)
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
                moonshot:keyreleased(key, keybind)
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
