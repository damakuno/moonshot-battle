Keybind = require "lib/utils/keybind"

function love.load()
    counter = 0
    -- This should go into game state
    deltaTime = 0
    imgMoon = love.graphics.newImage("res/images/moon.png")
    imgPos = {
        x = 20,
        y = 20
    }
    -- load key bindings from configuration file
    keybind = Keybind:new()
    -- Example setting of key bindings
    -- keybind:set("UP", "w")
    love.graphics.setBackgroundColor(30/255,30/255,30/255)
end

function love.draw()
    love.graphics.draw(imgMoon, imgPos.x, imgPos.y)
    love.graphics.print(counter, 10, 10)
end

function love.update(dt)
    deltaTime = dt
    counter = counter + dt
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