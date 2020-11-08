local Dialog = {}

local Anime = require "lib.utils.anime"

function Dialog:new(anime, text, font, x, y, limit, align, ticks, increment, object)
    object = object or {
        text = text,
        font = font,
        x = x or 10,
        y = y or 500,
        limit = limit or 760,
        align = align or "left",
        ticks = ticks or 0.3,
        increment = increment or 1,
        enabled = false,
        counter = 0,
        str_index = 1,
        display_text = "",
        displaying = true,
        charaAnime = anime
    }

    setmetatable(object, self)
    self.__index = self
    return object
end

function Dialog:update(dt)
    if self.enabled == true then
        self.counter = self.counter + dt
        if self.counter >= self.ticks then
            self:updateDialogText()
            self.counter = self.counter - self.ticks
        end
    end
end

function Dialog:draw()
    self.charaAnime:draw(self.x, self.y - self.charaAnime.height - 40, 0)
    love.graphics.printf(self.display_text, self.font, self.x, self.y, self.limit, self.align)
    love.graphics.printf(self.charaAnime.name, self.font, self.x, self.y - 30, self.limit, self.align)

end

function Dialog:addIncrement(num)
    self.str_index = self.str_index + num
end

function Dialog:updateDialogText()
    local text = self.text
    if self.str_index < #text then
        self.displaying = true
        self:addIncrement(self.increment)
        self.display_text = text:sub(1, self.str_index)
    end

    if self.str_index == #text then
        self.displaying = false
        self.charaAnime:stop()
    end
end

function Dialog:skipDialog()
    if (self.displaying == true) and (self.enabled == true) then
        local text = self.text
        self.str_index = #text - 1
        return true
    end
    return false
end

function Dialog:setNewDialog(text, charaAnime)
    if self.displaying == false then
        self.text = text
        self.str_index = 1
        self.displaying = true
        self.charaAnime = charaAnime or self.charaAnime
        self.charaAnime:start()
    end
end

function Dialog:start()
    self.enabled = true
    self.charaAnime:start()
end

function Dialog:stop()
    self.str_index = 1
    self.text = ""
    self.display_text = ""
    self.displaying = false
    self.enabled = false
end

return Dialog
