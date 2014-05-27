--- 
-- 任务条目
-- @module view.task.TaskCell
-- 

local class = class
local printf = printf
local require = require
local tr = tr

local moduleName = "view.task.TaskCell"
module(moduleName)


--- 
-- 类定义
-- @type TaskCell
-- 
local TaskCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 道具
-- @field [parent=#TaskCell] #Task_info _taskItem
-- 
TaskCell._taskItem = nil

---  
-- 是否选中
-- @field [parent=#TaskCell] #boolean _selected
-- 
--TaskCell._selected = false

--- 创建实例
-- @return TaskCell实例
function new()
	return TaskCell.new()
end

--- 
-- 构造函数
-- @function [parent=#TaskCell] ctor
-- @param self
-- 
function TaskCell:ctor()
	TaskCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#TaskCell] _create
-- @param self
-- 
function TaskCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_task/ui_sigletask.ccbi", true)
	
--	self:setCellClkMode(true)
--	self:_createClkHelper()
--	self._clkHelper:addUi(node)
--	self._clkHelper:setTouchEnabled(true)
--	
--	self["selectS9Spr"]:setVisible(self._selected)

	self:handleButtonEvent("pickCcb.aBtn", self._pickClkHandler)
end

--- 
-- 显示数据
-- @function [parent=#TaskCell] showItem
-- @param self
-- @param #Task_info item 道具
-- 
function TaskCell:showItem( item )
	self._taskItem = item
	
	if( not item ) then
		self["targetLab"]:setString("")
		self["descLab"]:setString("")
		self["rewardLab"]:setString("")
		self:showBtn("pickCcb", false)
		self["finishSpr"]:setVisible(false)
--		self["finishBgSpr"]:setVisible(false)
		return
	end
	
	self["targetLab"]:setString(item.name)
	self["descLab"]:setString(item.des)
	self["rewardLab"]:setString(item.reward)
	self["finishSpr"]:setVisible(item.isfinish == 1)
--	self["finishBgSpr"]:setVisible(item.isfinish == 1)
	
	self:showBtn("pickCcb", item.isfinish == 1)
end

---
-- 点击了领取奖励
-- @function [parent=#TaskCell] _pickClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function TaskCell:_pickClkHandler( sender, event )
	printf("you have clicked the pickCcb.aBtn!")
	if not self._taskItem then return end
	if self._taskItem.isfinish ~= 1 then 
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("任务未完成，无法领取奖励!"))
		return
	end
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_task_getreward", {taskid = self._taskItem.taskid})
end 

---
-- ui点击处理
-- @function [parent=#TaskCell] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function TaskCell:uiClkHandler( ui, rect )
	if( not self.owner or not self.owner.owner or not self._taskItem ) then return end
	
	local view = self.owner.owner
	view:updateSelectShow( self )
end

---
-- 获取武学信息
-- @function [parent=#TaskCell] getItem
-- @param self
-- @return model.Item#Item 
-- 
function TaskCell:getItem()
	return self._item
end
