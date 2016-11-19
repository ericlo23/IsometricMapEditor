local Layer = require("Layer")

local GameConfig = require("GameConfig")

local DemoContainer = {}


DemoContainer.new = function(w, h)
	local container = display.newContainer(w, h)

	local layerGroup = display.newGroup()
	
	local sky = Layer.new()
	sky.x = 0
	sky.y = GameConfig.layOffset + -GameConfig.gapHeight
	layerGroup:insert(sky)
	layerGroup.sky = sky
	
	local ground = Layer.new()
	ground.x = 0
	ground.y = GameConfig.layOffset
	layerGroup:insert(ground)
	layerGroup.ground = ground
	
	local underground = Layer.new()
	underground.x = 0
	underground.y = GameConfig.layOffset + GameConfig.gapHeight
	layerGroup:insert(underground)
	layerGroup.underground = underground
	
	-- layout
	container.currentScale = GameConfig.layerScale
	layerGroup.x = 0
	layerGroup.y = 0
	layerGroup:scale(GameConfig.layerScale, GameConfig.layerScale)
	container.layerGroup = layerGroup
	
	container:insert(layerGroup)
	
	function container:zoomIn()
		print("zoom in")
		self.currentScale = self.currentScale+0.05
		self.layerGroup.xScale = self.currentScale
		self.layerGroup.yScale = self.currentScale
	end
	
	function container:zoomOut()
		print("zoom out")
		self.currentScale = self.currentScale-0.05
		self.layerGroup.xScale = self.currentScale
		self.layerGroup.yScale = self.currentScale
	end
	
	function container:up()
		print("up")
		self.layerGroup.y = self.layerGroup.y + 10
	end
	
	function container:down()
		print("down")
		self.layerGroup.y = self.layerGroup.y - 10
	end
	
	function container:reset()
		print("reset")
		self.layerGroup.x = 0
		self.layerGroup.y = 0
		container.currentScale = GameConfig.layerScale
		self.layerGroup.xScale = GameConfig.layerScale
		self.layerGroup.yScale = GameConfig.layerScale
	end
	
	return container
end

return DemoContainer