--- 
-- 奖励信息界面
-- @module view.task.RewardView
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local dump = dump
local CCLayer = CCLayer

local moduleName = "view.task.RewardView"
module(moduleName)

---
-- 标记selectedIndex
-- @field [parent=#view.task.RewardView] #number _index
--
local _index = 1

--- 
-- 类定义
-- @type RewardView
-- 
local RewardView = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 当前显示tab（1，任务，2，成就）
-- @field [parent=#RewardView] #number _selectedIndex
--
RewardView._selectedIndex = 0

---
-- 日常任务view
-- @field [parent=#RewardView] #CCLayer _everydayView
-- 
RewardView._everydayView = nil

---
-- 签到view
-- @field [parent=#RewardView] #CCBView _signinView
-- 
RewardView._signinView = nil

---
-- 每日任务view是否已初始化
-- @field [parent=#RewardView] #boolean _isEverydayTaskInit
-- 
RewardView._isEverydayTaskInit = false

---
-- 领取奖励次数
-- @field [parent = #RewardView] #number pickRewardCount
-- 
RewardView.pickRewardCount = 0

--- 
-- 构造函数
-- @function [parent=#RewardView] ctor
-- @param self
-- 
function RewardView:ctor()
	RewardView.super.ctor(self)
	
	self:_create()
	--self:retain()
end

--- 
-- 创建
-- @function [parent=#RewardView] _create
-- @param self
-- 
function RewardView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_task/ui_task.ccbi")
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleRadioGroupEvent("tabRGrp", self._tabClkHandler)
	
	self["noneLab"]:setVisible(false)
	self["noneSpr"]:setVisible(false)
	
	self._everydayView = CCLayer:create()
	
	local x, y = self["infoVCBox"]:getPosition()
	local size = self["infoVCBox"]:getContentSize()
	
	self._everydayView:setPosition(x, y)
	self._everydayView:setContentSize(size)
	
	self:addChild(self._everydayView)
	self._everydayView.owner = self
	
	self["tabRGrp"]:setSelectedIndex(_index)
--	self:_tabClkHandler()

	local EverydayTaskData = require("model.EverydayTaskData")
	local DataSet = require("utils.DataSet")
	EverydayTaskData.task:addEventListener(DataSet.CHANGED.name, self._taskListChange, self)
end

---
-- 获取签到view
-- @field [parent=#RewardView] getSignInView
-- @param self
-- @return #SignInView
-- 
function RewardView:getSignInView()
	return self._signinView
end

--- 
-- 点击了tab
-- @function [parent=#RewardView] _tabClkHandler
-- @param self
-- @param ui.RadioGroup#SEL_CHANGED event
-- 
function RewardView:_tabClkHandler( event )
	
	local infoBox = self["infoVCBox"] -- ui.CellBox#CellBox
	
	--屏蔽第三项（不知道为什么ccb里面会有第三项）
--	if self["tabRGrp"]:getSelectedIndex() >= 2 then
--		 self["tabRGrp"]:setSelectedIndex(self._selectedIndex)
--		return
--	end
	
	local set
	self._selectedIndex = self["tabRGrp"]:getSelectedIndex()
	
	local GameNet = require("utils.GameNet")
	-- 显示任务
	if(self._selectedIndex <= 1) then
		infoBox:setVisible(true)
		self["infoVSBar"]:setVisible(true)
		self._everydayView:setVisible(false)
		if self._signinView then
			self._signinView:setVisible(false)
		end
		
		local TaskCell = require("view.task.TaskCell")
		infoBox:setCellRenderer(TaskCell)
		infoBox:setDataSet(nil)
		
		GameNet.send("C2s_task_infolist", {placeholder = 1})
	-- 显示日常任务
	elseif(self._selectedIndex == 2) then
		infoBox:setVisible(false)
		self["infoVSBar"]:setVisible(false)
		self._everydayView:setVisible(true)
		if self._signinView then
			self._signinView:setVisible(false)
		end
		
		if not self._isEverydayTaskInit then
			local EverydayTaskData = require("model.EverydayTaskData")
--			if not EverydayTaskData.isGetTaskList then
				-- 发送获取列表协议
				local GameNet = require("utils.GameNet")
				GameNet.send("C2s_dailytask_infolist", { placeholder = 1 })
				
				local NetLoading = require("view.notify.NetLoading")
				NetLoading.show()
--				local EverydayTaskData = require("model.EverydayTaskData")
--				EverydayTaskData.test()
--			else
--				self:_taskListChange()
--			end
		end
	elseif(self._selectedIndex == 3) then
		local SignInView = require("view.task.SignInView")
		if self._signinView then
			self._signinView:setVisible(true)
		else
			self._signinView = SignInView.new()
			local x, y = self["infoVCBox"]:getPosition()
			self._signinView:setPosition(x - 12, y - 5)
			self:addChild(self._signinView)
			SignInView.requestRewardInfo()
		end
		
		infoBox:setVisible(false)
		self["infoVSBar"]:setVisible(false)
		self._everydayView:setVisible(false)
	end
--	self:_dataChangedHandler()
end

--- 
-- 点击了关闭
-- @function [parent=#RewardView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function RewardView:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
    local MainView = require("view.main.MainView")
    GameView.replaceMainView(MainView.createInstance(), true)
end

---
-- 打开界面调用
-- @function [parent=#RewardView] openUi
-- @param self
-- 
function RewardView:openUi()
	-- 加载等待
--	local NetLoading = require("view.notify.NetLoading")
--	NetLoading.show()
	
	local GameView = require("view.GameView")
	GameView.replaceMainView(self, true)
	
	self:_tabClkHandler()
end

---
-- 更新任务列表
-- @function [parent=#RewardView] updateTaskList
-- @param self
-- @param #table list
-- 
function RewardView:updateTaskList( list )
	-- 加载等待
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()

	if self._selectedIndex > 1 then return end
	if not list then return end
	
--	dump(list)
	
	function sortByTaskNo(a, b)
		if a.isfinish ~= b.isfinish then
			return a.isfinish > b.isfinish 
		else
			return a.taskid < b.taskid
		end
	end
	
	local table = require("table")
	table.sort(list, sortByTaskNo)
	
	local infoBox = self["infoVCBox"] -- ui.CellBox#CellBox
	local DataSet = require("utils.DataSet")
	local dataset = DataSet.new()
	dataset:setArray(list)
	infoBox:setDataSet(dataset)
	
	--infoBox:getDataSet():addEventListener(DataSet.CHANGED.name, self._dataChangedHandler, self)
	self:_dataChangedHandler()
end

--- 
-- 数据变化
-- @function [parent=#RewardView] _dataChangedHandler
-- @param self
-- @param utils.DataSet#CHANGED event 数据集改变事件
-- 
function RewardView:_dataChangedHandler( event )
	local equipsBox = self["infoVCBox"] -- ui.CellBox#CellBox
	equipsBox:validate()
	local arr = equipsBox:getItemArr()
	if not arr or #arr == 0 then
		self["noneLab"]:setVisible(true)
		self["noneSpr"]:setVisible(true)
	else
		self["noneLab"]:setVisible(false)
		self["noneSpr"]:setVisible(false)
	end
end

---
-- 日常任务列表改变
-- @function [parent=#RewardView] _taskListChange
-- @param self
-- @param #table event
--
function RewardView:_taskListChange(event)
	local view = self._everydayView
	
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()
	
--	local func = function()
--		local EverydayTaskData = require("model.EverydayTaskData")
--		local task = EverydayTaskData.task
--		for i = event.beginIndex, event.endIndex do
--			local item = task:getItemAt(i)
--			local cell = view.item[i]
--			item.owner = cell
--			cell:showItem(item)
--		end
--	end
	
	if not self._isEverydayTaskInit then
		local x, y = view:getPosition()
		local size = view:getContentSize()
		local beginY = y + size.height - 5
		x = x - 21
		
		view.item = {}
		
		local FlashTaskCell = require("view.task.FlashTaskCell")
		local flashCell = FlashTaskCell:new()
		beginY = beginY - flashCell:getContentSize().height
		flashCell:setPosition(x, beginY)
		view:addChild(flashCell)
		view.item["flash"] = flashCell
		flashCell.owner = view
			
		local EverydayTaskCell = require("view.task.EverydayTaskCell")
		
		local EverydayTaskData = require("model.EverydayTaskData")
		local taskArr = EverydayTaskData.task:getArray()
		for i = 1, 3 do
			local dayCell = EverydayTaskCell:new()
			beginY = beginY - dayCell:getContentSize().height - 3
			dayCell:setPosition(x, beginY)
			view:addChild(dayCell)
			view.item[i] = dayCell
			dayCell:showItem(taskArr[i])
			dayCell.owner = view
		end
		
		self._isEverydayTaskInit = true
--		func()
	else
		local EverydayTaskData = require("model.EverydayTaskData")
		local taskArr = EverydayTaskData.task:getArray()
		for i = 1, 3 do
			view.item[i]:setVisible(false)
		end
		
		for i = 1, #taskArr do
			view.item[i]:showItem(taskArr[i])
			view.item[i]:setVisible(true)
		end
--		func()
	end
	
	view.item["flash"]:checkCountIsFull()
end

---
-- 关闭界面时调用
-- @function [parent=#RewardView] onExit
-- @param self
-- 
function RewardView:onExit()
	self._isEverydayTaskInit = false
	self._signinView = nil
	instance = nil
	
	self["infoVCBox"]:setDataSet(nil)
	
	_index = self["tabRGrp"]:getSelectedIndex()
	
	local EverydayTaskData = require("model.EverydayTaskData")
	local DataSet = require("utils.DataSet")
	EverydayTaskData.task:removeEventListener(DataSet.CHANGED.name, self._taskListChange, self)
	EverydayTaskData.task:removeEventListener(DataSet.ITEM_UPDATED.name, self._taskItemChange, self)
	
	RewardView.super.onExit(self)
end