local SheetInfo = require("tiles.RoadtilesNova")

--[[ 
	SheetInfo:setMeta
	Inputs:
		topLeftY: numbers
		topFrontY: numbers
		topRightY: numbers
	Description:
		Coordinate at left-top of the image.
]]
function SheetInfo:setMeta(name, topLeftY, topFrontY, topRightY)
	local frame = SheetInfo.sheet.frames[SheetInfo:getFrameIndex(name)]
	local halfH = math.ceil(frame.height/2)
	local halfW = math.ceil(frame.width/2)
	frame.meta = {}
	-- fixed or calculatable
	frame.meta.btmLeft		= {x = -halfW,	y = halfH-24}
	frame.meta.btmRight		= {x = halfW,	y = halfH-24}
	frame.meta.btmFront		= {x = 0,		y = halfH}
	frame.meta.topBehind	= {x = 0,		y = -halfH}
	-- non-calculatable
	frame.meta.topLeft		= {x = halfW,	y = topLeftY-halfH}
	frame.meta.topRight		= {x = halfW,	y = topRightY-halfH}
	frame.meta.topFront		= {x = 0,		y = topFrontY-halfH}
end

SheetInfo:setMeta("beach", 25, 50, 25)

return SheetInfo