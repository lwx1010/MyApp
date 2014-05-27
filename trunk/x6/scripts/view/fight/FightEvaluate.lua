--- 
-- 保存战斗评价pb
-- @module view.fight.FightEvaluate
-- 

local CCLuaLog = CCLuaLog

local moduleName = "view.fight.FightEvaluate" 
module(moduleName)

--- 
-- 保存战斗评价表
-- @field [parent = #view.fight.FightEvaluate] #table _fightEvaluateTable
--
local _fightEvaluateTable = {}

--- 
-- 加入一个pb表
-- @function [parent = #view.fight.FightEvaluate] push
-- @param #table pb
-- 
function push(pb)
	_fightEvaluateTable[#_fightEvaluateTable + 1] = pb
	--CCLuaLog("Has Push "..#_fightEvaluateTable.." pb in FightEvaluateTable...")
end


--- 
-- 获取私有的mFightEvaluateTable表
-- @function [parent = #view.fight.FightEvaluate] getFightEvaluateTable
-- @return #table _fightEvaluateTable
--
function getFightEvaluateTable()
	return _fightEvaluateTable
end	


---
-- 清空表
-- @function [parent = #view.fight.FightEvaluate] clear
-- 
function clear()
	_fightEvaluateTable = {}
end

