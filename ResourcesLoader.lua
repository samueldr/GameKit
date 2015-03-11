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

function Resources.font(name, file, ...)
	BaconBox.ResourceManager_loadFont(name, resources_path .. "/" .. file, ...)
end

return Resources
