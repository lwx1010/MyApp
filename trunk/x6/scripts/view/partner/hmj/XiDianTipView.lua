---
-- 洗点提示界面
-- @module view.partner.hmj.XiDianTipView
-- 

local class = class
local require = require
local string = string
local tr = tr

local moduleName = "view.partner.hmj.XiDianTipView"
module(moduleName)

---
-- 类定义
-- @type XiDianTipView
-- 
local XiDianTipView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 出关提示信息
-- @field [parent=#XiDianTipView] #string _tip 
-- 
XiDianTipView._tip = tr("<c0>您确定消耗<c1>%s<c0>元宝重置灵兽吗？")

---
-- 回调函数
-- @field [parent=#XiDianTipView] #function _callback 
-- 
XiDianTipView._callback = nil

---
-- 消耗元宝数
-- @field [parent=#XiDianTipView] #number _costYuanBao 
-- 
XiDianTipView._costYuanBao = nil

---
-- 构造函数
-- @function [parent=#XiDianTipView] ctor
-- @param self
-- 
function XiDianTipView:ctor()
	XiDianTipView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

---
-- 创建
-- @function [parent=#XiDianTipView] _create
-- @param self
-- 
function XiDianTipView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_onbattle/ui_hongmengjuepiece.ccbi", true)
	
	self:handleButtonEvent("yesBtn", self._yesClkHandler)
	self:handleButtonEvent("noBtn", self._noClkHandler)
end

--- 
-- 点击了确定
-- @function [parent=#XiDianTipView] _yesClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function XiDianTipView:_yesClkHandler(send, event)
	local FloatNotify = require("view.notify.FloatNotify")
	local HeroAttr = require("model.HeroAttr")
	if self._costYuanBao and HeroAttr.YuanBao < self._costYuanBao then
		FloatNotify.show(tr("元宝不足，无法洗点！"))
	else
		if( self._callback ) then
			self._callback()
		end
	end
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

--- 
-- 点击了取消
-- @function [parent=#XiDianTipView] _noClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function XiDianTipView:_noClkHandler(send, event)
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 显示确认信息
-- @function [parent=#XiDianTipView] showMsg
-- @param self
-- @param #number value 
-- @param #Function callback 回调函数
-- 
function XiDianTipView:showMsg(value,callback)
	self._costYuanBao = value
	local msg = string.format(self._tip, value)
	self["msgLab"]:setString(msg)
	self._callback = callback
end

---
-- 退出界面调用
-- @function [parent=#XiDianTipView] onExit
-- @param self
-- 
function XiDianTipView:onExit()
	instance = nil
	XiDianTipView.super.onExit(self)
end






