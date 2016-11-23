local widget = require("widget")

local GridContainer = require("ui.GridContainer")

local GameConfig = require("GameConfig")

local ControlBar = {}

ControlBar.new = function(preview, width, height)

	local bar = GridContainer.new({
		maxW = width,
		maxH = height,
		rows = 1,
		cols = 5
	})

	bar.btnUp = widget.newButton({
		label="UP",
		fontSize = 12,
		onEvent = function(event)
				if event.phase == "ended" then
					preview:up()
				end
		end
	})
	bar.btnZoomOut = widget.newButton({
		label="ZOOM\n  OUT",
		fontSize = 10,
		onEvent = function(event)
				if event.phase == "ended" then
					preview:zoomOut()
				end
			end
	})
	bar.btnReset = widget.newButton({
		label="RESET",
		fontSize = 12,
		onEvent = function(event)
				if event.phase == "ended" then
					preview:reset()
				end
			end
	})
	bar.btnZoomIn = widget.newButton({
		label="ZOOM\n   IN",
		fontSize = 10,
		onEvent = function(event)
				if event.phase == "ended" then
					preview:zoomIn()
				end
			end
	})
	bar.btnDown = widget.newButton({
		label="DOWN",
		fontSize = 12,
		onEvent = function(event)
				if event.phase == "ended" then
					preview:down()
				end
			end
	})

	bar:insertAt(bar.btnDown, 1, 1)
	bar:insertAt(bar.btnZoomOut, 1, 2)
	bar:insertAt(bar.btnReset, 1, 3)
	bar:insertAt(bar.btnZoomIn, 1, 4)
	bar:insertAt(bar.btnUp, 1, 5)

	return bar
end


return ControlBar
