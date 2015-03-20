-- Keyboard
--
-- Sugarcoating for keyboard events handling.
--
-- Use GameKit.Keyboard() for the default keyboard.
--
local GameKit = require('GameKit/GameKit')

local default_keyboard = BaconBox.Keyboard_getDefault()

local Keyboard = class()

local Key = class()

-- Metatable for Key
-- Allows calling kb.key.__KEYNAME__ to do just as held would.
local Key_mt = {
	__index = function(tbl, key)
		-- Pass through to Key
		if key == "held" or key == "pressed" or key == "released" then
			return function(strip, ...)
				return tbl._inst[key](tbl._inst, ...)
			end
		end
		key = key:upper()
		return tbl._inst:held(key)
	end
}

function Keyboard:init(keyboard)
	if not keyboard then
		keyboard = default_keyboard
	end

	self.keyboard = keyboard

	local key_inst = Key(self)
	self.key = { _inst = key_inst }
	setmetatable(self.key, Key_mt)
end

function Key:init(keyboard)
	assert(keyboard, "No keyboard given to Key()")
	self.keyboard = keyboard
end

-- Whether the key was "just pressed".
function Key:pressed(keyname)
	assert(keyname, "No key name given to Key:pressed()")
	return self.keyboard.keyboard:isKeyPressed(BaconBox["Key_"..keyname])
end

-- Whether the key was "just released".
function Key:released(keyname)
	assert(keyname, "No key name given to Key:released()")
	return self.keyboard.keyboard:isKeyReleased(BaconBox["Key_"..keyname])
end

-- Whether the key is held
function Key:held(keyname)
	assert(keyname, "No key name given to Key:held()")
	return self.keyboard.keyboard:isKeyHeld(BaconBox["Key_"..keyname])
end


return Keyboard
