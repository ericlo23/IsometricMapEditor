local GameConfig = require("GameConfig")

local Cursor = {}

Cursor.new = function()
	local cursor = display.newGroup()
	cursor.obj = nil

	function cursor:removeObjIfExist()
	    if self.obj then
	        self:remove(self.obj)
	        self.obj = nil
	    end
	end

	function cursor:setObj(obj, x, y)
	    self.obj = obj
	    self.x = x + GameConfig.cursorOffsetX
	    self.y = y + GameConfig.cursorOffsetY
	    local scale = GameConfig.cursorWidth/self.obj.width
	    self.xScale = scale
	    self.yScale = scale
	    self:insert(obj)
	end

	function cursor:moveTo(x, y)
		self.x = x + GameConfig.cursorOffsetX
		self.y = y + GameConfig.cursorOffsetY
	end

	return cursor
end

return Cursor