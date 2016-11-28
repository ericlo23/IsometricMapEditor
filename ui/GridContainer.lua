local json = require("json")

local GridContainer = {}

--[[
options = {
	cols = ,
	rows = ,
	gridW = ,
	gridH = ,
	maxW = ,
	maxH =
}
]]
GridContainer.new = function(options)
	if not options then
		return nil
	end

	local g = display.newGroup()

	g.gapSize = options.gapSize or 0

	if not (options.maxW and options.maxH) then
		if not (options.rows and options.cols) or not (options.gridW and options.gridH) then
			print("require rows and cols or gridW and gridH")
			return nil
		end
		g.maxW = options.cols * (options.gridW + g.gapSize) - g.gapSize
		g.maxH = options.rows * (options.gridH + g.gapSize) - g.gapSize
		g.numCols = options.cols
		g.numRows = options.rows
		g.gridW = options.gridW
		g.gridH = options.gridH
	elseif not (options.rows and options.cols) then
		if not (options.maxW and options.maxH) or not (options.gridW and options.gridH) then
			return nil
		end
		g.maxW = options.maxW
		g.maxH = options.maxH
		g.numCols = (options.maxW + g.gapSize) / (options.gridW + g.gapSize)
		g.numRows = (options.maxH + g.gapSize) / (options.gridH + g.gapSize)
		g.gridW = options.gridW
		g.gridH = options.gridH
	elseif not (options.gridW and options.gridH) then
		if not (options.rows and options.cols) or not (options.maxW and options.maxH) then
			return nil
		end
		g.maxW = options.maxW
		g.maxH = options.maxH
		g.numCols = options.cols
		g.numRows = options.rows
		g.gridW = (options.maxW - (options.cols - 1) * g.gapSize) / options.cols
		g.gridH = (options.maxH - (options.rows - 1) * g.gapSize) / options.rows
	elseif options.maxW == options.cols * (options.gridW + g.gapSize) - g.gapSize then
		g.maxW = options.maxW
		g.maxH = options.maxH
		g.numCols = options.cols
		g.numRows = options.rows
		g.gridW = options.gridW
		g.gridH = options.gridH
	else
		return nil
	end

	g.realW = g.numCols*(g.gridW+g.gapSize)-g.gapSize
	g.realH = g.numRows*(g.gridH+g.gapSize)-g.gapSize

	--print(json.prettify( g ))

	--[[
	local r = display.newRect( 0, 0, g.realW, g.realH )
	g:insert(r)
	]]
	g.tab = {}
	for i = 1, g.numRows do
		g.tab[i] = {}
		for j = 1, g.numCols do
			g.tab[i][j] = display.newContainer(g.gridW, g.gridH)
			local t = g.tab[i][j]
			--[[
			local rect = display.newRect( 0, 0, g.gridW, g.gridH )
			rect.fill = {1,1,1,0}
			rect.stroke = {1,0,0}
			rect.strokeWidth = 2
			t:insert(rect)
			]]
			t.x = (g.gridW+g.gapSize) * (j-1) - g.realW/2 + (g.gridW)/2
			t.y = (g.gridH+g.gapSize) * (i-1) - g.realH/2 + (g.gridH)/2

			g:insert(t)
		end
	end

	g.oriInsert = g.insert
	g.insert = nil

	function g:insertAt(obj, i, j)
		if obj then
			local t = g.tab[i][j]
			obj.x = 0
			obj.y = 0
			t:insert(obj)
		end
	end

	return g
end

return GridContainer
