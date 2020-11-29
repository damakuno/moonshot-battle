local Player = {}

function Player:new(grid, keybind, object)
    object = object or {
        grid = grid,
        keybind = keybind,
        cursor = {
            selectMode = false,
            x = 1,
            y = 1
        },
        enabled = false
    }
    setmetatable(object, self)
    self.__index = self
    return object
end

function Player:update(dt)
end

function Player:draw(x, y, width, height)
    width = width
    height = height
    ox = width - x
    oy = height - y
    nx = (self.cursor.x * width) - ox
    ny = (self.cursor.y * height) - oy
    if self.cursor.selectMode == true then
        love.graphics.setColor(50 / 255, 255 / 255, 0 / 255, 1)
    end

    love.graphics.rectangle("line", nx, ny, width, height)
    love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 1)
end

function Player:start()
    self.enabled = true
end

function Player:stop()
    self.enabled = false
end

function Player:keypressed(key)
    if self.enabled == true then
        if self.cursor.selectMode == true then
            if key == self.keybind.SPACE then
                self.cursor.selectMode = not self.cursor.selectMode
            end
            local invalidMove = false
            if key == self.keybind.UP then
                invalidMove = self.grid:swap(self.cursor.x, self.cursor.y, "up")
            end

            if key == self.keybind.DOWN then
                invalidMove = self.grid:swap(self.cursor.x, self.cursor.y, "down")
            end

            if key == self.keybind.LEFT then
                invalidMove = self.grid:swap(self.cursor.x, self.cursor.y, "left")
            end

            if key == self.keybind.RIGHT then
                invalidMove = self.grid:swap(self.cursor.x, self.cursor.y, "right")
            end

            if invalidMove == false then
                self.cursor.selectMode = false
            end
        else
            if key == self.keybind.UP then
                if self.cursor.y > 1 then
                    self.cursor.y = self.cursor.y - 1
                end
            end

            if key == self.keybind.DOWN then
                if self.cursor.y < self.grid:getHeight() then
                    self.cursor.y = self.cursor.y + 1
                end
            end

            if key == self.keybind.LEFT then
                if self.cursor.x > 1 then
                    self.cursor.x = self.cursor.x - 1
                end
            end

            if key == self.keybind.RIGHT then
                if self.cursor.x < self.grid:getWidth() then
                    self.cursor.x = self.cursor.x + 1
                end
            end

            if key == self.keybind.SPACE then
                self.cursor.selectMode = not self.cursor.selectMode
            end

            if key == self.keybind.S then
                self.grid.chara:specialActivate()
            end
        end

        -- if key == self.keybind.R then
        --     self.grid:reset()
        -- end
    end
end

return Player
