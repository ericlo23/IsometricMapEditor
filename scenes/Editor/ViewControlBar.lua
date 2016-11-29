local widget = require("widget")

local GridContainer = require("ui.GridContainer")

local GameConfig = require("GameConfig")

local ControlBar = {}

ControlBar.new = function(preview, width, height)

	local bar = GridContainer.new({
		maxW = width,
		maxH = height,
		rows = 1,
		cols = 5,
		gapSize = 1
	})

	bar.btnUp = widget.newButton({
		label="UP",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		fontSize = 10,
		onEvent = function(event)
				if event.phase == "ended" then
					preview:up()
				end
		end,
		shape = "roundedRect",
		width = bar.gridW,
		height = GameConfig.controlBtnHeight,
		fillColor = { default={1,1,1,0.3}, over={1,1,1,0.1} },
	})
	bar.btnDown = widget.newButton({
		label="DOWN",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		fontSize = 10,
		onEvent = function(event)
			if event.phase == "ended" then
				preview:down()
			end
		end,
		shape = "roundedRect",
		width = bar.gridW,
		height = GameConfig.controlBtnHeight,
		fillColor = { default={1,1,1,0.3}, over={1,1,1,0.1} },
	})
	bar.btnReset = widget.newButton({
		label="CENTER",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		fontSize = 10,
		onEvent = function(event)
			if event.phase == "ended" then
				preview:reset()
			end
		end,
		shape = "roundedRect",
		width = bar.gridW,
		height = GameConfig.controlBtnHeight,
		fillColor = { default={1,1,1,0.3}, over={1,1,1,0.1} },
	})
	bar.btnVisible = widget.newButton({
		label="VISIBLE",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		fontSize = 10,
		onEvent = function(event)
			if event.phase == "ended" then
				preview:toggleBoardVisible()
			end
		end,
		shape = "roundedRect",
		width = bar.gridW,
		height = GameConfig.controlBtnHeight,
		fillColor = { default={1,1,1,0.3}, over={1,1,1,0.1} },
	})
	
	--bar:insertAt(nil, 1, 1)
	bar:insertAt(bar.btnDown, 1, 2)
	bar:insertAt(bar.btnReset, 1, 3)
	bar:insertAt(bar.btnUp, 1, 4)
	bar:insertAt(bar.btnVisible, 1, 5)

	return bar
end


return ControlBar
