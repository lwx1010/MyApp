---
-- 运营活动图片子项界面
-- @module view.activity.ActivityNewCell
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local CCSize = CCSize
local ccp = ccp
local tr = tr
local string = string
local dump = dump

local moduleName = "view.activity.ActivityNewCell"
module(moduleName)


---
-- 类定义
-- @type ActivityNewCell
-- 
local ActivityNewCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 创建实例
-- @return ActivityNewCell实例
-- 
function new()
	return ActivityNewCell.new()
end

---
-- 构造函数
-- @function [parent=#ActivityNewCell] ctor
-- @param self
-- 
function ActivityNewCell:ctor()
	ActivityNewCell.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#ActivityNewCell] _create
-- @param self
-- 
function ActivityNewCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_mainstage/ui_mainstage_scroll.ccbi", true)
	
end

---
-- 显示数据
-- @function [parent=#ActivityNewCell] showItem
-- @param self
-- @param #table activity 活动信息
-- 
function ActivityNewCell:showItem(activity)
	if not activity then
		self:changeTexture("activitySpr", nil)
		return
	end
	
	self._activity = activity
	
	if activity.ActTrueNo == 1014 then
		self:changeTexture("activitySpr", "ui/ccb/ccbResources/layout/share/"..activity.ActPic..".jpg")
	else
		self:changeTexture("activitySpr", "ui/ccb/ccbResources/layout/share/"..activity.Pic..".jpg")
	end
end


