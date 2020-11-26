local Anime = {}

function Anime:new(name, image, width, height, duration, startingSpriteNum, enabled, loop, playTillEnd, dialogPosition,
    object)
    if width == nil then
        width = image:getWidth()
    end
    if height == nil then
        height = image:getHeight()
    end

    object = object or {
        currentTime = 0,
        name = name,
        spriteSheet = image,
        width = width,
        height = height,
        duration = duration or 1,
        quads = {},
        spriteNum = startingSpriteNum or 1,
        enabled = enabled or false,
        loop = loop or false,
        playTillEnd = playTillEnd or false,
        dialogPosition = dialogPosition or "left",
        callback = {},
        callbackFlag = {},
        visible = true
    }

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(object.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    setmetatable(object, self)
    self.__index = self
    return object
end

function Anime:update(dt)
    if (self.spriteNum < #self.quads) or self.loop then
        if self.enabled == true then
            self.currentTime = self.currentTime + dt
            if self.currentTime >= self.duration then
                self.currentTime = self.currentTime - self.duration
            end
        else
            if self.playTillEnd == true then
                if not (self.spriteNum == 1) then
                    self.currentTime = self.currentTime + dt
                    if self.currentTime >= self.duration then
                        self.currentTime = self.currentTime - self.duration
                    end
                end
            end
        end
    end

    if (self.spriteNum == #self.quads) then
        if self.callback["animationEnd"] ~= nil then
            if self.callbackFlag["animationEnd"] == false then
                self.callback["animationEnd"](self)
                self.callbackFlag["animationEnd"] = true
            end
        end
    end
end

function Anime:draw(x, y, r, sx, sy, ox, oy, kx, ky)
    self.spriteNum = math.floor(self.currentTime / self.duration * #self.quads) + 1
    if self.visible == true then
        love.graphics.draw(self.spriteSheet, self.quads[self.spriteNum], x, y, r, sx, sy, ox, oy, kx, ky)
    end
end

function Anime:start()
    self.enabled = true
    if self.callback["animationEnd"] ~= nil then
        self.callbackFlag["animationEnd"] = false
    end
end

function Anime:stop()
    self.enabled = false
end

function Anime:show()
    self.visible = true
end

function Anime:hide()
    self.visible = false
end

function Anime:registerCallback(event, callback)
    self.callback[event] = callback
    self.callbackFlag[event] = false
end

return Anime
