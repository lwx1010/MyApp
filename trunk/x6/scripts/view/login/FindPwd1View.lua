--- 
-- 找回密码1界面
-- @module view.login.FindPwd1View
-- 

local class = class
local require = require
local printf = printf
local tr = tr
local PLATFORM_NAME = PLATFORM_NAME
local kEditBoxInputFlagPassword = kEditBoxInputFlagPassword
local ccc3 = ccc3

local moduleName = "view.login.FindPwd1View"
module(moduleName)

--- 
-- 类定义
-- @type FindPwd1View
-- 
local FindPwd1View = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 创建实例
-- @function [parent=#view.login.FindPwd1View] new
-- @return #FindPwd1View
-- 
function new()
	return FindPwd1View.new()
end

--- 
-- 构造函数
-- @function [parent=#FindPwd1View] ctor
-- @param self
-- 
function FindPwd1View:ctor()
	FindPwd1View.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#FindPwd1View] _create
-- @param self
-- 
function FindPwd1View:_create()

	local undumps = self:load("ui/ccb/ccbfiles/ui_login/ui_findpassword.ccbi")

	self:handleButtonEvent("nextBtn", self._nextClkHandler)
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("returnBtn", self._returnClkHandler)
	
	local acctEdit = self["acctEdit"]
	acctEdit:setPlaceHolder(tr("点击输入账号"))
	acctEdit:setFontColor(ccc3(0,0,0))
	acctEdit:setMaxLength(16)
end

--- 
-- 点击了下一步
-- @function [parent=#FindPwd1View] _nextClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function FindPwd1View:_nextClkHandler( sender, event )
	local acctEdit = self["acctEdit"]
	local acct = acctEdit:getText()
	
	local string = require("string")
	if acct then
		acct = string.trim(acct)
	end
	
	if not acct or #acct==0 then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("账号为空")}, {{text=tr("确定")}})
		return
	end
	
	-- 登录
	local MHSdk = require("logic.sdk.MHSdk")
	MHSdk.repass1(acct, PLATFORM_NAME)
end

--- 
-- 点击了返回
-- @function [parent=#FindPwd1View] _returnClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function FindPwd1View:_returnClkHandler( sender, event )
	local GameView = require("view.GameView")
	local LoginView = require("view.login.LoginView")
	GameView.replaceMainView(LoginView.new())
end

--- 
-- 点击了关闭
-- @function [parent=#FindPwd1View] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function FindPwd1View:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
	local LoginView = require("view.login.LoginView")
	GameView.replaceMainView(LoginView.new())
end

---
-- 退出场景
-- @function [parent=#FindPwd1View] onExit
-- @param self
-- 
function FindPwd1View:onExit()
	instance = nil
	FindPwd1View.super.onExit(self)
end
