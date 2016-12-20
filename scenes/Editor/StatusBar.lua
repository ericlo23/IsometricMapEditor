local MarginGroup = require("ui.MarginGroup")
local GridContainer = require("ui.GridContainer")
local GameConfig = require("GameConfig")

local StatusBar = {}

StatusBar.new = function(w, h, options)
	local bar = MarginGroup.new(w, h, options)
	local marginSize = options and options.marginSize or 0
	local marginColor = options and options.marginColor or 0

	local grid = GridContainer.new({
		maxW = w-marginSize*2,
		maxH = h-marginSize*2,
		cols = 6,
		rows = 1,
		gapSize = 2,
		backgroundColor = {1,1,1,0.5}
	})

	bar.universeSize = display.newText({
		text = "",
		x = 0,
		y = 0,
		width = grid.gridW,
		height = grid.gridH,
		font = native.systemFont,
		fontSize = GameConfig.fontSize,
		align = "left"
	})

	bar.currentWorld = display.newText({
		text = "",
		x = 0,
		y = 0,
		width = grid.gridW,
		height = grid.gridH,
		font = native.systemFont,
		fontSize = GameConfig.fontSize,
		align = "left"
	})

	bar.currentLayer = display.newText({
		text = "",
		x = 0,
		y = 0,
		width = grid.gridW,
		height = grid.gridH,
		font = native.systemFont,
		fontSize = GameConfig.fontSize,
		align = "left"
	})

	--local r = display.newRect(0, 0, grid.gridW, grid.gridH)
	--r.fill = GameConfig.backgroundColor
	--grid:insertAt(r, 1, 1)
	
	--r = display.newRect(0, 0, grid.gridW, grid.gridH)
	--r.fill = GameConfig.backgroundColor
	--grid:insertAt(r, 1, 2)



	grid:insertAt(
		display.newText({
			text="Universe Size:",
			x = 0,
			y = 0,
			width = grid.gridW,
			height = grid.gridH,
			font = native.systemFont,
			fontSize = GameConfig.fontSize,
			align = "right"		
		}), 
		1, 
		1
	)
	grid:insertAt(bar.universeSize, 1, 2)

	grid:insertAt(
		display.newText({
			text="Current World:",
			x = 0,
			y = 0,
			width = grid.gridW,
			height = grid.gridH,
			font = native.systemFont,
			fontSize = GameConfig.fontSize,
			align = "right"		
		}), 
		1, 
		3
	)
	grid:insertAt(bar.currentWorld, 1, 4)

	grid:insertAt(
		display.newText({
			text="Current Layer:",
			x = 0,
			y = 0,
			width = grid.gridW,
			height = grid.gridH,
			font = native.systemFont,
			fontSize = GameConfig.fontSize,
			align = "right"		
		}), 
		1, 
		5
	)
	grid:insertAt(bar.currentLayer, 1, 6)

	bar:insert(grid)

	function bar:updateUniverseSize(text)
		self.universeSize.text = text
	end

	function bar:updateCurrentWorld(text)
		self.currentWorld.text = text
	end

	function bar:updateCurrentLayer(text)
		self.currentLayer.text = text
	end

	return bar
end

return StatusBar