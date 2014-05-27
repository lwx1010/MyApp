---
-- 聊天数据
-- @module model.ChatData
-- 


local require = require
local printf = printf
local pairs = pairs

local moduleName = "model.ChatData" 
module(moduleName)

---
-- 聊天记录
-- @field [parent=#model.ChatView] #table _messageArr 存聊天记录
-- 
local messageArr = nil

---
-- 聊天记录最大个数
-- @field [parent=#model.ChatView] #number MESSAGE_MAX_COUNT
-- 
local MESSAGE_MAX_COUNT = 50

---
-- 延迟显示信息
-- @field [parent=#model.ChatView] #table _delayMsgTl
-- 
local _delayMsgTl = {}

---
-- 添加记录
-- @function [parent = #model.ChatData] addChatItem
-- @param #table chatMsg 聊天信息(type, name, info)
-- 
function addChatItem( chatMsg )
	if not chatMsg then return end
	
	if not messageArr then 
		messageArr = {}
	end 
	
	local table = require("table") 
	local ChatView = require("view.chat.ChatView")
	if #messageArr == MESSAGE_MAX_COUNT then
		--删除记录里面的第一条
		table.remove(messageArr, 1)		
		
		-- 删除泡泡里面的第一条
		if ChatView.instane and ChatView.instance:getVBox() then
			local box = ChatView.instance:getVBox()
			local cell = box:getItemAt(1)
			box:removeItemAt(1)
			cell:release()
		end
	end
	
	table.insert(messageArr, chatMsg)
	
--	for k, v in pairs(chatMsg) do
--		printf(k .. " = " .. v)
--	end
--	
	if ChatView.instance and ChatView.instance:getVBox() then
		local box = ChatView.instance:getVBox()
		ChatView.instance:addChatCell(chatMsg)
		box:validate()
		box:scrollToIndex(#messageArr)
	end
end

--- 
-- 获取聊天记录信息
-- @function [parent=#ChatData] getMessageArr
-- @return table
-- 
function getMessageArr()
	return messageArr
end

---
-- 添加延迟信息
-- @function [parent=#model.ChatData] addDelayMsg
-- @param #string msg
-- 
function addDelayMsg(msg)
	_delayMsgTl[#_delayMsgTl + 1] = msg	
end

---
-- 处理延迟信息
-- @function [parent=#model.ChatData] dealDelayMsg
-- 
function dealDelayMsg()
	for i = 1, #_delayMsgTl do
		local FloatNotify = require("view.notify.FloatNotify") 
		FloatNotify.show(_delayMsgTl[i])
	end
	_delayMsgTl = {}
end

