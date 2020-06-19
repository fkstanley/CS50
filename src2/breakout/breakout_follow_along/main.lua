
require 'src/Dependencies'

--[[
    Run when the window is created
]]
function love.load()
    -- enables nearest neighbour filtering
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- set the random seed
    math.randomseed(os.time())

    -- set the screen title
    love.window.setTitle('Breakout')

    -- import fonts
    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
    }

    -- import images 
    gTextures = {
        ['background'] = love.graphics.newImage('graphics/background.png'),
        ['main'] = love.graphics.newImage('graphics/breakout.png'),
        ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
        ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
        ['particle'] = love.graphics.newImage('graphics/particle.png')
    }

    -- Allows us to show only part of a texture
    gFrames = {
        ['paddles'] = GenerateQuadsPaddles(gTextures['main']),
        ['balls'] = GenerateQuadsBalls(gTextures['main']),
        ['bricks'] = GenerateQuadsBricks(gTextures['main']),
        ['hearts'] = GenerateQuads(gTextures['hearts'], 10, 9)
    }

    -- setup virtual screen
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- import sounds 
    gSounds = {
        ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
        ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
        ['no-select'] = love.audio.newSource('sounds/no-select.wav', 'static'),
        ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav', 'static'),
        ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
        ['recover'] = love.audio.newSource('sounds/recover.wav', 'static'),
        ['high-score'] = love.audio.newSource('sounds/high_score.wav', 'static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),

        ['music'] = love.audio.newSource('sounds/music.wav', 'static')
    }

    -- set up state machine
    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['serve'] = function() return ServeState() end,
        ['game-over'] = function() return GameOverState() end,
        ['victory'] = function() return VictoryState() end,
        ['high-scores'] = function() return HighScoreState() end,
        ['enter-high-score'] = function() return EnterHighScoreState() end
    }
    gStateMachine:change('start', {
        highScores = loadHighScores()
    })

    -- store keys pressed
    love.keyboard.keysPressed = {}

end

--[[
    enable screen resizing
]] 
function love.resize(w, h)
    push:resize(w, h)
end

--[[
    Update the screen every dt time interval
]]
function love.update(dt)
    gStateMachine:update(dt)

    -- Reset keys pressed
    love.keyboard.keysPressed = {}
end

--[[
    Store if a key has been pressed
]]
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

--[[
    Check if a key has been pressed
]]
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

--[[
    Draw the window
]]
function love.draw()
    push:apply('start')

    -- Draw the background
    local backgroundWidth = gTextures['background']:getWidth()
    local backgroundHeight = gTextures['background']:getHeight()

    love.graphics.draw(gTextures['background'],
        0, 0,       -- start drawing at (0,0)
        0,          -- no rotation
        VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))

    -- Render the screen in the correct state
    gStateMachine:render()

    displayFPS()
    
    push:apply('end')
end

function loadHighScores()
    love.filesystem.setIdentity('breakout')
    
    -- if the file doesn't exist, create a default score list
    if not love.filesystem.getInfo('breakout.lst') then
        local scores = ''
        for i = 10, 1, -1 do
            scores = scores .. 'CTO\n'
            scores = scores .. tostring(i * 1000) .. '\n'
        end

        love.filesystem.write('breakout.lst', scores)
    end

    -- flag whether we're reading a name or not
    local name = true
    local currentName = nil
    local counter = 1

    -- initialise a blank table
    local scores = {}
    for i = 1, 10 do
        scores[i] = {
            name = nil,
            score = nil
        }
    end

    -- iterate over each line in the file, filling in names and scores
    -- convert the strings back to relevant data types
    for line in love.filesystem.lines('breakout.lst') do
        if name then
            scores[counter].name = string.sub(line, 1, 3)
        else
            scores[counter].score = tonumber(line)
            counter = counter + 1
        end

        -- flip the name flag
        name = not name
    end

    return scores
end

function renderHealth(health)
    local healthX = VIRTUAL_WIDTH - 100

    -- render remaining health
    for i = 1, health do
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][1], healthX, 4)
        healthX = healthX + 11
    end

    -- render missing health
    for i = 1, 3 - health do
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][2], healthX, 4)
        healthX = healthX + 11
    end
end

function renderScore(score)
    love.graphics.setFont(gFonts['small'])
    love.graphics.print('Score:', VIRTUAL_WIDTH - 60, 5)
    love.graphics.printf(tostring(score), VIRTUAL_WIDTH - 50, 5, 40, 'right')
end

function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end