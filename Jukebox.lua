local GameKit = require 'GameKit/GameKit'
local Callback = GameKit.Callback

local Jukebox = class()

Jukebox.soundEngine = BaconBox.Engine_getSoundEngine()
Jukebox.musicEngine = BaconBox.Engine_getMusicEngine()

-- Jukebox.musicEngine:setMusicVolume(0)

function Jukebox:init()
	self.callback = Callback(Jukebox.update, self)
	self.currentMusic = nil
	self.fadeOutMusic = nil
	self.isCrossfading = false
	-- BaconBox.Engine_update:connect(self.callback)
end

function Jukebox:playSound(sound)
    if sound == nil then
        print(debug.traceback())
    end
    if sound == nil then return end
    Jukebox.soundEngine:getSoundFX(sound, false):play()
end

-- function Jukebox:fadeToMusic(music, fadeTime)
--     fadeTime = fadeTime or 2
--     self.fadeTime = fadeTime
--     if self.currentMusic then
--         self.currentMusic:stop(fadeTime)
--         self.fadeOutMusic = self.currentMusic
--         self.isCrossfading = true
--     end

--     self.currentMusic = Jukebox.musicEngine:getBackgroundMusic(music, true)
--     if not self.fadeOutMusic then
--         self.currentMusic:play(-1,2)
--     end
-- end


function Jukebox:fadeToMusic(music, nbLoop)
	nbLoop = nbLoop or -1
	if self.currentMusic then
		self.currentMusic:stop()
		self.currentMusic:__disown()
		self.currentMusic = nil
	end

	self.currentMusic = Jukebox.musicEngine:getBackgroundMusic(music, true)
	if not self.fadeOutMusic then
		self.currentMusic:play(nbLoop)
	end
end

function Jukebox:fadeAllMusicToDestroy(fadeTime)
	fadeTime = fadeTime or 2

	if self.currentMusic then
		self.currentMusic:stop(fadeTime)
		self.currentMusic:__disown()
	end

	self.currentMusic = nil
end

function Jukebox:update()
	if self.isCrossfading then
		if self.fadeOutMusic:getCurrentState() == BaconBox.AudioState_STOPPED then
			self.currentMusic:play(-1, self.fadeTime)
			self.fadeTime = 2
			self.isCrossfading = false
			-- self.callback:disconnect( BaconBox.Engine_update, BaconBox.LuaHelper_getPointerFromLuaUserData(BaconBox.Engine_update))
			-- BaconBox.Engine_update:disconnectCB(self.callback)
			self.fadeOutMusic:__disown()
			self.fadeOutMusic = nil
		end
	end
end

Jukebox.instance = Jukebox()
return Jukebox
