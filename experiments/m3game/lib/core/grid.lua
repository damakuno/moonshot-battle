local Grid = {}

function Grid:new(grid, chara, tiles, object)
    object =
        object or
        {
            grid = grid,
            chara = chara,
            tiles = tiles,
            freezeGrid = {},
            spawnRates = {},
            spawnRateCount = 0,
            matchResults = {
                [1] = 0,
                [2] = 0,
                [3] = 0,
                [4] = 0,
                [5] = 0
            },
            finalMatchResults = {
                [1] = 0,
                [2] = 0,
                [3] = 0,
                [4] = 0,
                [5] = 0
            },
            combo = 0,
            currentTime = 0,
            duration = 0.3,
            enabled = false,
            callback = {},
            callbackFlag = {}
        }

    math.randomseed(os.clock() * 100000000000)
    for i = 1, 3 do
        math.random()
    end

    for i, spawnRate in ipairs(object.chara:getSpawnTable()) do
        for j = 1, spawnRate do
            table.insert(object.spawnRates, i)
            object.spawnRateCount = object.spawnRateCount + 1
        end
    end
    -- circular reference to grid
    chara.grid = object

    setmetatable(object, self)
    self.__index = self
    return object
end

function Grid:update(dt)
    if self.enabled == true then
        self.currentTime = self.currentTime + dt
        if self.currentTime >= self.duration then
            self.currentTime = self.currentTime - self.duration
            if not (self:hasEmpty()) then
                self:clearMatches()
                self.combo = self.combo + 1
            end
            self:fillEmpty()
            m = self:checkMatch()

            if (not (#m > 0) and not (self:hasEmpty())) then
                self.enabled = false
                -- Callback for when all matches are cleared
                if self.callback["clearedAllMatches"] ~= nil then
                    if self.callbackFlag["clearedAllMatches"] == false then
                        local matchResultsCopy = {}
                        for k, v in ipairs(matchResults) do
                            matchResultsCopy[k] = v
                        end
                        self.callback["clearedAllMatches"](self, matchResultsCopy)
                        self.callbackFlag["clearedAllMatches"] = true
                    end
                end
                self.combo = 0                

                local possibleMoves = self:checkPossibleMoves() 
                print("possible move count: "..#possibleMoves)
                if #possibleMoves < 1 then
                    self:reset()
                end
            end
        end
    end
end

function Grid:draw(x, y, width, height)
    for i, row in ipairs(self.grid) do
        for j, col in ipairs(row) do
            ox = width - x
            oy = height - y
            nx = (j * width) - ox
            ny = (i * height) - oy
            if self.tiles[col] ~= nil then
                if self.freezeGrid[i][j] == 1 then
                    love.graphics.setColor(155 / 255, 155 / 255, 155 / 255, 0.8)
                end
                self.tiles[col]:draw(nx, ny, 0, width / self.tiles[col].width, height / self.tiles[col].height)
                love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 1)
            end
        end
    end
end

function Grid:fill()
    local hasMatches = false
    repeat
        for i, row in ipairs(self.grid) do
            for j, col in ipairs(row) do
                self.grid[i][j] = self:spawnTile()
            end
        end
        m = self:checkMatch()
    until (not (#m > 0))

    self.freezeGrid = self:copyGrid(true)
end

function Grid:reset()
    for i, row in ipairs(self.grid) do
        for j, col in ipairs(row) do
            self.grid[i][j] = 0
        end
    end
    self:fill()
end

function Grid:hasEmpty()
    local has0 = false
    for i, row in ipairs(self.grid) do
        for j, col in ipairs(row) do
            if col == 0 then
                has0 = true
            end
        end
    end
    return has0
end

function Grid:fillEmpty()
    local hasMatches = false
    for i = #(self.grid), 1, -1 do
        row = self.grid[i]
        for j, col in ipairs(row) do
            if col == 0 then
                for k = i, 1, -1 do
                    if self.grid[k - 1] == nil then
                        self.grid[k][j] = self:spawnTile()
                    elseif self.grid[k - 1][j] ~= 0 then
                        self.grid[k][j], self.grid[k - 1][j] = self.grid[k - 1][j], self.grid[k][j]
                    end
                end
            end
        end
    end
end

function Grid:swap(x, y, direction)
    local invalidMove = false
    local m = {}
    if self.enabled == false then
        if direction == "up" then
            if self.grid[y - 1] ~= nil then
                self.grid[y][x], self.grid[y - 1][x] = self.grid[y - 1][x], self.grid[y][x]
                m = self:checkMatch()
                -- print(self.chara.charaFile .. "-> grid frozen: " .. self.freezeGrid[y][x])
                if (not (#m > 0)) or (self.freezeGrid[y][x] == 1 or self.freezeGrid[y - 1][x] == 1) then
                    -- print(self.chara.charaFile .. "-> Can't move this tile!!")
                    self.grid[y][x], self.grid[y - 1][x] = self.grid[y - 1][x], self.grid[y][x]
                end
            else
                invalidMove = true
            end
        elseif direction == "down" then
            if self.grid[y + 1] ~= nil then
                self.grid[y][x], self.grid[y + 1][x] = self.grid[y + 1][x], self.grid[y][x]
                m = self:checkMatch()
                -- print(self.chara.charaFile .. "-> grid frozen: " .. self.freezeGrid[y][x])
                if (not (#m > 0)) or (self.freezeGrid[y][x] == 1 or self.freezeGrid[y + 1][x] == 1) then
                    -- print(self.chara.charaFile .. "-> Can't move this tile!!")
                    self.grid[y][x], self.grid[y + 1][x] = self.grid[y + 1][x], self.grid[y][x]
                end
            else
                invalidMove = true
            end
        elseif direction == "left" then
            if self.grid[x - 1] ~= nil then
                self.grid[y][x], self.grid[y][x - 1] = self.grid[y][x - 1], self.grid[y][x]
                m = self:checkMatch()
                -- print(self.chara.charaFile .. "-> grid frozen: " .. self.freezeGrid[y][x])
                if (not (#m > 0)) or (self.freezeGrid[y][x] == 1 or self.freezeGrid[y][x - 1] == 1) then
                    -- print(self.chara.charaFile .. "-> Can't move this tile!!")
                    self.grid[y][x], self.grid[y][x - 1] = self.grid[y][x - 1], self.grid[y][x]
                end
            else
                invalidMove = true
            end
        elseif direction == "right" then
            if self.grid[x + 1] ~= nil then
                self.grid[y][x], self.grid[y][x + 1] = self.grid[y][x + 1], self.grid[y][x]
                m = self:checkMatch()
                -- print(self.chara.charaFile .. "-> grid frozen: " .. self.freezeGrid[y][x])
                if (not (#m > 0)) or (self.freezeGrid[y][x] == 1 or self.freezeGrid[y][x + 1] == 1) then
                    -- print(self.chara.charaFile .. "-> Can't move this tile!!")
                    self.grid[y][x], self.grid[y][x + 1] = self.grid[y][x + 1], self.grid[y][x]
                end
            else
                invalidMove = true
            end
        end
        if invalidMove == false then
            self.enabled = true
            if self.callback["clearedMatches"] ~= nil then
                self.callbackFlag["clearedMatches"] = false
            end
        end
    end
    return invalidMove
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

function Grid:checkMatch(_grid)
    local matches = {}
    local grid = self.grid
    local prevRows = {}
    local rowCounts = {}

    if _grid ~= nil then
        grid = _grid
    end

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
                            table.insert(matches, {hx, hy, col})
                        end
                    end
                end
            end
            prevCol = col

            if col ~= prevRows[j] then
                rowCounts[j] = 1
            else
                rowCounts[j] = rowCounts[j] + 1
                if rowCounts[j] >= 3 then
                    for k = 1, rowCounts[j] do
                        local vx = j
                        local vy = i - k + 1
                        if not (self:matchExists(vx, vy, matches)) then
                            table.insert(matches, {vx, vy, col})
                        end
                    end
                end
            end
            prevRows[j] = col
        end
    end
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
    self.matchResults = {
        [1] = 0,
        [2] = 0,
        [3] = 0,
        [4] = 0,
        [5] = 0
    }
    local matches = self:checkMatch()
    for i, match in ipairs(matches) do
        local x = match[1]
        local y = match[2]
        if self.grid[y][x] ~= 0 then
            self.matchResults[self.grid[y][x]] = self.matchResults[self.grid[y][x]] + 1
            self.finalMatchResults[self.grid[y][x]] = self.finalMatchResults[self.grid[y][x]] + 1
            self.grid[y][x] = 0
        end
    end
    -- Callback for when matches are cleared
    if #matches > 0 then
        if self.callback["clearedMatches"] ~= nil then
            if self.callbackFlag["clearedMatches"] == false then
                local matchResultsCopy = {}
                for k, v in ipairs(self.matchResults) do
                    matchResultsCopy[k] = v
                end
                self.callback["clearedMatches"](self, matchResultsCopy)
            end
        end
    end
end

function Grid:checkPossibleMoves()
    local gridCopy = self:copyGrid()
    local moves = {}

    for i, row in ipairs(gridCopy) do
        for j, col in ipairs(row) do
            for k, tileMoves in ipairs(self:checkTileMoves(j, i, gridCopy)) do
                table.insert(moves, tileMoves)
            end
        end
    end
    return moves
end

function Grid:checkTileMoves(x, y, _grid)
    local grid = _grid
    local m = {}
    local possibleSwaps = {}
    -- Check swap "up"
    if grid[y - 1] ~= nil then
        grid[y][x], grid[y - 1][x] = grid[y - 1][x], grid[y][x]
        m = self:checkMatch(grid)
        if #m > 0 then
            table.insert(
                possibleSwaps,
                {
                    x = x,
                    y = y,
                    dir = "up",
                    matches = m
                }
            )
        end
        grid[y][x], grid[y - 1][x] = grid[y - 1][x], grid[y][x]
    end

    if grid[y + 1] ~= nil then
        grid[y][x], grid[y + 1][x] = grid[y + 1][x], grid[y][x]
        m = self:checkMatch(grid)
        if #m > 0 then
            table.insert(
                possibleSwaps,
                {
                    x = x,
                    y = y,
                    dir = "down",
                    matches = m
                }
            )
        end
        grid[y][x], grid[y + 1][x] = grid[y + 1][x], grid[y][x]
    end

    if grid[x - 1] ~= nil then
        grid[y][x], grid[y][x - 1] = grid[y][x - 1], grid[y][x]
        m = self:checkMatch(grid)
        if #m > 0 then
            table.insert(
                possibleSwaps,
                {
                    x = x,
                    y = y,
                    dir = "left",
                    matches = m
                }
            )
        end
        grid[y][x], grid[y][x - 1] = grid[y][x - 1], grid[y][x]
    end

    if grid[x + 1] ~= nil then
        grid[y][x], grid[y][x + 1] = grid[y][x + 1], grid[y][x]
        m = self:checkMatch(grid)
        if #m > 0 then
            table.insert(
                possibleSwaps,
                {
                    x = x,
                    y = y,
                    dir = "right",
                    matches = m
                }
            )
        end
        grid[y][x], grid[y][x + 1] = grid[y][x + 1], grid[y][x]
    end

    return possibleSwaps
end

function Grid:checkUnfrozenTiles()
    -- TODO check for tiles that are not frozen, 1 is frozen 0 is not.
    local unfrozenTiles = {}
    local freezeGrid = self.freezeGrid
    for i, row in ipairs(freezeGrid) do
        for j, col in ipairs(row) do
            if col == 0 then
                table.insert(
                    unfrozenTiles,
                    {
                        x = j,
                        y = i
                    }
                )
            end
        end
    end
    return unfrozenTiles
end

function Grid:getUnfrozenTiles(count)
    local unfrozenTiles = self:checkUnfrozenTiles()
    local selectedTiles = {}
    local t = {}
    -- print(#unfrozenTiles)
    if count > #unfrozenTiles then
        count = #unfrozenTiles
    end
    for i = 1, count do
        local ix = randomUniqueInt(t, 1, #unfrozenTiles)
        table.insert(selectedTiles, unfrozenTiles[ix])
        -- print("x: " .. unfrozenTiles[ix].x.." y: "..unfrozenTiles[ix].y)
    end
    return selectedTiles
end

function Grid:freezeTile(x, y)
    self.freezeGrid[y][x] = 1
end

function Grid:unfreezeTile(x, y)
    self.freezeGrid[y][x] = 0
end

function Grid:copyGrid(empty)
    local gridCopy = {}
    for i, row in ipairs(self.grid) do
        local rowCopy = {}
        for j, col in ipairs(row) do
            if empty == true then
                table.insert(rowCopy, 0)
            else
                table.insert(rowCopy, col)
            end
        end
        table.insert(gridCopy, rowCopy)
    end
    return gridCopy
end

function Grid:getWidth()
    return #(self.grid[1])
end

function Grid:getHeight()
    return #(self.grid)
end

function Grid:spawnTile()
    return self.spawnRates[randomInt(1, self.spawnRateCount)]
end

function Grid:registerCallback(event, callback)
    self.callback[event] = callback
    self.callbackFlag[event] = false
end

function randomInt(start, length)
    return math.floor(math.random() * length + start)
end

function randomUniqueInt(t, from, to) -- second, exclude duplicates
    local num = math.random(from, to)
    if t[num] then
        num = randomUniqueInt(t, from, to)
    end
    t[num] = num
    return num
end

return Grid
