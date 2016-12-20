local widget = require("widget")

local MarginGroup = require("ui.MarginGroup")
local GridContainer = require("ui.GridContainer")

local GameConfig = require("GameConfig")
local TileInfo = require("TileInfo")

local TileSprite = require("sprites.TileSprite")
local isotiles = require("sprites.isotiles")

local TileBox = {}

TileBox.LAYOUT_HORIZONTAL = 0
TileBox.LAYOUT_VERTICAL = 1

TileBox.new = function(maxW, maxH, layout, options)
    local callback = options and options.callback or nil
    local gapSize = options and options.gapSize or 0
    local marginSize = options and options.marginSize or 0
    local tileBox = MarginGroup.new(
        maxW,
        maxH,
        {
            marginSize = marginSize,
            marginColor = {1,1,1,0}
        }
    )
    local options = {
        width = maxW - marginSize*2, -- consider scoller margin
        height = maxH - marginSize*2, -- consider scoller margin
        backgroundColor = GameConfig.backgroundColor
    }
    if layout == TileBox.LAYOUT_VERTICAL then
        options["horizontalScrollDisabled"] = true
    elseif layout == TileBox.LAYOUT_HORIZONTAL then
        options["verticalScrollDisabled"] = true
    else
        print("layout is invalid")
        return nil
    end
    
    local tiles = {}
    local size = 0
    local selectedTileName = nil

    function tileBox:deselectTile()
        print("deselect:", self.selectedTileName)
        self.tiles[self.selectedTileName].selectRegion.alpha = 0
        self.selectedTileName = nil
    end

    function tileBox:selectTile(name)
        print("select:", name)
        self.selectedTileName = name
        self.tiles[self.selectedTileName].selectRegion.alpha = 0.3
    end

    function tileBox:chooseTile(name)
        if self.selectedTileName ~= name then
            if self.selectedTileName ~= nil then
                self:deselectTile()
            end
            self:selectTile(name)
        else
            self:deselectTile()
        end
    end

    -- load isotiles
    for name, idx in pairs(isotiles.frameIndex) do
        size = size+1
        local scale = GameConfig.gridWidth / TileInfo.baseWidth
        tiles[name] = display.newGroup()
        tiles[name].sprite = TileSprite.new("isotiles", name)
        tiles[name].sprite.y = 3
        tiles[name].sprite.xScale = scale
        tiles[name].sprite.yScale = scale
        tiles[name].name = name
        local rect = display.newRoundedRect(0, 0, GameConfig.gridWidth, GameConfig.gridHeight, 2)
        rect.fill = {1,0,0}
        rect.alpha = 0
        tiles[name].selectRegion = rect
        local function tapListener(self, event)
            if ( event.numTaps == 1 ) then
                tileBox:chooseTile(self.name)
                if callback then
                    callback()
                end
                return true
            end
        end
        tiles[name].tap = tapListener
        tiles[name]:addEventListener( "tap", tiles[name] )
        tiles[name]:insert(tiles[name].sprite)
        tiles[name]:insert(rect)
    end

    -- calculate proper layout
    local numCols = nil
    local numRows = nil
    if layout == TileBox.LAYOUT_VERTICAL then
        local width = options.width-2*marginSize
        numCols = math.floor((width+gapSize)/(GameConfig.gridWidth + gapSize))
        numRows = math.ceil(size / numCols)
    elseif layout == TileBox.LAYOUT_HORIZONTAL then
        local height = options.height-2*marginSize
        numRows = math.floor((height+gapSize)/(GameConfig.gridHeight + gapSize))
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
    local i = 0
    for name, tile in pairs(tiles) do
        i = i+1
        local x = math.floor((i-1)/numCols)+1
        local y = i-(x-1)*numCols
        container:insertAt(tiles[name], x, y, 0, 1)
    end

    local containerMargin = MarginGroup.new(
        container.realW+2*marginSize, 
        container.realH+2*marginSize,
        {
            marginSize = marginSize,
            marginColor = {1,1,1,0}
        }
    )
    containerMargin.x = options.width/2
    containerMargin.y = container.realH/2 + marginSize
    containerMargin:insert(container)

    local scoller = widget.newScrollView(options)
    scoller:insert(containerMargin)

    scoller.x = 0
    scoller.y = 0

    tileBox:insert(scoller)

    tileBox.tiles = tiles
    tileBox.size = size
    tileBox.selectedTileName = selectedTileName

    return tileBox
end

return TileBox