local GameKit = {
	_VERSION = "0.1"
}

-- Actual implementation of GameKit.require()
-- Outside of GameKit to escape the syntactic sugar.
local function gkrequire(component_name)
	-- We need to bypass the syntactic sugar from the metatable.
	-- This is why we're using rawget and rawset here.
	local component = rawget(GameKit, component_name)

	-- If component_name is already known
	if component then
		return component
	end

	component = require('GameKit/' .. component_name)
	rawset(GameKit, component_name, component)
	return rawget(GameKit, component_name)
end

--- Requires a component that should be known by the GameKit.
--- Returns that component as a normal require would, making idiomatic
--- `local Component = GameKit.require('Component')` as lua-like as possible.
function GameKit.require(component_name)
	return gkrequire(component_name)
end

--- Metatable for GameKit.
local gameKit_mt = {}

--- Syntactic sugar to allow using a not-yet-required GameKit component as
--- if it was already required.
gameKit_mt.__index = function(table, key)
	local comp = rawget(GameKit, key)
	if comp then
		return comp
	else
		return gkrequire(key)
	end
end

setmetatable(GameKit, gameKit_mt)

return GameKit
