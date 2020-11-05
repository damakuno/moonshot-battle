Keybind = require "lib.utils.keybind"
Timer = require "lib.utils.timer"
Anime = require "lib.utils.anime"

function love.load()
    -- This should go into game state
    velocity = {
        x = 0,
        y = 0,
        px = 0,
        py = 0
    }
    acceleration = {
        x = 0,
        y = 0
    }
    imgMoon = love.graphics.newImage("res/images/moon.png")
    imgPos = {
        facing_x = 1,
        x = 20,
        y = 20,
        px = 20,
        py = 20
    }

    timer = Timer:new(0.2, calcVelocity)
    keybind = Keybind:new()
    -- Example setting of key bindings
    -- keybind:set("UP", "w")
    love.graphics.setBackgroundColor(30 / 255, 30 / 255, 30 / 255)

    ohAnime = Anime:new(love.graphics.newImage("res/images/oldHero.png"), 16, 18, 1, 1, false)
end

function love.draw()
    -- love.graphics.draw(imgMoon, imgPos.x, imgPos.y)
    ohAnime:draw(imgPos.x, imgPos.y, 0, imgPos.facing_x * 4, 4, ohAnime.width / 2, 0, 0, 0)
    show_vars()
end

function love.update(dt)
    ohAnime:update(dt)
    timer:update(dt)
    if love.keyboard.isDown(keybind.UP) then
        imgPos.y = imgPos.y - 1
        ohAnime:start()
    end
    if love.keyboard.isDown(keybind.DOWN) then
        imgPos.y = imgPos.y + 1
        ohAnime:start()
    end
    if love.keyboard.isDown(keybind.LEFT) then
        imgPos.x = imgPos.x - 1        
        imgPos.facing_x = -1
        ohAnime:start()
    end
    if love.keyboard.isDown(keybind.RIGHT) then
        imgPos.x = imgPos.x + 1
        imgPos.facing_x = 1
        ohAnime:start()
    end    
end

function love.keyreleased(key)
    if key == keybind.UP then
        ohAnime:stop()
    end
    if key == keybind.DOWN then
        ohAnime:stop()
    end
    if key == keybind.LEFT then
        ohAnime:stop()
    end
    if key == keybind.RIGHT then
        ohAnime:stop()
    end
end



function show_vars()
    love.graphics.print("x: " .. imgPos.x, 10, 20)
    love.graphics.print("y: " .. imgPos.y, 10, 30)
    love.graphics.print("px: " .. imgPos.px, 10, 40)
    love.graphics.print("py: " .. imgPos.py, 10, 50)
    love.graphics.print("x velocity: " .. velocity.x, 10, 60)
    love.graphics.print("y velocity: " .. velocity.y, 10, 70)
    love.graphics.print("x acceleration: " .. acceleration.x, 10, 80)
    love.graphics.print("y acceleration: " .. acceleration.y, 10, 90)
end

function calcVelocity(ticks, counter)
    velocity.x = (imgPos.x - imgPos.px) / ticks
    velocity.y =  (imgPos.y - imgPos.py) / ticks
    imgPos.px = imgPos.x
    imgPos.py = imgPos.y
    acceleration.x = (velocity.x - velocity.px) / ticks
    acceleration.y = (velocity.y - velocity.py) / ticks
    velocity.px = velocity.x
    velocity.py = velocity.y
end

-- example starting and stopping animation based on timer
-- function controlAnim(ticks, counter)
--     if ohAnime.enabled then
--         ohAnime:stop()
--     else
--         ohAnime:start()
--     end
-- end