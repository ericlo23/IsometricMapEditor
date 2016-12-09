local sqlite3 = require("sqlite3")

local StatusManager = {}

local Status = {}
StatusManager.Status = Status

Status.new = function(id, universe)
end

local create_tables = [=[
	CREATE TABLE IF NOT EXISTS 
	CREATE TABLE IF NOT EXISTS universe(
		worlds , 
		modified datetime
	);
	CREATE TABLE IF NOT EXISTS world(
		id, 
		culture, 
		sky, 
		ground, 
		underground, 
		charaters, 
		modified datetime
	);
	CREATE TABLE IF NOT EXISTS layer(
		id, 
		type, 
		tiles, 
		modified datetime
	);
]=]

StatusManager.new = function(options)
	local manager = {}
	manager.autoSave = options and options.autoSave or false
	
	manager.statusNum = 0
	manager.statusList = {}
	manager.currentStatus = 0
	manager.db = nil

	function manager:initial()
		self.db = sqlite3.open("status.db")
	end

	function manager:destroy()
		self.db:close()
	end

	function manager:saveStatus(universe)
		if self.currentStatus ~= self.statusNum then
			-- clean post status
			for i=self.currentStatus+1, self.statusNum do
				self.statusList[i] = nil
			end
		end
		self.statusNum = self.currentStatus + 1
		self.currentStatus = self.currentStatus + 1
		self.statusList[self.currentStatus] = Status.new(self.currentStatus, universe)
	end

	function manager:loadStatus(id)
		return self.statusList[id]
	end

	function manager:loadCurrentStatus()
		return self.loadStatus(self.currentStatus)
	end

	function manager:getStatus()
		return manager.statusList
	end

	return manager
end

return StatusManager