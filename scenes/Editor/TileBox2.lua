local widget = require("widget")

local TabView = require("ui.TabView")
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
    local tileBox = TabView.new(
        maxW,
        maxH,
        {
            marginSize = marginSize,
            marginColor = {1,1,1,0},
            backgroundColor = GameConfig.backgroundColor
        }
    )
    local options = {
        width = maxW - marginSize*2, -- consider scoller margin
        height = tileBox.contentHeight - marginSize*2, -- consider scoller margin
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
    local selectedTileTag = nil
    local selectedTileName = nil

    local loadTileFromSet = function(set, tag)
        tiles[tag] = {}
        -- load set
        for name, idx in pairs(set.frameIndex) do
            size = size+1
            local scale = GameConfig.gridWidth / TileInfo.baseWidth
            tiles[tag][name] = display.newGroup()
            tiles[tag][name].sprite = TileSprite.new(tag, name)
            tiles[tag][name].sprite.y = 3
            tiles[tag][name].sprite.xScale = scale
            tiles[tag][name].sprite.yScale = scale
            tiles[tag][name].selectRegion = display.newRoundedRect(0, 0, GameConfig.gridWidth, GameConfig.gridHeight, 2)
            tiles[tag][name].selectRegion.fill = {1,0,0}
            tiles[tag][name].selectRegion.alpha = 0
            local function tapListener(event)
                if ( event.numTaps == 1 ) then
                    tileBox:chooseTile(tag, name)
                    if callback then
                        callback()
                    end
                    return true
                end
            end
            tiles[tag][name]:addEventListener( "tap", tapListener )
            tiles[tag][name]:insert(tiles[tag][name].sprite)
            tiles[tag][name]:insert(tiles[tag][name].selectRegion)
        end

        -- calculate GridContainer layout
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
        for name, tile in pairs(tiles[tag]) do
            i = i+1
            local x = math.floor((i-1)/numCols)+1
            local y = i-(x-1)*numCols
            container:insertAt(tiles[tag][name], x, y, 0, 1)
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
        containerMargin.y = (container.realH+marginSize)/2
        containerMargin:insert(container)

        local scoller = widget.newScrollView(options)
        scoller:insert(containerMargin)

        scoller.x = 0
        scoller.y = 0

        return scoller
    end

    tileBox:insertTab("isotiles", loadTileFromSet(isotiles, "isotiles"))

    tileBox.tiles = tiles
    tileBox.size = size
    tileBox.selectedTileTag = selectedTileTag
    tileBox.selectedTileName = selectedTileName

    function tileBox:deselectTile()
        print("deselect:", self.selectedTileTag, self.selectedTileName)
        self.tiles[self.selectedTileTag][self.selectedTileName].selectRegion.alpha = 0
        self.selectedTileTag = nil
        self.selectedTileName = nil
    end

    function tileBox:selectTile(tag, name)
        print("select:", tag, name)
        self.selectedTileTag = tag
        self.selectedTileName = name
        self.tiles[self.selectedTileTag][self.selectedTileName].selectRegion.alpha = 0.3
    end

    function tileBox:chooseTile(tag, name)
        if self.selectedTileTag ~= tag or self.selectedTileName ~= name then
            if self.selectedTileTag ~= nil then
                self:deselectTile()
            end
            self:selectTile(tag, name)
        else
            self:deselectTile()
        end
    end

    return tileBox
end

return TileBox