--- 
-- 绑定身份证界面
-- @module view.help.BindCardView
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local ccc3 = ccc3
local PLATFORM_NAME = PLATFORM_NAME

local moduleName = "view.help.BindCardView"
module(moduleName)


--- 
-- 类定义
-- @type BindCardView
-- 
local BindCardView = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 构造函数
-- @function [parent=#BindCardView] ctor
-- @param self
-- 
function BindCardView:ctor()
	BindCardView.super.ctor(self)
	
	self:_create()
	--self:retain()
end

--- 
-- 创建
-- @function [parent=#BindCardView] _create
-- @param self
-- 
function BindCardView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_sysmanage/ui_bundsfz.ccbi")
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("okBtn", self._okClkHandler)
	
	local cardEdit = self["cardEdit"]
	cardEdit:setPlaceHolder(tr("点击输入身份证"))
	cardEdit:setFontColor(ccc3(0,0,0))
	cardEdit:setMaxLength(16)
end

--- 
-- 点击了确定
-- @function [parent=#BindCardView] _okClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BindCardView:_okClkHandler( sender, event )
	local cardEdit = self["cardEdit"]
	local card = cardEdit:getText()
	
	local string = require("string")
	if card then
		card = string.trim(card)
	end
	
	if not card or #card~=18 then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("身份证位数不正确")}, {{text=tr("确定")}})
		return
	end

	-- 登录
	local MHSdk = require("logic.sdk.MHSdk")
	
	MHSdk.reset(MHSdk.getAccount(), PLATFORM_NAME, MHSdk.getToken(), nil, card)
end

--- 
-- 点击了关闭
-- @function [parent=#BindCardView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BindCardView:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 关闭界面时调用
-- @function [parent=#BindCardView] onExit
-- @param self
-- 
function BindCardView:onExit()
	instance = nil
	
	BindCardView.super.onExit(self)
end

---
-- 打开界面调用
-- @function [parent=#BindCardView] openUi
-- @param self
-- 
function BindCardView:openUi()
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
end

