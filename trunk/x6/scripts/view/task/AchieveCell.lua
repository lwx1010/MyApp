--- 
-- 成就条目
-- @module view.task.AchieveCell
-- 

local class = class
local printf = printf
local require = require
local tr = tr

local moduleName = "view.task.AchieveCell"
module(moduleName)


--- 
-- 类定义
-- @type AchieveCell
-- 
local AchieveCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 道具
-- @field [parent=#AchieveCell] #Task_info _taskItem
-- 
AchieveCell._taskItem = nil

---  
-- 是否选中
-- @field [parent=#AchieveCell] #boolean _selected
-- 
--AchieveCell._selected = false

--- 创建实例
-- @return AchieveCell实例
function new()
	return AchieveCell.new()
end

--- 
-- 构造函数
-- @function [parent=#AchieveCell] ctor
-- @param self
-- 
function AchieveCell:ctor()
	AchieveCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#AchieveCell] _create
-- @param self
-- 
function AchieveCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_task/ui_sigleachivement.ccbi", true)
	
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
-- @function [parent=#AchieveCell] showItem
-- @param self
-- @param #Task_info item 道具
-- 
function AchieveCell:showItem( item )
	self._taskItem = item
	
	if( not item ) then
		return
	end
	
	
end

---
-- 点击了领取奖励
-- @function [parent=#AchieveCell] _pickClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function AchieveCell:_pickClkHandler( sender, event )
	
end 

---
-- ui点击处理
-- @function [parent=#AchieveCell] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function AchieveCell:uiClkHandler( ui, rect )
	if( not self.owner or not self.owner.owner or not self._item ) then return end
	
	local view = self.owner.owner
	view:updateSelectShow( self )
end

---
-- 获取武学信息
-- @function [parent=#AchieveCell] getItem
-- @param self
-- @return model.Item#Item 
-- 
function AchieveCell:getItem()
	return self._item
end
