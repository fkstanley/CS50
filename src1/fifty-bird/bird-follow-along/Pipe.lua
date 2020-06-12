Pipe = Class{}

-- Is not instantiated every time an object is made
-- Useful as we create multiple pipes
local PIPE_IMAGE = love.graphics.newImage('pipe.png')

-- Scrolling speed of the pipes
PIPE_SPEED = 60

-- global pipe variables
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

--[[
    Initialise the pipe
]]
function Pipe:init(orientation, y)
    -- spawns outside the rightside of the screen
    self.x = VIRTUAL_WIDTH
    self.y = y

    -- set the width of the pipe from the image
    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_HEIGHT
end

--[[
    Update the pipe per unit interval to move
]]
function Pipe:update(dt)

end

--[[
    Draw the pipe
]]
function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, 
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y), 
        0, 1, self.orientation == 'top' and -1 or 1)
end