local Chara = {}
local LIP = require "lib.utils.LIP"
local Timer = require "lib.utils.timer"

function Chara:new(charaFile, object)
    object = object or {
        charaFile = charaFile,
        state = {},
        grid = {},
        enemy = {},
        updates = {},
        shieldCurrentTime = 0,
        shieldDuration = 0,
        shielded = false,
        specialCurrentTime = 0,
        specialDuration = 0,
        specialActive = false,
        callback = {},
        callbackFlag = {},
        dead = false
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
    if self.shielded == true then
        self.shieldCurrentTime = self.shieldCurrentTime + dt
        if self.shieldCurrentTime >= self.shieldDuration then
            self.shieldCurrentTime = 0
            self.shieldDuration = 0
            self.shielded = false
        end
    end
    if self.specialActive == true then
        self.specialCurrentTime = self.specialCurrentTime + dt
        if self.specialCurrentTime >= self.specialDuration then
            self.specialCurrentTime = 0
            -- self.specialDuration = 0
            self.state.stats.meter = self.state.stats.meter - 3
            if self.state.stats.meter < 1 then
                self.specialActive = false
                self.state.stats.meter = 0
                if self.callback["specialActivate"] ~= nil then
                    self.callbackFlag["specialActivate"] = false
                end
            end
        end
    end
    for i, arg in ipairs(self.updates) do
        arg:update(dt)
    end
end

function Chara:draw(x, y, align)
    local V2P = 3
    if align == "right" then
        love.graphics.setColor(255 / 255, 0 / 255, 0 / 255, 1)
        love.graphics.rectangle("fill", x, y, self.state.stats.maxhp * V2P, 20)
        love.graphics.setColor(0 / 255, 255 / 255, 0 / 255, 1)
        love.graphics.rectangle("fill", x, y, self.state.stats.hp * V2P, 20)
        love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 1)
        love.graphics.print(self.state.stats.hp, font, x + (self.state.stats.maxhp * V2P) - 24, y + 4)
        love.graphics.setColor(255 / 255, 145 / 255, 0 / 255, 1)
        love.graphics.rectangle("fill", x, y + 20, self.state.stats.maxmeter * V2P, 20)
        love.graphics.setColor(225 / 255, 255 / 255, 105 / 255, 1)
        love.graphics.rectangle("fill", x, y + 20, self.state.stats.meter * V2P, 20)
        love.graphics.setColor(66 / 255, 75 / 255, 245 / 255, 1)
        love.graphics.rectangle("fill", x, y + 40, self.state.stats.maxshield * V2P, 20)
        love.graphics.setColor(66 / 255, 147 / 255, 245 / 255, 1)
        love.graphics.rectangle("fill", x, y + 40, self:getShieldDuration() * V2P, 20)
    end
    if align == "left" then
        love.graphics.setColor(255 / 255, 0 / 255, 0 / 255, 1)
        love.graphics.rectangle("fill", x, y, self.state.stats.maxhp * V2P, 20)
        love.graphics.setColor(0 / 255, 255 / 255, 0 / 255, 1)
        love.graphics.rectangle("fill", ((self.state.stats.maxhp - self.state.stats.hp) * V2P) + x, y,
            self.state.stats.hp * V2P, 20)
        love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 1)
        love.graphics.print(self.state.stats.hp, font, x + 4, y + 4)
        love.graphics.setColor(255 / 255, 145 / 255, 0 / 255, 1)
        local offsetx = self.state.stats.maxhp / 2 * V2P
        love.graphics.rectangle("fill", x + offsetx, y + 20, self.state.stats.maxmeter * V2P, 20)
        love.graphics.setColor(225 / 255, 255 / 255, 105 / 255, 1)
        love.graphics.rectangle("fill", ((self.state.stats.maxmeter - self.state.stats.meter) * V2P) + x + offsetx,
            y + 20, self.state.stats.meter * V2P, 20)
        love.graphics.setColor(66 / 255, 75 / 255, 245 / 255, 1)
        love.graphics.rectangle("fill", x + offsetx, y + 40, self.state.stats.maxshield * V2P, 20)
        love.graphics.setColor(66 / 255, 147 / 255, 245 / 255, 1)
        love.graphics.rectangle("fill", ((self.state.stats.maxshield - self:getShieldDuration()) * V2P) + x + offsetx, y + 40,
            self:getShieldDuration() * V2P, 20)
    end
    love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 1)
end

function Chara:setEnemy(enemy)
    self.enemy = enemy
end

function Chara:getShieldDuration()
    return math.ceil(self.shieldDuration - self.shieldCurrentTime)
end

