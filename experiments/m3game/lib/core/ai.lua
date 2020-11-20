local AI = {}

function AI:new(duration, grid, object)
    object = object or {
        grid = grid,
        enabled = false,
        currentTime = 0,
        duration = duration or 1,
        cursor = {
            selectMode = false,
            x = 1,
            y = 1
        },
        chosenMove = {
            chosen = false,
            x = 1,
            y = 1
        }
    }
    setmetatable(object, self)
    self.__index = self
    return object
end

function AI:update(dt)
    if self.enabled == true then
        self.currentTime = self.currentTime + dt
        if self.currentTime >= self.duration then
            self.currentTime = self.currentTime - self.duration
            self:play()
        end
    end
end

function AI:draw(x, y, width, height)
    ox = width - x
    oy = height - y
    nx = (self.cursor.x * width) - ox
    ny = (self.cursor.y * height) - oy
    -- nx2 = ((cursor.x + 1) * width) - ox
    if self.cursor.selectMode == true then
        love.graphics.setColor(50 / 255, 255 / 255, 0 / 255, 1)
    end

    love.graphics.rectangle("line", nx, ny, width, height)
    love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 1)
end

function AI:play()
    if self.grid.enabled == false then
    local moves = self.grid:checkPossibleMoves()
    -- local firstMove = moves[1]
    local cursorMovement = {
        x = 0,
        y = 0
    }

    if self.chosenMove.chosen == false and #moves > 0 then
        self.chosenMove = self:chooseMove(moves)
        self.chosenMove.chosen = true
    end
    -- if #moves > 0 then
    --     print(
    --         "x: " .. self.cursor.x .. " y: " .. self.cursor.y .. " chosen x: " .. self.chosenMove.x .. " chosen y: " ..
    --             self.chosenMove.y .. " dir: '" .. self.chosenMove.dir .. "' match tile: " .. self.chosenMove.matches[1][3])
    -- end
    -- print("AI plays-> x:" .. firstMove.x .. " y: " .. firstMove.y .. " dir: " .. firstMove.dir)
    if self.cursor.x == self.chosenMove.x and self.cursor.y == self.chosenMove.y then
        self.grid:swap(self.chosenMove.x, self.chosenMove.y, self.chosenMove.dir)
        self.chosenMove.chosen = false
        self.cursor.selectMode = false
    else
        cursorMovement = self:cursorMovement(self.cursor.x, self.cursor.y, self.chosenMove.x, self.chosenMove.y)
        self.cursor.x = self.cursor.x + cursorMovement.x
        self.cursor.y = self.cursor.y + cursorMovement.y
        if self.cursor.x == self.chosenMove.x and self.cursor.y == self.chosenMove.y then
            self.cursor.selectMode = true
        end
    end
end
end

function AI:chooseMove(moves)
    local chosenMove = {}
    -- chosenMove = moves[1]
    -- TODO prioritize move
    -- For now, just randomize the chosen move
    local moveIndex = randomInt(1, #moves)
    chosenMove = moves[moveIndex]
    return chosenMove
end

function AI:cursorMovement(fromX, fromY, toX, toY)
    local dx = toX - fromX
    local dy = toY - fromY
    local cursorMove = {
        x = 0,
        y = 0
    }
    if dx < 0 then
        cursorMove.x = -1
    elseif dx > 0 then
        cursorMove.x = 1
    elseif dy < 0 then
        cursorMove.y = -1
    elseif dy > 0 then
        cursorMove.y = 1
    end

    return cursorMove
end

function AI:start()
    self.enabled = true
end

function AI:stop()
    self.enabled = false
end

function randomInt(start, length)
    return math.floor(math.random() * length + start)
end

return AI
