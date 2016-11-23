local widget = require("widget")

local GridContainer = require("ui.GridContainer")

local GameConfig = require("GameConfig")

local Sprite = require("Sprite")
local isotiles = require("sprites.isotiles")

local TileBox = {}

TileBox.LAYOUT_HORIZONTAL = 0
TileBox.LAYOUT_VERTICAL = 1

TileBox.new = function(maxW, maxH, layout, options)
    local scrollView = widget.newScrollView({
        width = maxW,
        height = maxH
    })

    local gapSize = options and options.gapSize or 0

    if layout ~= TileBox.LAYOUT_VERTICAL and layout ~= TileBox.LAYOUT_HORIZONTAL then
        print("layout is invalid")
        return nil
    end

    local tiles = {}
    local idx = 0
    function scrollView:loadTiles()
        -- isotiles
        for i = 1, #(isotiles.sheet.frames) do
            idx = idx + 1
            --tiles[idx] = Sprite["isotiles"].new(tostring(i))
            local gg = display.newGroup()


            local rect = display.newRect( 0, 0, GameConfig.gridWidth, GameConfig.gridHeight )
            rect.fill = {1, 0, 0}
            rect.stroke = {0, 1, 0}
            rect.strokeWidth = 3
            local t = display.newText( {
                text=tostring(idx),
                font=native.systemFont,
                fontSize=10
            } )
            gg:insert(rect)
            gg:insert(t)


            tiles[idx] = gg
        end
    end
    scrollView:loadTiles()

    local numCols = nil
    local numRows = nil

    if layout == TileBox.LAYOUT_VERTICAL then
        numCols = math.floor((maxW+gapSize)/(GameConfig.gridWidth + gapSize))
        numRows = math.ceil(idx / numCols)
    elseif layout == TileBox.LAYOUT_HORIZONTAL then
        numRows = math.floor((maxH+gapSize)/(GameConfig.gridHeight + gapSize))
        numCols = math.ceil(idx / numRows)
    end

    local container = GridContainer.new({
        cols = numCols,
        rows = numRows,
        gridW = GameConfig.gridWidth,
        gridH = GameConfig.gridHeight
    })

    if not container then
        print("container is nil")
        return nil
    end

    for i = 1, idx do
        local x = i%numCols
        if x == 0 then
            x = numCols
        end
        --container:insertAt(rect, math.floor(i/numCols)+1, x)
        print((math.floor(i/numCols)+1)..","..x)
        container:insertAt(tiles[i], math.floor(i/numCols)+1, x)
    end

    container.x = 0
    container.y = 0
    --scrollView:insert(container)

    return scrollView
end

return TileBox
