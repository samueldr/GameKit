-- AchievementManager
--
-- Manages the state of Achievements.
--
-- There is a queue that should be used to know whether an achievement has just been achieved.
-- A feature that will be coming is the ability to hook a Callback instead.

local GameKit = require('GameKit/GameKit')
local Callback = GameKit.Callback
local SaveManager = GameKit.SaveManager

local AchievementManager = class(SaveManager.BaseManager)

function AchievementManager:init()
	self.key = "Achievements"

	-- Table to store the queue of achievements left to give.
	self.achievementsQueue = {}

	-- Waits for a polling event instead of directly using the Callback
	self.waitForPolling = true

	-- List of all achievements that exists.
	-- They are indexed by name
	self.achievements = {}

	-- Achievments achieved will have their name be true in this table.
	self.achieved = {}
end

function AchievementManager:register(achievement)
	self.achievements[achievement:getName()] = achievement
end

-- This is the "clean" way to code it.
-- Though, you can also use AchievementManager.achievements.NAME
function AchievementManager:getAchievmentByName(name)
	return self.achievements[name]
end

function AchievementManager:getAchievmentByID(id)
	for k,achievement in pairs(self.achievements) do
		if achievement:getID() == id then
			return achievement
		end
	end
	return nil
end

function AchievementManager:isAchieved(needle)
	if tonumber(needle) then
		needle = self:getAchievmentByID(needle):getName()
	end
	return self.achieved[needle]
end

-- Sets a certain achievement as achieved.
-- Will also return the achievement for chaining purposes.
function AchievementManager:achieve(needle)
	local achievement = nil
	if tonumber(needle) then
		achievement = self:getAchievmentByID(needle)
	else
		achievement = self.achievements[needle]
	end

	local achievement = self.achievements[needle]
	assert(achievement, "No achievement found for: " .. needle)
	if not achievement then
		return false
	end

	-- Do not "achieve" if already achieved
	if self.achieved[needle] then
		return
	end

	self.achieved[needle] = true
	self:push(achievement)
	-- And save it!
	SaveManager.instance:save()
	return achievement
end

--------------------------------------------------------------------------------
-- Queue management {{{
--------------------------------------------------------------------------------
-- Adds an achievement to the queue of achievements to give
function AchievementManager:push(achievement)
	table.insert(self.achievementsQueue, achievement)
end

-- Gets and removes from queue the first achievement in line.
-- If there are none to give, returns nil
function AchievementManager:pop()
	return table.remove(self.achievementsQueue, 1)
end

-- Peek at the next achievement in queue.
function AchievementManager:peek()
	return self.achievementsQueue[1]
end
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Saving / loading {{{
--------------------------------------------------------------------------------
-- Allows saving and retrieval of achievements state.
function AchievementManager:load(save)
	if not save then
		save = {}
	end
	self.achieved = save.achieved or {}
end
function AchievementManager:save()
	return { achieved = self.achieved }
end

-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- BaseAchievement interface for Achievements {{{
--------------------------------------------------------------------------------

-- Describes the base informations needed for an Achievement to work with AchievementManager.
-- Other informations can be added to the inheriting class without issues.
--
-- Don't forget that an "Achievement" is basically a token saying that the user did
-- what was necessary to get it.
local BaseAchievement = class()

-- id : A numeric ID used for saving and loading.
-- name : A programmer-friendly name for the achievement.
--        It will be possible to get it by this name
-- friendly_name : The name to show to the players.
function BaseAchievement:init(id, name, friendly_name)
	assert(id, "No ID passed to BaseAchievement.")
	assert(tonumber(id), "The ID for an achievement has to be a number.")
	assert(name, "No name passed to the achievement.")
	assert(friendly_name, "No friendly name passed to the achievement.")

	self.id = id
	self.name = name
	self.friendly_name = friendly_name
end

function BaseAchievement:getFriendlyName()
	return self.friendly_name
end
function BaseAchievement:getName()
	return self.name
end
function BaseAchievement:getID()
	return self.id
end

-- }}}
--------------------------------------------------------------------------------

-- Quick way to create achievements.
function AchievementManager.createAchievement(ID, name, friendly_name)
	AchievementManager.instance:register(
		BaseAchievement(ID, name, friendly_name)
	)
end

AchievementManager.BaseAchievement = BaseAchievement
AchievementManager.instance = AchievementManager()
return AchievementManager
