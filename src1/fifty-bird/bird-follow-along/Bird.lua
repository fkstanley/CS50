Bird = Class{}

-- arbitrary value, high value implies greater gravity
local GRAVITY = 20

function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- Draw the bird in the middle of the screen
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    -- Initial velocity
    self.dy = 0
end

--[[
    Draws the bird
]]
function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then
        self.dy = - 0.25 * GRAVITY
    end

    self.y = self.y + self.dy
end