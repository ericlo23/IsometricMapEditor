print("display size: "..display.contentWidth.."x"..display.contentHeight)

local lsInfo = require("landscape")
local lsSheet = graphics.newImageSheet("landscape.png", lsInfo:getSheet())

local beach = lsInfo.sheet.frames[lsInfo:getFrameIndex("beach")]

local gridHeight = 80--math.floor(display.contentHeight/65)
local gridWidth = 45--math.floor(display.contentWidth/100)

print("grid size: "..gridWidth.."x"..gridHeight)

local numOfHeight = math.floor(gridHeight) + 1
local numOfWidth = math.floor(gridWidth) + 1 

local grids = {}

for i = 0, numOfHeight-1 do
	grids[i] = {}
	for j = 0, numOfWidth-1 do
		grids[i][j] = display.newSprite(lsSheet, {frames={lsInfo:getFrameIndex("beach")}})
		grids[i][j].x = i * gridHeight
		grids[i][j].y = j * gridWidth
		print("grid ("..i..","..j..") at ("..grids[i][j].x..", "..grids[i][j].y..")")
	end
end

--print(count .. " beach sprite should be display")






--[[ beach in middle
local beach = display.newSprite(lsSheet, {frames={lsInfo:getFrameIndex("beach")}})

beach.x = display.contentCenterX
beach.y = display.contentCenterY
]]

--[[ hello corona
print("Hello, Corona!")
local text = display.newText({
    text = "Hello Corona",
    font = native.systemFontBold,
    fontSize = 32,
    x = display.contentCenterX,
    y = display.contentCenterY,
})
text.fill = {0, 0, 1}
]]
