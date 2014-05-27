--- 
-- 刷新任务条目
-- @module view.task.FlashTaskCell
-- 

local class = class
local printf = printf
local require = require
local tr = tr

local moduleName = "view.task.FlashTaskCell"
module(moduleName)


--- 
-- 类定义
-- @type FlashTaskCell
-- 
local FlashTaskCell = class(moduleName, require("ui.CCBView").CCBView)

--- 创建实例
-- @return FlashTaskCell实例
function new()
	return FlashTaskCell.new()
end

--- 
-- 构造函数
-- @function [parent=#FlashTaskCell] ctor
-- @param self
-- 
function FlashTaskCell:ctor()
	FlashTaskCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#FlashTaskCell] _create
-- @param self
-- 
function FlashTaskCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_task/ui_richangpece1.ccbi", true)
	
	self:handleButtonEvent("flashBtn", self._flashClkHandler)
end

---
-- 按钮点击处理函数
-- @function [parent=#FlashTaskCell] _flashClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
--
function FlashTaskCell:_flashClkHandler(sender, event)
	local func = function()
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_dailytask_fresh", { placeholder = 1 })
	end
	
	local EverydayTaskData = require("model.EverydayTaskData")
	if EverydayTaskData.isNotPickReward() then
		
		local TaskConfirmView = require("view.task.TaskConfirmView").createInstance()
		TaskConfirmView:openUi(func)
		TaskConfirmView:setText(tr("您当前有任务奖励没有领取，是否确认需要刷新任务？"))
	else
		func()
	end
	
end

---
-- 检测是否达到最大完成次数，并禁用按钮
-- @function [parent=#FlashTaskCell] checkCountIsFull
-- @param self
--
function FlashTaskCell:checkCountIsFull()
	if not self.owner or not self.owner.owner then return end
	
	local attrTbl = require("model.HeroAttr")
	if attrTbl.DailyTaskTimes then
		self:setCountStr(attrTbl.DailyTaskTimes)
		
		if attrTbl.DailyTaskTimes >= 12 then
			self["flashBtn"]:setEnabled(false)
		else
			self["flashBtn"]:setEnabled(true)
		end
	else
		self:setCountStr(0)
		self["flashBtn"]:setEnabled(true)
	end
end

---
-- 设置完成任务次数
--  @function [parent=#FlashTaskCell] setCountStr
--  @param self
--  @param #number count 次数
--
function FlashTaskCell:setCountStr(count)
	self["countLab"]:setString("  " .. count .." / 12")
end