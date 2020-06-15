LevelMaker = Class{}

function LevelMaker.createMap(level)
    local bricks = {}

    local numRows = math.random(1, 5)
    local numCols = math.random(7, 13)

    for y = 1, numRows do
        for x = 1, numCols do
            b = Brick(
                (x-1)                   -- decrement x by 1
                * 32                    -- multiply by brick width
                + 8                     -- screen has 8 pixels of padding
                + (13 - numCols) * 16,  -- left-side padding when there are less than 13 columns

                y * 16
            )

            table.insert(bricks, b)
        end
    end

    return bricks
end