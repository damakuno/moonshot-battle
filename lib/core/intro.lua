local Intro = {}

function Intro:new(object)
    object = object or {
        
    }
    setmetatable(object, self)
    self.__index = self
    return object
end

function Intro:update(dt)

end

function Intro:draw()

end

return Intro