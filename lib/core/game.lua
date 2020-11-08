local Game = {}

function Game:new(object)
    object = object or {}
    setmetatable(object, self)
    self.__index = self
    return object
end

function Game:update(dt) end

function Game:draw() end

return Game
