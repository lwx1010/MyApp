---
-- 积分界面底下信息
-- @module view.biwu.BWBottomPageUi
--

local require = require
local class = class


local moduleName = "view.biwu.BWBottomPageUi"
module(moduleName)


--- 
-- 类定义
-- @type BWBottomPageUi
-- 
local BWBottomPageUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent = #BWBottomPageUi] ctor
-- 
function BWBottomPageUi:ctor()
	BWBottomPageUi.super.ctor(self)
	self:_create()
end

---
-- 创建加载ccbi文件
-- @function [parent = #BWBottomPageUi] _create
-- 
function BWBottomPageUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_pk/ui_pkcontent_bottom1.ccbi", true)
end

---
-- 场景退出回调
-- @function [parent = #BWBottomPageUi] onExit
-- 
function BWBottomPageUi:onExit()
	require("view.biwu.BWBottomPageUi").instance = nil
	BWBottomPageUi.super.onExit(self)
end




