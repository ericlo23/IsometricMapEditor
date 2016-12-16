local widget = require("widget")

local GridContainer = require("ui.GridContainer")

local GameConfig = require("GameConfig")

local ControlBar = {}

ControlBar.new = function(width, height, options)
	local eraserCallback = options and options.eraserCallback or nil
	local saveCallback = options and options.saveCallback or nil
	local loadCallback = options and options.loadCallback or nil
	local undoCallback = options and options.undoCallback or nil
	local redoCallback = options and options.redoCallback or nil

	local bar = GridContainer.new({
		maxW = width,
		maxH = height,
		rows = 1,
		cols = 5,
		gapSize = 1
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
		shape = "roundedRect",
		width = bar.gridW,
		height = GameConfig.controlBtnHeight,
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
		shape = "roundedRect",
		width = bar.gridW,
		height = GameConfig.controlBtnHeight,
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
		shape = "roundedRect",
		width = bar.gridW,
		height = GameConfig.controlBtnHeight,
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
		shape = "roundedRect",
		width = bar.gridW,
		height = GameConfig.controlBtnHeight,
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
		shape = "roundedRect",
		width = bar.gridW,
		height = GameConfig.controlBtnHeight,
		fillColor = { default={1,1,1,0.3}, over={1,1,1,0.1} },
	})
	
	bar:insertAt(bar.btnSave, 1, 1)
	bar:insertAt(bar.btnLoad, 1, 2)
	bar:insertAt(bar.btnUndo, 1, 3)
	bar:insertAt(bar.btnRedo, 1, 4)
	bar:insertAt(bar.btnEraser, 1, 5)

	return bar
end


return ControlBar
