local config = {}

config.contentWidth = display.contentWidth
config.contentHeight = display.contentHeight
config.contentCenterX = display.contentCenterX
config.contentCenterY = display.contentCenterY

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
config.controlBarHeight = 18
config.controlBtnHeight = 12
config.previewWidth = config.contentWidth*8/16
config.previewHeight = config.contentHeight-config.controlBarHeight*2
config.tileBoxWidth = config.contentWidth*4/16
config.tileBoxHeight = config.contentHeight/2

-- Cursor
config.cursorWidth = 16
config.cursorOffsetX = 15
config.cursorOffsetY = 10

-- Preview
config.previewScale = 0.2
config.previewScaleStep = config.previewScale / 10
config.previewOffsetX = 0
config.previewOffsetY = 0
config.previewMoveFactor = 1

-- World
config.boardAlpha = 1
config.layerSize = 15
config.layerOffset = 50
config.layerDistance = 1000

-- Tile box
config.gridWidth = 20
config.gridHeight = 20

return config