Brick = Class{}

-- colours to be used in particle system
paletteColors = {
    -- blue
    [1] = {
        ['r'] = 0.40,
        ['g'] = 0.61,
        ['b'] = 1
    },
    -- green
    [2] = {
        ['r'] = 0.42,
        ['g'] = 0.75,
        ['b'] = 0.18
    },
    -- red
    [3] = {
        ['r'] = 0.85,
        ['g'] = 0.34,
        ['b'] = 0.39
    },
    -- purple
    [4] = {
        ['r'] = 0.84,
        ['g'] = 0.48,
        ['b'] = 0.73
    },
    -- gold
    [5] = {
        ['r'] = 0.98,
        ['g'] = 0.95,
        ['b'] = 0.21
    }
}

function Brick:init(x, y)
    self.tier = 0
    self.color = 1

    self.x = x
    self.y = y
    self.width = 32
    self.height = 16

    -- to see if the brick should be rendered
    self.inPlay = true

    -- particle system emitted on hit
    self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)
    -- lasts between 0.5 to 1 seconds
    self.psystem:setParticleLifetime(0.5, 1)
    -- give it an acceleration of anywhere between X1,Y1 and X2,Y2 (0, 0) and (80, 80) here
    -- gives generally downward 
    self.psystem:setLinearAcceleration(-15, 0, 15, 80)
    -- spread particles 'naturally'
    self.psystem:setEmissionArea('normal', 10, 10)

end

function Brick:hit()
    -- particle system interpolates between two colours with varying alpha
    self.psystem:setColors(
        paletteColors[self.color].r,
        paletteColors[self.color].g,
        paletteColors[self.color].b,
        (55 * (self.tier + 1)) / 255,
        paletteColors[self.color].r,
        paletteColors[self.color].g,
        paletteColors[self.color].b,
        0
    )
    self.psystem:emit(64)

    gSounds['brick-hit-2']:stop()
    gSounds['brick-hit-2']:play()

    -- if we are a higher tier than base, decrement tier if at lowest colour
    -- else just go down a colour
    if self.tier > 0 then 
        if self.color == 1 then
            self.tier = self.tier - 1
            self.color = 5
        else
            self.color = self.color - 1
        end
    else
        if self.color == 1 then
            self.inPlay = false
        else
            self.color = self.color - 1
        end
    end

    -- extra layer of sound if brick is destroyed
    if not self.inPlay then
        gSounds['brick-hit-1']:stop()
        gSounds['brick-hit-1']:play()
    end
end

function Brick:update(dt)
    self.psystem:update(dt)
end

function Brick:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'],
            gFrames['bricks'][1 + ((self.color - 1) * 4) + self.tier],
            self.x,
            self.y)
    end
end

function Brick:renderParticles()
    love.graphics.draw(self.psystem, self.x + 16, self.y + 8)
end

