local config = {}

config.contentWidth = display.contentWidth
config.contentHeight = display.contentHeight

config.basicHeight = 720

config.imageSuffix = {
    ["@2x"] = 1.5,
    ["@3x"] = 2.5,
    ["@4x"] = 3
}

config.scaleFactor =  config.contentHeight / config.basicHeight

config.fontSize = 14

-- Editor layout size
config.attrTableWidth = config.contentWidth*4/16
config.attrTableHeight = config.contentHeight

config.controlBarWidth = config.contentWidth*8/16
config.controlBarHeight = 30
config.controlBtnHeight = 24

config.demoContainerWidth = config.contentWidth*8/16
config.demoContainerHeight = config.contentHeight-config.controlBarHeight

config.tileTableWidth = config.contentWidth*4/16
config.tileTableHeight = config.contentHeight

-- Layer
config.layerSize = 8
config.layerScale = 0.3
config.layOffset = 50
config.gapHeight = 200/0.3

-- Tile table
--config.numTiles = 96
config.tileRows = 8
config.tileCols = 8

return config