-- Callback
--
-- Implements an interface to make callbacks.
--
-- Works closely with BaconBox for C calls wrappers.

local Callback = class()

function Callback:init(func, ...)
	--assert(func)
	self.func = func
	self.arg = {...}
	self.cWrapper = {}
end

function Callback:call(...)
	if select('#',...) > 0 then
		self.func(unpack(self.arg), unpack({...}))
	else
		self.func(unpack(self.arg))
	end
end

function Callback:getCallback(type)
	return BaconBox.LuaCallback(self, type)
end

function Callback:addCWrapper(signalPtr, luaCallback)
	self.cWrapper[signalPtr] =  luaCallback
end

function Callback:disconnect(signal, signalPtr)
	local wrapper = self.cWrapper[signalPtr]
	if wrapper then
		signal:disconnect(self.cWrapper[signalPtr])
		self.cWrapper[signalPtr] = nil
	end
end

return Callback
