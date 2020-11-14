local Keybind = require "lib.utils.keybind"
local Anime = require "lib.utils.anime"
local Grid = require "lib.core.grid"

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

    spawnTable = {
        [1] = 20,
        [2] = 20,
        [3] = 20,
        [4] = 20,
        [5] = 20
    }

    newGrid = {
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},  
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0}
    }

    grid = Grid:new(newGrid, spawnTable) 
    grid:fill()
    grid:show()

    keybind = Keybind:new()

    math.randomseed(os.clock() * 100000000000)
    for i = 1, 3 do
        math.random()
    end

    
end

function love.draw()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    -- love.graphics.print("Screen width: "..screenWidth, font, 10, 10)
    -- love.graphics.print("Screen height: "..screenHeight, font, 10, 20)
    love.graphics.rectangle("line", 10, 10, 780 / 2, 580)
    love.graphics.rectangle("line", screenWidth / 2, 10, 780 / 2, 580)
    for i, row in ipairs(grid.grid) do
        for j, col in ipairs(row) do
            ox = 20
            oy = 20
            nx = (j * 50) - ox
            ny = (i * 50) - oy
            love.graphics.rectangle("line", nx, ny, 50, 50)
            moons[col]:draw(nx, ny, 0, 50 / moons[col].width, 50 / moons[col].height)
        end
    end
end

function love.update(dt)
    deltaTime = dt
end

function love.keyreleased(key)
    if key == keybind.SPACE then
        print(randomInt(0, 5))
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
