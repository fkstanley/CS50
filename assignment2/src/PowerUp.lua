PowerUp = Class{}

function PowerUp:init(x, y, skin)
    self.x = x
    self.y = y

    self.width = 16
    self.height = 16

    -- for two balls on screen set to 7
    self.skin = skin

    self.dy = 20

    self.hit = false
end

function PowerUp:update(dt)
    self.y = self.y + self.dy * dt
end

function PowerUp:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    self.hit = true
    gSounds['recover']:play()

    -- if the above aren't true, they're overlapping
    return true
end

function PowerUp:render()
    if not self.hit then
        love.graphics.draw(gTextures['main'], gFrames['powers'][self.skin],
        self.x, self.y)
    end 
end

