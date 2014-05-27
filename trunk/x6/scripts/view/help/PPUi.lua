----
-- pp用户中心
-- @module view.help.PPUi
-- 

local class = class
local require = require
local printf = printf

local moduleName = "view.help.PPUi"
module(moduleName)

---
-- 类定义
-- @type PPUi
-- 
local PPUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 创建实例
-- @function [parent=#view.help.PPUi] new
-- @return #PPUi实例 
-- 
function new()
	return PPUi.new()
end

---
-- 构造函数
-- @function [parent=#PPUi] ctor
-- @param self
-- 
function PPUi:ctor()
	self.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#PPUi] _create
-- @param self
-- 
function PPUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_sysmanage/ui_pppiece.ccbi", true)
	
	self:handleButtonEvent("checkCcb.aBtn", self._checkClkHandler)
end

---
-- 点击了查看
-- @function [parent=#PPUi] _checkClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function PPUi:_checkClkHandler(sender,event)
	local luaoc = require("framework.client.luaoc")
	luaoc.callStaticMethod("PPSdk", "showCenter", nil)
end



