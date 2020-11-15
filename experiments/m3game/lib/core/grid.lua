local Grid = {}

function Grid:new(grid, spawnTable, tiles, object)
    object = object or {
        grid = grid,
        spawnTable = spawnTable,
        tiles = tiles,
        spawnRates = {},
        spawnRateCount = 0,
        matchResults = {
            [1] = 0,
            [2] = 0,
            [3] = 0,
            [4] = 0,
            [5] = 0
        }
    }

    math.randomseed(os.clock() * 100000000000)
    for i = 1, 3 do
        math.random()
    end

    for i, spawnRate in ipairs(object.spawnTable) do
        for j = 1, spawnRate do
            table.insert(object.spawnRates, i)
            object.spawnRateCount = object.spawnRateCount + 1
        end
    end

    setmetatable(object, self)
    self.__index = self
    return object
end

function Grid:update(dt)
end

function Grid:draw(x, y, width, height)
    for i, row in ipairs(grid.grid) do
        for j, col in ipairs(row) do
            ox = width - x
            oy = height - y
            nx = (j * width) - ox
            ny = (i * height) - oy
            -- love.graphics.rectangle("line", nx, ny, width, height)
            if self.tiles[col] ~= nil then
                self.tiles[col]:draw(nx, ny, 0, width / self.tiles[col].width, height / self.tiles[col].height)
            end
        end
    end
end

function Grid:fill()
    print("\n")
    local hasMatches = false
    repeat
        for i, row in ipairs(self.grid) do
            for j, col in ipairs(row) do
                self.grid[i][j] = self:spawnTile()
            end
        end
        m = self:checkMatch(self.grid)
        if (#m > 0) then
            hasMatches = true
        else
            hasMatches = false
        end
    until (hasMatches == false)
end

function Grid:swap(x, y)
    self.grid[y][x], self.grid[y][x + 1] = self.grid[y][x + 1], self.grid[y][x]
    self:clearMatches()
end

function Grid:show()
    for i, row in ipairs(self.grid) do
        local rowVals = ""
        for j, col in ipairs(row) do
            if self.grid[i][j] == nil then
                rowVals = rowVals .. "x"
            else
                rowVals = rowVals .. self.grid[i][j]
            end
        end
        print(rowVals)
    end
end

function Grid:checkMatch()
    -- local vMatches = {}
    -- local hMatches = {}
    local matches = {}
    local grid = self.grid
    local prevRows = {}
    local rowCounts = {}
    for i, row in ipairs(grid) do
        local prevCol = 0
        local colCount = 0
        for j, col in ipairs(row) do
            if prevRows[j] == nil then
                prevRows[j] = 0
                rowCounts[j] = 0
            end
            if col ~= prevCol then
                colCount = 1
            else
                colCount = colCount + 1
                if colCount >= 3 then
                    for h = 1, colCount do
                        local hx = j - h + 1
                        local hy = i
                        if not (self:matchExists(hx, hy, matches)) then
                            table.insert(matches, {hx, hy})
                        end
                    end
                end
            end
            prevCol = col
            -- print(col, colCount)

            if col ~= prevRows[j] then
                rowCounts[j] = 1
            else
                rowCounts[j] = rowCounts[j] + 1
                if rowCounts[j] >= 3 then
                    for k = 1, rowCounts[j] do
                        local vx = j
                        local vy = i - k + 1
                        if not (self:matchExists(vx, vy, matches)) then
                            table.insert(matches, {vx, vy})
                        end
                    end
                end
            end
            prevRows[j] = col
            -- print(col, rowCounts[j])
        end
    end
    --    return hMatches, vMatches
    return matches
end

function Grid:matchExists(x, y, matches)
    local hasMatch = false
    for i, match in ipairs(matches) do
        if x == match[1] and y == match[2] then
            hasMatch = true
        end
    end
    return hasMatch
end

function Grid:clearMatches()
    local matches = self:checkMatch()
    self.matchResults = {
        [1] = 0,
        [2] = 0,
        [3] = 0,
        [4] = 0,
        [5] = 0
    }

    for i, match in ipairs(matches) do
        -- print("Grid Before:")
        -- self:show()
        local x = match[1]
        local y = match[2]
        -- print(x, y)
        -- print("self.grid[y][x]: ", self.grid[y][x])
        if self.grid[y][x] ~= 0 then            
            self.matchResults[self.grid[y][x]] = self.matchResults[self.grid[y][x]] + 1
            self.grid[y][x] = 0
        end
    end

end

function Grid:spawnTile()
    return self.spawnRates[randomInt(1, self.spawnRateCount)]
end

function randomInt(start, length)
    return math.floor(math.random() * length + start)
end

return Grid
