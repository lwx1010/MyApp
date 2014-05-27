---
-- 活动内容子项界面
-- @module view.activity.ActivityLabCell
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local CCSize = CCSize
local ccp = ccp
local tr = tr
local string = string

local moduleName = "view.activity.ActivityLabCell"
module(moduleName)


---
-- 类定义
-- @type ActivityLabCell
-- 
local ActivityLabCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 创建实例
-- @return ActivityLabCell实例
-- 
function new()
	return ActivityLabCell.new()
end

---
-- 构造函数
-- @function [parent=#ActivityLabCell] ctor
-- @param self
-- 
function ActivityLabCell:ctor()
	ActivityLabCell.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#ActivityLabCell] _create
-- @param self
-- 
function ActivityLabCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_mainstage/ui_yunyinghuodong1.ccbi", true)
	
	self:setAnchorPoint(ccp(0,0))
	self["desLab"]:setAnchorPoint(ccp(0,0))
	self["desLab"]:setPosition(0,0)
end

---
-- 显示数据
-- @function [parent=#ActivityLabCell] showItem
-- @param self
-- @param #string des 活动信息
-- 
function ActivityLabCell:showItem(des)
	self["desLab"]:setString(tr(des))
	local desLabHeight = self["desLab"]:getContentSize().height
	
	local width = 510
	local height = desLabHeight
	self:setContentSize(CCSize(width, height))
end

