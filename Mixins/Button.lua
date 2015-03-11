-- Mixin used to work with our buttons

-- Button assumes that the element mixed in has:
--  -> self.getChildByName()
--  -> self.state set to its parent state (or itself for a state).

-- Adds add_button() that allows adding a button.
-- Adds enable_button() that enables a certain button.
-- Adds disable_button() that disables a certain button.

local GameKit = require('GameKit/GameKit')
local Mixins = GameKit.Mixins
local Callback = GameKit.Callback

local Button = Mixins.new('Button')

-- Helper to automagically conjure buttons
-- Will automatically set a property on self with the button name
-- Will automatically attach self.on_[name] if not overridden.
-- The function passed can be either a function or the name of a function
-- Assumes any further parameters are to be passed to the callback.
-- Also assumes the button is available by name in self:getChildByName()
function Button.add_button(self, name, fn, ...)
	assert(self, "Bad call to add_button; no self given.")
	assert(name, "No name given to add_button.")
	-- Sanity check
	assert(self.getChildByName, "Object given to Button.add_button does not have getChildByName().")
	assert(self.state, "Object given to Button.add_button does not have self.state")

	-- Hooks on on_... if no alternative given
	if not fn then
		fn = "on_"..name
	end
	-- If it's not a function, assume a string was given
	if type(fn) ~= "function" then
		fn = self[fn]
	end
	
	-- Getting an entity
	local entity = self:getChildByName(name)
	assert(entity, "Entity " .. name .. " could not be conjured by self:getChildByName.")

	-- Makes the button
	entity = GameKit.Button(
		entity,
		Callback(fn, self, ...),
		self.state
	)

	assert(entity, "Button entity " .. name .. " could somehow not be tranformed in a GameKit.Button.")

	-- Append it to 'self'
	self[name] = entity

	-- Allows chaining to the text entity
	return entity
end

function Button.disable_button(self, btn)
	assert(self, "Bad call to disable_button; no self given.")
	assert(btn, "No button given to disable_button")
	-- If given a string, fetch it from the properties of self
	if type(btn) == 'string' then
		btn = self[btn]
	end

	self.state:removeClickable(btn)
end
function Button.enable_button(self, btn)
	assert(self, "Bad call to enable_button; no self given.")
	assert(btn, "No button given to enable_button")
	-- If given a string, fetch it from the properties of self
	if type(btn) == 'string' then
		btn = self[btn]
	end
	self.state:addClickable(btn)
end

return Button
