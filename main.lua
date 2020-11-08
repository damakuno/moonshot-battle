Keybind = require "lib.utils.keybind"
Timer = require "lib.utils.timer"
Anime = require "lib.utils.anime"
Dialog = require "lib.utils.dialog"
Moonshot = require "lib.core.moonshot"

function love.load()
    deltaTime = 0

    font = love.graphics.newFont("res/fonts/lucon.ttf", 12)
    dialog_font = love.graphics.newFont("res/fonts/lucon.ttf", 20)

    moonshot = Moonshot:new("intro", dialog_font)
    moonshot:start()
    -- dialog_text = "Hey Jill, care to recommend me something good?"
    -- dialog_text2 = "Sure, how does a Sugar Rush sound?"
    -- mikiAnime = Anime:new("Kira Miki", love.graphics.newImage("res/images/KiraMikiSprite.png"), 205, 200, 1, 1)
    -- jillAnime = Anime:new("Jill", love.graphics.newImage("res/images/Jill.png"), 205, 190, 1, 1)

    -- dialog = Dialog:new(mikiAnime, dialog_text, dialog_font, 10, 500, 760, "left", 0.04)
    -- dialog:start()

    keybind = Keybind:new()
    -- Example setting of key bindings
    -- keybind:set("UP", "w")
    love.graphics.setBackgroundColor(30 / 255, 30 / 255, 30 / 255)
end

function love.draw()
    draws(moonshot)
    -- show_vars()
end

function love.update(dt)
    deltaTime = dt
    updates(dt, moonshot, mikiAnime, jillAnime)
end

function love.keyreleased(key)
    moonshot:keyreleased(key)
    -- if key == keybind.SPACE then
    --     dialog:skipDialog()
    --     dialog:setNewDialog(dialog_text2, jillAnime)
    -- end
end

function show_vars()
    love.graphics.print("dt: " .. deltaTime, font, 10, 10)
end

function calcVelocity(ticks, counter)
    velocity.x = (imgPos.x - imgPos.px) / ticks
    velocity.y = (imgPos.y - imgPos.py) / ticks
    imgPos.px = imgPos.x
    imgPos.py = imgPos.y
    acceleration.x = (velocity.x - velocity.px) / ticks
    acceleration.y = (velocity.y - velocity.py) / ticks
    velocity.px = velocity.x
    velocity.py = velocity.y
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
