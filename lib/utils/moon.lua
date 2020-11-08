-- Parser for .moon files
local Moon = {}

function Moon:new(path, object)
    object = object or {
        path = path
        story = {}
    }

    

    setmetatable(object, self)
    self.__index = self
    return object
end

function Moon:update(dt)

end

function Moon:draw()

end

function Moon:trim(str)
    return string.gsub(str, '^%s*(.-)%s*$', '%1')
end

return Moon