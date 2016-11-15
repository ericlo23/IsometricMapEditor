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
	
end

function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
		print("building")
       	--print("display size: "..display.contentWidth.."x"..display.contentHeight)

		local sheetName = "RoadtilesNova"
		local sheetInfo = require("tiles.Wrapped"..sheetName)
		local imageSheet = graphics.newImageSheet("tiles/"..sheetName..".png", sheetInfo:getSheet())

		local tileInfo = require("TileInfo")

		-- 9x9 beaches with Group
		self.beachGroup = display.newGroup()
		sceneGroup:insert(self.beachGroup)
		self.beaches = {}
		for i = 3, 1, -1 do
			self.beaches[i] = {}
			for j = 1, 3 do
				self.beaches[i][j] = display.newSprite(imageSheet, {frames={sheetInfo:getFrameIndex("beach")}})
				self.beachGroup:insert(self.beaches[i][j])		
				self.beaches[i][j].x = -tileInfo.width	+ (i-1)*tileInfo.width/2	+ (j-1)*tileInfo.width/2
				self.beaches[i][j].y = 0				+ -(i-1)*tileInfo.height/2	+ (j-1)*tileInfo.height/2
			end
		end
		self.beachGroup.x = display.contentCenterX
		self.beachGroup.y = display.contentCenterY    


    elseif ( phase == "did" ) then
		
		
    end
end


function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
		print("cleaning")
        self.beachGroup:removeSelf()
		self.beaches = nil

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