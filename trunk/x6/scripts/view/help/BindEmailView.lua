--- 
-- 绑定邮箱界面
-- @module view.help.BindEmailView
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local ccc3 = ccc3
local PLATFORM_NAME = PLATFORM_NAME

local moduleName = "view.help.BindEmailView"
module(moduleName)


--- 
-- 类定义
-- @type BindEmailView
-- 
local BindEmailView = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 构造函数
-- @function [parent=#BindEmailView] ctor
-- @param self
-- 
function BindEmailView:ctor()
	BindEmailView.super.ctor(self)
	
	self:_create()
	--self:retain()
end

--- 
-- 创建
-- @function [parent=#BindEmailView] _create
-- @param self
-- 
function BindEmailView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_sysmanage/ui_bundmailbox.ccbi")
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("okBtn", self._okClkHandler)
	
	local emailEdit = self["emailEdit"]
	emailEdit:setPlaceHolder(tr("点击输入邮箱"))
	emailEdit:setFontColor(ccc3(0,0,0))
	emailEdit:setMaxLength(16)
end

--- 
-- 点击了确定
-- @function [parent=#BindEmailView] _okClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BindEmailView:_okClkHandler( sender, event )
	local emailEdit = self["emailEdit"]
	local email = emailEdit:getText()
	
	local string = require("string")
	if email then
		email = string.trim(email)
	end
	
	if not email or #email==0 then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("邮箱为空")}, {{text=tr("确定")}})
		return
	end

	-- 登录
	local MHSdk = require("logic.sdk.MHSdk")
	
	MHSdk.reset(MHSdk.getAccount(), PLATFORM_NAME, MHSdk.getToken(), nil, nil, email)
end

--- 
-- 点击了关闭
-- @function [parent=#BindEmailView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BindEmailView:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 关闭界面时调用
-- @function [parent=#BindEmailView] onExit
-- @param self
-- 
function BindEmailView:onExit()
	instance = nil
	
	BindEmailView.super.onExit(self)
end

---
-- 打开界面调用
-- @function [parent=#BindEmailView] openUi
-- @param self
-- 
function BindEmailView:openUi()
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
end

