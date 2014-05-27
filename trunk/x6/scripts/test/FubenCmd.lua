---
-- 副本指令
-- @module test.FubenCmd
--


module("test.FubenCmd")

--- 
-- @field [parent = #test.FubenCmd] #table FubenCmd
-- 
fubenCmd = {}

fubenCmd = 
{
	["清除副本信息"] = "/protomsg 1225",
	["开启某个篇章"] = "/protomsg 1226 2",
	["直接完成并开启关联篇章"] = "/protomsg 1227 1",
	["补充体力"] = "/protomsg 1 a add Physical 30",
}