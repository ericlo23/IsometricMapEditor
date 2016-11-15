local composer = require("composer")
local widget = require("widget")

local scene = composer.newScene()

function scene:create( event )

    local sceneGroup = self.view

end

function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
		
		local function handleDemoEvent(event)
			if(event.phase == "ended") then
				composer.gotoScene("scenes.Demo", {
					effect = "fade",
					time = 500,
				})
			end
		end
		
		local function handleEditorEvent(event)
			if(event.phase == "ended") then
				composer.gotoScene("scenes.Editor.Editor", {
					effect = "fade",
					time = 500,
				})
			end
		end
	
		self.btnDemo = widget.newButton({
			id = "demo",
			x = display.contentCenterX,
			y = display.contentCenterY,
			label = "Demo",
			onEvent = handleDemoEvent
		})
		
		self.btnEditor = widget.newButton({
			id = "editor",
			x = display.contentCenterX,
			y = display.contentCenterY+50,
			label = "Editor",
			onEvent = handleEditorEvent
		})
		
		sceneGroup:insert(self.btnDemo)
		sceneGroup:insert(self.btnEditor)
		
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