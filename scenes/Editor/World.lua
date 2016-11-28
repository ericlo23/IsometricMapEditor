local GameConfig = require("GameConfig")

local Layer = require("scenes.Editor.Layer")

local World = {}

World.LAYER_SKY = 1
World.LAYER_GROUND = 0
World.LAYER_UNDERGROUND = -1

World.new = function(options)
	local world = display.newGroup()
	local boardAlpha = options and options.boardAlpha or GameConfig.boardAlpha

	local sky = Layer.new("sky", options)
	sky.x = 0
	sky.y = -GameConfig.layerDistance
	world:insert(sky)
	world.sky = sky

	local ground = Layer.new("ground", options)
	ground.x = 0
	ground.y = 0
	world:insert(ground)
	world.ground = ground

	local underground = Layer.new("underground", options)
	underground.x = 0
	underground.y = GameConfig.layerDistance
	world:insert(underground)
	world.underground = underground

	function world:toggleBoardVisible()
		self.sky:toggleBoardVisible()
		self.ground:toggleBoardVisible()
		self.underground:toggleBoardVisible()
	end

	return world
end

return World