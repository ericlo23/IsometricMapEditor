local widget = require("widget")

local GridContainer = require("ui.GridContainer")

local GameConfig = require("GameConfig")

local ControlBar = {}

ControlBar.new = function(width, height)

	local bar = GridContainer.new({
		maxW = width,
		maxH = height,
		rows = 1,
		cols = 5,
		gapSize = 1
	})

	bar.btnEraser = widget.newButton({
		label="Eraser",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		fontSize = 10,
		onEvent = function(event)
					
		end,
		shape = "roundedRect",
		width = bar.gridW,
		height = GameConfig.controlBtnHeight,
		fillColor = { default={1,1,1,0.3}, over={1,1,1,0.1} },
	})
	
	bar:insertAt(bar.btnEraser, 1, 5)

	return bar
end


return ControlBar
