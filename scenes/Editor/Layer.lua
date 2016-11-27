local string = require("string")

local TileBase = require("scenes.Editor.TileBase")

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

	for i = GameConfig.layerSize, 1, -1 do
		layer.tiles[i] = {}
		for j = 1, GameConfig.layerSize do
			layer.tiles[i][j] = display.newGroup()
			local t = layer.tiles[i][j]
			t.sprite = nil
			-- position: isometrically increase + OFFSET
			t.x = (i-1)*TileInfo.width/2	+ (j-1)*TileInfo.width/2	+ -TileInfo.width*(GameConfig.layerSize-1)/2
			t.y = -(i-1)*TileInfo.height/2	+ (j-1)*TileInfo.height/2	+ 0
			--insert base tile
			local tileBase = TileBase.new()
			tileBase.callback = layer.callback
			local function tapListener(self, event)
				print("tap on: "..i..","..j)
				if self.callback then
					self.callback(layer.id, i, j)
				end
				return true
			end
			tileBase.tap = tapListener
			tileBase:addEventListener( "tap", tileBase )
			t.tileBase = tileBase
			t:insert(tileBase)
			layer:insert(t)
		end
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
		if t.sprite then
			print("remove previous tile")
			t:remove(t.sprite)
		end
		o.x = 0
		o.y = 0
		t.sprite = o
		t:insert(o)
		o:toBack()
	end

	return layer
end

return Layer
