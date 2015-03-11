-- Mixin used to work with BaconBox text fields.

-- Text assumes that the element mixed in has:
--  -> self.getChildByName()

-- Adds add_text() that allows adding a text.

local GameKit = require('GameKit/GameKit')
local Mixins = GameKit.Mixins

local Text = Mixins.new('Text')

-- Helper to automagically conjure texts.
-- Will automatically set a property on self with the text name
-- Also assumes the text is available by name in self:getChildByName()
function Text.add_text(self, name)
	assert(self, "Bad call to add_text; no self given.")
	assert(name, "No name given to add_text.")
	-- Sanity check
	assert(self.getChildByName, "Object given to Text.add_text does not have getChildByName().")

	-- Getting an entity
	local entity = self:getChildByName(name)
	assert(entity, "Entity " .. name .. " could not be conjured by self.entity:getChildByName.")

	entity = BaconBox.cast(entity, 'TextEntity')
	assert(entity, "Text entity " .. name .. " could not be casted by BaconBox.cast(entity, 'TextEntity').")
	
	-- Append it to 'self'
	self[name] = entity

	-- Allows chaining to the text entity
	return entity
end

return Text
