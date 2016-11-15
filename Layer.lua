local TileInfo = require("TileInfo")
local GameConfig = require("GameConfig")

local Layer = {}

--[[ 
m: numbers
n: numbers

		/\         |
   m   /  \  n     |
	  /    \       |
	 /      \      |
	/        \   size
	\        /     |
	 \      /      |
	  \    /       |
	   \  /        |
		\/         |
		
	--size---
]]

Layer.new = function()
	local layer = display.newGroup()

	layer.tiles = {}
	
	function layer:setDefaultAt(i, j)
		local t = self.tiles[i][j]
		if(t.numChildren ~= 0) then
			self:cleanAt(i, j)
		end
		local g = display.newGroup()
		g.x = 0
		g.y = 0
		local c = display.newCircle(0, 0, 2)
		c.x = 0
		c.y = 0
		
		--[[
		local l = display.newLine(
				-TileInfo.width/2, 0, 0, TileInfo.height/2, -- left bottom
				TileInfo.width/2, 0, 0, TileInfo.height/2, -- right bottom
				-TileInfo.width/2, 0, 0, -TileInfo.height/2, -- left top
				TileInfo.width/2, 0, 0, -TileInfo.height/2 -- right top
			)
		]]
		local l = nil
		if j == 1 and i == GameConfig.layerSize then
		
			l = display.newLine(
				-TileInfo.width/2, 0, 0, TileInfo.height/2, -- left bottom
				TileInfo.width/2, 0, 0, TileInfo.height/2, -- right bottom
				-TileInfo.width/2, 0, 0, -TileInfo.height/2, -- left top
				TileInfo.width/2, 0, 0, -TileInfo.height/2 -- right top
			)
		elseif j == 1 and i ~= GameConfig.layerSize then
			l = display.newLine(
				-TileInfo.width/2, 0, 0, TileInfo.height/2, -- left bottom
				TileInfo.width/2, 0, 0, TileInfo.height/2, -- right bottom
				-TileInfo.width/2, 0, 0, -TileInfo.height/2 -- left top
			)
		elseif j ~= 1 and i == GameConfig.layerSize then
			l = display.newLine(
				-TileInfo.width/2, 0, 0, TileInfo.height/2, -- left bottom
				TileInfo.width/2, 0, 0, TileInfo.height/2, -- right bottom
				TileInfo.width/2, 0, 0, -TileInfo.height/2 -- right top
			)
		else
			l = display.newLine(
				-TileInfo.width/2, 0, 0, TileInfo.height/2, -- left bottom
				TileInfo.width/2, 0, 0, TileInfo.height/2 -- right bottom
			)
		end
		g:insert(l)
		g:insert(c)
		t:insert(g)
	end
	
	function layer:cleanAt(i, j)
		local t = self.tiles[i][j]
		if(t.numChildren == 0) then
			print("warning! tile is already empty")
		end
		for i = 1, t.numChildren do
			t:remove(1)
		end
	end
	
	function layer:setTileAt(o, i, j)
		local t = self.tiles[i][j]
		if(t.numChildren ~= 0) then
			self:cleanAt(i, j)
		end
		o.x = 0
		o.y = 0
		t:insert(o)
	end
	
	for i = 1, GameConfig.layerSize do
		layer.tiles[i] = {}
		for j = 1, GameConfig.layerSize do
			layer.tiles[i][j] = display.newGroup()
			local t = layer.tiles[i][j]
			-- position: isometric increase + OFFSET
			t.x = (i-1)*TileInfo.width/2	+ (j-1)*TileInfo.width/2	+ -TileInfo.width*(GameConfig.layerSize-1)/2
			t.y = -(i-1)*TileInfo.height/2	+ (j-1)*TileInfo.height/2	+ 0
			layer:setDefaultAt(i, j)
			layer:insert(t)
		end
	end

	return layer
end

return Layer