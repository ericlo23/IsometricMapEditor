local GameConfig = require("GameConfig")

local World = require("scenes.Editor.World")
local Universe = require("scenes.Editor.Universe")

local Preview = {}

Preview.new = function(w, h, options)
	local preview = display.newContainer(w, h)
	local universe = Universe.new()

	universe:addWorld(World.new(options))

	preview.universe = universe
	preview:insert(universe)

	function preview:getCurrentWorld()
		return self.universe:getWorld(self.currentWorld)
	end

	function preview:toggleBoardVisible()
		self.universe:toggleBoardVisible()
	end

	function preview:changeCenter(worldIdx, layerIdx)
		local world = self.universe:getWorld(worldIdx)
		if layerIdx == World.LAYER_SKY then
			universe.x = world.sky.x
			universe.y = world.sky.y
		elseif layerIdx == World.LAYER_GROUND then
			universe.x = world.ground.x
			universe.y = world.ground.y
		elseif layerIdx == World.LAYER_UNDERGROUND then
			universe.x = world.underground.x
			universe.y = world.underground.y
		end
		universe.x = -universe.x * self.currentScale + GameConfig.previewOffsetX
		universe.y = -universe.y * self.currentScale + GameConfig.previewOffsetY
	end

	function preview:zoomIn()
		print("zoom in")
		self.currentScale = self.currentScale + GameConfig.previewScaleStep
		self.universe.xScale = self.currentScale
		self.universe.yScale = self.currentScale
		self:changeCenter(self.currentWorld, self.currentLayer)
	end

	function preview:zoomOut()
		print("zoom out")
		if math.floor(self.currentScale*100) > math.floor(GameConfig.previewScaleStep*100) then
			self.currentScale = self.currentScale - GameConfig.previewScaleStep
			self.universe.xScale = self.currentScale
			self.universe.yScale = self.currentScale
			self:changeCenter(self.currentWorld, self.currentLayer)
		end
	end

	function preview:up()
		print("up")
		if self.currentLayer < World.LAYER_SKY then
			self.currentLayer = self.currentLayer + 1
			self:changeCenter(self.currentWorld, self.currentLayer)
		end
	end

	function preview:down()
		print("down")
		if self.currentLayer > World.LAYER_UNDERGROUND then
			self.currentLayer = self.currentLayer - 1
			self:changeCenter(self.currentWorld, self.currentLayer)
		end
	end

	function preview:default()
		print("default")
		self.currentScale = GameConfig.previewScale
		self.currentWorld = 1
		self.currentLayer = World.LAYER_GROUND
		self:changeCenter(self.currentWorld, self.currentLayer)
		self.universe.xScale = GameConfig.previewScale
		self.universe.yScale = GameConfig.previewScale
	end

	-- Layer layout
	preview:default()

	return preview
end

return Preview
