local Keybind = require "lib.utils.keybind"
local Anime = require "lib.utils.anime"
local Grid = require "lib.core.grid"

function love.load()
    cursor = {
        x = 1,
        y = 1
    }
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

    newGrid = {{0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0},
               {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}}

    grid = Grid:new(newGrid, spawnTable, moons)
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
    -- love.graphics.rectangle("line", 10, 10, 780 / 2, 580)
    -- love.graphics.rectangle("line", screenWidth / 2, 10, 780 / 2, 580)
    grid:draw(10, 60, 50, 50)

    width = 50
    height = 50
    ox = width - 10
    oy = height - 60
    nx = (cursor.x * width) - ox
    ny = (cursor.y * height) - oy
    nx2 = ((cursor.x + 1) * width) - ox
    love.graphics.rectangle("line", nx, ny, width, height)
    love.graphics.rectangle("line", nx2, ny, width, height)

    show_vars()
end

function love.update(dt)
    deltaTime = dt
    updates(dt, grid)
end

function love.keypressed(key)
    if key == keybind.UP then
        cursor.y = cursor.y - 1
    end

    if key == keybind.DOWN then
        cursor.y = cursor.y + 1
    end

    if key == keybind.LEFT then
        cursor.x = cursor.x - 1
    end

    if key == keybind.RIGHT then
        cursor.x = cursor.x + 1
    end

    if key == keybind.SPACE then
        grid:swap(cursor.x, cursor.y)
    end
end

function love.keyreleased(key)
    if key == keybind.SPACE then
    end
end

function show_vars()
    for i, row in ipairs(grid.grid) do
        local rowVals = ""
        for j, col in ipairs(row) do
            rowVals = rowVals .. grid.grid[i][j]
        end
        love.graphics.print(rowVals, font, 500, i * 10)
    end

    for i, res in ipairs(grid.matchResults) do
        love.graphics.print(moons[i].name..": "..res, font, 500, 200 + (i * 10))
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
