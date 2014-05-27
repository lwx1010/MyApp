--- 
-- 修改密码界面
-- @module view.help.ChangePwdView
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local kEditBoxInputFlagPassword = kEditBoxInputFlagPassword
local ccc3 = ccc3
local PLATFORM_NAME = PLATFORM_NAME

local moduleName = "view.help.ChangePwdView"
module(moduleName)


--- 
-- 类定义
-- @type ChangePwdView
-- 
local ChangePwdView = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 构造函数
-- @function [parent=#ChangePwdView] ctor
-- @param self
-- 
function ChangePwdView:ctor()
	ChangePwdView.super.ctor(self)
	
	self:_create()
	--self:retain()
end

--- 
-- 创建
-- @function [parent=#ChangePwdView] _create
-- @param self
-- 
function ChangePwdView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_sysmanage/ui_changepass.ccbi")
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("okBtn", self._okClkHandler)
	
	local oldPwdEdit = self["oldPwdEdit"]
	oldPwdEdit:setPlaceHolder(tr("点击输入密码"))
	oldPwdEdit:setInputFlag(kEditBoxInputFlagPassword)
	oldPwdEdit:setFontColor(ccc3(0,0,0))
	oldPwdEdit:setMaxLength(16)

	local pwdEdit = self["newPwdEdit1"]
	pwdEdit:setPlaceHolder(tr("点击输入密码"))
	pwdEdit:setInputFlag(kEditBoxInputFlagPassword)
	pwdEdit:setFontColor(ccc3(0,0,0))
	pwdEdit:setMaxLength(16)
	
	pwdEdit = self["newPwdEdit2"]
	pwdEdit:setPlaceHolder(tr("点击输入密码"))
	pwdEdit:setInputFlag(kEditBoxInputFlagPassword)
	pwdEdit:setFontColor(ccc3(0,0,0))
	pwdEdit:setMaxLength(16)
end

--- 
-- 点击了确定
-- @function [parent=#ChangePwdView] _okClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function ChangePwdView:_okClkHandler( sender, event )
	local oldPwdEdit = self["oldPwdEdit"]
	local pwdEdit1 = self["newPwdEdit1"]
	local pwdEdit2 = self["newPwdEdit2"]
	local oldPwd = oldPwdEdit:getText()
	local pwd1 = pwdEdit1:getText()
	local pwd2 = pwdEdit2:getText()
	
	local string = require("string")
	if oldPwd then
		oldPwd = string.trim(oldPwd)
	end
	
	if pwd1 then
		pwd1 = string.trim(pwd1)
	end
	
	if pwd2 then
		pwd2 = string.trim(pwd2)
	end
	
	if not oldPwd or not pwd1 or not pwd2 or #oldPwd==0 or #pwd1==0 or #pwd2==0 then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("密码为空")}, {{text=tr("确定")}})
		return
	end
	
	if pwd1~=pwd2 then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("两次输入的新密码不一致")}, {{text=tr("确定")}})
		return
	end

	-- 登录
	local MHSdk = require("logic.sdk.MHSdk")
	
	if MHSdk.getPwd()~=oldPwd then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("旧密码不正确")}, {{text=tr("确定")}})
		return
	end
	
	if #pwd1<MHSdk.PWD_MIN_LEN or #pwd1>MHSdk.PWD_MAX_LEN then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("密码长度限制为 "..MHSdk.PWD_MIN_LEN.."~"..MHSdk.PWD_MAX_LEN.." 字节")}, {{text=tr("确定")}})
		return
	end
	
	MHSdk.reset(MHSdk.getAccount(), PLATFORM_NAME, MHSdk.getToken(), pwd1)
end

--- 
-- 点击了关闭
-- @function [parent=#ChangePwdView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function ChangePwdView:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 关闭界面时调用
-- @function [parent=#ChangePwdView] onExit
-- @param self
-- 
function ChangePwdView:onExit()
	instance = nil
	
	ChangePwdView.super.onExit(self)
end

---
-- 打开界面调用
-- @function [parent=#ChangePwdView] openUi
-- @param self
-- 
function ChangePwdView:openUi()
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
end

