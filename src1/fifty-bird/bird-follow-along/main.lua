push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- 16:9 resolution
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- Import images
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

-- ground moves twice as fast as the background
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

-- The pixel at which our image begins looping
local BACKGROUND_LOOPING_POINT = 413

--[[
    Sets up the initial window
]]
function love.load()
    -- No blurriness
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Set the title for the game
    love.window.setTitle('Fifty Bird')

    -- Set up the virtual window
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
end

--[[
    Allows for resizing
]]
function love.resize(w, h)
    push:resize(w, h)
end

--[[
    Detects user input
]]
function love.keypressed(key)
    -- If we press escape then quit the game
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    -- Set up scrolling values 
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
end


--[[
    Draws our screen
]]
function love.draw()
    push:start()
    -- negative scroll values for right to left scrolling
    love.graphics.draw(background, -backgroundScroll, 0)
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    push:finish()
end