function Chara:takeDamage(damage)
    self:fillMeter(math.ceil(damage / 2))
    -- Half the damage if shield is active
    if self.shielded == true then
        damage = math.ceil(damage / 2)
        local durationto = self.shieldDuration - damage
        if durationto < 0 then
            self.shieldDuration = 0
        else
            self.shieldDuration = self.shieldDuration - damage
        end
    end
    self.state.stats.hp = self.state.stats.hp - damage

    if self.state.stats.hp <= 0 then
        if self.enemy.dead == false then
            if self.callback["dead"] ~= nil then
                if self.callbackFlag["dead"] == false then
                    self.dead = true
                    self.callback["dead"](self, self.enemy)
                    self.callbackFlag["dead"] = true
                end
            end
        end
    end
end

function Chara:heal(points)
    local healto = self.state.stats.hp + (points)
    if healto > self.state.stats.maxhp then
        self.state.stats.hp = self.state.stats.maxhp
    else
        self.state.stats.hp = healto
    end
end

function Chara:fillMeter(meter)
    local meterto = self.state.stats.meter + meter
    if self.specialActive == false then
        if meterto > self.state.stats.maxmeter then
            self.state.stats.meter = self.state.stats.maxmeter
        else
            self.state.stats.meter = meterto
        end
    end
end

function Chara:fillShield(duration)
    local shieldto = self.shieldDuration + duration
    if shieldto > self.state.stats.maxshield then
        self.shieldDuration = self.state.stats.maxshield
    else
        self.shieldDuration = shieldto
    end
end

function Chara:specialActivate()
    if self.state.stats.meter >= self.state.stats.maxmeter then
        -- self.state.stats.meter = 0
        self.specialActive = true
        self.specialDuration = 1 -- self.specialDuration + self.state.stats.special
        if self.callback["specialActivate"] ~= nil then
            if self.callbackFlag["specialActivate"] == false then
                self.callback["specialActivate"](self)
                self.callbackFlag["specialActivate"] = true
            end
        end
    end
end

-- function Chara:getSpecialDuration()
--     return math.ceil(self.specialDuration - self.specialCurrentTime)
-- end

function Chara:initCallbacks()
    if self.callback["dead"] ~= nil then
        self.callbackFlag["dead"] = false
    end

    if self.callback["specialActivate"] ~= nil then
        self.callbackFlag["specialActivate"] = false
    end

    self.grid:registerCallback("clearedMatches", function(g, res)
        -- print("Matched:")
        for k, v in ipairs(res) do
            -- print("[" .. moons[k].name .. "]: " .. v)
            if v > 0 then
                local specialMultiplier = 1
                if self.specialActive then
                    specialMultiplier = 2
                else
                    specialMultiplier = 1
                end
                local f = function()
                end
                local timer = Timer:new(1, f, true)
                -- Damage
                if k == 1 then
                    f = function(t)
                        self.enemy:takeDamage(self.state.stats.damage * v * specialMultiplier)
                        t.enabled = false
                    end
                    timer = Timer:new(1, f, true)
                end
                -- Freeze
                if k == 2 then
                    -- TODO freeze function
                    local tilesToFreeze = self.enemy.grid:getUnfrozenTiles(v * specialMultiplier)
                    for k, tile in ipairs(tilesToFreeze) do
                        -- print("freeze " .. self.enemy.charaFile .. " for x: " .. tile.x .. " y: " .. tile.y)
                        self.enemy.grid:freezeTile(tile.x, tile.y)
                    end
                    f = function(t)
                        -- TODO end freeze function
                        -- set this to freeze duration
                        if t.accumulator == self.state.stats.freeze then
                            for k, tile in ipairs(tilesToFreeze) do
                                self.enemy.grid:unfreezeTile(tile.x, tile.y)
                            end
                            t.enabled = false
                        end
                    end
                    timer = Timer:new(1, f, true)
                end
                -- Heal
                if k == 3 then
                    f = function(t)
                        self:heal(self.state.stats.heal * v * specialMultiplier)
                        t.enabled = false
                    end
                    timer = Timer:new(0.2, f, true)
                end
                -- Meter
                if k == 4 then
                    f = function(t)
                        self:fillMeter(v)
                        t.enabled = false
                    end
                    timer = Timer:new(0.2, f, true)
                end
                -- shield
                if k == 5 then
                    -- self.shieldDuration = self.shieldDuration + (self.state.stats.shield * v * specialMultiplier)
                    self:fillShield(v * specialMultiplier)
                    if self.shielded == false then
                        self.shielded = true
                    end
                end
                table.insert(self.updates, timer)
            end
        end
    end)
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

function Chara:registerCallback(event, callback)
    self.callback[event] = callback
    self.callbackFlag[event] = false
end

function randomInt(start, length)
    return math.floor(math.random() * length + start)
end

return Chara
