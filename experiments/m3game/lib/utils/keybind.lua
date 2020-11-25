local Keybind = {}

function Keybind:new(object)
    object = object or {
        UP = "up",
        DOWN = "down",
        LEFT = "left",
        RIGHT = "right",
        SPACE = "space",
        C = "c",
        Q = "q",
        R = "r",
        X = "x"
    }
    -- TODO
    -- Load keybind from configuration file
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
    -- TODO
    -- Save keybind to configuration file
end

return Keybind
