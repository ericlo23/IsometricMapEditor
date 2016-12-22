local TabView = require("ui.TabView")

local mui = require( "materialui.mui" )

local composer = require("composer")

local function onOrientationChange( event )
    local currentOrientation = event.type
    print( "Current orientation: " .. currentOrientation )
	if(currentOrientation == "landscapeRight" or currentOrientation == "landscapeLeft") then
		print("Change to Editor Mode")
		composer.gotoScene("scenes.Editor.Editor")
	end
end
Runtime:addEventListener( "orientation", onOrientationChange )

local scene = composer.newScene()

function scene:create( event )

    local sceneGroup = self.view

    local t = TabView.new(200, 300, {marginSize = 1, backgroundColor={1,1,1,0.3}})
	
    t:insertTab("test", display.newRect(0, 0, 100, 100))
    t:insertTab("tttttttt", display.newRect(0, 0, 1111, 100))
    t:insertTab("i am hero", nil)
    t:insertTab("am i?")
    t:insertTab("bbbbbbb")
    t:insertTab("??")


	t.x = display.contentCenterX
	t.y = display.contentCenterY
    sceneGroup:insert(t)

    --[[
	mui.init()

    mui.newNavbar({
		name = "navbar_demo",
		--width = mui.getScaleVal(500), -- defaults to display.contentWidth
		height = mui.getScaleVal(70),
		left = 0,
		top = 0,
		fillColor = { 0.63, 0.81, 0.181 },
		activeTextColor = { 1, 1, 1, 1 },
		padding = mui.getScaleVal(10),
	})

	-- let's attach something to the navbar
	--
	mui.newIconButton({
		name = "menu",
		text = "menu",
		width = mui.getScaleVal(50),
		height = mui.getScaleVal(50),
		x = mui.getScaleVal(0),
		y = mui.getScaleVal(0),
		font = "MaterialIcons-Regular.ttf",
		textColor = { 1, 1, 1 },
		textAlign = "center",
		callBack = showSlidePanel2
	})
	-- use the helper method attachToNavBar to attach
	--
	mui.attachToNavBar( "navbar_demo", {
		widgetName = "menu",
		widgetType = "IconButton",
		align = "left",  -- left | right supported
	})

	local buttonHeight = mui.getScaleVal(70)
	mui.newToolbar({
		name = "toolbar_demo",
		--width = mui.getScaleVal(500), -- defaults to display.contentWidth
		height = mui.getScaleVal(70),
		buttonHeight = buttonHeight,
		x = 0,
		y = (display.contentHeight - (buttonHeight * 0.5)),
		layout = "horizontal",
		labelFont = native.systemFont,
		fillColor = { 0, 0.46, 1 },
		labelColor = { 1, 1, 1 },
		labelColorOff = { 0.41, 0.03, 0.49 },
		callBack = mui.actionForToolbarDemo,
		sliderColor = { 1, 1, 1 },
		list = {
			{ key = "Home", value = "1", icon="home", labelText="Home", isActive = true },
			{ key = "Newsroom", value = "2", icon="new_releases", labelText="News", isActive = false },
			{ key = "Location", value = "3", icon="location_searching", labelText="Location", isActive = false },
			{ key = "To-do", value = "4", icon="view_list", labelText="To-do", isActive = false },
			-- { key = "Viewer", value = "4", labelText="View", isActive = false } -- uncomment to see View as text
		}
	})
	]]
end

function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then


    	--[[
		print("building")

		local sheetName = "isotiles"
		local sheetInfo = require("sprites."..sheetName)
		local imageSheet = graphics.newImageSheet("sprites/"..sheetName..".png", sheetInfo:getSheet())

		local tileInfo = require("TileInfo")

		-- 9x9 beaches with Group
		self.beachGroup = display.newGroup()
		sceneGroup:insert(self.beachGroup)
		self.beaches = {}
		for i = 3, 1, -1 do
			self.beaches[i] = {}
			for j = 1, 3 do
				self.beaches[i][j] = display.newSprite(imageSheet, {frames={sheetInfo:getFrameIndex("90")}})
				self.beachGroup:insert(self.beaches[i][j])		
				self.beaches[i][j].x = -tileInfo.width	+ (i-1)*tileInfo.width/2	+ (j-1)*tileInfo.width/2
				self.beaches[i][j].y = 0				+ -(i-1)*tileInfo.height/2	+ (j-1)*tileInfo.height/2
			end
		end
		self.beachGroup.x = display.contentCenterX
		self.beachGroup.y = display.contentCenterY    
		]]

    elseif ( phase == "did" ) then
		
		
    end
end


function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
		print("cleaning")
        --[[
        self.beachGroup:removeSelf()
		self.beaches = nil
		]]
    elseif ( phase == "did" ) then

    end
end


function scene:destroy( event )

    local sceneGroup = self.view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene