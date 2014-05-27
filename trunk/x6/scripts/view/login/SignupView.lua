--- 
-- 注册界面
-- @module view.login.SignupView
-- 

local class = class
local require = require
local printf = printf
local tr = tr
local PLATFORM_NAME = PLATFORM_NAME
local kEditBoxInputFlagPassword = kEditBoxInputFlagPassword
local ccc3 = ccc3
local CONFIG = CONFIG

local moduleName = "view.login.SignupView"
module(moduleName)

--- 
-- 类定义
-- @type SignupView
-- 
local SignupView = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 创建实例
-- @function [parent=#view.login.SignupView] new
-- @return #SignupView
-- 
function new()
	return SignupView.new()
end

--- 
-- 构造函数
-- @function [parent=#SignupView] ctor
-- @param self
-- 
function SignupView:ctor()
	SignupView.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#SignupView] _create
-- @param self
-- 
function SignupView:_create()
	
	local ConfigParams = require("model.const.ConfigParams")
	
	if CONFIG[ConfigParams.IS_FCM] and CONFIG[ConfigParams.IS_FCM]>0 then
		self:load("ui/ccb/ccbfiles/ui_login/ui_register_bs.ccbi")
	else
		self:load("ui/ccb/ccbfiles/ui_login/ui_register.ccbi")
	end

	self:handleButtonEvent("okBtn", self._okClkHandler)
	self:handleButtonEvent("returnBtn", self._returnClkHandler)
	
	local acctEdit = self["acctEdit"]
	acctEdit:setPlaceHolder(tr("点击输入账号"))
	acctEdit:setFontColor(ccc3(0,0,0))
	acctEdit:setMaxLength(16)

	local pwdEdit = self["pwdEdit1"]
	pwdEdit:setPlaceHolder(tr("点击输入密码"))
	pwdEdit:setInputFlag(kEditBoxInputFlagPassword)
	pwdEdit:setFontColor(ccc3(0,0,0))
	pwdEdit:setMaxLength(16)
	
	pwdEdit = self["pwdEdit2"]
	pwdEdit:setPlaceHolder(tr("点击输入密码"))
	pwdEdit:setInputFlag(kEditBoxInputFlagPassword)
	pwdEdit:setFontColor(ccc3(0,0,0))
	pwdEdit:setMaxLength(16)
	
	local cardEdit = self["cardEdit"]
	if cardEdit then
		cardEdit:setPlaceHolder(tr("点击输入身份证"))
		cardEdit:setFontColor(ccc3(0,0,0))
		cardEdit:setMaxLength(16)
	end
end

--- 
-- 点击了确定
-- @function [parent=#SignupView] _okClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function SignupView:_okClkHandler( sender, event )
	local acctEdit = self["acctEdit"]
	local pwdEdit1 = self["pwdEdit1"]
	local pwdEdit2 = self["pwdEdit2"]
	local acct = acctEdit:getText()
	local pwd1 = pwdEdit1:getText()
	local pwd2 = pwdEdit2:getText()
	
	local string = require("string")
	if acct then
		acct = string.trim(acct)
	end
	
	if pwd1 then
		pwd1 = string.trim(pwd1)
	end
	
	if pwd2 then
		pwd2 = string.trim(pwd2)
	end
	
	if not acct or not pwd1 or not pwd2 or #acct==0 or #pwd1==0 or #pwd2==0 then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("用户名或密码为空")}, {{text=tr("确定")}})
		return
	end
	
	if pwd1~=pwd2 then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("两次输入的密码不一致")}, {{text=tr("确定")}})
		return
	end

	-- 登录
	local MHSdk = require("logic.sdk.MHSdk")
	
	if #acct<MHSdk.ACCOUNT_MIN_LEN or #acct>MHSdk.ACCOUNT_MAX_LEN then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("账号长度限制为 "..MHSdk.ACCOUNT_MIN_LEN.."~"..MHSdk.ACCOUNT_MAX_LEN.." 字节")}, {{text=tr("确定")}})
		return
	end
	
	if #pwd1<MHSdk.PWD_MIN_LEN or #pwd1>MHSdk.PWD_MAX_LEN then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("密码长度限制为 "..MHSdk.PWD_MIN_LEN.."~"..MHSdk.PWD_MAX_LEN.." 字节")}, {{text=tr("确定")}})
		return
	end
	
	local card
	local cardEdit = self["cardEdit"]
	if cardEdit then
		card = cardEdit:getText()
		
		if card then
			card = string.trim(card)
			
			if #card~=0 and #card~=18 then
				local Alert = require("view.notify.Alert")
				Alert.show({text=tr("身份证位数不正确")}, {{text=tr("确定")}})
			end
		end
	end
	
	MHSdk.signup(acct, PLATFORM_NAME, pwd1, card)
end

--- 
-- 点击了返回
-- @function [parent=#SignupView] _findPwdClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function SignupView:_returnClkHandler( sender, event )
	local GameView = require("view.GameView")
	local LoginView = require("view.login.LoginView")
	GameView.replaceMainView(LoginView.new())
end

---
-- 退出场景
-- @function [parent=#SignupView] onExit
-- @param self
-- 
function SignupView:onExit()
	instance = nil
	SignupView.super.onExit(self)
end
