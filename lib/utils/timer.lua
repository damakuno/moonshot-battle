local Timer = {}

function Timer:new(ticks, callback, object)
    object = object or {
        callback = callback,
        ticks = ticks or 1,
        counter = 0,
        enabled = false
    }
    setmetatable(object, self)
    self.__index = self
    return object
end

function Timer:update(dt, ...)
    local args = {...}
    if self.enabled == true then
        self.counter = self.counter + dt
        if self.counter >= self.ticks then
            self.counter = 0
            self.callback(self.ticks, args)
        end
    end
end

function Timer:addEvent(ticks, callback)
    self.ticks = ticks
    self.callback = callback
end

function Timer:start()
    self.enabled = true
end

function Timer:stop()
    self.enabled = false
    self.counter = 0
end

return Timer
