local composer = require( "composer" )
local json = require("json")

local Sprite = require("sprites.Sprite")
local isotiles = require("sprites.isotiles")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------




-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

end

function scene:loadSprites()
    self.sprites = {}
    self.outlines = {}
    local imgSheet = Sprite[self.set]:getSheet()
    local len = #(isotiles.sheet.frames)
    for i = 1, len do
        local name = tostring(i)
        -- sprites
        local s = Sprite[self.set].new(name)
        self.sprites[i] = s
        self.view:insert(self.sprites[i])
        -- outlines and polygons
        self.outlines[i] = graphics.newOutline(1, imgSheet, i)
        local p = display.newPolygon(0, 0, self.outlines[i])
        self.view:insert(p)
        p:toBack()
    end
end

-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then     
        self.view.x = display.contentCenterX
        self.view.y = display.contentCenterY

        self.set = "isotiles"
        self:loadSprites()
        
    elseif ( phase == "did" ) then
    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

    end
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

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