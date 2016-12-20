local Cursor = {}

Cursor.new = function(offsetX, offsetY)
	local cursor = display.newGroup()
	cursor.obj = nil
	cursor.offsetX = offsetX
	cursor.offsetY = offsetY

	function cursor:removeObjIfExist()
	    if self.obj then
	        self:remove(self.obj)
	        self.obj = nil
	    end
	end

	function cursor:setObj(obj, x, y, scale)
	    self.obj = obj
	    self.x = x + self.offsetX
	    self.y = y + self.offsetY
	    self.xScale = scale
	    self.yScale = scale

	    self:insert(obj)
	end

	function cursor:moveTo(x, y)
		self.x = x + self.offsetX
		self.y = y + self.offsetY
	end

	return cursor
end

return Cursor