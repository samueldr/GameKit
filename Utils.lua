
local GameKit = require('GameKit/GameKit')
local MainWindow = GameKit.MainWindow
local Utils = {}

function Utils.center_entity(entity)
	assert(entity, "No entity passed to Utils.center_entity")
	local context = MainWindow:getContextSize()
	entity:setPosition(context/2)
end

-- Local references.
-- Used in the pilfered code, don't know how much it helps though...
local strfind = string.find
local strsub  = string.sub
local tinsert = table.insert
-- Split text into a list consisting of the strings in text,
-- separated by strings matching delimiter (which may be a pattern). 
-- example: string_split("Anna, Bob, Charlie,Dolores", ",%s*")
-- http://lua-users.org/wiki/SplitJoin
function Utils.string_split(text, delimiter)
	local list = {}
	local pos = 1
	if strfind("", delimiter, 1) then -- this would result in endless loops
		error("delimiter matches empty string!")
	end
	while 1 do
		local first, last = strfind(text, delimiter, pos)
		if first then -- found?
			tinsert(list, strsub(text, pos, first-1))
			pos = last+1
		else
			tinsert(list, strsub(text, pos))
			break
		end
	end
	return list
end

return Utils
