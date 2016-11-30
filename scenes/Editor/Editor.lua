local composer = require("composer")
local widget = require("widget")

local Preview = require("scenes.Editor.Preview")
local EditControlBar = require("scenes.Editor.EditControlBar")
local ViewControlBar = require("scenes.Editor.ViewControlBar")
local TileSprite = require("sprites.TileSprite")
local TileBox = require("scenes.Editor.TileBox")
local TileBase = require("scenes.Editor.TileBase")
local Cursor = require("ui.Cursor")

local Layer = require("scenes.Editor.Layer")
local GameConfig = require("GameConfig")
local LinearGroup = require("ui.LinearGroup")
local GridContainer = require("ui.GridContainer")

local Editor = composer.newScene()

function Editor:create( event )
    local sceneGroup = self.view
end

Editor.MODE_NONE = 0
Editor.MODE_ERASER = 1
Editor.MODE_TILE = 2

function Editor:initiateCallback()
    -- control bar callback
    self.previewUp = function()
        self.preview:up()
    end
    self.previewDown = function()
        self.preview:down()
    end
    self.previewReset = function()
        self.preview:reset()
    end
    self.previewEraser = function()
        self.preview:toggleBoardVisible()
    end

    -- tile select callback
    self.tileSelectCallback = function()
        if self.mode == Editor.MODE_NONE then
            local idx = self.tileBox.selectedTileIdx
            --self.cursor:removeObjIfExist()
            if idx ~= -1 then
                self.cursor:setObj(TileSprite.new("isotiles", tostring(idx)), self.mouseX, self.mouseY)
            end
            self.mode = Editor.MODE_TILE
        elseif self.mode == Editor.MODE_TILE then
            local idx = self.tileBox.selectedTileIdx
            self.cursor:removeObjIfExist()
            if idx ~= -1 then
                self.cursor:setObj(TileSprite.new("isotiles", tostring(idx)), self.mouseX, self.mouseY)
                self.mode = Editor.MODE_TILE
            else
                self.mode = Editor.MODE_NONE
            end
        elseif self.mode == Editor.MODE_ERASER then
            self.toggleEraser()
            self.cursor:setObj(TileSprite.new("isotiles", tostring(idx)), self.mouseX, self.mouseY)
            self.mode = Editor.MODE_TILE
        end
    end

    -- layer position select callback
    self.posSelectCallback = function(layer, x, y)
        if self.mode == Editor.MODE_TILE then
            local idx = self.tileBox.selectedTileIdx
            print("paste tile", idx, "on", layer, "("..x..", "..y..")")
            local tile = TileSprite.new("isotiles", tostring(idx))
            self.preview.world[layer]:setTileAt(tile, x, y)
        elseif self.mode == Editor.MODE_ERASER then
            print("clean on", layer, "("..x..", "..y..")")
            self.preview.world[layer]:cleanAt(x, y)
        end
    end

    -- eraser btn
    self.toggleEraser = function()
        local mode = self.mode
        if self.mode == Editor.MODE_TILE or self.mode == Editor.MODE_ERASER then
            self.cursor:removeObjIfExist()
            mode = Editor.MODE_NONE
        end
        if self.mode == Editor.MODE_NONE or self.mode == Editor.MODE_TILE then
            local tileBase = TileBase.new()
            self.cursor:setObj(tileBase, self.mouseX, self.mouseY)
            mode = Editor.MODE_ERASER
        end
        self.mode = mode
    end
end

