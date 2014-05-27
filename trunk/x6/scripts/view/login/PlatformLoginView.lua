---
-- 平台登录界面
-- @module view.login.PlatformLoginView
-- 

local require = require
local class = class
local CCRect = CCRect
local CCFadeTo = CCFadeTo
local CCRepeatForever = CCRepeatForever
local transition = transition
local printf = printf
local CCBlink = CCBlink
local CCDelayTime = CCDelayTime

local moduleName = "view.login.PlatformLoginView"
module(moduleName)


--- 
-- 类定义
-- @type PlatformLoginView
-- 
local PlatformLoginView = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 创建实例
-- @function [parent=#view.login.PlatformLoginView] new
-- @return #PlatformLoginView
-- 
function new()
	return PlatformLoginView.new()
end

--- 
-- 构造函数
-- @function [parent=#PlatformLoginView] ctor
-- @param self
-- 
function PlatformLoginView:ctor()
	PlatformLoginView.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#PlatformLoginView] _create
-- @param self
-- 
function PlatformLoginView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_login/ui_login_relogin.ccbi")
	
	local action = transition.sequence({
			CCFadeTo:create(0.2, 100),
			CCFadeTo:create(0.2, 255),
			CCDelayTime:create(0.2),
			})
	local actionForever = CCRepeatForever:create(action)
	self["desSpr"]:runAction(actionForever)
	
	self:createClkHelper()
	self:addClkUi(node)
	
--	local PlatformLogic = require("logic.PlatformLogic")
--	PlatformLogic.openLoginView()
end

---
-- ui点击处理
-- @function [parent=#PlatformLoginView] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function PlatformLoginView:uiClkHandler( ui, rect )
	local PlatformLogic = require("logic.PlatformLogic")
	PlatformLogic.openSdkLogin()
end

---
-- 退出场景
-- @function [parent=#PlatformLoginView] onExit
-- @param self
-- 
function PlatformLoginView:onExit()
	instance = nil
	PlatformLoginView.super.onExit(self)
end







