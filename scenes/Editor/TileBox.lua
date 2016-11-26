local widget = require("widget")

local GridContainer = require("ui.GridContainer")

local GameConfig = require("GameConfig")
local TileInfo = require("TileInfo")

local Sprite = require("Sprite")
local isotiles = require("sprites.isotiles")

local TileBox = {}

TileBox.LAYOUT_HORIZONTAL = 0
TileBox.LAYOUT_VERTICAL = 1

TileBox.new = function(maxW, maxH, layout, options)
    local gapSize = options and options.gapSize or 0
    local callback = options and options.callback or nil
    local options = {
        width = maxW,
        height = maxH,
        backgroundColor = {1,1,1,0.3}
    }
    if layout == TileBox.LAYOUT_VERTICAL then
        options["horizontalScrollDisabled"] = true
    elseif layout == TileBox.LAYOUT_HORIZONTAL then
        options["verticalScrollDisabled"] = true
    else
        print("layout is invalid")
        return nil
    end

    local scrollView = widget.newScrollView(options)
    local tiles = {}
    local size = 0
    local selectedTileIdx = -1

    -- load isotiles
    for i = 1, #(isotiles.sheet.frames) do
        size = size + 1
        local name = tostring(i)
        local sprite = Sprite["isotiles"].new(name)
        tiles[size] = display.newGroup()
        local scale = GameConfig.gridWidth / TileInfo.baseWidth
        sprite.xScale = scale
        sprite.yScale = scale
        tiles[size].idx = size
        local rect = display.newRoundedRect(0, 0, GameConfig.gridWidth, GameConfig.gridHeight, 2)
        rect.fill = {1,0,0}
        rect.alpha = 0
        tiles[size].selectRegion = rect
        local function tapListener(self, event)
            if ( event.numTaps == 1 ) then
                if scrollView.selectedTileIdx ~= self.idx then
                    if scrollView.selectedTileIdx ~= -1 then
                        print("deselect:", scrollView.selectedTileIdx)
                        scrollView.tiles[scrollView.selectedTileIdx].selectRegion.alpha = 0
                    end
                    print("select:", self.idx)
                    scrollView.selectedTileIdx = self.idx
                    self.selectRegion.alpha = 0.3
                else
                    print("deselect:", scrollView.selectedTileIdx)
                    scrollView.selectedTileIdx = -1
                    self.selectRegion.alpha = 0
                end
                return true
            end
        end
        tiles[size].tap = tapListener
        tiles[size]:addEventListener( "tap", tiles[size] )
        tiles[size]:insert(sprite)
        tiles[size]:insert(rect)
    end

    -- calculate proper layout
    local numCols = nil
    local numRows = nil
    if layout == TileBox.LAYOUT_VERTICAL then
        numCols = math.floor((maxW+gapSize)/(GameConfig.gridWidth + gapSize))
        numRows = math.ceil(size / numCols)
    elseif layout == TileBox.LAYOUT_HORIZONTAL then
        numRows = math.floor((maxH+gapSize)/(GameConfig.gridHeight + gapSize))
        numCols = math.ceil(size / numRows)
    end

    -- use GridContainer for tiles
    local container = GridContainer.new({
        cols = numCols,
        rows = numRows,
        gridW = GameConfig.gridWidth,
        gridH = GameConfig.gridHeight,
        gapSize = gapSize
    })
    if not container then
        print("container is nil")
        return nil
    end
    for i = 1, size do
        local x = math.floor((i-1)/numCols)+1
        local y = i-(x-1)*numCols
        container:insertAt(tiles[i], x, y)
    end

    container.x = maxW/2
    container.y = container.realH/2
    scrollView:insert(container)

    scrollView.tiles = tiles
    scrollView.size = size
    scrollView.selectedTileIdx = selectedTileIdx

    return scrollView
end

return TileBox
