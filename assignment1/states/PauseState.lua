PauseState = Class{__includes = BaseState}

function PauseState:enter(params)
    self.score = params.score
    self.pipePairs = params.pipePairs
    self.bird = params.bird
    self.timer = params.timer
end

function PauseState:update(dt)
    -- transition to countdown when enter/return are pressed
    if love.keyboard.wasPressed('p') then
        gStateMachine:change('play', {
            bird = self.bird,
            pipePairs = self.pipePairs,
            timer = self.timer,
            score = self.score                     
        })
    end
end

function PauseState:render()

    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end
    self.bird:render()
    
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Pause', 0, 64, VIRTUAL_WIDTH, 'center')
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press P to continue...', 0, 100, VIRTUAL_WIDTH, 'center')

end