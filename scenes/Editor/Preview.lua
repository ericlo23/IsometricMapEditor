local Layer = require("scenes.Editor.Layer")
local GameConfig = require("GameConfig")

local Preview = {}

Preview.LAYER_SKY = 1
Preview.LAYER_GROUND = 0
Preview.LAYER_UNDERGROUND = -1

Preview.new = function(w, h, options)
	local container = display.newContainer(w, h)

	local world = display.newGroup()

	-- Layers
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

	container.world = world
	container:insert(world)

	function container:changeCenter(layerIdx)
		if layerIdx == Preview.LAYER_SKY then
			self.world.x = self.world.sky.x
			self.world.y = self.world.sky.y
		elseif layerIdx == Preview.LAYER_GROUND then
			self.world.x = self.world.ground.x
			self.world.y = self.world.ground.y
		elseif layerIdx == Preview.LAYER_UNDERGROUND then
			self.world.x = self.world.underground.x
			self.world.y = self.world.underground.y
		end
		self.world.x = -self.world.x * self.currentScale + GameConfig.previewOffsetX
		self.world.y = -self.world.y * self.currentScale + GameConfig.previewOffsetY
	end

	function container:zoomIn()
		print("zoom in")
		self.currentScale = self.currentScale + GameConfig.previewScaleStep
		self.world.xScale = self.currentScale
		self.world.yScale = self.currentScale
		self:changeCenter(self.currentLayer)
	end

	function container:zoomOut()
		print("zoom out")
		if math.floor(self.currentScale*100) > math.floor(GameConfig.previewScaleStep*100) then
			self.currentScale = self.currentScale - GameConfig.previewScaleStep
			self.world.xScale = self.currentScale
			self.world.yScale = self.currentScale
			self:changeCenter(self.currentLayer)
		end
	end

	function container:up()
		print("up")
		if self.currentLayer < Preview.LAYER_SKY then
			self.currentLayer = self.currentLayer + 1
			self:changeCenter(self.currentLayer)
		end
	end

	function container:down()
		print("down")
		if self.currentLayer > Preview.LAYER_UNDERGROUND then
			self.currentLayer = self.currentLayer - 1
			self:changeCenter(self.currentLayer)
		end
	end

	function container:reset()
		print("reset")
		self.currentScale = GameConfig.previewScale
		self.currentLayer = Preview.LAYER_GROUND
		self:changeCenter(self.currentLayer)
		self.world.xScale = GameConfig.previewScale
		self.world.yScale = GameConfig.previewScale
	end

	-- Layer layout
	container:reset()

	return container
end

return Preview
