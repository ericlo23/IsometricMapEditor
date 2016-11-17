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

-- Editor layout size
config.attrTableWidth = config.contentWidth*4/16
config.attrTableHeight = config.contentHeight

config.controlTableWidth = config.contentWidth*8/16
config.controlTableHeight = 30
config.controlBtnHeight = 24

config.demoContainerWidth = config.contentWidth*8/16
config.demoContainerHeight = config.contentHeight-config.controlTableHeight

config.tileTableWidth = config.contentWidth*4/16
config.tileTableHeight = config.contentHeight

-- Layer
config.layerSize = 8
config.layerScale = 0.4
config.layOffset = 30
config.gapHeight = 200

-- Tile table
--config.numTiles = 96
config.tileRows = 8
config.tileCols = 8

return config