local Keybind = require "lib.utils.keybind"

function love.load()
    deltaTime = 0
    font = love.graphics.newFont("res/fonts/lucon.ttf", 12)
    moons = {
        damage = love.graphics.newImage("res/images/moonDamage.png"),
        freeze = love.graphics.newImage("res/images/moonFreeze.png"),
        heal = love.graphics.newImage("res/images/moonHeal.png"),
        meter = love.graphics.newImage("res/images/moonMeter.png"),
        shield = love.graphics.newImage("res/images/moonShield.png")
    }

    keybind = Keybind:new()
end

function love.draw()
end

function love.update(dt)
    deltaTime = dt
end

function love.keyreleased(key)

end

function updates(dt, ...)
    local args = {...}
    for i, arg in ipairs(args) do
        arg:update(dt)
    end
end

function draws(...)
    local args = {...}
    for i, arg in ipairs(args) do
        arg:draw()
    end
end
