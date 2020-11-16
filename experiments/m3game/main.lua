local Keybind = require "lib.utils.keybind"
local Anime = require "lib.utils.anime"
local Grid = require "lib.core.grid"
local AI = require "lib.core.ai"

function love.load()
    cursor = {
        selectMode = false,
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

    ai = AI:new(2, grid)
    ai:start()

    keybind = Keybind:new()

    possibleMoves = grid:checkPossibleMoves()

    -- print("possible moves")
    -- for i, move in ipairs(possibleMoves) do
    --     print("x: " .. move.x .. " y: " .. move.y .. " dir: " .. move.dir)
    --     for j, match in ipairs(move.matches) do
    --         print("\tmatches-> x: "..match[1].." y: "..match[2].." tileType: "..match[3])
    --     end
    -- end
end

function love.draw()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    -- love.graphics.print("Screen width: "..screenWidth, font, 10, 10)
    -- love.graphics.print("Screen height: "..screenHeight, font, 10, 20)
    -- love.graphics.rectangle("line", 10, 10, 780 / 2, 580)
    -- love.graphics.rectangle("line", screenWidth / 2, 10, 780 / 2, 580)
    grid:draw(10, 60, 50, 50)
    ai:draw(10, 60, 50, 50)
    width = 50
    height = 50
    ox = width - 10
    oy = height - 60
    nx = (cursor.x * width) - ox
    ny = (cursor.y * height) - oy
    -- nx2 = ((cursor.x + 1) * width) - ox
    if cursor.selectMode == true then
        love.graphics.setColor(50 / 255, 255 / 255, 0 / 255, 1)
    end

    love.graphics.rectangle("line", nx, ny, width, height)
    love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 1)
    -- love.graphics.rectangle("line", nx2, ny, width, height)

    show_vars()
end

function love.update(dt)
    deltaTime = dt
    updates(dt, grid, ai)
end

function love.keypressed(key)
    if cursor.selectMode == true then
        local invalidMove = false
        if key == keybind.UP then
            invalidMove = grid:swap(cursor.x, cursor.y, "up")
        end

        if key == keybind.DOWN then
            invalidMove = grid:swap(cursor.x, cursor.y, "down")
        end

        if key == keybind.LEFT then
            invalidMove = grid:swap(cursor.x, cursor.y, "left")
        end

        if key == keybind.RIGHT then
            invalidMove = grid:swap(cursor.x, cursor.y, "right")
        end

        if invalidMove == false then
            cursor.selectMode = false
        end
    else
        if key == keybind.UP then
            if cursor.y > 1 then
                cursor.y = cursor.y - 1
            end
        end

        if key == keybind.DOWN then
            if cursor.y < grid:getHeight() then
                cursor.y = cursor.y + 1
            end
        end

        if key == keybind.LEFT then
            if cursor.x > 1 then
                cursor.x = cursor.x - 1
            end
        end

        if key == keybind.RIGHT then
            if cursor.x < grid:getWidth() then
                cursor.x = cursor.x + 1
            end
        end
    end
    if key == keybind.SPACE then
        -- grid:swap(cursor.x, cursor.y)
        if cursor.selectMode == false then
            cursor.selectMode = true
        end
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
        love.graphics.print(moons[i].name .. ": " .. res, font, 500, 200 + (i * 10))
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
