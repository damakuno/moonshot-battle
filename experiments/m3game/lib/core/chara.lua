local Chara = {}
local LIP = require "lib.utils.LIP"

function Chara:new(charaFile, object)
    object = object or {
        charaFile = charaFile,
        state = {},
        grid = {}
    }
    object.state = LIP.load(object.charaFile)
    -- print("\n")
    -- for k, v in pairs(object.state) do
    --     print(k)
    --     for p, t in pairs(v) do
    --         print("\t", p, t)
    --     end
    -- end
    math.randomseed(os.clock() * 100000000000)
    for i = 1, 3 do
        math.random()
    end

    setmetatable(object, self)
    self.__index = self
    return object
end

function Chara:update(dt)

end

function Chara:draw()

end

function Chara:getSpawnTable()
    local spawnTable = {
        [1] = self.state.spawnTable["damage"],
        [2] = self.state.spawnTable["freeze"],
        [3] = self.state.spawnTable["heal"],
        [4] = self.state.spawnTable["meter"],
        [5] = self.state.spawnTable["shield"]
    }
    return spawnTable
end

function Chara:evalMatchResults()
    for k, v in pairs(self.grid.matchResults) do
        print(k, v)
    end
end

function randomInt(start, length)
    return math.floor(math.random() * length + start)
end

return Chara
