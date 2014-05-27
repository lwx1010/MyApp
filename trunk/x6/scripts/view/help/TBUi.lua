----
-- pp用户中心
-- @module view.help.TBUi
-- 

local class = class
local require = require
local tr = tr
local printf = printf

local moduleName = "view.help.TBUi"
module(moduleName)

---
-- 类定义
-- @type TBUi
-- 
local TBUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 创建实例
-- @function [parent=#view.help.TBUi] new
-- @return #TBUi实例 
-- 
function new()
	return TBUi.new()
end

---
-- 构造函数
-- @function [parent=#TBUi] ctor
-- @param self
-- 
function TBUi:ctor()
	self.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#TBUi] _create
-- @param self
-- 
function TBUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_sysmanage/ui_pppiece.ccbi", true)
	
	self:handleButtonEvent("checkCcb.aBtn", self._checkClkHandler)
	
	self["userCenterLab"]:setString(tr("同步推用户中心"))
end

---
-- 点击了查看
-- @function [parent=#TBUi] _checkClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function TBUi:_checkClkHandler(sender,event)
	local luaoc = require("framework.client.luaoc")
	luaoc.callStaticMethod("TBSdk", "enterUserCenter", nil)
end