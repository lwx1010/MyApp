--- 
-- 战斗回合中逻辑处理
-- @module view.fight.FightBout
-- 


local CCLuaLog = CCLuaLog
local assert = assert
local require = require

local moduleName = "view.fight.FightBout" 
module(moduleName)

---
-- 回合中的数据逻辑表, 这个表按照行动数分组
-- @field [parent = #view.fight.FightBout] #table _fightBoutTable
-- 
local _fightBoutTable = {}

---
-- 当前回合数
-- @field [parent = #view.fight.FightBout] #number _boutNum
-- 
local _boutNum = 0

---
-- 指向当前表
-- @field [parent = #view.fight.FightBout] #table _currTable
-- 
local _currTable

---
-- 当前读到的数据索引
-- @field [parent = #view.fight.FightBout] #number _currItem
-- 
local _currItem = 1


---
-- 获取当前索引
-- @function [parent = #view.fight.FightBout] getCurrItem
-- 
function getCurrItem()
	return _currItem
end

---
-- 设置当前索引
-- @function [parent = #view.fight.FightBout] setCurrItem
-- 
function setCurrItem(num)
	_currItem = num
end

---
-- 战斗是否已开始播放
-- @field [parent = #view.fight.FightBout] #bool _fightIsPlay
-- 
local _fightIsPlay = false


--- 
-- 加入一个pb表
-- @function [parent = #view.fight.FightBout] push
-- @param #table pb
-- 
function push(pb)
	if pb.structType.name == "S2c_fight_bout" then
		_boutNum = _boutNum + 1
		_fightBoutTable[_boutNum] = {}
		_currTable = _fightBoutTable[_boutNum]
	end
	
	if _currTable ~= nil then
		_currTable[#_currTable + 1] = pb
		--CCLuaLog("Has Push "..#_currTable.."actor pb in FightBoutTable...")
	end
	
	if pb.structType.name == "S2c_start_draw" then
		if _fightIsPlay == false then
    		--播放战斗
	    	local fightScene = require("view.fight.FightScene")
		    fightScene.playBout(getFightBoutTable())
		    _fightIsPlay = true
		end
	end
end

--- 
-- 获取私有的_fightBoutTable表
-- @function [parent = #view.fight.FightBout] getFightBoutTable
-- @return #table _fightBoutTable 表
-- 
function getFightBoutTable()
	return _fightBoutTable
end	

---
-- 重置FightBout状态
-- @function [parent = #view.fight.FightBout] reset
--
function reset()
	_currTable = nil
	_boutNum = 0
	_fightBoutTable = {}
	_fightIsPlay = false
	_currItem = 1
end