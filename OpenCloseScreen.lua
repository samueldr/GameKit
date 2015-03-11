local GameKit = require('GameKit/GameKit')
local OpenCloseScreen = class(LuaEntity)

OpenCloseScreen.MODE_STOPPED = 1
OpenCloseScreen.MODE_INTRO = 2
OpenCloseScreen.MODE_OUTRO = 3

function OpenCloseScreen:init(entity, introEndFrame, outroStartFrame, introCB, outroCB)
	LuaEntity.init(self, entity)
	self.mode   = OpenCloseScreen.MODE_STOPPED
	self.introEndFrame = introEndFrame
	self.outroStartFrame = outroStartFrame
	self.introCB = introCB
	self.outroCB = outroCB
end

function OpenCloseScreen:start()
	self.mode   = OpenCloseScreen.MODE_INTRO
	self:gotoAndStop(0)
end

function OpenCloseScreen:stop()
	self.mode   = OpenCloseScreen.MODE_STOPPED
	self:gotoAndStop(0)
end

function OpenCloseScreen:close()
	self.mode   = OpenCloseScreen.MODE_OUTRO
	self:gotoAndStop(self.outroStartFrame)
end

function  OpenCloseScreen:update()
	if self.mode == OpenCloseScreen.MODE_INTRO then
		self:nextFrame()
		if self:getCurrentFrame() >= self.introEndFrame then
			self.mode = OpenCloseScreen.MODE_STOPPED
			if self.introCB then self.introCB:call() end 
		end
	elseif self.mode == OpenCloseScreen.MODE_OUTRO then
		self:nextFrame()
		if self.entity:getCurrentFrame() == self:getNbFrames()-1 then
			self.mode = OpenCloseScreen.MODE_STOPPED
			if self.outroCB then self.outroCB:call() end 
		end
	end
end

return OpenCloseScreen
