PlayState = Class{__includes = BaseState}

--[[
    Initialises the state, creates the paddle
]]
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.ball = params.ball
    self.level = params.level
    self.highScores = params.highScores

    -- give ball random starting velocity
    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-50, -60)
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
        -- raise ball above paddle if it goes below it
        self.ball.y = self.paddle.y - 8
        self.ball.dy = -self.ball.dy

        -- edit collision code for paddle depending on where it is hit

        -- if hit on left side whilst moving left...
        if self.ball.x < self.ball.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
            self.ball.dx = -50 + (-8 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))
        -- if hit on right side whilst moving right...
        elseif self.ball.x > self.paddle.x +(self.paddle.width / 2) and self.paddle.dx > 0 then
            self.ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x))
        end

        gSounds['paddle-hit']:play()
    end

    for k, brick in pairs(self.bricks) do
        if brick.inPlay and self.ball:collides(brick) then

            self.score = self.score + (brick.tier * 200 + brick.color * 25)

            brick:hit()

            -- go to victory screen if no bricks left
            if self:checkVictory() then
                gSounds['victory']:play()

                gStateMachine:change('victory', {
                    level = self.level,
                    paddle = self.paddle,
                    health = self.health,
                    score = self.score,
                    ball = self.ball,
                    highScores = self.highScores
                })
            end

            --[[
                Collision code for bricks
            ]]
            if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x - 8
            elseif self.ball.x + 6 > brick.x + brick.width and self.ball.dx < 0 then
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x + 32
            elseif self.ball.y < brick.y then
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y - 8
            else
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y + 16
            end

            -- slightly scale to speed up game
            self.ball.dy = self.ball.dy * 1.02
            break
        end
    end

    -- If ball goes below play then decrease health and change state
    if self.ball.y >= VIRTUAL_HEIGHT then
        self.health = self.health - 1
        gSounds['hurt']:play()

        if self.health == 0 then 
            gStateMachine:change('game-over', {
                score = self.score,
                highScores = self.highScores
            })
        else
            gStateMachine:change('serve', {
                paddle = self.paddle,
                bricks = self.bricks,
                health = self.health,
                score = self.score,
                level = self.level,
                highScores = self.highScores
            })
        end
    end
    
    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end
end

-- draw the screen
function PlayState:render()
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()
    self.ball:render()

    renderScore(self.score)
    renderHealth(self.health)

    -- pause text (if the game is paused)
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()

    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end
    end
    
    return true
end