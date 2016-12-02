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
Editor.MODE_MOVE = 3

-- eraser
function Editor:enableEraser()
    print("enable eraser")
    self.cursor:setObj(TileBase.new(), self.mouseX, self.mouseY)
    self:toMode(Editor.MODE_ERASER)
end
function Editor:disableEraser()
    print("disable eraser")
    self.cursor:removeObjIfExist()
    self:toMode(Editor.MODE_NONE)
end

function Editor:toMode(mode)
    if mode == self.mode then
        print("stay same mode")
        return
    end
    local s = nil
    if mode == Editor.MODE_NONE then
        s = "NONE"
    elseif mode == Editor.MODE_ERASER then
        s = "ERASER"
    elseif mode == Editor.MODE_TILE then
        s = "TILE"
    elseif mode == Editor.MODE_MOVE then
        s = "MVOE"
    else
        print("invalid mode")
        return
    end
    self.mode = mode
    print("switch to", s, "mode")
end

function Editor:initiateCallback()
    -- control bar callback
    self.previewUp = function()
        self.preview:up()
    end
    self.previewDown = function()
        self.preview:down()
    end
    self.previewDefault = function()
        self.preview:default()
    end
    self.previewEraser = function()
        self.preview:toggleBoardVisible()
    end

    -- tile select callback
    self.tileSelectCallback = function()
        local idx = self.tileBox.selectedTileIdx
        if self.mode == Editor.MODE_NONE then
            self.cursor:setObj(TileSprite.new("isotiles", tostring(idx)), self.mouseX, self.mouseY)
            self:toMode(Editor.MODE_TILE)
        elseif self.mode == Editor.MODE_TILE then
            self.cursor:removeObjIfExist()
            if idx ~= -1 then
                self.cursor:setObj(TileSprite.new("isotiles", tostring(idx)), self.mouseX, self.mouseY)
            else
                self:toMode(Editor.MODE_NONE)
            end
        elseif self.mode == Editor.MODE_ERASER then
            self:disableEraser()
            self.cursor:setObj(TileSprite.new("isotiles", tostring(idx)), self.mouseX, self.mouseY)
            self:toMode(Editor.MODE_TILE)
        end
    end

    -- layer position select callback
    self.posSelectCallback = function(layer, x, y)
        local world = self.preview:getCurrentWorld()
        -- paste tile
        if self.mode == Editor.MODE_TILE then
            local idx = self.tileBox.selectedTileIdx    
            local oldSprite = world[layer].tiles[x][y].sprite
            if not oldSprite or (oldSprite and oldSprite.name ~= tostring(idx)) then
                print("paste tile", idx, "on", layer, "("..x..", "..y..")")
                local tile = TileSprite.new("isotiles", tostring(idx))
                world[layer]:setTileAt(tile, x, y)
            end
            return true
        -- clean tile
        elseif self.mode == Editor.MODE_ERASER then
            print("clean on", layer, "("..x..", "..y..")")
            world[layer]:cleanAt(x, y)
            return true
        end
        return false
    end

    -- eraser btn
    self.toggleEraser = function()
        if self.mode == Editor.MODE_ERASER then
            -- disable eraser
            self:disableEraser()
        else
            -- enable eraser
            if self.mode == Editor.MODE_TILE then
                self.tileBox:deselectTile()
                self.cursor:removeObjIfExist()
            end
            self:enableEraser()
        end
    end

    -- move callbacks
    self.preMode = nil
    self.moveBeginCallback = function()
        self.preMode = self.mode
        self:toMode(Editor.MODE_MOVE)
    end

    self.movingCallback = function(distX, distY)
        self.preview:move(distX, distY)
    end

    self.moveEndCallback = function()
        self:toMode(self.preMode)
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
            callback = self.posSelectCallback,
            moveBegin = self.moveBeginCallback,
            moving = self.movingCallback,
            moveEnd = self.moveEndCallback
        }
    )

	self.ViewControlBar = ViewControlBar.new(
        GameConfig.controlBarWidth,
        GameConfig.controlBarHeight,
        {
            upCallback = self.previewUp,
            downCallback = self.previewDown,
            defaultCallback = self.previewDefault,
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
        self:toMode(Editor.MODE_NONE)
        -- cursor
        self.cursor = Cursor.new()
        self.mouseX = GameConfig.contentCenterX
        self.mouseY = GameConfig.contentCenterY
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
    elseif event.keyName == "up" and event.phase == "up" then
        Editor.preview:up()
    elseif event.keyName == "down" and event.phase == "up" then
        Editor.preview:down()
    elseif event.keyName == "escape" and event.phase == "up" then
        Editor.cursor:removeObjIfExist()
        if Editor.mode == Editor.MODE_ERASER then
            Editor:disableEraser()
            Editor.mode = Editor.MODE_NONE
        elseif Editor.mode == Editor.MODE_TILE then
            Editor.tileBox:deselectTile()
            Editor.mode = Editor.MODE_NONE
        else
        end
    end
end
Runtime:addEventListener("key", onKeyEvent)

return Editor
