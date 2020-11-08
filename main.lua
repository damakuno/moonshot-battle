Keybind = require "lib.utils.keybind"
Timer = require "lib.utils.timer"
Anime = require "lib.utils.anime"
Dialog = require "lib.utils.dialog"

function love.load()
    deltaTime = 0
    font = love.graphics.newFont("res/fonts/lucon.ttf", 12)
    dialog_font = love.graphics.newFont("res/fonts/lucon.ttf", 20)

    str_index = 1
    dialog_text =
        "this is some long text " ..
        "this is some long text " ..
            "this is some long text " ..
                "this is some long text " ..
                    "this is some long text " ..
                        "this is some long text " ..
                            "this is some long text " ..
                                "this is some long text " .. "this is some long text " .. "this is some long text"
    dialog_text2 =
        "some other long text " ..
        "some other long text " ..
            "some other long text " ..
                "some other long text " ..
                    "some other long text " ..
                        "some other long text " ..
                            "some other long text " ..
                                "some other long text " .. "some other long text " .. "some other long text"
    ohAnime = Anime:new(love.graphics.newImage("res/images/oldHero.png"), 16, 18, 1, 1, false, true)
    mikiAnime = Anime:new(love.graphics.newImage("res/images/KiraMikiSprite.png"), 205, 200, 1, 1, false)
    jillAnime = Anime:new(love.graphics.newImage("res/images/Jill.png"), 205, 190, 1, 1, false)

    dialog = Dialog:new(mikiAnime, dialog_text, dialog_font, 10, 500, 760, "left", 0.04)
    dialog:start()

    counter = 0
    -- This should go into game state
    velocity = {x = 0, y = 0, px = 0, py = 0}
    acceleration = {x = 0, y = 0}
    imgMoon = love.graphics.newImage("res/images/moon.png")
    imgPos = {facing_x = 1, x = 20, y = 20, px = 20, py = 20}

    timer = Timer:new(0.2, calcVelocity)
    keybind = Keybind:new()
    -- Example setting of key bindings
    -- keybind:set("UP", "w")
    love.graphics.setBackgroundColor(30 / 255, 30 / 255, 30 / 255)
end

function love.draw()
    -- love.graphics.draw(imgMoon, imgPos.x, imgPos.y)
    ohAnime:draw(imgPos.x, imgPos.y, 0, imgPos.facing_x * 4, 4, ohAnime.width / 2, 0, 0, 0)
    show_vars()
    draws(dialog)
end

function love.update(dt)
    deltaTime = dt
    updates(dt, ohAnime, timer, dialog)

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

    if key == keybind.SPACE then
        dialog:skipDialog()
        dialog:setNewDialog(dialog_text2, jillAnime)
    end
end

function show_vars()    
    love.graphics.print("dt: " .. deltaTime, font, 10, 10)
    love.graphics.print("x: " .. imgPos.x, font, 10, 20)
    love.graphics.print("y: " .. imgPos.y, font, 10, 30)
    love.graphics.print("px: " .. imgPos.px, font, 10, 40)
    love.graphics.print("py: " .. imgPos.py, font, 10, 50)
    love.graphics.print("x velocity: " .. velocity.x, font, 10, 60)
    love.graphics.print("y velocity: " .. velocity.y, font, 10, 70)
    love.graphics.print("x acceleration: " .. acceleration.x, font, 10, 80)
    love.graphics.print("y acceleration: " .. acceleration.y, font, 10, 90)
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

-- example starting and stopping animation based on timer
-- function controlAnim(ticks, counter)
--     if ohAnime.enabled then
--         ohAnime:stop()
--     else
--         ohAnime:start()
--     end
-- end
