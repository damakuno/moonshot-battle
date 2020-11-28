Keybind = require "lib.utils.keybind"
Timer = require "lib.utils.timer"
Anime = require "lib.utils.anime"
Dialog = require "lib.utils.dialog"
Moonshot = require "lib.core.moonshot"
Screens, Flow = require "screens"()

globalUpdates = {}

function love.load()
    font = love.graphics.newFont("res/fonts/lucon.ttf", 12)
    dialog_font = love.graphics.newFont("res/fonts/lucon.ttf", 20)
    countdown_font = love.graphics.newFont("res/fonts/lucon.ttf", 40)
    keybind = Keybind:new()
    moons = {
        [1] = Anime:new("damage", love.graphics.newImage("res/images/moonDamage.png")),
        [2] = Anime:new("freeze", love.graphics.newImage("res/images/moonFreeze.png")),
        [3] = Anime:new("heal", love.graphics.newImage("res/images/moonHeal.png")),
        [4] = Anime:new("meter", love.graphics.newImage("res/images/moonMeter.png")),
        [5] = Anime:new("shield", love.graphics.newImage("res/images/moonShield.png"))
    }

    expandingCircle = Anime:new("circle", love.graphics.newImage("res/images/expandingCircle.png"), 350, 350, 0.2, 1)
    expandingCircle:hide()
    expandingCircle:registerCallback(
        "animationEnd",
        function(anime)
            anime:hide()
        end
    )    
    
    expandingCircle2 = Anime:new("circle", love.graphics.newImage("res/images/expandingCircle.png"), 350, 350, 0.2, 1)
    expandingCircle2:hide()
    expandingCircle2:registerCallback(
        "animationEnd",
        function(anime)
            anime:hide()
        end
    )

    moonshotExpandingText = Anime:new("moonshotText", love.graphics.newImage("res/images/moonshotExpandingText.png"), 800, 600, 0.5, 1)
    moonshotExpandingText:hide()

    Screens[Flow.index].load()
end

function love.draw()
    Screens[Flow.index].draw()
end

function love.update(dt)
    Screens[Flow.index].update(dt)
    for i, arg in ipairs(globalUpdates) do
        arg:update(dt)
    end
end

function love.keyreleased(key)
    if Screens[Flow.index].keyreleased ~= nil then
        Screens[Flow.index].keyreleased(key)
    end
end

function love.keypressed(key)
    if Screens[Flow.index].keypressed ~= nil then
        Screens[Flow.index].keypressed(key)
    end
end

function updates(dt, ...)
    local args = {...}
    for i, arg in ipairs(args) do
        arg:update(dt)
    end
end

function draws(...)
    local args = {...}
    for i, arg in ipairs(args) do
        arg:draw()
    end
end
