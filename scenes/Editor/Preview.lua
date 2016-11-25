local Layer = require("scenes.Editor.Layer")
local GameConfig = require("GameConfig")

local Preview = {}

Preview.LAYER_SKY = 1
Preview.LAYER_GROUND = 0
Preview.LAYER_UNDERGROUND = -1

Preview.new = function(w, h, options)
	local container = display.newContainer(w, h)

	local layerGroup = display.newGroup()

	-- Layers
	local sky = Layer.new("sky", options)
	sky.x = 0
	sky.y = -GameConfig.layerDistance
	layerGroup:insert(sky)
	layerGroup.sky = sky

	local ground = Layer.new("ground", options)
	ground.x = 0
	ground.y = 0
	layerGroup:insert(ground)
	layerGroup.ground = ground

	local underground = Layer.new("underground", options)
	underground.x = 0
	underground.y = GameConfig.layerDistance
	layerGroup:insert(underground)
	layerGroup.underground = underground

	container.layerGroup = layerGroup
	container:insert(layerGroup)

	function container:changeCenter(layerIdx)
		if layerIdx == Preview.LAYER_SKY then
			self.layerGroup.x = self.layerGroup.sky.x
			self.layerGroup.y = self.layerGroup.sky.y
		elseif layerIdx == Preview.LAYER_GROUND then
			self.layerGroup.x = self.layerGroup.ground.x
			self.layerGroup.y = self.layerGroup.ground.y
		elseif layerIdx == Preview.LAYER_UNDERGROUND then
			self.layerGroup.x = self.layerGroup.underground.x
			self.layerGroup.y = self.layerGroup.underground.y
		end
		self.layerGroup.x = -self.layerGroup.x * self.currentScale + GameConfig.previewOffsetX
		self.layerGroup.y = -self.layerGroup.y * self.currentScale + GameConfig.previewOffsetY
	end

	function container:zoomIn()
		print("zoom in")
		self.currentScale = self.currentScale + GameConfig.previewScaleStep
		self.layerGroup.xScale = self.currentScale
		self.layerGroup.yScale = self.currentScale
		self:changeCenter(self.currentLayer)
	end

	function container:zoomOut()
		print("zoom out")
		if math.floor(self.currentScale*100) > math.floor(GameConfig.previewScaleStep*100) then
			self.currentScale = self.currentScale - GameConfig.previewScaleStep
			self.layerGroup.xScale = self.currentScale
			self.layerGroup.yScale = self.currentScale
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
		self.layerGroup.xScale = GameConfig.previewScale
		self.layerGroup.yScale = GameConfig.previewScale
	end

	-- Layer layout
	container:reset()

	return container
end

return Preview
