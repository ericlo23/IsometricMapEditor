local GameConfig = require("GameConfig")

local TileInfo = require("TileInfo")
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
		return self.universe:getWorld(self.currentWorldId)
	end

	function preview:toggleBoardVisible()
		self.universe:toggleBoardVisible()
	end

	function preview:changeCenter(x, y, preScale)
		if preScale == 0 then
			return
		end
		self.universe.x = x * self.currentScale / preScale
		self.universe.y = y * self.currentScale / preScale
	end

	function preview:changeCenterToLayer(worldIdx, layerIdx)
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
		self:changeCenter(-layer.x, -layer.y, 1)
		self.universe.x  = self.universe.x + GameConfig.previewOffsetX
		self.universe.y  = self.universe.y + GameConfig.previewOffsetY
	end

	function preview:zoomIn()
		print("zoom in")
		local preScale = self.currentScale
		self.currentScale = self.currentScale + GameConfig.previewScaleStep
		self:changeCenter(self.universe.x, self.universe.y, preScale)
		self.universe.xScale = self.currentScale
		self.universe.yScale = self.currentScale
	end

	function preview:zoomOut()
		print("zoom out")
		if math.floor(self.currentScale*100) > math.floor(GameConfig.previewScaleStep*100) then
			local preScale = self.currentScale
			self.currentScale = self.currentScale - GameConfig.previewScaleStep
			self:changeCenter(self.universe.x, self.universe.y, preScale)
			self.universe.xScale = self.currentScale
			self.universe.yScale = self.currentScale
		end
	end

	function preview:up()
		print("up")
		if self.currentLayer < World.LAYER_SKY then
			self.currentLayer = self.currentLayer + 1
			self:changeCenterToLayer(self.currentWorldId, self.currentLayer)
		end
	end

	function preview:down()
		print("down")
		if self.currentLayer > World.LAYER_UNDERGROUND then
			self.currentLayer = self.currentLayer - 1
			self:changeCenterToLayer(self.currentWorldId, self.currentLayer)
		end
	end

	function preview:default()
		print("default")
		self.currentScale = GameConfig.previewScale
		self.currentWorldId = 1
		self.currentLayer = World.LAYER_GROUND
		self:changeCenterToLayer(self.currentWorldId, self.currentLayer)
		self.universe.xScale = GameConfig.previewScale
		self.universe.yScale = GameConfig.previewScale
	end

	-- Layer layout
	preview:default()

	function preview:move(distX, distY)
		-- check layer center in bound
		local x = self.universe.x + distX * GameConfig.previewMoveFactor
		local y = self.universe.y + distY * GameConfig.previewMoveFactor
		-- calculate bounds
		local firstWorld = self.universe[1]
		local lastWorld = self.universe[self.universe.size]
		local topBound = -(firstWorld.x+firstWorld.width/2-TileInfo.width/2)*self.currentScale
		local bottomBound = (lastWorld.x+lastWorld.width/2-TileInfo.width/2)*self.currentScale
		local leftBound = -(firstWorld.height/2-TileInfo.height/2)*self.currentScale
		local rightBound = (firstWorld.height/2-TileInfo.height/2)*self.currentScale
		-- change location if inside bounds
		if x > topBound and x < bottomBound and y > leftBound and y < rightBound then
			self.universe.x = x
			self.universe.y = y
			-- set currentLayer as closest layer to center
			local skyDist= math.abs(self:getCurrentWorld().sky.y*self.currentScale+y)
			local groundDist = math.abs(self:getCurrentWorld().ground.y*self.currentScale+y)
			local undergroundDist = math.abs(self:getCurrentWorld().underground.y*self.currentScale+y)
			if skyDist < groundDist and skyDist < undergroundDist then
				self.currentLayer = World.LAYER_SKY
			elseif groundDist < skyDist and groundDist < undergroundDist then
				self.currentLayer = World.LAYER_GROUND
			elseif undergroundDist < skyDist and undergroundDist < groundDist then
				self.currentLayer = World.LAYER_UNDERGROUND
			end
		end
	end

	preview.preTouchX = nil
	preview.preTouchY = nil
	preview.touch = function(self, event)
		if ( event.phase == "began" ) then
			display.getCurrentStage():setFocus(self)
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
			display.getCurrentStage():setFocus(nil)
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