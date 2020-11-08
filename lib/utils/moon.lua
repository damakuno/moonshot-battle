-- Parser for .moonshot files
local Moonshot = {}

function Moonshot:new(path, object)
    object = object or {
        path = path,
        story = {}
    }
    setmetatable(object, self)
    self.__index = self
    return object
end

function Moonshot:update(dt)

end

function Moonshot:draw()

end

function Moonshot:trim(str)
    return string.gsub(str, '^%s*(.-)%s*$', '%1')
end

return Moonshot