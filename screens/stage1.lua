local Grid = require "lib.core.grid"
local AI = require "lib.core.ai"
local Player = require "lib.core.player"
local Chara = require "lib.core.chara"

local Stage1 = {
    load = function()
        newGrid = {
            {0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0}
        }

        chara = Chara:new("huiye.chara")
        chara2 = Chara:new("change.chara")
        chara:setEnemy(chara2)
        chara2:setEnemy(chara)

        grid = Grid:new(newGrid, chara, moons)
        grid:fill()
        player1 = Player:new(grid, keybind)

        newGrid2 = {
            {0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0}
        }

        grid2 = Grid:new(newGrid2, chara2, moons)
        grid2:fill()

        chara:initCallbacks()
        chara2:initCallbacks()

        chara:registerCallback(
            "specialActivate",
            function()
                expandingCircle:show()
                expandingCircle:start(true)
            end
        )
        
        chara2:registerCallback(
            "specialActivate",
            function()
                expandingCircle2:show()
                expandingCircle2:start(true)
            end
        )

        ai = AI:new(0.4, grid2)
        ai:start()

        chara:registerCallback(
            "dead",
            function(p1, p2)
                -- TODO gameover screen
                print("Player 1 dead")
            end
        )

        chara2:registerCallback(
            "dead",
            function(p2, p1)
                print("Player 2 dead")
                nextScreen()
            end
        )
        love.graphics.setBackgroundColor(30 / 255, 30 / 255, 30 / 255)
    end,
    draw = function()
        local screenWidth = love.graphics.getWidth()
        local screenHeight = love.graphics.getHeight()

        grid:draw(10, 60, 50, 50)
        player1:draw(10, 60, 50, 50)
        grid2:draw(420, 60, 50, 50)
        ai:draw(420, 60, 50, 50)
        chara:draw(50, 10, "left")
        chara2:draw(430, 10, "right")

        expandingCircle:draw(10, 60, 0, 1, 1)
        expandingCircle2:draw(420, 60, 0, 1, 1)
    end,
    update = function(dt)
        updates(dt, grid, grid2, ai, chara, chara2, expandingCircle, expandingCircle2)
    end,
    keypressed = function(key)
        player1:keypressed(key)
    end
}

return Stage1
