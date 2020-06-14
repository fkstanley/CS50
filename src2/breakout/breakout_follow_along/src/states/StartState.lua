-- Inherit from the base class
StartState = Class{__includes = BaseState}

-- Indicates if we highlight 'Start' or 'Highscores'
local highlighted = 1

--[[
    Updates the variables per dt interval
]]
function StartState:update(dt)
    -- toggle highlighted if we press up or down
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        highlighted = highlighted == 1 and 2 or 1
        gSounds['paddle-hit']:play()
    end

    -- quit the game if we press escape
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

--[[
    Draw the screen
]]
function StartState:render()
    -- title
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("BREAKOUT", 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')

    -- instructions
    love.graphics.setFont(gFonts['medium'])
    if highlighted == 1 then
        love.graphics.setColor(0.4, 1, 1, 1)
    end
    love.graphics.printf("START", 0, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, 'center')

    -- reset colour
    love.graphics.setColor(1, 1, 1, 1)

    if highlighted == 2 then
        love.graphics.setColor(0.4, 1, 1, 1)
    end
    love.graphics.printf("HIGH SCORES", 0, VIRTUAL_HEIGHT / 2 + 90, VIRTUAL_WIDTH, 'center')

    -- reset colour
    love.graphics.setColor(1, 1, 1, 1)
end