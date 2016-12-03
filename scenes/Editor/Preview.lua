local GameConfig = require("GameConfig")

local World = require("scenes.Editor.World")
local Universe = require("scenes.Editor.Universe")

local Preview = {}

Preview.new = function(w, h, options)
	local moveBegin = options and options.moveBegin or nil
	local moving = options and options.moving or nil
	local moveEnd = options and options.moveEnd or nil

	local preview = display.newContainer(w, h)
	local universe = Universe.new()
	universe:addWorld(World.new(options))
	preview.universe = universe

	-- make preview touchable
	local rect = display.newRect(0, 0, w, h)
	rect.fill = {1,1,1,0}
	rect.isHitTestable = true
	preview:insert(rect)
	preview:insert(universe)

	function preview:getCurrentWorld()
		return self.universe:getWorld(self.currentWorld)
	end

	function preview:toggleBoardVisible()
		self.universe:toggleBoardVisible()
	end

	function preview:changeCenter(worldIdx, layerIdx)
		local world = self.universe:getWorld(worldIdx)
		local layer = nil
		if layerIdx == World.LAYER_SKY then
			layer = world.sky
		elseif layerIdx == World.LAYER_GROUND then
			layer = world.ground
		elseif layerIdx == World.LAYER_UNDERGROUND then
			layer = world.underground
		else
			print("invalid layer index")
			return
		end
		universe.x = -layer.x * self.currentScale + GameConfig.previewOffsetX
		universe.y = -layer.y * self.currentScale + GameConfig.previewOffsetY
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

	function preview:move(distX, distY)
		self.universe.x = self.universe.x + distX * GameConfig.previewMoveFactor
		self.universe.y = self.universe.y + distY * GameConfig.previewMoveFactor
	end

	preview.preTouchX = nil
	preview.preTouchY = nil
	preview.touch = function(self, event)
		if ( event.phase == "began" ) then
			preview.preTouchX = event.x
			preview.preTouchY = event.y
			if moveBegin then
				moveBegin()
			end
		elseif ( event.phase == "moved" ) then
			if moving and preview.preTouchX and preview.preTouchY then
				moving(event.x-preview.preTouchX, event.y-preview.preTouchY)
			end
			preview.preTouchX = event.x
			preview.preTouchY = event.y
		elseif ( event.phase == "ended" ) then
			if moveEnd then
				moveEnd()
			end
		end

		return true
	end
	preview:addEventListener("touch", preview)

	return preview
end

return Preview