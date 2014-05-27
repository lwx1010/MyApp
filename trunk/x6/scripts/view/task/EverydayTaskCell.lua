--- 
-- 日常任务任务条目
-- @module view.task.EverydayTaskCell
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local ipairs = ipairs
local CCLayer = CCLayer

local moduleName = "view.task.EverydayTaskCell"
module(moduleName)


--- 
-- 类定义
-- @type EverydayTaskCell
-- 
local EverydayTaskCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 任务内容
-- @field [parent=#EverydayTaskCell] #table _item
-- 
EverydayTaskCell._item = nil

---
-- 任务类型(0为普通类型,1为交付类型)
-- @field [parent=#EverydayTaskCell] #number _taskType
-- 
EverydayTaskCell._taskType = 0


--- 创建实例
-- @return EverydayTaskCell实例
function new()
	return EverydayTaskCell.new()
end

--- 
-- 构造函数
-- @function [parent=#EverydayTaskCell] ctor
-- @param self
-- 
function EverydayTaskCell:ctor()
	EverydayTaskCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#EverydayTaskCell] _create
-- @param self
-- 
function EverydayTaskCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_task/ui_richangpiece2.ccbi", true)

	self:handleButtonEvent("aBtn", self._btnClkHandler)
end

---
-- 显示内容
-- @function [parent=#EverydayTaskCell] showItem
-- @param self
-- @param #table item 任务项
-- 
function EverydayTaskCell:showItem(item)
	if item then
		if self._item then self._item.owner = nil end
		self._item = item
		item.owner = self
	else
		self:setVisible(false)
		return
	end
	
	local targetStr = self._item.name .. " <c5>(" .. self._item.num .. "/" .. self._item.neednum .. ")</c>"
	self["targetLab"]:setString(targetStr)
	self["conditionLab"]:setString(self._item.des)
	self["rewardLab"]:setString(self._item.reward)
	
	local x = self["targetLab"]:getPositionX()
	local width = self["targetLab"]:getContentSize().width
	local sx = x + width + 30
	
	local amount = self._item.star
	local str = "starSpr"
	
	for i = 1, 5 do
		self[str .. i]:setVisible(false)
	end
	
	for i = 1, amount do
		self[str .. i]:setVisible(true)
		self[str .. i]:setPositionX(sx)
		sx = sx + 30
	end
	
	if self._item.isfinish == 0 then
		-- 未完成
		self["noFinishSpr"]:setVisible(true)
		self["finishSpr"]:setVisible(false)
		self["pickCcbSpr"]:setVisible(false)
		if self._item.type ~= 13 then
			self["payResourceSpr"]:setVisible(false)
			self["aBtn"]:setVisible(false)
		else
			self["payResourceSpr"]:setVisible(true)
			self["aBtn"]:setVisible(true)
		end
	else
		-- 完成
		self["noFinishSpr"]:setVisible(false)
		self["finishSpr"]:setVisible(true)
		self["aBtn"]:setVisible(true)
		self["pickCcbSpr"]:setVisible(true)
		self["payResourceSpr"]:setVisible(false)
		
		local attrTbl = require("model.HeroAttr")
		if attrTbl.DailyTaskTimes and attrTbl.DailyTaskTimes >= 12 then
			self["aBtn"]:setVisible(false)
			self["pickCcbSpr"]:setVisible(false)
		end	
	end
	-- 显示任务
end

---
-- 按钮点击处理函数
-- @function [parent=#EverydayTaskCell] _btnClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function EverydayTaskCell:_btnClkHandler(sender, event)
	-- 根据item里面的字段判断是普通还是交付类任务
	
	if not self._item then return end
	if not self.owner or not self.owner.owner then return end 
	
	if self._item.isfinish == 1 then
		-- 领奖励
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_dailytask_getreward", {taskid = self._item.taskid})

		self.owner.owner.pickRewardCount = self.owner.owner.pickRewardCount + 1
		self.owner.item["flash"]:checkCountIsFull()
		
		local EverydayTaskData = require("model.EverydayTaskData")
		EverydayTaskData.removeTask(self._item)
	elseif self._item.type == 13 then	
		local SelectResourceView = require("view.task.SelectResourceView").createInstance()
		local con = self._item.finishcondition
		SelectResourceView:openUi(con[2], con[3], con[1])
	end
end
