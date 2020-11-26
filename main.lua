Keybind = require "lib.utils.keybind"
Timer = require "lib.utils.timer"
Anime = require "lib.utils.anime"
Dialog = require "lib.utils.dialog"
Moonshot = require "lib.core.moonshot"
Screens = require "screens"

function love.load()
    font = love.graphics.newFont("res/fonts/lucon.ttf", 12)
    dialog_font = love.graphics.newFont("res/fonts/lucon.ttf", 20)
end

function love.draw()

end

function love.update(dt)

end

function love.keyreleased(key)
  
end

function updates(dt, arr)
    for i, a in ipairs(arr) do
        a:update(dt)
    end
end

function draws(arr)
    for i, a in ipairs(arr) do
        a:draw()
    end
end

