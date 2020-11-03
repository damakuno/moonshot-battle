local Keybind = {}

function Keybind:new(object)
    object = object or {
        UP = "up",
        DOWN = "down",
        LEFT = "left",
        RIGHT = "right"
    }    
    setmetatable(object, self)

    self.__index = self
    return object
end

function Keybind:get(keyname)
    local key
    key = self[keyname]
    return key
end

function Keybind:set(keyname, keyString)
    self[keyname] = keyString
end

return Keybind