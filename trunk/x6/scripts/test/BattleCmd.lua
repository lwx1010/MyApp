---
-- 战斗指令
-- @module test.BattleCmd
--


module("test.BattleCmd")

--- 
-- @field [parent = #test.BattleCmd] #table battleCmd
-- 
battleCmd = {}

battleCmd = 
{
	["添加同伴(ID，位置)"] = "/protomsg 10015 101001 1",
	["进入战斗"] = "/protomsg 10016 10007",
	["进入副本"] = "/protomsg 10016 10001",
	["测试特效"] = "/fight 0 1001002 {1,2,3,4} {1,2,3,4,5}",
	["开始世界BOSS"] = "/protomsg 10003 1",
}