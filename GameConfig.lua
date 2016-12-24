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
config.controlBarWidth = config.contentWidth*16/20
config.controlBarHeight = 18
config.statusBarWidth = config.contentWidth*16/20
config.statusBarHeight = 18
config.previewWidth = config.contentWidth*16/20
config.previewHeight = config.contentHeight-config.controlBarHeight*2-config.statusBarHeight
config.tileBoxWidth = config.contentWidth*4/20
config.tileBoxHeight = config.contentHeight*2/3
config.marginColor = {1,1,1,0}
config.marginSize = 2
config.backgroundColor = {1,1,1,0.3}

-- Cursor
config.cursorWidth = 35
config.cursorOffsetX = 0
config.cursorOffsetY = 0

-- Preview
config.previewScale = 0.4
config.previewScaleStep = config.previewScale / 10
config.previewOffsetX = 0
config.previewOffsetY = 0
config.previewMoveFactor = 1

-- Universe
config.boardAlpha = 1
config.worldDistance = 100
config.layerSize = 20
config.layerOffset = 50
config.layerDistance = 1200	

-- TileBase
config.tileBaseAlpha = 0.2
config.tileBaseStrokeAlpha = 1

-- TileBox
config.gridWidth = 35
config.gridHeight = 35

return config