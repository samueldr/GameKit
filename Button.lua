local GameKit = require('GameKit/GameKit')
local Callback = GameKit.Callback
local Jukebox = GameKit.Jukebox

local Button = class(LuaEntity)

-- TODO : Document that if no state is passed, you have to addClickable() it yourself.
function Button:init(entity, callback, state, buttonSoundID)
	LuaEntity.init(self, entity)

	-- if buttonSoundID ~= '' then
	-- 	self.buttonSoundID = buttonSoundID or 'Button'
	-- end

	self.callback = callback

	self:reloadLuaClass()
	self.over = false

	self.entity.moveOver:connect(Callback(Button.onPointerMove, self))
	self.entity.moveOut:connect(Callback(Button.onPointerMoveOut, self))
	self.entity.released:connect(Callback(Button.onPointerButtonRelease, self))
	self.entity.pressed:connect(Callback(Button.onPointerButtonPress, self))

	-- print(debug.traceback(),  state, callback, entity)
	if state then
	   state:addClickable(self)
	end
	
	self.hasOverAndOut = entity:hasLabel('over') and entity:hasLabel('out')
	self.hasDownAndUp = entity:hasLabel('down') and entity:hasLabel('up')

end

function Button:onPointerButtonPress()
	if self.hasDownAndUp then
		self:gotoAndPlay("down")
	end
end

function Button:onPointerButtonRelease()
	-- TODO : Fix when releasing after dragging a bit... It cancels click even when still on button and always cancels out for the animation...
	if self.hasDownAndUp then
		self:gotoAndPlay("up")
	end
	if self.buttonSoundID then Jukebox.instance:playSound(self.buttonSoundID) end
	self.callback:call()
end

function Button:onPointerMove()
	if self.hasOverAndOut and not self.over then
		self:gotoAndPlay("over")
		self.over = true
	end
end

function Button:onPointerMoveOut()
	if self.hasOverAndOut and self.over then
		self:gotoAndPlay("out")
		self.over = false
	end
end

return Button
