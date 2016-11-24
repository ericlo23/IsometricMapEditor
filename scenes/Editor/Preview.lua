local json = require("json")

local widget = require("widget")

local Layer = require("scenes.Editor.Layer")
local GameConfig = require("GameConfig")

local Preview = {}

Preview.LAYER_SKY = 1
Preview.LAYER_GROUND = 0
Preview.LAYER_UNDERGROUND = -1

Preview.new = function(w, h)
	--local container = display.newContainer(w, h)

	local container = widget.newScrollView({
        width = w,
        height = h,
        backgroundColor = {0,0,0}
    })

	local layerGroup = display.newGroup()

	-- Layers
	local sky = Layer.new("SKY")
	sky.x = 0
	sky.y = -GameConfig.layerDistance
	layerGroup:insert(sky)
	layerGroup.sky = sky

	local ground = Layer.new("GROUND")
	ground.x = 0
	ground.y = 0
	layerGroup:insert(ground)
	layerGroup.ground = ground

	local underground = Layer.new("UNDERGROUND")
	underground.x = 0
	underground.y = GameConfig.layerDistance
	layerGroup:insert(underground)
	layerGroup.underground = underground

	print(layerGroup.width..","..layerGroup.height)
	print(layerGroup.x..","..layerGroup.y)
	layerGroup.x = layerGroup.width/2
	layerGroup.y = layerGroup.height/2

	local rect = display.newRect( 0, 0, layerGroup.width, layerGroup.height )
	rect.fill = {1,1,1,0.5}
	layerGroup:insert(rect)


	container.layerGroup = layerGroup
	container:insert(layerGroup)
	print(layerGroup.x..","..layerGroup.y)

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
