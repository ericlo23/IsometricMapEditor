local GameConfig = require("GameConfig")

local World = require("scenes.Editor.World")

local Preview = {}

Preview.new = function(w, h, options)
	local container = display.newContainer(w, h)

	local world = World.new(options)
	container.world = world
	container:insert(world)

	function container:toggleBoardVisible()
		self.world:toggleBoardVisible()
	end

	function container:changeCenter(layerIdx)
		if layerIdx == World.LAYER_SKY then
			self.world.x = self.world.sky.x
			self.world.y = self.world.sky.y
		elseif layerIdx == World.LAYER_GROUND then
			self.world.x = self.world.ground.x
			self.world.y = self.world.ground.y
		elseif layerIdx == World.LAYER_UNDERGROUND then
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
		if self.currentLayer < World.LAYER_SKY then
			self.currentLayer = self.currentLayer + 1
			self:changeCenter(self.currentLayer)
		end
	end

	function container:down()
		print("down")
		if self.currentLayer > World.LAYER_UNDERGROUND then
			self.currentLayer = self.currentLayer - 1
			self:changeCenter(self.currentLayer)
		end
	end

	function container:default()
		print("default")
		self.currentScale = GameConfig.previewScale
		self.currentLayer = World.LAYER_GROUND
		self:changeCenter(self.currentLayer)
		self.world.xScale = GameConfig.previewScale
		self.world.yScale = GameConfig.previewScale
	end

	-- Layer layout
	container:default()

	return container
end

return Preview
