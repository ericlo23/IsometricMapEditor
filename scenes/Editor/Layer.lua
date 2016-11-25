local string = require("string")

local BaseTile = require("scenes.Editor.BaseTile")

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

Layer.new = function(text, options)
	local layer = display.newGroup()
	layer.id = text
	layer.callback = options and options.callback or nil
	layer.tiles = {}

	local title = display.newText({
		text = string.upper(text),
		font = native.systemFont,
		fontSize = 50
	})
	title.fill = {0.4, 0.4, 0.4}

	layer:insert(title)

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
			--layer.tiles[i][j] = BaseTile.new()
			layer.tiles[i][j] = display.newGroup()
			layer:setTileAt(BaseTile.new(), i, j)
			local t = layer.tiles[i][j]
			-- position: isometrically increase + OFFSET
			t.x = (i-1)*TileInfo.width/2	+ (j-1)*TileInfo.width/2	+ -TileInfo.width*(GameConfig.layerSize-1)/2
			t.y = -(i-1)*TileInfo.height/2	+ (j-1)*TileInfo.height/2	+ 0
			t.callback = layer.callback
			local function tapListener(self, event)
				print("tap on: "..i..","..j)
				if self.callback then
					self.callback(layer.id, i, j)
				end
				return true
			end
			t.tap = tapListener
			t:addEventListener( "tap", t )
			layer:insert(t)
		end
	end

	return layer
end

return Layer
