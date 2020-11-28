local Grid = require "lib.core.grid"
local AI = require "lib.core.ai"
local Player = require "lib.core.player"
local Chara = require "lib.core.chara"
local Timer = require "lib.utils.timer"

local Stage1 = {
    load = function()
        roundEnd = false
        gameover = false
        winner = ""
        newGrid = {{0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0},
                   {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}}

        chara = Chara:new("huiye.chara")
        chara2 = Chara:new("change.chara")
        chara:setEnemy(chara2)
        chara2:setEnemy(chara)

        grid = Grid:new(newGrid, chara, moons)
        grid:fill()

        newGrid2 = {{0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0},
                    {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}}

        grid2 = Grid:new(newGrid2, chara2, moons)
        grid2:fill()

        chara:initCallbacks()
        chara2:initCallbacks()

        chara:registerCallback("specialActivate", function()
            expandingCircle:show()
            expandingCircle:start(true)
        end)

        chara2:registerCallback("specialActivate", function()
            expandingCircle2:show()
            expandingCircle2:start(true)
        end)

        chara:registerCallback("dead", function(p1, p2)
            -- TODO show match results first
            -- TODO gameover screen
            gameover = true
            roundEnd = true
            winner = "Player 1"
            ai:stop()
            player1:stop()
        end)

        chara2:registerCallback("dead", function(p2, p1)
            -- TODO show match results first
            -- nextScreen()
            roundEnd = true
            winner = "Player 2"
            ai:stop()
            player1:stop()
        end)

        countdown = 3
        drawCountdown = true

        player1 = Player:new(grid, keybind)
        ai = AI:new(0.4, grid2)
        local fcd = function(t)
            countdown = countdown - 1
            if countdown == 0 then
                t.enabled = false
                drawCountdown = false
                ai:start()
                player1:start()
                moonshotExpandingText:show()
                moonshotExpandingText:start()
            end
        end
        countdownTimer = Timer:new(1, fcd)
        love.graphics.setBackgroundColor(30 / 255, 30 / 255, 30 / 255)
    end,
    draw = function()
        local screenWidth = love.graphics.getWidth()
        local screenHeight = love.graphics.getHeight()

        if drawCountdown == true then
            love.graphics.print(countdown, countdown_font, 380, 250)
        end
        grid:draw(10, 100, 50, 50)
        player1:draw(10, 100, 50, 50)
        grid2:draw(420, 100, 50, 50)
        ai:draw(420, 100, 50, 50)
        chara:draw(50, 10, "left")
        chara2:draw(430, 10, "right")

        expandingCircle:draw(10, 60, 0, 1, 1)
        expandingCircle2:draw(420, 60, 0, 1, 1)

        moonshotExpandingText:draw(0, 0, 0, 1, 1)

        show_vars()
        if roundEnd == true then
            love.graphics.setColor(155 / 255, 155 / 255, 155 / 255, 0.5)
            love.graphics.rectangle("fill", 0, 0, 800, 600)
            love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 1)
            love.graphics.print(winner .. " wins!!", countdown_font, 220, 250)
        end

    end,
    update = function(dt)
        updates(dt, grid, grid2, ai, chara, chara2, expandingCircle, expandingCircle2, countdownTimer,
            moonshotExpandingText)
    end,
    keypressed = function(key)
        if roundEnd == true then
            if key == keybind.SPACE then
                nextScreen({
                    gameover = gameover
                })
            end
        else
            player1:keypressed(key)
        end
    end
}

function show_vars()
    -- love.graphics.print("special active: " .. (chara.specialActive and "true" or "false") .. " - ".. chara:getSpecialDuration(), font, 100, 460)
    -- love.graphics.print("special active: " .. (chara2.specialActive and "true" or "false") .. " - " .. chara2:getSpecialDuration(), font, 600, 460)
    love.graphics.print("shielded: " .. (chara.shielded and "true" or "false") .. " - " .. chara:getShieldDuration(),
        font, 100, 470)
    love.graphics.print("shielded: " .. (chara2.shielded and "true" or "false") .. " - " .. chara2:getShieldDuration(),
        font, 600, 470)
    love.graphics.print("combo: " .. grid.combo, font, 100, 480)
    love.graphics.print("combo: " .. grid2.combo, font, 600, 480)
    love.graphics.print("hp: " .. chara.state.stats.hp .. "/" .. chara.state.stats.maxhp, font, 100, 490)
    love.graphics.print("hp: " .. chara2.state.stats.hp .. "/" .. chara2.state.stats.maxhp, font, 600, 490)
    love.graphics.print("meter: " .. chara.state.stats.meter .. "/" .. chara.state.stats.maxmeter, font, 100, 500)
    love.graphics.print("meter: " .. chara2.state.stats.meter .. "/" .. chara2.state.stats.maxmeter, font, 600, 500)
    -- for i, res in ipairs(grid.matchResults) do
    --     love.graphics.print(moons[i].name .. ": " .. res, font, 100, 400 + (i * 10))
    -- end
    for i, res in ipairs(grid.finalMatchResults) do
        love.graphics.print(moons[i].name .. ": " .. res, font, 100, 500 + (i * 10))
    end
    -- for i, res in ipairs(grid2.matchResults) do
    --     love.graphics.print(moons[i].name .. ": " .. res, font, 600, 400 + (i * 10))
    -- end
    for i, res in ipairs(grid2.finalMatchResults) do
        love.graphics.print(moons[i].name .. ": " .. res, font, 600, 500 + (i * 10))
    end
end

return Stage1
