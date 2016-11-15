local GameConfig = require("GameConfig")

local TileInfo = {}

TileInfo.ratio = 2.0 
--[[ 
ratio = w/h
  w
 ＜＞h
]]
TileInfo.baseWidth = 100
TileInfo.baseHeight = 50

TileInfo.width = TileInfo.baseWidth
TileInfo.height = TileInfo.baseHeight
local currentScale = 0
for k, v in pairs(GameConfig.imageSuffix) do
	if GameConfig.scaleFactor >= v and v >= currentScale then
		TileInfo.width = TileInfo.baseWidth
		TileInfo.height = TileInfo.baseHeight
		currentScale = v
	end
end

return TileInfo