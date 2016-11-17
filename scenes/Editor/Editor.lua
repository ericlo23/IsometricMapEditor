local composer = require("composer")
local widget = require("widget")

local ControlTable = require("scenes.Editor.ControlTable")
local DemoContainer = require("scenes.Editor.DemoContainer")
local Layer = require("Layer")
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
	
	self.demoContainer = DemoContainer.new(GameConfig.demoContainerWidth, GameConfig.demoContainerHeight)
	
	self.controlTable = GridContainer.new(
		GameConfig.controlTableWidth,
		GameConfig.controlTableHeight,
		1,
		5
	)
	
	self.tileTable = GridContainer.new(
		GameConfig.tileTableWidth, 
		GameConfig.tileTableHeight, 
		GameConfig.tileRows,
		GameConfig.tileCols
	)
	
	-- left part
	self.leftGroup = display.newGroup()
	self.attrTable.x = 0
	self.attrTable.y = 0
	self.leftGroup:insert(self.attrTable)
	
	-- middle part
	self.middleGroup = display.newGroup()
	self.demoContainer.x = 0
	self.demoContainer.y = 0
	self.controlTable.x = 0
	self.controlTable.y = (GameConfig.contentHeight-GameConfig.controlTableHeight)/2
	self.middleGroup:insert(self.demoContainer)
	self.middleGroup:insert(self.controlTable)
	
	-- right part
	self.rightGroup = display.newGroup()
	self.tileTable.x = 0
	self.tileTable.y = (GameConfig.contentHeight-GameConfig.tileTableHeight)
	self.rightGroup:insert(self.tileTable)
	
	self.universalGroup:insert(self.leftGroup)
	self.universalGroup:insert(self.middleGroup)
	self.universalGroup:insert(self.rightGroup)
	self.universalGroup:resize()
	
	sceneGroup:insert(self.universalGroup)
end

function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
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

return scene