---
-- 任务协议处理
-- @module protocol.handler.TaskHandler
-- 

local require = require
local printf = printf
local pairs = pairs

local modalName = "protocol.handler.TaskHandler"
module(modalName)


local GameNet = require("utils.GameNet")

---
-- 任务信息
--  
GameNet["S2c_task_infolist"] = function( pb )
	if not pb then return end 
	
	local RewardView = require("view.task.RewardView")
	if RewardView.instance then
		RewardView.instance:updateTaskList(pb.list_info)
	end
end

