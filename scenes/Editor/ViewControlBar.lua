local widget = require("widget")

local GridContainer = require("ui.GridContainer")

local GameConfig = require("GameConfig")

local ControlBar = {}

ControlBar.new = function(width, height, options)
	local upCallback = options and options.upCallback or nil
	local downCallback = options and options.downCallback or nil
	local defaultCallback = options and options.defaultCallback or nil
	local visibleCallback = options and options.visibleCallback or nil

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
			if event.phase == "ended" and upCallback then
				upCallback()
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
			if event.phase == "ended" and downCallback then
				downCallback()
			end
		end,
		shape = "roundedRect",
		width = bar.gridW,
		height = GameConfig.controlBtnHeight,
		fillColor = { default={1,1,1,0.3}, over={1,1,1,0.1} },
	})
	bar.btnDefault = widget.newButton({
		label="DEFAULT",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		fontSize = 10,
		onEvent = function(event)
			if event.phase == "ended" and defaultCallback then
				defaultCallback()
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
			if event.phase == "ended" and visibleCallback then
				visibleCallback()
			end
		end,
		shape = "roundedRect",
		width = bar.gridW,
		height = GameConfig.controlBtnHeight,
		fillColor = { default={1,1,1,0.3}, over={1,1,1,0.1} },
	})
	
	--bar:insertAt(nil, 1, 1)
	bar:insertAt(bar.btnDown, 1, 2)
	bar:insertAt(bar.btnDefault, 1, 3)
	bar:insertAt(bar.btnUp, 1, 4)
	bar:insertAt(bar.btnVisible, 1, 5)

	return bar
end


return ControlBar
