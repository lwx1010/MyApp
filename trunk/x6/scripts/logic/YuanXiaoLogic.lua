---
-- 元宵节逻辑
-- @module logic.YuanXiaoLogic
--

local tr = tr
local require = require

local moduleName = "logic.YuanXiaoLogic"
module(moduleName)

---
-- 保存延迟信息表
-- @field [parent = #logic.YuanXiaoLogic] #table _delayMsgTl
--
local _delayMsgTl = {}

---
-- 添加延迟信息
-- @function [parent = #logic.YuanXiaoLogic] addDelayMsg
-- @param #string delayMsg
--
function addDelayMsg(delayMsg)
	local itemName = delayMsg.name 
	local count = delayMsg.count
	local msg = tr("获得了")..itemName.." "..count..tr("个")
	_delayMsgTl[#_delayMsgTl + 1] = msg
end

---
-- 显示延迟信息
-- @function [parent = #logic.YuanXiaoLogic] showDelayMsg
--
function showDelayMsg()
	local notify = require("view.notify.FloatNotify")
	for i = 1, #_delayMsgTl do
		notify.show(_delayMsgTl[i])
	end
	_delayMsgTl = {}	
end


