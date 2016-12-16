local MarginGroup = {}

MarginGroup.new = function(w, h, options)
	local group = display.newGroup()
	local marginSize = options and options.marginSize or 1
	local marginColor = options and options.marginColor or {1,1,1,1}

	group.margin = display.newRect(0, 0, w-2*marginSize, h-2*marginSize)
	group.margin.fill = {1,1,1,0}
	group:insert(group.margin)

	function group:setSize(size)
		self.margin.strokeWidth = size
	end

	function group:setColor(color)
		self.margin.stroke = color
	end

	group:setSize(marginSize)
	group:setColor(marginColor)

	return group
end

return MarginGroup