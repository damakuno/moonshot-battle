local Keybind = require "lib.utils.keybind"

function love.load()

    font = love.graphics.newFont("res/fonts/lucon.ttf", 12)

    keybind = Keybind:new()
end