PowerUp = Class{}

function PowerUp:init(x, y, skin)
    self.x = x
    self.y = y

    self.width = 16
    self.height = 16

    -- for two balls on screen set to 7
    self.skin = skin

    self.dy = 20
end

function PowerUp:update(dt)
    self.y = self.y + self.dy * dt
end

function PowerUp:render()
    love.graphics.draw(gTextures['main'], gFrames['powers'][self.skin],
        self.x, self.y)
end

