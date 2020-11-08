local Anime = {}

function Anime:new(image, width, height, duration, startingSpriteNum, enabled, playTillEnd, object)
    object =
        object or
        {
            currentTime = 0,
            spriteSheet = image,
            width = width,
            height = height,
            duration = duration,
            quads = {},
            spriteNum = startingSpriteNum or 1,
            enabled = enabled or false,
            playTillEnd = playTillEnd or false
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

function Anime:draw(x, y, r, sx, sy, ox, oy, kx, ky)
    self.spriteNum = math.floor(self.currentTime / self.duration * #self.quads) + 1
    love.graphics.draw(self.spriteSheet, self.quads[self.spriteNum], x, y, r, sx, sy, ox, oy, kx, ky)
end

function Anime:start()
    self.enabled = true
end

function Anime:stop()
    self.enabled = false
end

return Anime
