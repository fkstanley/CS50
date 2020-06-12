push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- 16:9 resolution
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png')
local ground = love.graphics.newImage('ground.png')

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


--[[
    Draws our screen
]]
function love.draw()
    push:start()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(ground, 0, VIRTUAL_HEIGHT - 16)
    push:finish()
end