function Editor:initiateLayout()
	local sceneGroup = self.view
	self.universalGroup = LinearGroup.new()
	self.universalGroup.x = display.contentCenterX
	self.universalGroup.y = display.contentCenterY

	self.attrTable = widget.newTableView({
		id="attr_table",
		width = GameConfig.attrTableWidth,
		height = GameConfig.attrTableHeight
	})

    self.EditControlBar = EditControlBar.new(
        GameConfig.controlBarWidth,
        GameConfig.controlBarHeight,
        {
            eraserCallback = self.toggleEraser
        }
    )

	self.preview = Preview.new(
        GameConfig.previewWidth,
        GameConfig.previewHeight,
        {
            callback = self.posSelectCallback
        }
    )

	self.ViewControlBar = ViewControlBar.new(
        GameConfig.controlBarWidth,
        GameConfig.controlBarHeight,
        {
            upCallback = self.previewUp,
            downCallback = self.previewDown,
            resetCallback = self.previewReset,
            visibleCallback = self.previewEraser,
        }
    )

	self.tileBox = TileBox.new(
		GameConfig.tileBoxWidth,
		GameConfig.tileBoxHeight,
		TileBox.LAYOUT_VERTICAL,
        {
            gapSize = 3,
            callback = self.tileSelectCallback
        }
	)

	-- left part
	self.leftGroup = display.newGroup()
	self.attrTable.x = 0
	self.attrTable.y = 0
	self.leftGroup:insert(self.attrTable)

	-- middle part
	self.middleGroup = display.newGroup()
    self.EditControlBar.x = 0
    self.EditControlBar.y = -(GameConfig.contentHeight-GameConfig.controlBarHeight)/2
	self.preview.x = 0
	self.preview.y = 0
	self.ViewControlBar.x = 0
	self.ViewControlBar.y = (GameConfig.contentHeight-GameConfig.controlBarHeight)/2
    self.middleGroup:insert(self.EditControlBar)
	self.middleGroup:insert(self.preview)
	self.middleGroup:insert(self.ViewControlBar)

	-- right part
	self.rightGroup = display.newGroup()
	self.tileBox.x = 0
	self.tileBox.y = -(GameConfig.contentHeight-GameConfig.tileBoxHeight)/2
	self.rightGroup:insert(self.tileBox)

	self.universalGroup:insert(self.leftGroup)
	self.universalGroup:insert(self.middleGroup)
	self.universalGroup:insert(self.rightGroup)
	self.universalGroup:resize()

	sceneGroup:insert(self.universalGroup)
end

function Editor:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- mode
        self.mode = Editor.MODE_NONE

        -- cursor
        self.cursor = Cursor.new()
        sceneGroup:insert(self.cursor)

        self:initiateCallback() -- should be called before initiateLayout
		
        self:initiateLayout()

    elseif ( phase == "did" ) then

    end
end

function Editor:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

    elseif ( phase == "did" ) then

    end
end

function Editor:destroy( event )

    local sceneGroup = self.view

end

Editor:addEventListener( "create", Editor )
Editor:addEventListener( "show", Editor )
Editor:addEventListener( "hide", Editor )
Editor:addEventListener( "destroy", Editor )

local function onOrientationChange( event )
    local currentOrientation = event.type
    print( "Current orientation: " .. currentOrientation )
	if(currentOrientation == "portrait" or currentOrientation == "portraitUpsideDown") then
		print("Change to Demo Mode")
		composer.gotoScene("scenes.Demo")
	end
end
Runtime:addEventListener( "orientation", onOrientationChange )

local function onMouseEvent(event)
    -- record mouse position
    Editor.mouseX = event.x
    Editor.mouseY = event.y
    -- scrolling
	if event.scrollY > 0 then
        Editor.preview:zoomOut()
	elseif event.scrollY < 0 then
        Editor.preview:zoomIn()
	end
    -- cursor
    if Editor.cursor then
        Editor.cursor:moveTo(event.x, event.y)
    end
end
Runtime:addEventListener("mouse", onMouseEvent)

local function onKeyEvent(event)
    if event.keyName == "v" then
        Editor.preview:toggleBoardVisible()
    elseif event.keyName == "e" and event.phase == "up" then
        Editor.toggleEraser()
    elseif event.keyName == "up" then
        if event.phase == "up" then
            Editor.preview:up()
        end
    elseif event.keyName == "down" then
        if event.phase == "up" then
            Editor.preview:down()
        end
    end
end
Runtime:addEventListener("key", onKeyEvent)

return Editor
