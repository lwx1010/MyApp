--- 
-- 战斗开始初始化数据保存
-- @module view.fight.FightInit
-- 

local require = require

local moduleName = "view.fight.FightInit"
module(moduleName)

---
-- 人物初始化信息表
-- @field [parent = #view.fight.FightInit] _fighterInitMsgTl
--
local _fighterInitMsgTl = {}

---
-- 获取人物初始化信息表
-- @function [parent = #view.fight.FightInit] getFighterInitTl
--
function getFighterInitTl()
	return _fighterInitMsgTl
end

---
-- 添加初始化人物信息
-- @function [parent = #view.fight.FightInit] addFighterMsg
--
function addFighterMsg(msg)
	_fighterInitMsgTl[#_fighterInitMsgTl + 1] = msg
end

---
-- 重置信息
-- @function [parent = #view.fight.FightInit] reset
--
function reset()
	_fighterInitMsgTl = {}
end

