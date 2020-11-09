-- Parser for .moonshot files
local Moonshot = {}

local Keybind = require "lib.utils.keybind"
local Anime = require "lib.utils.anime"
local Dialog = require "lib.utils.dialog"
local LIP = require "lib.utils.LIP"

function Moonshot:new(path, font, object)
    object = object or {
        path = path,
        font = font,
        moonshotfile = path .. ".moonshot",
        charafile = path .. ".moonshot.chara",
        charas = {},
        charaAnimes = {},
        story = {},
        story_index = 1
    }

    assert(type(object.moonshotfile) == 'string', 'Parameter "moonshotfile" must be a string.');
    local file = assert(io.open(object.moonshotfile, 'r'), 'Error loading moonshot file : ' .. object.moonshotfile);

    for line in file:lines() do
        local k, v = line:match('(.-) (.+)$')
        if (k and v ~= nil) then
            table.insert(object.story, {
                alias = k,
                text = v
            })
        end
    end
    file:close()

    object.charas = LIP.load(object.charafile)

    for k, v in pairs(object.charas) do
        local alias = k
        local config = v
        object.charaAnimes[alias] = Anime:new(config.name, love.graphics.newImage(config.sprite), config.width,
                                        config.height, config.duration, config.startingSpriteNum, false, config.loop)
    end

    local story = object.story[object.story_index]
    local anime = object.charaAnimes[story.alias]
    object.dialog = Dialog:new(anime, story.text, object.font, 10, 500, 760, "left", 0.04)

    setmetatable(object, self)
    self.__index = self
    return object
end

function Moonshot:update(dt)
    self.dialog:update(dt)
end

function Moonshot:draw()
    self.dialog:draw()
end

function Moonshot:keyreleased(key, keybind)
    if key == keybind.SPACE then        
        local skipped = self.dialog:skipDialog()
        if self.story_index == #(self.story) then
            return true
        else
            if not (skipped) then
                if self.story_index < #(self.story) then
                    self.story_index = self.story_index + 1
                end
                local story = self.story[self.story_index]
                local anime = self.charaAnimes[story.alias]
                self.dialog:setNewDialog(story.text, anime)
            end
            return false
        end
    end
end

function Moonshot:start()
    self.dialog:start()
end

function Moonshot:reset()
    self.story = {}
    self.charas = {}
    self.charaAnimes = {}
    self.story = {}
    self.story_index = 1
end

function Moonshot:stop()
    self:reset()
    self.dialog:stop()
end

function Moonshot:setNewStory(path)
    self.moonshotfile = path .. ".moonshot"
    self.charafile = path .. ".moonshot.chara"
    self:reset()
    assert(type(self.moonshotfile) == 'string', 'Parameter "moonshotfile" must be a string.');
    local file = assert(io.open(self.moonshotfile, 'r'), 'Error loading moonshot file : ' .. self.moonshotfile);

    for line in file:lines() do
        local k, v = line:match('(.-) (.+)$')
        if (k and v ~= nil) then
            table.insert(self.story, {
                alias = k,
                text = v
            })
        end
    end
    file:close()

    self.charas = LIP.load(self.charafile)

    for k, v in pairs(self.charas) do
        local alias = k
        local config = v
        self.charaAnimes[alias] = Anime:new(config.name, love.graphics.newImage(config.sprite), config.width,
                                      config.height, config.duration, config.startingSpriteNum, false, config.loop)
    end

    local story = self.story[self.story_index]
    local anime = self.charaAnimes[story.alias]
    self.dialog = Dialog:new(anime, story.text, self.font, 10, 500, 760, "left", 0.04)
end

function Moonshot:trim(str)
    return string.gsub(str, '^%s*(.-)%s*$', '%1')
end

return Moonshot
