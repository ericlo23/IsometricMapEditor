local GameConfig = require("GameConfig")
local TileInfo = require("TileInfo")
local TileBase = {}

TileBase.new = function(options)
    local tile = display.newGroup()

    -- tile polygon
    local vertices = {
        -TileInfo.width/2, 0,
        0, -TileInfo.height/2,
        TileInfo.width/2, 0,
        0, TileInfo.height/2,
    }
    local polygon = display.newPolygon( 0, 0, vertices )
    polygon.fill = {1,1,1,0.3}
    polygon.strokeWidth = 1
    polygon.stroke = {1, 1, 1, 0.8}

    -- tile center
    local c = display.newCircle(0, 0, 2)

    tile:insert(c)
    tile:insert(polygon)

    return tile
end

return TileBase
