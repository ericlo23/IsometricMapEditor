local lfs = require("lfs")

local json = require("json")

local loadsave = require("util.loadsave")

local TileSprite = require("sprites.TileSprite")
local Universe = require("scenes.Editor.Universe")
local World = require("scenes.Editor.World")

local basePath = system.pathForFile("", system.DocumentsDirectory)

local manager = {}

function manager:save(file, universe)
	local setTileTable = function(layerTable, tiles)
		for x, tileCol in pairs(tiles) do
			layerTable[x] = {}
			for y, tile in pairs(tileCol) do
				if tile.sprite then
					layerTable[x][y] = {
						["tileTag"] = tile.sprite.tag, 
						["tileName"] = tile.sprite.name
					}
				else
					layerTable[x][y] = {}
				end
			end
		end
	end
	-- set json table
	local jsonTable = {}
	jsonTable["universe"] = {}
	for idx, world in pairs(universe.worlds) do
		jsonTable["universe"][idx] = {}
		jsonTable["universe"][idx]["name"] = world.name
		jsonTable["universe"][idx]["sky"] = {}
		jsonTable["universe"][idx]["ground"] = {}
		jsonTable["universe"][idx]["underground"] = {}
		setTileTable(jsonTable["universe"][idx]["sky"], world.sky.tiles)
		setTileTable(jsonTable["universe"][idx]["ground"], world.ground.tiles)
		setTileTable(jsonTable["universe"][idx]["underground"], world.underground.tiles)
	end
	-- save
	loadsave.saveTable(jsonTable, file)

	print("save finished")
end

function manager:saveOld(universe)
	-- first save file
	if not self.currentFile then
		self:saveNew(universe)
		return
	end
	-- backup
	os.rename(self.currentFile, self.currentFile..".bak")
	-- last save file
	self:save(self.currentFile, universe)
end

function manager:saveNew(universe)
	self.lastSaveIdx = self.lastSaveIdx + 1
	self.currentFile = tostring(self.lastSaveIdx)..".save"
	self:save(self.currentFile, universe)
end

function manager:load(file)
	local setLayerTile = function(layer, layerTable)
		for x, tileColTable in pairs(layerTable) do
			for y, tileTable in pairs(layerTable[x]) do
				if tileTable["tileTag"] and tileTable["tileName"] then
					local tile = TileSprite.new(tileTable["tileTag"], tileTable["tileName"])
					layer:_setTileAt(tile, x, y)
				end
			end
		end
	end

	self.currentFile = file
	local universe = Universe.new()

	local jsonTable = loadsave.loadTable(file)

	for idx, worldTable in pairs(jsonTable["universe"]) do
		local world = World.new(worldTable.name, {callback = self.posSelectCallback})
		setLayerTile(world.sky, worldTable["sky"])
		setLayerTile(world.ground, worldTable["ground"])
		setLayerTile(world.underground, worldTable["underground"])
		universe:addWorld(world)
	end
	print("load finished")
	return universe
end

function manager:loadLast()
	if self.lastSaveIdx == -1 then
		print("save not found")
		return nil
	end
	return self:load(tostring(self.lastSaveIdx)..".save")
end

function manager:initial(posSelectCallback)
	-- find max save
	local max = -1
	for fileName in lfs.dir(basePath) do
		-- get save idx
		if fileName:match("%d+%.save") and fileName:match("%d+%.save"):len() == fileName:len() then
			local saveIdx = tonumber( string.match(fileName, "%d+") )
			if saveIdx then
				if max < saveIdx then
					max = saveIdx
				end
			end
		end
	end
	self.lastSaveIdx = max

	-- posSelectCallback
	self.posSelectCallback = posSelectCallback

	lfs.chdir(basePath)
end

function manager:destroy()

end

return manager