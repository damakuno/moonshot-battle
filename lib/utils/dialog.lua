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
        charaAnime = anime,
        selectedChara = "left",
        charaBuffer = {},
        callback = {},
        callbackFlag = {}
    }

    object.charaBuffer[anime.dialogPosition] = anime
    object.selectedChara = anime.dialogPosition

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
    local window_width = love.graphics.getWidth()

    if self.selectedChara == "right" then
        love.graphics.printf(self.charaBuffer["right"].name, self.font, self.x, self.y - 30, self.limit, "right")
        love.graphics.setColor(100 / 255, 100 / 255, 100 / 255, 0.8)
    end

    if self.charaBuffer["left"] ~= nil then
        self.charaBuffer["left"]:draw(self.x, self.y - self.charaBuffer["left"].height - 40, 0)
    end

    if self.selectedChara == "left" then
        love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 1)
        if self.charaBuffer["left"] ~= nil then
            love.graphics.printf(self.charaBuffer["left"].name, self.font, self.x, self.y - 30, self.limit, "left")
        end
        love.graphics.setColor(100 / 255, 100 / 255, 100 / 255, 0.8)
    end

    if self.charaBuffer["right"] ~= nil then
        if self.selectedChara == "right" then
            love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 1)
        end
        self.charaBuffer["right"]:draw(window_width - self.charaBuffer["right"].width - self.x,
            self.y - self.charaBuffer["right"].height - 40, 0)
    end
    local x_offset = 0
    local limit_offset = 0
    love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 1)
    love.graphics.printf(self.display_text, self.font, self.x, self.y, self.limit, self.align)
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
      
        local pitches = {
            [1] = 0.96,
            [2] = 0.98,
            [3] = 1.00,
            [4] = 1.02,
            [5] = 1.04
        }
        srcBlip:setPitch(pitches[randomInt(1, 5)])
        srcBlip:setVolume(0.1)
        srcBlip:play()

        if string.sub(self.display_text, -1) == " " then
            srcBlip:stop()
        end
    end

    if self.str_index == #text then
        if self.callback["textend"] ~= nil then
            if self.callbackFlag["textend"] == false then
                self.callback["textend"](self)
                self.callbackFlag["textend"] = true
            end
        end
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
        -- Add anime to buffer, based on position. If it exists, set it to that
        self.charaBuffer[self.charaAnime.dialogPosition] = self.charaAnime
        self.selectedChara = self.charaAnime.dialogPosition
        if self.callbackFlag["textend"] ~= nil then
            self.callbackFlag["textend"] = false
        end
        self.charaAnime:start()
        -- print(self.selectedChara)
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

function Dialog:registerCallback(event, callback)
    self.callback[event] = callback
    self.callbackFlag[event] = false
end

function randomInt(start, length)
    return math.floor(math.random() * length + start)
end

return Dialog
