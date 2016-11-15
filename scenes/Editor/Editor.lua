local composer = require("composer")
local widget = require("widget")
local Layer = require("Layer")
local GameConfig = require("GameConfig")
local LinearGroup = require("ui.LinearGroup")

local function onOrientationChange( event )
    local currentOrientation = event.type
    print( "Current orientation: " .. currentOrientation )
	if(currentOrientation == "portrait" or currentOrientation == "portraitUpsideDown") then
		print("Change to Demo Mode")
		composer.gotoScene("scenes.Demo")
	end
end
Runtime:addEventListener( "orientation", onOrientationChange )

local scene = composer.newScene()

function scene:create( event )

    local sceneGroup = self.view

end
	
function scene:setUniversalGroup()
	local sceneGroup = self.view
	self.universalGroup = LinearGroup.new()
	self.universalGroup.x = display.contentCenterX
	self.universalGroup.y = display.contentCenterY
	
	self.attrTable = widget.newTableView({
		id="attr_table",
		x = 0,
		y = 0,
		width = display.contentWidth*4/16,
		height = display.contentHeight
	})
	
	self.demoContainer = display.newContainer(display.contentWidth*8/16, display.contentHeight)
	self.demoContainer.x = 0
	self.demoContainer.y = 0
	local ground = Layer.new()
	ground.x = 0
	ground.y = 0
	ground:scale(0.3, 0.3)
	self.demoContainer:insert(ground)
	
	self.tileTable = widget.newTableView({
		id="tile_table",
		x = 0,
		y = 0,
		width = display.contentWidth*4/16,
		height = display.contentHeight
	})
	
	-- left part
	self.leftGroup = display.newGroup()
	self.leftGroup:insert(self.attrTable)
	
	-- middle part
	self.middleGroup = display.newGroup()
	self.middleGroup:insert(self.demoContainer)
	
	-- right part
	self.rightGroup = display.newGroup()
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
		self:setUniversalGroup()
		
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

return scene