---
-- 修改物品指令
-- @module test.ItemCmd
--


module("test.ItemCmd")

---
-- 物品指令表
-- @field [parent = test.ItemCmd] #table itemCmd
-- 
itemCmd = {}


itemCmd = 
{
	["增加普通道具"] = "/protomsg 30",
	["增加一个可淬炼的道具"] = "/protomsg 30 802004",
	["增加一个神兵"] = "/protomsg 30 899901",
	["充值金钱"] = "/protomsg 10000 1000",
	["充值元宝"] = "/protomsg 168 1000",
	["补充精力"] = "/protomsg 1 a add Vigor 1000",
	["清空副本战斗次数"] = "/protomsg 1225",
	["增加经验 提高人物等级"] = "/protomsg 0 100000",
	--["设置人物等级"] = "/protomsg 10001 40",
	["增加武学"] = "/protomsg 30 1001001",
	["增加武学碎片"] = "/protomsg 30 10010011",
	["增加装备碎片"] = "/protomsg 30 5802010 10",
	["增加同伴碎片"] = "/protomsg 30 3102002 10",
	["增加宝物"] = "/protomsg 30 9000001",
	["增加银两"] = "/protomsg 1 a add Cash 1000000",
}