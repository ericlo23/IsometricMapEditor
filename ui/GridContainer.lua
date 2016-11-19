local GridContainer = {}

GridContainer.new = function(maxW, maxH, rows, cols, options)
	local g = display.newGroup()
	
	g.maxWidth = maxW
	g.maxHeight = maxH
	g.numRows = rows
	g.numCols = cols
	g.gapSize = options and options.gapSize or 0

	--g:insert(display.newRect(0, 0, maxW, maxH))
	
	local gridHeight = (g.maxHeight-g.gapSize*(g.numRows-1))/g.numRows
	local gridWidth = (g.maxWidth-g.gapSize*(g.numCols-1))/g.numCols
	
	--[[
	print(g.maxWidth..","..g.maxHeight)
	print(g.numCols..","..g.numRows)
	print(gridWidth..","..gridHeight)
	]]
	
	function g:insertAt(obj, i, j)
		local t = g.tab[i][j]
		if t.numChildren ~= 0 then
			t:remove(1)
		end
		obj.x = 0
		obj.y = 0
		t:insert(obj)
	end	
	
	g.tab = {}
	for i = 1, g.numRows do
		g.tab[i] = {}
		for j = 1, g.numCols do
			
			g.tab[i][j] = display.newContainer(gridWidth, gridHeight)
			local t = g.tab[i][j]
			t.x = (gridWidth+g.gapSize) * (j-1) - g.maxWidth/2 + (gridWidth+g.gapSize)/2
			t.y = (gridHeight+g.gapSize) * (i-1) - g.maxHeight/2 + (gridHeight+g.gapSize)/2
			
			--[[
			--test
			local rect = display.newRect(0, 0, gridWidth, gridHeight)
			local circle = display.newCircle(0, 0, 1)
			rect.fill = {1, 0, 0, 1}
			rect.strokeWidth = 3
			rect:setStrokeColor( 1, 1, 1 )
			circle.fill = {0, 1, 0, 1}
			t:insert(rect)
			t:insert(circle)
			]]
			
			g:insert(t)
			
		end
	end
	
	--[[
	local c = display.newCircle(0, 0, 1)
	c.fill = {0,0,1,1}
	g:insert(c)
	]]
	
	
	g.oriInsert = g.insert
	g.insert = nil
	
	return g
end

return GridContainer