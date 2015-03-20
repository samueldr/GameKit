
local GameKit = require('GameKit/GameKit')
local MainWindow = GameKit.MainWindow
local Utils = {}

function Utils.center_entity(entity)
	assert(entity, "No entity passed to Utils.center_entity")
	local context = MainWindow:getContextSize()
	entity:setPosition(context/2)
end

return Utils
