----
-- 绑定身份证界面
-- @module view.help.BindCardUi
-- 

local class = class
local require = require
local printf = printf
local tr = tr

local moduleName = "view.help.BindCardUi"
module(moduleName)

---
-- 类定义
-- @type BindCardUi
-- 
local BindCardUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 创建实例
-- @function [parent=#view.help.BindCardUi] new
-- @return #BindCardUi实例 
-- 
function new()
	return BindCardUi.new()
end

---
-- 构造函数
-- @function [parent=#BindCardUi] ctor
-- @param self
-- 
function BindCardUi:ctor()
	self.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#BindCardUi] _create
-- @param self
-- 
function BindCardUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_sysmanage/ui_sysmanagepiece3.ccbi", true)
	
	self:handleButtonEvent("bindCcb.aBtn", self._bindClkHandler)
	
	local MHSdk = require("logic.sdk.MHSdk")
	local idcard = MHSdk.getParamTb()["idcard"]
	if idcard then
		local string = require("string")
		local show = string.sub(idcard, 1, 4).."**"..string.sub(idcard, 7, 14).."***"..string.sub(idcard, 18)

		self["infoLab"]:setString(tr("已绑定  "..show))
		self["bindCcbSpr"]:setVisible(false)
		self["bindCcb"]:setVisible(false)
	end
end

---
-- 点击了绑定邮箱
-- @function [parent=#BindCardUi] _bindClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BindCardUi:_bindClkHandler(sender,event)
	local BindCardView = require("view.help.BindCardView")
	BindCardView.createInstance():openUi()
end
