local composer = require("composer")
local widget = require("widget")

local Preview = require("scenes.Editor.Preview")
local EditControlBar = require("scenes.Editor.EditControlBar")
local ViewControlBar = require("scenes.Editor.ViewControlBar")
local TileSprite = require("sprites.TileSprite")
local TileBox = require("scenes.Editor.TileBox")

local Layer = require("scenes.Editor.Layer")
local GameConfig = require("GameConfig")
local LinearGroup = require("ui.LinearGroup")
local GridContainer = require("ui.GridContainer")

local scene = composer.newScene()

function scene:create( event )
    local sceneGroup = self.view
end

function scene:initialLayout()
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
        GameConfig.controlBarHeight
    )

	self.preview = Preview.new(
        GameConfig.previewWidth,
        GameConfig.previewHeight,
        {
            callback = self.posSelectCallback
        }
    )

	self.ViewControlBar = ViewControlBar.new(
        self.preview,
        GameConfig.controlBarWidth,
        GameConfig.controlBarHeight
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

function scene:removeCursorIfExist()
    local sceneGroup = self.view
    if self.toolCursor then
        sceneGroup:remove(self.toolCursor)
        self.toolCursor = nil
    end
end

function scene:setCursor(obj, x, y)
    local sceneGroup = self.view
    self.toolCursor = obj
    self.toolCursor.x = x + 15
    self.toolCursor.y = y + 10
    self.toolCursor.xScale = GameConfig.cursorWidth/self.toolCursor.width
    self.toolCursor.yScale = GameConfig.cursorWidth/self.toolCursor.width
    sceneGroup:insert(self.toolCursor)
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        self.toolCursor = nil

        -- tile select callback
        self.tileSelectCallback = function(x, y)
            local idx = self.tileBox.selectedTileIdx
            self:removeCursorIfExist()
            if idx ~= -1 then
                self:setCursor(TileSprite.new("isotiles", tostring(idx)), x, y)
            end
        end

        -- layer position select callback
        self.posSelectCallback = function(id, x, y)
            local idx = self.tileBox.selectedTileIdx
            if idx ~= -1 then
                print("paste tile "..idx.." on "..id..","..x..","..y)
                local tile = TileSprite.new("isotiles", tostring(idx))
                self.preview.world[id]:setTileAt(tile, x, y)
            end
        end

        -- eraser btn
        self.toggleEraser = function()

        end

		self:initialLayout()

    elseif ( phase == "did" ) then

    end
end

function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

    elseif ( phase == "did" ) then

    end
end

function scene:destroy( event )

    local sceneGroup = self.view

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

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
    -- scrolling
	if event.scrollY > 0 then
        scene.preview:zoomOut()
	elseif event.scrollY < 0 then
        scene.preview:zoomIn()
	end
    -- cursor
    if scene.toolCursor then
        scene.toolCursor.x = event.x + 15
        scene.toolCursor.y = event.y + 10
    end
end
Runtime:addEventListener("mouse", onMouseEvent)

local function onKeyEvent(event)
    if event.keyName == "v" then
        scene.preview:toggleBoardVisible()
    elseif event.keyName == "up" then
        if event.phase == "up" then
            scene.preview:up()
        end
    elseif event.keyName == "down" then
        if event.phase == "up" then
            scene.preview:down()
        end
    end
end
Runtime:addEventListener("key", onKeyEvent)

return scene
