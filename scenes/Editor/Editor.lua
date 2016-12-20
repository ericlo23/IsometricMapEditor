local composer = require("composer")
local widget = require("widget")

local Preview = require("scenes.Editor.Preview")
local EditControlBar = require("scenes.Editor.EditControlBar")
local ViewControlBar = require("scenes.Editor.ViewControlBar")
local StatusBar = require("scenes.Editor.StatusBar")

local TileSprite = require("sprites.TileSprite")
local TileBox = require("scenes.Editor.TileBox")
local TileBase = require("scenes.Editor.TileBase")
local Cursor = require("ui.Cursor")
local StateManager = require("scenes.Editor.StateManager")
local World = require("scenes.Editor.World")

local Action = require("scenes.Editor.Action")

local Layer = require("scenes.Editor.Layer")
local GameConfig = require("GameConfig")
local LinearGroup = require("ui.LinearGroup")
local GridContainer = require("ui.GridContainer")

local Editor = composer.newScene()

Editor.MODE_NONE = 0
Editor.MODE_ERASER = 1
Editor.MODE_TILE = 2
Editor.MODE_MOVE = 3

-- eraser
function Editor:enableEraser()
    print("enable eraser")
    local t = TileBase.new()
    self.cursor:setObj(t, self.mouseX, self.mouseY, GameConfig.cursorWidth/t.width)
    self:toMode(Editor.MODE_ERASER)
end
function Editor:disableEraser()
    print("disable eraser")
    self.cursor:removeObjIfExist()
    self:toMode(Editor.MODE_NONE)
end

function Editor:toMode(mode)
    if mode == self.mode then
        print("stay at same mode")
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
        s = "MOVE"
    else
        print("invalid mode")
        return
    end
    self.mode = mode
    print("switch to", s, "mode")
end

function Editor:initiateCallback()
    -- control bar callback
    self.previewLeft = function()
        self.preview:left()
    end
    self.previewRight = function()
        self.preview:right()
    end
    self.previewUp = function()
        self.preview:up()
    end
    self.previewDown = function()
        self.preview:down()
    end
    self.previewDefault = function()
        self.preview:default()
    end
    self.previewVisible = function()
        self.preview:toggleBoardVisible()
    end

    -- tile select callback
    self.tileSelectCallback = function()
        local name = self.tileBox.selectedTileName
        -- if still in move mode
        self.moveEndCallback()

        if self.mode == Editor.MODE_NONE then
            local t = TileSprite.new("isotiles", name)
            self.cursor:setObj(t, self.mouseX, self.mouseY, GameConfig.cursorWidth/t.width)
            self:toMode(Editor.MODE_TILE)
        elseif self.mode == Editor.MODE_TILE then
            self.cursor:removeObjIfExist()
            if name ~= nil then
                local t = TileSprite.new("isotiles", name)
                self.cursor:setObj(t, self.mouseX, self.mouseY, GameConfig.cursorWidth/t.width)
            else
                self:toMode(Editor.MODE_NONE)
            end
        elseif self.mode == Editor.MODE_ERASER then
            self:disableEraser()
            local t = TileSprite.new("isotiles", name)
            self.cursor:setObj(t, self.mouseX, self.mouseY, GameConfig.cursorWidth/t.width)
            self:toMode(Editor.MODE_TILE)
        end
    end

    -- layer position select callback
    self.posSelectCallback = function(world, layerId, x, y)
        -- if still in move mode
        self.moveEndCallback()
        -- paste tile
        if self.mode == Editor.MODE_TILE then
            local name = self.tileBox.selectedTileName
            local oldSprite = world[layerId].tiles[x][y].sprite
            if not oldSprite or (oldSprite and oldSprite.name ~= name) then
                local action = Action.new(
                    Action.TYPE_PASTE_TILE,
                    world,
                    layerId,
                    x, 
                    y,
                    "isotiles",
                    name
                )
                Action.todo(action)

                --local tile = TileSprite.new("isotiles", name)
                --world[layerId]:setTileAt(tile, x, y)
            end
            return true
        -- clean tile
        elseif self.mode == Editor.MODE_ERASER then
            local sprite = world[layerId]:getTileAt(x, y).sprite
            if sprite then
                local action = Action.new(
                    Action.TYPE_CLEAN_TILE,
                    world,
                    layerId,
                    x, 
                    y,
                    sprite.tag,                    
                    sprite.name
                )
                Action.todo(action)
            end
            --world[layerId]:cleanAt(x, y)
            return true
        end
        return false
    end

    -- eraser btn
    self.toggleEraser = function()
        self.moveEndCallback()
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
        self.moveEndCallback()
        self.preMode = self.mode
        self:toMode(Editor.MODE_MOVE)
    end

    self.movingCallback = function(distX, distY)
        if self.mode == Editor.MODE_MOVE then
            self.preview:move(distX, distY)
        end
    end

    self.moveEndCallback = function()
        if self.mode == Editor.MODE_MOVE then
            self:toMode(self.preMode)
        end
    end

    -- new/delete world callback
    self.newWorldCallback = function()
        local universe = self.preview.universe
        local world = World.new({name = tostring(self.preview.universe.size+1), callback = self.posSelectCallback})
        universe:addWorld(world)
        self.preview:default(universe.size)
        self.statusBar:updateUniverseSize(tostring(self.preview.universe.size))
    end

    self.delWorldCallback = function()
        local universe = self.preview.universe
        local target = self.preview.currentWorldId
        if target == self.preview.universe.size then
            self.preview:left()
        end
        universe:removeWorld(target)
        self.statusBar:updateUniverseSize(tostring(self.preview.universe.size))
    end

    -- update status callback
    self.updateStatusCallback = function(worldStatus, layerStatus)
        if worldStatus then
            self.statusBar:updateCurrentWorld(worldStatus)
        end
        if layerStatus then
            self.statusBar:updateCurrentLayer(layerStatus)
        end
    end
