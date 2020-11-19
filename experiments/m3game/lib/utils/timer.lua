local Timer = {}

function Timer:new(ticks, callback, enabled, object)
    object =
        object or
        {
            id = 0,
            callback = callback,
            ticks = ticks or 1,
            counter = 0,
            accumulator = 0,
            enabled = enabled or true,
            loop = true
        }
    if loop == false then
        print("loop set to false")
        object.loop = false
    end
    setmetatable(object, self)
    self.__index = self
    return object
end

function Timer:update(dt, ...)
    local args = {...}
    if self.enabled == true then
        self.counter = self.counter + dt
        if self.counter >= self.ticks then
            self.counter = self.counter - self.ticks
            self.accumulator = self.accumulator + self.ticks
            self.callback(self, self.ticks, self.counter, args)
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
