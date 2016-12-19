local sqlite3 = require("sqlite3")

local manager = {}

local create_tables = [=[
	CREATE TABLE IF NOT EXISTS worlds(
		id INTEGER PRIMARY KEY,
		culture TEXT,
		save_date DATETIME
	);
	CREATE TABLE IF NOT EXISTS layers(
		id INTEGER PRIMARY KEY,
		type TEXT,
		world_id INTEGER,
		save_date DATETIME
	);
	CREATE TABLE IF NOT EXISTS tiles(
		id INTEGER PRIMARY KEY,
		tag TEXT,
		name TEXT,
		x INTEGER,
		y INTEGER,
		layer_id INTEGER,
		save_date DATETIME
	);
]=]

local manager = {}
manager.db = nil

function manager:save()
		
end

function manager:load(file)
	
end

function manager:loadLast()
	
end

function manager:initial(universe)
	self.db = sqlite3.open("state.db")
	self.universe = universe
end

function manager:destroy()
	self.db:close()
	self.universe = nil
end

return manager