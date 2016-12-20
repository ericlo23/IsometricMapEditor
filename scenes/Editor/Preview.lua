local GameConfig = require("GameConfig")

local TileInfo = require("TileInfo")
local World = require("scenes.Editor.World")
local Universe = require("scenes.Editor.Universe")

local Preview = {}

Preview.new = function(w, h, options)
	local moveBegin = options and options.moveBegin or nil
	local moving = options and options.moving or nil
	local moveEnd = options and options.moveEnd or nil
	local updateStatus = options and options.updateStatus or nil

	local preview = display.newContainer(w, h)
	preview.universe = Universe.new()
	preview.currentWorldId = 0

	-- make preview touchable
	local rect = display.newRect(0, 0, w, h)
	rect.fill = {1,1,1,0}
	rect.isHitTestable = true
	preview:insert(rect)
	preview:insert(preview.universe)

	function preview:setCurrentLayer(id)
		self.currentLayer = id
		if updateStatus then
			local layerString = ""
			if self.currentLayer == World.LAYER_SKY then
				layerString = layerString.."SKY"
			elseif self.currentLayer == World.LAYER_GROUND then
				layerString = layerString.."GROUND"
			elseif self.currentLayer == World.LAYER_UNDERGROUND then
				layerString = layerString.."UNDERGROUND"
			end
			layerString = layerString
			updateStatus(nil, layerString)
		end
	end

	function preview:setCurrentWorld(id)
		self.currentWorldId = id
		if updateStatus then
			local worldString = tostring(self.currentWorldId)..", "..self:getCurrentWorld().name
			updateStatus(worldString, nil)
		end
	end	

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
		self:changeCenter(-world.x-layer.x, -world.y-layer.y, 1)
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

	function preview:left()
		if self.currentWorldId > 1 then
			self:setCurrentWorld(self.currentWorldId - 1)
			self:changeCenterToLayer(self.currentWorldId, self.currentLayer)
		end
	end

	function preview:right()
		if self.currentWorldId < self.universe.size then
			self:setCurrentWorld(self.currentWorldId + 1)
			self:changeCenterToLayer(self.currentWorldId, self.currentLayer)
		end
	end

	function preview:up()
		print("up")
		if self.currentLayer < World.LAYER_SKY then
			self:setCurrentLayer(self.currentLayer + 1)
			self:changeCenterToLayer(self.currentWorldId, self.currentLayer)
		end
	end

	function preview:down()
		print("down")
		if self.currentLayer > World.LAYER_UNDERGROUND then
			self:setCurrentLayer(self.currentLayer - 1)
			self:changeCenterToLayer(self.currentWorldId, self.currentLayer)
		end
	end

	function preview:default(idx)
		print("default")
		self.currentScale = GameConfig.previewScale
		if self.universe.size ~= 0 then
			if idx and idx > 0 and idx <= self.universe.size then
				self:setCurrentWorld(idx)
			else
				self:setCurrentWorld(1)
			end
			self:setCurrentLayer(World.LAYER_GROUND)
			self:changeCenterToLayer(self.currentWorldId, self.currentLayer)
			self.universe.xScale = GameConfig.previewScale
			self.universe.yScale = GameConfig.previewScale
		end
	end

	-- Layer layout
	--preview:default()

	function preview:move(distX, distY)
		--print(distX, distY)
		if self.universe.size == 0 then
			return
		end
		-- check layer center in bound
		local x = self.universe.x + distX * GameConfig.previewMoveFactor
		local y = self.universe.y + distY * GameConfig.previewMoveFactor
		-- calculate bounds
		local firstWorld = self.universe:getWorld(1)
		local lastWorld = self.universe:getWorld(self.universe.size)
		local leftBound = -(firstWorld.x+firstWorld.width/2-TileInfo.width/2)*self.currentScale
		local rightBound = (lastWorld.x+lastWorld.width/2-TileInfo.width/2)*self.currentScale
		local topBound = -(firstWorld.height/2-TileInfo.height/2)*self.currentScale
		local bottomBound = (firstWorld.height/2-TileInfo.height/2)*self.currentScale
		-- change location if inside bounds
		if -x > leftBound and -x < rightBound and -y > topBound and -y < bottomBound then
			local previewX, previewY = self:localToContent(0, 0)
			self.universe.x = x
			self.universe.y = y
			-- set currentLayer as closest layer to center
			local groundX, groundY = self:getCurrentWorld().ground:localToContent(0, 0)
			local groundDist = math.abs(groundY-previewY)
			local skyX, skyY = self:getCurrentWorld().sky:localToContent(0, 0)
			local skyDist = math.abs(skyY-previewY)
			local undergroundX, undergroundY = self:getCurrentWorld().underground:localToContent(0, 0)
			local undergroundDist = math.abs(undergroundY-previewY)
			if distY < 0 then
				if self.currentLayer == World.LAYER_GROUND and groundDist > undergroundDist then
					self:setCurrentLayer(World.LAYER_UNDERGROUND)
					print("set current layer:", self.currentLayer)
				elseif self.currentLayer == World.LAYER_SKY and skyDist > groundDist then
					self:setCurrentLayer(World.LAYER_GROUND)
					print("set current layer:", self.currentLayer)
				end
			elseif distY > 0 then
				if self.currentLayer == World.LAYER_GROUND and skyDist < groundDist then
					self:setCurrentLayer(World.LAYER_SKY)
					print("set current layer:", self.currentLayer)
				elseif self.currentLayer == World.LAYER_UNDERGROUND and groundDist < undergroundDist then
					self:setCurrentLayer(World.LAYER_GROUND)
					print("set current layer:", self.currentLayer)
				end
			end

			local currentWorldX, currentWorldY = self.universe:getWorld(self.currentWorldId):localToContent(0, 0)
			local currentDist = math.abs(currentWorldX - previewX)
			--print("c", currentDist)
			if distX < 0 and self.currentWorldId < self.universe.size then
				local rightWorldX, rightWorldY = self.universe:getWorld(self.currentWorldId+1):localToContent(0, 0)
				local rightDist = math.abs(rightWorldX - previewX)
				--print("r", rightDist)
				if currentDist > rightDist then
					self:setCurrentWorld(self.currentWorldId+1)
					print("set current world:", self.currentWorldId)
				end
			elseif distX > 0 and self.currentWorldId > 1 then
				local leftWorldX, leftWorldY = self.universe:getWorld(self.currentWorldId-1):localToContent(0, 0)
				local leftDist = math.abs(leftWorldX - previewX)
				--print("l", leftDist)
				if currentDist > leftDist then
					self:setCurrentWorld(self.currentWorldId-1)
					print("set current world:", self.currentWorldId)
				end
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