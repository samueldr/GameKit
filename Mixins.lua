-- Mixins
--
-- Global helper file for GameKit Mixins.
--
-- Defines the loader and defines some common behaviour between mixins.
--
-- A Mixin basically imports their methods to another table.
-- This is useful to add a common behaviour to something that may not
-- be fit for inheritance.

local GameKit = require('GameKit/GameKit')
local Mixins = {}

-- The metatable for /a/ mixin.
local mixin_mt = {}

-- Constructor-like call for the mixin
-- Mutates the target table.
mixin_mt.__call = function(source_mixin, target_table)
	for key,val in pairs(source_mixin) do
		if key == "_mixin_name" then
			-- Add the _mixin_name to the target's _mixins table.
			if not target_table._mixins then
				target_table._mixins = {}
			end
			table.insert(target_table._mixins, val)
		else
			-- Otherwise, import the k/v pair.
			target_table[key] = val
		end
	end
end

-- Used to define a new Mixin
function Mixins.new(name)
	assert(name, "No name passed to the mixin")
	local tbl = {
		_mixin_name = name
	}
	-- Add the mixin metatable (constructor thingie)
	setmetatable(tbl, mixin_mt)
	return tbl
end

-- Metatable for /Mixins/
-- Auto-requires a sub-component.
local mixins_mt = {}
mixins_mt.__index = function(table, key)
	local comp = rawget(Mixins, key)
	if comp then
		return comp
	else
		return GameKit.require('Mixins/' .. key)
	end
end
setmetatable(Mixins, mixins_mt)

return Mixins

