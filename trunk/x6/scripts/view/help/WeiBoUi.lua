----
-- 绑定微博界面
-- @module view.help.WeiBoUi
-- 

local class = class
local require = require
local printf = printf
local tr = tr

local moduleName = "view.help.WeiBoUi"
module(moduleName)

---
-- 类定义
-- @type WeiBoUi
-- 
local WeiBoUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 创建实例
-- @function [parent=#view.help.WeiBoUi] new
-- @return #WeiBoUi实例 
-- 
function new()
	return WeiBoUi.new()
end

---
-- 构造函数
-- @function [parent=#WeiBoUi] ctor
-- @param self
-- 
function WeiBoUi:ctor()
	self.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#WeiBoUi] _create
-- @param self
-- 
function WeiBoUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_sysmanage/ui_weibo.ccbi", true)
	
	self:handleButtonEvent("bindCcb.aBtn", self._bindClkHandler)
end

---
-- 点击了绑定
-- @function [parent=#WeiBoUi] _bindClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function WeiBoUi:_bindClkHandler( sender, event )
	local FloatNotify = require("view.notify.FloatNotify")
	FloatNotify.show(tr("该功能尚未开放！"))
end



