Pipe = Class{}

-- Is not instantiated every time an object is made
-- Useful as we create multiple pipes
local PIPE_IMAGE = love.graphics.newImage('pipe.png')

-- Scrolling speed of the pipes
local PIPE_SCROLL = -60

--[[
    Initialise the pipe
]]
function Pipe:init()
    -- spawns outside the rightside of the screen
    self.x = VIRTUAL_WIDTH
    -- set a random height for each pipe
    self.y = math.random(VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT - 10)
    -- set the width of the pipe from the image
    self.width = PIPE_IMAGE:getWidth()
end

--[[
    Update the pipe per unit interval to move
]]
function Pipe:update(dt)
    self.x = self.x + PIPE_SCROLL * dt
end

--[[
    Draw the pipe
]]
function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, self.y)
end