---
-- 每日任务数据
-- @module model.EverydayTaskData
-- 


local require = require
local printf = printf
local pairs = pairs
local table = table

local moduleName = "model.EverydayTaskData" 
module(moduleName)

---
-- 日常任务列表
-- @field [parent=#model.EverydayTaskData] utils#DataSet task 存日常任务
-- 
task = nil

---
-- 是否已获取任务列表
-- @field [parent=#model.EverydayTaskData] #boolean isGetTaskList
-- 
isGetTaskList = false

---
-- 任务完成次数
-- @field [parent=#model.EverydayTaskData] #number finishCount
-- 
finishCount = -1

---
-- 任务是否更新
-- @field [parent=#model.EverydayTaskData] #boolean hasNewTask
-- 
hasNewTask = false

---
-- 是否有任务奖励
-- @field [parent=#model.EverydayTaskData] #number IsTaskReward
-- 
IsTaskReward = nil

---
-- 是否有日常任务奖励
-- @field [parent=#model.EverydayTaskData] #number IsDailyTaskReward
-- 
IsDailyTaskReward = nil


---
-- 初始化
-- @function [parent=#model.EverydayTaskData] init
-- 
function init()
	local DataSet = require("utils.DataSet")
	task = DataSet.new()
end

init()

---
-- 得到任务列表
-- @function [parent=#model.EverydayTaskData] getTaskList
-- @param #table list 服务端的任务列表
--
function getTaskList(list)
	-- 遍历列表，生成任务数据，并分派事件
	local arr = {}
	for i = 1, #list do
		arr[i] = list[i]
	end
	task:setArray(arr)
	isGetTaskList = true
	isNewTask = true
end

---
-- 任务完成
-- @function [parent=#model.EverydayTaskData] taskFinish
-- @param #table pb 服务端发来
--
function taskFinish(pb)
	-- 遍历列表，找到该任务，标记完成，并分派任务
	
end

---
-- 领取奖励后移除任务
-- @function [parent=#model.EverydayTaskData] removeTask
-- @param #table item
--
function removeTask(item)
	task:removeItem(item)
end

---
-- 是否存在完成但未领取奖励的任务
-- @function [parent=#model.EverydayTaskData] taskFinish
-- @return #boolean
-- 
--
function isNotPickReward()
	local arr = task:getArray()
	for i = 1, #arr do
		if arr[i].isfinish == 1 then
			return true
		end
	end
	return false
end