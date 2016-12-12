local sqlite3 = require("sqlite3")

local StateManager = {}

local State = {}
StateManager.State = State

State.new = function(id, universe)
end

local create_tables = [=[
	CREATE TABLE IF NOT EXISTS worlds(
		id TEXT PRIMARY KEY, 
		sky INTEGER, 
		ground INTEGER, 
		underground INTEGER,
		modified DATETIME
	);
	CREATE TABLE IF NOT EXISTS layers(
		id INTEGER PRIMARY KEY,
		type TEXT, 
		tiles TEXT, 
		modified DATETIME
	);
	CREATE TABLE IF NOT EXISTS tiles(
		id TEXT,
		x INTEGER,
		y INTEGER,
		layer_id INTEGER,
	);
]=]

StateManager.new = function(options)
	local manager = {}
	manager.autoSave = options and options.autoSave or false
	
	manager.stateNum = 0
	manager.stateList = {}
	manager.currentState = 0
	manager.db = nil

	function manager:initial()
		self.db = sqlite3.open("state.db")
	end

	function manager:destroy()
		self.db:close()
	end

	function manager:saveState(universe)
		if self.currentState ~= self.stateNum then
			-- clean post state
			for i=self.currentState+1, self.stateNum do
				self.stateList[i] = nil
			end
		end
		self.stateNum = self.currentState + 1
		self.currentState = self.currentState + 1
		self.stateList[self.currentState] = State.new(self.currentState, universe)
	end

	function manager:loadState(id)
		return self.stateList[id]
	end

	function manager:loadCurrentState()
		return self.loadState(self.currentState)
	end

	function manager:getState()
		return manager.stateList
	end

	return manager
end

return StateManager