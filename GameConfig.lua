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

-- Editor layout 
config.attrTableWidth = config.contentWidth*4/16
config.attrTableHeight = config.contentHeight
config.controlBarWidth = config.contentWidth*12/16
config.controlBarHeight = 18
config.previewWidth = config.contentWidth*12/16
config.previewHeight = config.contentHeight-config.controlBarHeight*2
config.tileBoxWidth = config.contentWidth*4/16
config.tileBoxHeight = config.contentHeight/2
config.marginColor = {1,1,1,0}

-- Cursor
config.cursorWidth = 16
config.cursorOffsetX = 15
config.cursorOffsetY = 10

-- Preview
config.previewScale = 0.15
config.previewScaleStep = config.previewScale / 10
config.previewOffsetX = 0
config.previewOffsetY = 0
config.previewMoveFactor = 1

-- Universe
config.boardAlpha = 1
config.worldDistance = 200
config.layerSize = 20
config.layerOffset = 50
config.layerDistance = 1200	

-- TileBase
config.tileBaseAlpha = 0.2
config.tileBaseStrokeAlpha = 1

-- TileBox
config.gridWidth = 20
config.gridHeight = 20

return config