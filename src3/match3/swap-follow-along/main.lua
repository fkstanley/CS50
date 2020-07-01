push = require 'push'

require 'Util'

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

function love.load()
    -- sprite sheet of the tiles
    tileSprite = love.graphics.newImage('match3.png')

    -- individual tile quads
    tileQuads = GenerateQuads(tileSprite, 32, 32)

    --board of tiles
    board = generateBoard()

    -- the currently selected tile
    highlightedTile = false
    highlightedX, highlightedY = 1, 1
    selectedTile = board[1][1]

    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    local x, y = selectedTile.gridX, selectedTile.gridY

    -- input handling
    if key == 'up' then
        if y > 1 then
            selectedTile = board[y - 1][x]
        end
    elseif key == 'down' then
        if y < 8 then
            selectedTile = board[y + 1][x]
        end
    elseif key == 'left' then
        if x > 1 then
            selectedTile = board[y][x - 1]
        end
    elseif key == 'right' then
        if x < 8 then
            selectedTile = board[y][x + 1]
        end
    end

end

function love.draw()
    push:start()

    drawBoard(128, 16)

    push:finish()
end

function generateBoard()
    local tiles = {}

    -- each column of tiles
    for y = 1, 8 do
        -- a row of tiles
        table.insert(tiles, {})
        for x = 1, 8 do
            -- the blank table we just inserted
            table.insert(tiles[y], {
                x = (x - 1) * 32,
                y = (y - 1) * 32,

                gridX = x,
                gridY = y,

                tile = math.random(#tileQuads)
            })
        end
    end

    return tiles
end

function drawBoard(offsetX, offsetY)
    -- draw each column
    for y = 1, 8 do
        --draw each row
        for x = 1, 8 do
            local tile = board[y][x]

            love.graphics.draw(tileSprite, tileQuads[tile.tile],
                tile.x + offsetX, tile.y + offsetY)

            if highlightedTile then
                -- highlights the selected tile
                if tile.gridX == highlightedX and tile.gridY == highlightedY then
                    love.graphics.setColor(1, 1, 1, 0.5)
                    love.graphics.rectangle('fill', tile.x + offsetX, tile.y + offsetY, 32, 32, 4)
                    -- reset colour
                    love.graphics.setColor(1, 1, 1, 1)
                end
            end
        end
    end
    --draw rectangle around selected tiles
    love.graphics.setColor(1, 0, 0, 234/255)
    love.graphics.setLineWidth(4)
    love.graphics.rectangle('line', selectedTile.x + offsetX, selectedTile.y + offsetY, 32, 32, 4)

    -- reset colour
    love.graphics.setColor(1, 1, 1, 1)
end