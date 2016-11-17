local Layer = require("Layer")

local GameConfig = require("GameConfig")

local DemoContainer = {}


DemoContainer.new = function(w, h)
	local container = display.newContainer(w, h)

	local layerGroup = display.newGroup()
	
	local sky = Layer.new()
	sky.x = 0
	sky.y = GameConfig.layOffset + -GameConfig.gapHeight
	sky:scale(GameConfig.layerScale, GameConfig.layerScale)
	layerGroup:insert(sky)
	
	local ground = Layer.new()
	ground.x = 0
	ground.y = GameConfig.layOffset
	ground:scale(GameConfig.layerScale, GameConfig.layerScale)
	layerGroup:insert(ground)
	
	local underground = Layer.new()
	underground.x = 0
	underground.y = GameConfig.layOffset + GameConfig.gapHeight
	underground:scale(GameConfig.layerScale, GameConfig.layerScale)
	layerGroup:insert(underground)
	
	layerGroup.x = 0
	layerGroup.y = 0
	container:insert(layerGroup)
	
	return container
end

return DemoContainer