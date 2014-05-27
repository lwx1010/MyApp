----
-- 游戏活动界面
-- @module view.help.ActivityUi
-- 

local class = class
local require = require
local printf = printf
local tr = tr

local moduleName = "view.help.ActivityUi"
module(moduleName)

---
-- 类定义
-- @type ActivityUi
-- 
local ActivityUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 创建实例
-- @function [parent=#view.help.ActivityUi] new
-- @return #ActivityUi实例 
-- 
function new()
	return ActivityUi.new()
end

---
-- 构造函数
-- @function [parent=#ActivityUi] ctor
-- @param self
-- 
function ActivityUi:ctor()
	self.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#ActivityUi] _create
-- @param self
-- 
function ActivityUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_sysmanage/ui_gonggao.ccbi", true)
	
	self:handleButtonEvent("checkCcb.aBtn", self._checkClkHandler)
end

---
-- 点击了查看
-- @function [parent=#ActivityUi] _checkClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function ActivityUi:_checkClkHandler( sender, event )
	local ActivityNewView = require("view.activity.ActivityNewView")
	local GameView = require("view.GameView")
	GameView.addPopUp(ActivityNewView.createInstance(), true)
	GameView.center(ActivityNewView.instance)
end