end

function Editor:initiateLayout()
	local sceneGroup = self.view
	self.universalGroup = LinearGroup.new()
	self.universalGroup.x = display.contentCenterX
	self.universalGroup.y = display.contentCenterY

    self.editControlBar = EditControlBar.new(
        GameConfig.controlBarWidth,
        GameConfig.controlBarHeight,
        {
            saveCallback = nil,
            loadCallback = nil,
            undoCallback = Action.undo,
            redoCallback = Action.redo,
            newWorldCallback = self.newWorldCallback,
            delWorldCallback = self.delWorldCallback,
            visibleCallback = self.previewVisible,
            eraserCallback = self.toggleEraser,
            marginSize = GameConfig.marginSize,
            marginColor = GameConfig.marginColor
        }
    )

	self.preview = Preview.new(
        GameConfig.previewWidth,
        GameConfig.previewHeight,
        {
            moveBegin = self.moveBeginCallback,
            moving = self.movingCallback,
            moveEnd = self.moveEndCallback,
            updateStatus = self.updateStatusCallback
        }
    )

	self.viewControlBar = ViewControlBar.new(
        GameConfig.controlBarWidth,
        GameConfig.controlBarHeight,
        {
            leftCallback = self.previewLeft,
            rightCallback = self.previewRight,
            upCallback = self.previewUp,
            downCallback = self.previewDown,
            defaultCallback = self.previewDefault,
            marginSize = GameConfig.marginSize,
            marginColor = GameConfig.marginColor
        }
    )

    self.statusBar = StatusBar.new(
        GameConfig.statusBarWidth,
        GameConfig.statusBarHeight,
        {
            marginSize = GameConfig.marginSize,
            marginColor = GameConfig.marginColor
        }
    )

	self.tileBox = TileBox.new(
		GameConfig.tileBoxWidth,
		GameConfig.tileBoxHeight,
		TileBox.LAYOUT_VERTICAL,
        {
            gapSize = 4,
            marginSize = GameConfig.marginSize,
            callback = self.tileSelectCallback
        }
	)

	-- middle part
	self.middleGroup = display.newGroup()
    self.editControlBar.x = 0
    self.editControlBar.y = -(GameConfig.contentHeight-GameConfig.controlBarHeight)/2
	self.preview.x = 0
	self.preview.y = -GameConfig.statusBarHeight/2
	self.viewControlBar.x = 0
	self.viewControlBar.y = (GameConfig.contentHeight-GameConfig.controlBarHeight)/2 - GameConfig.statusBarHeight
    self.statusBar.x = 0
    self.statusBar.y = (GameConfig.contentHeight-GameConfig.statusBarHeight)/2 
    self.middleGroup:insert(self.editControlBar)
	self.middleGroup:insert(self.preview)
	self.middleGroup:insert(self.viewControlBar)
    self.middleGroup:insert(self.statusBar)

	-- right part
	self.rightGroup = display.newGroup()
	self.tileBox.x = 0
	self.tileBox.y = -(GameConfig.contentHeight-GameConfig.tileBoxHeight)/2
	self.rightGroup:insert(self.tileBox)

	--self.universalGroup:insert(self.leftGroup)
	self.universalGroup:insert(self.middleGroup)
	self.universalGroup:insert(self.rightGroup)
	self.universalGroup:resize()

	sceneGroup:insert(self.universalGroup)
end

function Editor:create( event )
    local sceneGroup = self.view

    -- mode
    self:toMode(Editor.MODE_NONE)
    
    -- layouts
    self:initiateCallback() -- should be called before initiateLayout
    self:initiateLayout()

    -- load universe state
    StateManager:initial(self.preview.universe)
    StateManager:loadLast()
    self.preview:default()

    -- cursor
    self.cursor = Cursor.new(GameConfig.cursorOffsetX, GameConfig.cursorOffsetY)
    self.mouseX = GameConfig.contentCenterX
    self.mouseY = GameConfig.contentCenterY
    sceneGroup:insert(self.cursor)

end

function Editor:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

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
    --print(event.x, event.y)
    -- record mouse position
    Editor.mouseX = event.x
    Editor.mouseY = event.y
    -- right click
    if event.isSecondaryButtonDown then
        Editor.cursor:removeObjIfExist()
        if Editor.mode == Editor.MODE_ERASER then
            Editor:disableEraser()
        elseif Editor.mode == Editor.MODE_TILE then
            Editor.tileBox:deselectTile()
            Editor:toMode(Editor.MODE_NONE)
        else
        end
    end
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
    elseif event.keyName == "left" and event.phase == "up" then
        Editor.preview:left()
    elseif event.keyName == "right" and event.phase == "up" then
        Editor.preview:right()
    elseif event.keyName == "up" and event.phase == "up" then
        Editor.preview:up()
    elseif event.keyName == "down" and event.phase == "up" then
        Editor.preview:down()
    elseif event.keyName == "escape" and event.phase == "up" then
        Editor.cursor:removeObjIfExist()
        if Editor.mode == Editor.MODE_ERASER then
            Editor:disableEraser()
        elseif Editor.mode == Editor.MODE_TILE then
            Editor.tileBox:deselectTile()
            Editor:toMode(Editor.MODE_NONE)
        else
        end
    elseif event.isCtrlDown and event.keyName == "z" and event.phase == "up" then
        Action.undo()
    elseif ((event.isCtrlDown and event.keyName == "y") or
            (event.isCtrlDown and event.isShiftDown and event.keyName == "z")) and 
            event.phase == "up" then
        Action.redo()
    end
end
Runtime:addEventListener("key", onKeyEvent)

return Editor