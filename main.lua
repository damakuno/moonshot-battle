Keybind = require "lib/utils/keybind"
Timer = require "lib/utils/timer"

function love.load()
    -- This should go into game state   
    deltaTime = 0
    velocity = {
        x = 0,
        y = 0
    }

    imgMoon = love.graphics.newImage("res/images/moon.png")
    imgPos = {
        x = 20,
        y = 20,
        px = 20,
        py = 20
    }

    timer = Timer:new(0.2, calcVelocity)
    timer:start()
    -- load key bindings from configuration file
    keybind = Keybind:new()
    -- Example setting of key bindings
    -- keybind:set("UP", "w")
    love.graphics.setBackgroundColor(30 / 255, 30 / 255, 30 / 255)
end

function love.draw()
    love.graphics.draw(imgMoon, imgPos.x, imgPos.y)
    show_vars()
end

function love.update(dt)
    timer:update(dt)
    deltaTime = dt
    if love.keyboard.isDown(keybind.UP) then
        imgPos.y = imgPos.y - 1
    end
    if love.keyboard.isDown(keybind.DOWN) then
        imgPos.y = imgPos.y + 1
    end
    if love.keyboard.isDown(keybind.LEFT) then
        imgPos.x = imgPos.x - 1
    end
    if love.keyboard.isDown(keybind.RIGHT) then
        imgPos.x = imgPos.x + 1
    end
end

function show_vars()
    love.graphics.print(deltaTime, 10, 10)
    love.graphics.print("x: " .. imgPos.x, 10, 20)
    love.graphics.print("y: " .. imgPos.y, 10, 30)
    love.graphics.print("px: " .. imgPos.px, 10, 40)
    love.graphics.print("py: " .. imgPos.py, 10, 50)
    love.graphics.print("x velocity: " .. velocity.x, 10, 60)
    love.graphics.print("y velocity: " .. velocity.y, 10, 70)
end

function calcVelocity(ticks)
    velocity.x = (imgPos.x - imgPos.px) / ticks
    velocity.y = (imgPos.y - imgPos.py) / ticks
    imgPos.px = imgPos.x
    imgPos.py = imgPos.y
end
