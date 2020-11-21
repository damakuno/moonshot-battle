local Keybind = require "lib.utils.keybind"
local Anime = require "lib.utils.anime"
local Grid = require "lib.core.grid"
local AI = require "lib.core.ai"
local Chara = require "lib.core.chara"

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

    newGrid = {{0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0},
               {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}}

    chara = Chara:new("huiye.chara")
    chara2 = Chara:new("change.chara")
    chara:setEnemy(chara2)
    chara2:setEnemy(chara)

    grid = Grid:new(newGrid, chara, moons)
    grid:fill()
    -- grid:show()

    chara:evalMatchResults()

    newGrid2 = {{0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0},
                {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}}

    grid2 = Grid:new(newGrid2, chara2, moons)
    grid2:fill()

    chara:initCallbacks()
    chara2:initCallbacks()

    ai = AI:new(0.5, grid2)
    ai:start()

    keybind = Keybind:new()

    -- grid:registerCallback("clearedMatches", function(g, res)
    --     print("Matched:")
    --     for k, v in ipairs(res) do
    --         print("["..moons[k].name.."]: "..v)
    --     end
    --     print("combo: "..g.combo)
    -- end)

    -- possibleMoves = grid:checkPossibleMoves()

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
    grid2:draw(400, 60, 50, 50)
    ai:draw(400, 60, 50, 50)

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
    updates(dt, grid, grid2, ai, chara, chara2)
end

function love.keypressed(key)
    if cursor.selectMode == true then
        if key == keybind.SPACE then
            cursor.selectMode = not cursor.selectMode
        end
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

        if key == keybind.SPACE then
            cursor.selectMode = not cursor.selectMode
        end
    end

    if key == keybind.R then
        grid:reset()
    end
end

function love.keyreleased(key)
    if key == keybind.SPACE then
    end
end

function show_vars()
    -- for i, row in ipairs(grid.grid) do
    --     local rowVals = ""
    --     for j, col in ipairs(row) do
    --         rowVals = rowVals .. grid.grid[i][j]
    --     end
    --     love.graphics.print(rowVals, font, 500, i * 10)
    -- end
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
