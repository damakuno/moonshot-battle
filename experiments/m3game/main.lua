local Keybind = require "lib.utils.keybind"
local Anime = require "lib.utils.anime"

function love.load()
    deltaTime = 0
    font = love.graphics.newFont("res/fonts/lucon.ttf", 12)
    moons = {
        damage = Anime:new("damage", love.graphics.newImage("res/images/moonDamage.png")),
        freeze = Anime:new("freeze", love.graphics.newImage("res/images/moonFreeze.png")),
        heal = Anime:new("heal", love.graphics.newImage("res/images/moonHeal.png")),
        meter = Anime:new("meter", love.graphics.newImage("res/images/moonMeter.png")),
        shield = Anime:new("shield", love.graphics.newImage("res/images/moonShield.png"))
    }

    keybind = Keybind:new()
end

function love.draw()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    -- love.graphics.print("Screen width: "..screenWidth, font, 10, 10)
    -- love.graphics.print("Screen height: "..screenHeight, font, 10, 20)
    love.graphics.rectangle("line", 10, 10, 780 / 2, 580)
    love.graphics.rectangle("line", screenWidth / 2, 10, 780 / 2, 580)
    moons.damage:draw(20, 20, 0, 0.5, 0.5)
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
