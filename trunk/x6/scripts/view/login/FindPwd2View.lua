--- 
-- 找回密码2界面
-- @module view.login.FindPwd2View
-- 

local class = class
local require = require
local printf = printf
local tr = tr
local PLATFORM_NAME = PLATFORM_NAME
local kEditBoxInputFlagPassword = kEditBoxInputFlagPassword
local ccc3 = ccc3

local moduleName = "view.login.FindPwd2View"
module(moduleName)

--- 
-- 类定义
-- @type FindPwd2View
-- 
local FindPwd2View = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 账号
-- @field [parent=#LoginView] #string _account
-- 
FindPwd2View._account = nil

--- 
-- 创建实例
-- @function [parent=#view.login.FindPwd2View] new
-- @return #FindPwd2View
-- 
function new()
	return FindPwd2View.new()
end

--- 
-- 构造函数
-- @function [parent=#FindPwd2View] ctor
-- @param self
-- 
function FindPwd2View:ctor()
	FindPwd2View.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#FindPwd2View] _create
-- @param self
-- 
function FindPwd2View:_create()

	local undumps = self:load("ui/ccb/ccbfiles/ui_login/ui_findpassword2.ccbi")

	self:handleButtonEvent("okBtn", self._okClkHandler)
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("returnBtn", self._returnClkHandler)
	
	local codeEdit = self["codeEdit"]
	codeEdit:setPlaceHolder(tr("点击输入校验码"))
	codeEdit:setFontColor(ccc3(0,0,0))
	codeEdit:setMaxLength(16)
	
	local newPwdEdit = self["newPwdEdit1"]
	newPwdEdit:setPlaceHolder(tr("点击输入密码"))
	newPwdEdit:setInputFlag(kEditBoxInputFlagPassword)
	newPwdEdit:setFontColor(ccc3(0,0,0))
	newPwdEdit:setMaxLength(16)
	
	newPwdEdit = self["newPwdEdit2"]
	newPwdEdit:setPlaceHolder(tr("点击输入密码"))
	newPwdEdit:setInputFlag(kEditBoxInputFlagPassword)
	newPwdEdit:setFontColor(ccc3(0,0,0))
	newPwdEdit:setMaxLength(16)
end

--- 
-- 设置账号
-- @function [parent=#FindPwd2View] setAccount
-- @param self
-- @param #string account 账号
-- 
function FindPwd2View:setAccount( account )
	self._account = account
end

--- 
-- 点击了确定
-- @function [parent=#FindPwd2View] _okClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function FindPwd2View:_okClkHandler( sender, event )
	if not self._account then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("账号为空")}, {{text=tr("确定")}})
		return
	end
	
	local codeEdit = self["codeEdit"]
	local pwdEdit1 = self["newPwdEdit1"]
	local pwdEdit2 = self["newPwdEdit2"]
	local code = codeEdit:getText()
	local pwd1 = pwdEdit1:getText()
	local pwd2 = pwdEdit2:getText()
	
	local string = require("string")
	if code then
		code = string.trim(code)
	end
	if pwd1 then
		pwd1 = string.trim(pwd1)
	end
	if pwd2 then
		pwd2= string.trim(pwd2)
	end
	
	if not code or #code==0 or not pwd1 or #pwd1==0 or not pwd2 or #pwd2==0 then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("校验码或密码为空")}, {{text=tr("确定")}})
		return
	end
	
	if pwd1~=pwd2 then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("两次输入的密码不一致")}, {{text=tr("确定")}})
		return
	end
	
	-- 
	local MHSdk = require("logic.sdk.MHSdk")
	
	if #pwd1<MHSdk.PWD_MIN_LEN or #pwd1>MHSdk.PWD_MAX_LEN then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("密码长度限制为 "..MHSdk.PWD_MIN_LEN.."~"..MHSdk.PWD_MAX_LEN.." 字节")}, {{text=tr("确定")}})
		return
	end
	
	MHSdk.repass2(self._account, PLATFORM_NAME, code, pwd1)
end

--- 
-- 点击了返回
-- @function [parent=#FindPwd2View] _returnClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function FindPwd2View:_returnClkHandler( sender, event )
	local GameView = require("view.GameView")
	local FindPwd1View = require("view.login.FindPwd1View")
	GameView.replaceMainView(FindPwd1View.new())
end

--- 
-- 点击了关闭
-- @function [parent=#FindPwd2View] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function FindPwd2View:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
	local LoginView = require("view.login.LoginView")
	GameView.replaceMainView(LoginView.new())
end

---
-- 退出场景
-- @function [parent=#FindPwd2View] onExit
-- @param self
-- 
function FindPwd2View:onExit()
	instance = nil
	FindPwd2View.super.onExit(self)
end
