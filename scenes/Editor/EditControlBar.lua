local widget = require("widget")

local MarginGroup = require("ui.MarginGroup")
local GridContainer = require("ui.GridContainer")

local GameConfig = require("GameConfig")

local ControlBar = {}

ControlBar.new = function(width, height, options)
	local eraserCallback = options and options.eraserCallback or nil
	local saveCallback = options and options.saveCallback or nil
	local loadCallback = options and options.loadCallback or nil
	local undoCallback = options and options.undoCallback or nil
	local redoCallback = options and options.redoCallback or nil
	local marginSize = options and options.marginSize or 0

	local bar = MarginGroup.new(
		width,
		height,
		{
			marginSize = marginSize,
			marginColor = GameConfig.marginColor
		}
	)

	local container = GridContainer.new({
		maxW = width-2*marginSize,
		maxH = height-2*marginSize,
		rows = 1,
		cols = 5,
		gapSize = 2
	})

	bar.btnSave = widget.newButton({
		label="Save",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		fontSize = 10,
		onEvent = function(event)
			if saveCallback and event.phase == "ended" then
				saveCallback()
			end
		end,
		shape = "rect",
		width = container.gridW,
		height = container.gridH,
		fillColor = { default={1,1,1,0.3}, over={1,1,1,0.1} },
	})

	bar.btnLoad = widget.newButton({
		label="Load",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		fontSize = 10,
		onEvent = function(event)
			if loadCallback and event.phase == "ended" then
				loadCallback()
			end
		end,
		shape = "rect",
		width = container.gridW,
		height = container.gridH,
		fillColor = { default={1,1,1,0.3}, over={1,1,1,0.1} },
	})

	bar.btnUndo = widget.newButton({
		label="Undo",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		fontSize = 10,
		onEvent = function(event)
			if undoCallback and event.phase == "ended" then
				undoCallback()
			end
		end,
		shape = "rect",
		width = container.gridW,
		height = container.gridH,
		fillColor = { default={1,1,1,0.3}, over={1,1,1,0.1} },
	})

	bar.btnRedo = widget.newButton({
		label="Redo",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		fontSize = 10,
		onEvent = function(event)
			if redoCallback and event.phase == "ended" then
				redoCallback()
			end
		end,
		shape = "rect",
		width = container.gridW,
		height = container.gridH,
		fillColor = { default={1,1,1,0.3}, over={1,1,1,0.1} },
	})

	bar.btnEraser = widget.newButton({
		label="Eraser",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		fontSize = 10,
		onEvent = function(event)
			if eraserCallback and event.phase == "ended" then
				eraserCallback()
			end
		end,
		shape = "rect",
		width = container.gridW,
		height = container.gridH,
		fillColor = { default={1,1,1,0.3}, over={1,1,1,0.1} },
	})
	
	container:insertAt(bar.btnSave, 1, 1)
	container:insertAt(bar.btnLoad, 1, 2)
	container:insertAt(bar.btnUndo, 1, 3)
	container:insertAt(bar.btnRedo, 1, 4)
	container:insertAt(bar.btnEraser, 1, 5)

	bar:insert(container)

	return bar
end


return ControlBar
