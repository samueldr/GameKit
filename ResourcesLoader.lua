-- Resources
--
-- Helpers to sugarcoat resources loading.
-- Might be a good idea later on to add callbacks or stuff to allow loading tracking.
--
-- Will load from the resources folder.
-- For more "flexibility", use the BaconBox functions directly.

local GameKit = require('GameKit/GameKit')

local Resources = {}
local resources_path = BaconBox.ResourcePathHandler_getResourcePath()

function Resources.xml(name)
	BaconBox.ResourceManager_loadFlashExporterXML(resources_path  .. "/" .. name .. ".xml")
end

-- Loads a file as a texture. When given no key, guesses the key from the filename.
-- The guess is made by stripping everything from and including the last dot
-- mypicture.png -> mypicture
function Resources.texture(file, key)
	assert(file, "No filename given to Resources.texture().")
	if not key then
		key = file:gsub("%.%w+$", "")
	end
	BaconBox.ResourceManager_loadTexture(key, resources_path .. "/" .. file)
end

function Resources.font(name, file, ...)
	BaconBox.ResourceManager_loadFont(name, resources_path .. "/" .. file, ...)
end

-- Loads a file as a sound. When given no key, guesses the key from the filename.
-- The guess is made by stripping everything from and including the last dot
-- mysound.wav -> mysound
function Resources.sound(file, key)
	assert(file, "No filename given to Resources.texture().")
	if not key then
		key = file:gsub("%.%w+$", "")
	end
	BaconBox.ResourceManager_loadSoundRelativePath(key, file);
end

return Resources
