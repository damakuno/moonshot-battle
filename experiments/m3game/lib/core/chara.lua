local Chara = {}
local LIP = require "lib.utils.LIP"
local Timer = require "lib.utils.timer"

function Chara:new(charaFile, object)
    object =
        object or
        {
            charaFile = charaFile,
            state = {},
            grid = {},
            enemy = {},
            actions = {
                --damage
                [1] = {
                    currentTime = 0,
                    duration = 0.5,
                    effectDuration = 0,
                    enabled = false
                },
                --freeze
                [2] = {
                    currentTime = 0,
                    duration = 0.5,
                    effectDuration = 1,
                    enabled = false
                },
                --heal
                [3] = {
                    currentTime = 0,
                    duration = 0.5,
                    effectDuration = 0,
                    enabled = false
                },
                --meter
                [4] = {
                    currentTime = 0,
                    duration = 0.5,
                    effectDuration = 0,
                    enabled = false
                },
                --shield
                [5] = {
                    currentTime = 0,
                    duration = 0.5,
                    effectDuration = 1,
                    enabled = false
                }
            },
            updates = {}
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
    for i, arg in ipairs(self.updates) do
        arg:update(dt)
    end
end

function Chara:draw()
end

function Chara:setEnemy(enemy)
    self.enemy = enemy
end

function Chara:initCallbacks()
    self.grid:registerCallback(
        "clearedMatches",
        function(g, res)
            print("Matched:")
            for k, v in ipairs(res) do
                print("[" .. moons[k].name .. "]: " .. v)
                if v > 0 then
                    --TODO add all actions here. Actions that affect enemy will go to enemy state.
                    local f = function()
                    end
                    local timer = Timer:new(1, f, true)
                    -- Damage
                    if k == 1 then
                        f = function(t)
                            -- print("damage function called")
                            self.enemy.state.stats.hp = self.enemy.state.stats.hp - (self.state.stats.damage * v)
                            t.enabled = false
                        end
                        timer = Timer:new(1, f, true)
                    end
                    -- Freeze
                    if k == 2 then
                        -- TODO freeze function
                        -- print("Freeze")
                        f = function(t)
                            -- TODO end freeze function
                            -- print("Freeze for: " .. t.accumulator)
                            -- set this to freeze duration
                            if t.accumulator == 2 then
                                t.enabled = false
                            -- print("Freeze End")
                            end
                        end
                        timer = Timer:new(1, f, true)
                    end
                    -- Heal
                    if k == 3 then
                        f = function(t)
                            local healto = self.state.stats.hp + (self.state.stats.heal * v)
                            if healto > self.state.stats.maxhp then
                                self.state.stats.hp = self.state.stats.maxhp
                            else
                                self.state.stats.hp = healto
                            end
                            t.enabled = false
                        end
                        timer = Timer:new(1, f, true)
                    end

                    table.insert(self.updates, timer)
                end
            end
        end
    )
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
        -- print(k, v)
    end
end

function randomInt(start, length)
    return math.floor(math.random() * length + start)
end

return Chara
