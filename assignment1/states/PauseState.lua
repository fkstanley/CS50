PauseState = Class{__includes = BaseState}

function PauseState:update(dt)
    -- transition to countdown when enter/return are pressed
    if love.keyboard.wasPressed('p') then
        gStateMachine:change('play')
    end
end

function PauseState:render()
    -- simple UI code
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Pause', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press P to continue...', 0, 100, VIRTUAL_WIDTH, 'center')
end