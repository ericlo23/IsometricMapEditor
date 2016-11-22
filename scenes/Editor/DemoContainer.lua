local Layer = require("Layer")

local GameConfig = require("GameConfig")

local DemoContainer = {}

DemoContainer.LAYER_SKY = 1
DemoContainer.LAYER_GROUND = 0
DemoContainer.LAYER_UNDERGROUND = -1

DemoContainer.new = function(w, h)
	local container = display.newContainer(w, h)

	local layerGroup = display.newGroup()

	-- Layers
	local sky = Layer.new("SKY")
	sky.x = 0
	sky.y = -GameConfig.layerGap
	layerGroup:insert(sky)
	layerGroup.sky = sky

	local ground = Layer.new("GROUND")
	ground.x = 0
	ground.y = 0
	layerGroup:insert(ground)
	layerGroup.ground = ground

	local underground = Layer.new("UNDERGROUND")
	underground.x = 0
	underground.y = GameConfig.layerGap
	layerGroup:insert(underground)
	layerGroup.underground = underground

	container.layerGroup = layerGroup
	container:insert(layerGroup)

	function container:zoomIn()
		print("zoom in")
		self.currentScale = self.currentScale + GameConfig.previewScaleStep
		self.layerGroup.xScale = self.currentScale
		self.layerGroup.yScale = self.currentScale
		self:changeCenter(self.currentLayer)
	end

	function container:zoomOut()
		print("zoom out")
		print("<--")
		print(self.currentScale)
		print(GameConfig.previewScaleStep)
		print(self.currentScale > GameConfig.previewScaleStep)
		if self.currentScale > GameConfig.previewScaleStep then
			self.currentScale = self.currentScale - GameConfig.previewScaleStep
			self.layerGroup.xScale = self.currentScale
			self.layerGroup.yScale = self.currentScale
			self:changeCenter(self.currentLayer)
			print("zoom out")
		end
		print("-->")
	end

	function container:changeCenter(layerIdx)
		if layerIdx == DemoContainer.LAYER_SKY then
			self.layerGroup.x = self.layerGroup.sky.x
			self.layerGroup.y = self.layerGroup.sky.y
		elseif layerIdx == DemoContainer.LAYER_GROUND then
			self.layerGroup.x = self.layerGroup.ground.x
			self.layerGroup.y = self.layerGroup.ground.y
		elseif layerIdx == DemoContainer.LAYER_UNDERGROUND then
			self.layerGroup.x = self.layerGroup.underground.x
			self.layerGroup.y = self.layerGroup.underground.y
		end
		self.layerGroup.x = -self.layerGroup.x * self.currentScale + GameConfig.previewOffsetX
		self.layerGroup.y = -self.layerGroup.y * self.currentScale + GameConfig.previewOffsetY
	end

	function container:up()
		print("up")
		if self.currentLayer < DemoContainer.LAYER_SKY then
			self.currentLayer = self.currentLayer + 1
			self:changeCenter(self.currentLayer)
		end
	end

	function container:down()
		print("down")
		if self.currentLayer > DemoContainer.LAYER_UNDERGROUND then
			self.currentLayer = self.currentLayer - 1
			self:changeCenter(self.currentLayer)
		end
	end

	function container:reset()
		print("reset")
		self.currentScale = GameConfig.previewScale
		self.currentLayer = DemoContainer.LAYER_GROUND
		self:changeCenter(self.currentLayer)
		self.layerGroup.xScale = GameConfig.previewScale
		self.layerGroup.yScale = GameConfig.previewScale
	end

	-- Layer layout
	container:reset()

	return container
end

return DemoContainer
