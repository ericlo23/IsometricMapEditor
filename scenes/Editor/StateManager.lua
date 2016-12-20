local sqlite3 = require("sqlite3")
local lfs = require("lfs")

local manager = {}

local basePath = system.pathForFile("", system.DocumentsDirectory)

local create_tables = [=[
	CREATE TABLE IF NOT EXISTS worlds(
		id INTEGER PRIMARY KEY,
		culture TEXT,
		deleted BOOLEAN
	);
	CREATE TABLE IF NOT EXISTS layers(
		id INTEGER PRIMARY KEY,
		type TEXT,
		world_id INTEGER,
		deleted BOOLEAN
	);
	CREATE TABLE IF NOT EXISTS tiles(
		id INTEGER PRIMARY KEY,
		tag TEXT,
		name TEXT,
		x INTEGER,
		y INTEGER,
		layer_id INTEGER,
		deleted BOOLEAN
	);
]=]

local manager = {}

function manager:save(file)
	local db = sqlite3.open(file)
	-- save
	

	db:close()
end

function manager:saveOld()
	-- first save file
	if self.lastSaveIdx == -1 then
		print("save not found")
		self:saveNew()
		return
	end
	-- last save file
	local oldFile = tostring(self.lastSaveIdx)..".save"
	self.save(oldFile)
end

function manager:saveNew()
	self.lastSaveIdx = self.lastSaveIdx + 1
	local newFile = tostring(self.lastSaveIdx)..".save"
	self.save(newFile)
end

function manager:load(file)
	local db = sqlite3.open(file)
	-- load
	db:close()
end

function manager:loadLast()
	if self.lastSaveIdx == -1 then
		print("save not found")
		return
	end
	self.load(tostring(self.lastSaveIdx)..".save")
end

function manager:initial(universe)
	-- find max save
	local max = -1
	for fileName in lfs.dir(basePath) do
		-- get save idx
		local saveIdx = tonumber( string.match(fileName, "%d+.save") )
		if saveIdx then
			if max < saveIdx then
				max = saveIdx
			end
		end
	end
	self.lastSaveIdx = max

	lfs.chdir(basePath)

	self.universe = universe
end

function manager:destroy()
	self.universe = nil
end

return manager