local Dialog = {}

function Dialog:new(text, font, x, y, limit, align, ticks, increment, object)
    object = object or {
        text = text,
        font = font,
        x = x or 10,
        y = y or 500,
        limit = limit or 760,
        align = align or "left",
        str_index = 1,
        display_text = "",
        ticks = ticks or 0.3,
        increment = increment or 1,
        counter = 0
    }
    setmetatable(object, self)
    self.__index = self
    return object
end

function Dialog:update(dt)
    self.counter = self.counter + dt
    if self.counter >= self.ticks then
        self:updateDialogText()
        self.counter = self.counter - self.ticks
    end
end

function Dialog:draw()
    -- print(self.text, self.font, self.x, self.y, self.limit, self.align)
    love.graphics.printf(self.display_text, self.font, self.x, self.y, self.limit, self.align)
end

function Dialog:addIncrement(num)
    self.str_index = self.str_index + num
end

function Dialog:updateDialogText()
    local text = self.text
    if self.str_index < #text then
        self:addIncrement(self.increment)
        self.display_text = text:sub(1, self.str_index)
    end
end

return Dialog
