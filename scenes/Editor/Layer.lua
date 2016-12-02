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
	layer.boardAlpha = options and options.boardAlpha or GameConfig.boardAlpha

	local title = display.newText({
		text = string.upper(text),
		font = native.systemFont,
		fontSize = 50
	})
	title.fill = {0.4, 0.4, 0.4}
	title.alpha = layer.boardAlpha
	layer.title = title

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
			tileBase.alpha = layer.boardAlpha
			tileBase.callback = layer.callback
			local function touchListener(self, event)
				print("touch on: "..i..","..j)
				if self.callback then
					return self.callback(layer.id, i, j)
				end
				return true
			end
			tileBase.touch = touchListener
			tileBase:addEventListener( "touch", tileBase )
			t.tileBase = tileBase
			t:insert(tileBase)
			layer:insert(t)
		end
	end

	function layer:cleanAt(i, j)
		local t = self.tiles[i][j]
		if t.sprite then
			t:remove(t.sprite)
			t.sprite = nil
		end
	end

	function layer:setTileAt(o, i, j)
		local t = self.tiles[i][j]
		if t.sprite then
			print("remove previous tile")
			t:remove(t.sprite)
			t.sprite = nil
		end
		o.x = 0
		o.y = 0
		t.sprite = o
		t:insert(o)
		o:toBack()
	end

	function layer:toggleBoardVisible()
		local function toggleVisible(obj)
			if obj.alpha == 1 then
				obj.alpha = 0
			else
				obj.alpha = 1
			end
		end
		toggleVisible(self.title)
		for i = 1, GameConfig.layerSize do
			for j = 1, GameConfig.layerSize do
				toggleVisible(self.tiles[i][j].tileBase)
			end
		end
	end

	return layer
end

return Layer
