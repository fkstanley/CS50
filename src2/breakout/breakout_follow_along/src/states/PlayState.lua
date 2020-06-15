PlayState = Class{__includes = BaseState}

--[[
    Initialises the state, creates the paddle
]]
function PlayState:init()
    self.paddle = Paddle()

    self.ball = Ball(1)
    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-50, -60)
    self.ball.x = VIRTUAL_WIDTH / 2 - 4
    self.ball.y = VIRTUAL_HEIGHT - 42
end

--[[
    Updates the variables per dt time interval
]]
function PlayState:update(dt)
    -- if esc is pressed, quit the game
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    -- check if the game is paused
    if self.paused then
        -- press space to exit pause state
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    -- else enter space to pause the game
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    -- call the update method in the paddle and ball class
    self.paddle:update(dt)
    self.ball:update(dt)

    if self.ball:collides(self.paddle) then
        self.ball.dy = -self.ball.dy
        gSounds['paddle-hit']:play()
    end

    
end

-- draw the screen
function PlayState:render()
    self.paddle:render()
    self.ball:render()

    -- crop and draw the paddle
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end