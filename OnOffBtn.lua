local GameKit = require('GameKit/GameKit')
local Callback = GameKit.Callback
local Button = GameKit.Button

local OnOffBtn = class(LuaEntity)

function OnOffBtn:init(entity, callback, state, btnState)
	LuaEntity.init(self, entity)
	self.callback = callback
	self.state = state
	self.btnState = btnState
	self:initProperties()
end

function OnOffBtn:refresh()
	if self.btnState then
		self:gotoAndStop('on')
	else
		self:gotoAndStop('off')
	end
end

function OnOffBtn:setBtnState(state)
	self.btnState = state
	self:refresh()
end

function OnOffBtn:getBtnState()
	return self.btnState
end

function OnOffBtn:onBtn()
	self.btnState = not self.btnState
	self.callback:call()
	self:refresh()
end

function OnOffBtn:initProperties()
	self.button = Button(self.entity, Callback(OnOffBtn.onBtn, self), self.state)
end
