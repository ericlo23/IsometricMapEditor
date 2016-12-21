local MarginGroup = require("ui.MarginGroup")
local LinearGroup = require("ui.LinearGroup")

local Dialog = {}

Dialog.new = function(w, h, text, options)
	local okCallback =		options and options.okCallback or		nil
	local cancelCallback =	options and options.cancelCallback or	nil
	local backgroundColor =	options and options or 					{1,1,1,0.9}
	local stroke =			options and options.stroke or			{1,1,1,0.5}
	local strokeWidth =		options and options.strokeWidth or		1
	local fontSize = 		options and options.fontSize or 		12

	local dialog = display.newGroup()

	local linear = LinearGroup.new({layout=LinearGroup.VERTICAL})

	local btnLinear = LinearGroup.new()

	local panel = display.newRect(0, 0, w, h)
	panel.fill = backgroundColor
	panel.stroke = stroke
	panel.strokeWidth = strokeWidth

	local text = display.newText({
		text = text,
		font = native.systemFont,
		fontSize = fontSize,
	})

	local okBtn = display.newButton({
		label = "Ok",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		fontSize = fontSize,
		onEvent = function(event)
			if okCallback and event.phase == "ended" then
				okCallback()
			end
		end,
		shape = "rect"
		width = w/2,
		height = 24,
		fillColor = { default=backgroundColor, over={1,1,1,0.1} },
	})

	local cancelBtn = display.newButton({
		label = "Cancel",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		fontSize = fontSize,
		onEvent = function(event)
			if cancelCallback and event.phase == "ended" then
				cancelCallback()
			end
		end,
		shape = "rect"
		width = w/2,
		height = 24,
		fillColor = { default=backgroundColor, over={1,1,1,0.1} },
	})

	btnLinear:insert(okBtn)

	dialog:insert(panel)
	dialog:insert(linear)
	dialog:insert(text)



	return dialog
end

return Dialog