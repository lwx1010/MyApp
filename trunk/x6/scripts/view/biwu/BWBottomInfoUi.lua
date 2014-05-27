---
-- 比武界面底下信息
-- @module view.biwu.BWBottomInfoUi
--

local require = require
local class = class


local moduleName = "view.biwu.BWBottomInfoUi"
module(moduleName)


--- 
-- 类定义
-- @type BWBottomInfoUi
-- 
local BWBottomInfoUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent = #BWBottomInfoUi] ctor
-- 
function BWBottomInfoUi:ctor()
	BWBottomInfoUi.super.ctor(self)
	self:_create()
end

---
-- 创建加载ccbi文件
-- @function [parent = #BWBottomInfoUi] _create
-- 
function BWBottomInfoUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_pk/ui_pkcontent_bottom.ccbi", true)
	
	self:handleButtonEvent("changeCcb.aBtn", self._changeClkHandler)
end


--- 
-- 点击了换一组
-- @function [parent=#BWBottomInfoUi] _changeClkHandler
-- @param self
-- @param #CCNode sender            
-- @param #table event
-- 
function BWBottomInfoUi:_changeClkHandler( sender, event )
	--- 获取比武界面信息
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_biwu_info", {open_type = 2})
end

---
-- 场景退出回调 
-- @function [parent = #BWBottomInfoUi] onExit
-- 
function BWBottomInfoUi:onExit()
	require("view.biwu.BWBottomInfoUi").instance = nil
	BWBottomInfoUi.super.onExit(self)
end

