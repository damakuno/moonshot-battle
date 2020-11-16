local AI = {}

function AI:new(duration, grid, object)
    object = object or {
        grid = grid,
        enabled = false,
        currentTime = 0,
        duration = duration or 2,
        cursor = {
            selectMode = false,
            x = 1,
            y = 1
        },
        chosenMove = {}
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
    print(self.grid)
    local moves = self.grid:checkPossibleMoves()
    local firstMove = moves[1]
    if #firstMove == 0 then
        self.chosenMove = firstMove
    end
    -- print("AI plays-> x:" .. firstMove.x .. " y: " .. firstMove.y .. " dir: " .. firstMove.dir)
    if cursor.x == self.chosenMove.x and cursor.y == self.chosenMove.y then
        self.cursor.selectMode = true
        self.grid:swap(self.chosenMove.x, self.chosenMove.y, self.chosenMove.dir)
        self.chosenMove = {}
    else 
       self.cursor.selectMode = false 
    end
end

function AI:start()
    self.enabled = true
end

function AI:stop()
    self.enabled = false
end

return AI
