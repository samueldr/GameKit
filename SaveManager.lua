-- SaveManager
-- 
-- Implements a registry and an interface to which a class can refer to save data.

require 'vendor/json'
local GameKit = require 'GameKit/GameKit'
local SaveManager = class()

SaveManager.saveFile = BaconBox.ResourcePathHandler_getDocumentPath() .. '/save.json'
SaveManager.loadFile = SaveManager.saveFile

function SaveManager:init()
	self.managers = {}
end

-- Registers a manager that will be saved and loaded
function SaveManager:register(manager)
	table.insert(self.managers, manager)
end

--------------------------------------------------------------------------------
-- Saving / Loading to file {{{
--------------------------------------------------------------------------------

function SaveManager:load()
	local saves = nil
	local save = nil
	local file = io.open(SaveManager.loadFile , 'rb')
	if file then
		local filetext = file:read("*all")
		saves = json.decode(filetext)
		save = saves[1]
		file:close()
	end
	-- Ensures that we have a table
	if not save then
		save = {}
	end
	-- Loads data from table
	for k,manager in ipairs(self.managers) do
		manager:load(save[manager:getKey()])
	end
end

function SaveManager:save()
	local save = {}
	for k,manager in ipairs(self.managers) do
		save[manager:getKey()] = manager:save()
	end

	local filetext = json.encode({save})
	local file = io.open(SaveManager.saveFile , 'w+')
	file:write(filetext)
	file:close()
end

-- }}}
--------------------------------------------------------------------------------

-- Proxies for the singleton instance.
function SaveManager.Save(...) SaveManager.instance:save(...) end
function SaveManager.Load(...) SaveManager.instance:load(...) end
function SaveManager.Register(...) SaveManager.instance:register(...) end

--------------------------------------------------------------------------------
-- Base Manager {{{
--------------------------------------------------------------------------------

-- We want a base class with helpers for the managers
local BaseManager = class()

function BaseManager:init() end
function BaseManager:getKey()
	assert(self.key, "No key defined for derived BaseManager.")
	return self.key
end
function BaseManager:save() end
-- For load, the data can be nil when the save has no data yet.
-- The manager should handle this gracefully by getting default values.
function BaseManager:load(data) end

SaveManager.BaseManager = BaseManager

-- }}}
--------------------------------------------------------------------------------

SaveManager.instance = SaveManager()
return SaveManager
