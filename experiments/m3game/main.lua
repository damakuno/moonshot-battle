local Keybind = require "lib.utils.keybind"
local Anime = require "lib.utils.anime"
local Grid = require "lib.core.grid"
local AI = require "lib.core.ai"
local Player = require "lib.core.player"
local Chara = require "lib.core.chara"

function love.load()
   
    deltaTime = 0
    font = love.graphics.newFont("res/fonts/lucon.ttf", 12)
    moons = {
        [1] = Anime:new("damage", love.graphics.newImage("res/images/moonDamage.png")),
        [2] = Anime:new("freeze", love.graphics.newImage("res/images/moonFreeze.png")),
        [3] = Anime:new("heal", love.graphics.newImage("res/images/moonHeal.png")),
        [4] = Anime:new("meter", love.graphics.newImage("res/images/moonMeter.png")),
        [5] = Anime:new("shield", love.graphics.newImage("res/images/moonShield.png"))
    }
    keybind = Keybind:new()

    newGrid = {{0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0},
               {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}}

    chara = Chara:new("huiye.chara")
    chara2 = Chara:new("change.chara")
    chara:setEnemy(chara2)
    chara2:setEnemy(chara)

    grid = Grid:new(newGrid, chara, moons)
    grid:fill()
    player1 = Player:new(grid, keybind) 

    newGrid2 = {{0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0},
                {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}}

    grid2 = Grid:new(newGrid2, chara2, moons)
    grid2:fill()

    chara:initCallbacks()
    chara2:initCallbacks()

    ai = AI:new(0.5, grid2)
    ai:start()

    chara:registerCallback("dead", function(p1, p2)
        print("Player 1 dead")
    end)

    chara2:registerCallback("dead", function(p2, p1)
        print("Player 2 dead")
    end)
end

function love.draw()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
   
    grid:draw(10, 60, 50, 50)
    player1:draw(10, 60, 50, 50)
    grid2:draw(420, 60, 50, 50)
    ai:draw(420, 60, 50, 50)
    chara:draw(50, 10, "left")
    chara2:draw(430, 10, "right")

    show_vars()
end

function love.update(dt)
    deltaTime = dt
    updates(dt, grid, grid2, ai, chara, chara2)
end

function love.keypressed(key)
    player1:keypressed(key)
end

function love.keyreleased(key)
    if key == keybind.SPACE then
    end
end

function show_vars()
    love.graphics.print("shielded: " .. (chara.shielded and "true" or "false") .. " - ".. chara:getShieldDuration(), font, 100, 470)
    love.graphics.print("shielded: " .. (chara2.shielded and "true" or "false") .. " - " .. chara2:getShieldDuration(), font, 600, 470)
    love.graphics.print("combo: " .. grid.combo, font, 100, 480)
    love.graphics.print("combo: " .. grid2.combo, font, 600, 480)
    love.graphics.print("hp: " .. chara.state.stats.hp .. "/" .. chara.state.stats.maxhp, font, 100, 490)
    love.graphics.print("hp: " .. chara2.state.stats.hp .. "/" .. chara2.state.stats.maxhp, font, 600, 490)
    love.graphics.print("meter: " .. chara.state.stats.meter .. "/" .. chara.state.stats.maxmeter, font, 100, 500)
    love.graphics.print("meter: " .. chara2.state.stats.meter .. "/" .. chara2.state.stats.maxmeter, font, 600, 500)
    for i, res in ipairs(grid.matchResults) do
        love.graphics.print(moons[i].name .. ": " .. res, font, 100, 400 + (i * 10))
    end
    for i, res in ipairs(grid.finalMatchResults) do
        love.graphics.print(moons[i].name .. ": " .. res, font, 100, 500 + (i * 10))
    end
    for i, res in ipairs(grid2.matchResults) do
        love.graphics.print(moons[i].name .. ": " .. res, font, 600, 400 + (i * 10))
    end
    for i, res in ipairs(grid2.finalMatchResults) do
        love.graphics.print(moons[i].name .. ": " .. res, font, 600, 500 + (i * 10))
    end
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
