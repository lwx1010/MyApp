---
-- 其他指令
-- @module test.OtherCmd
--


module("test.OtherCmd")

--- 
-- @field [parent = #test.OtherCmd] #table otherCmd
-- 
otherCmd = {}

otherCmd = 
{
	["奇遇事件"] = "/protomsg 1232 1",
	["清除VIP"] = "/protomsg 10037",
	["扣除元宝"] = "/protomsg 10038 1000",
	["添加神行数"] = "/protomsg 10043 100"
}