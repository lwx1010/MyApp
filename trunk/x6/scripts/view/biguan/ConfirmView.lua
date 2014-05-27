---
-- 修炼加速/出关确认界面
-- @module view.biguan.ConfirmView
-- 

local class = class
local require = require
local string = string
local tr = tr

local moduleName = "view.biguan.ConfirmView"
module(moduleName)

---
-- 类定义
-- @type ConfirmView
-- 
local ConfirmView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 出关提示信息
-- @field [parent=#ConfirmView] #string _chuguan 
-- 
ConfirmView._chuguan = tr("<c8>闭关时间尚未结束，此时出关最终可获得<c1>%s<c8>经验，是否确认需要终止闭关修炼？")

---
-- 加速修炼提示信息
-- @field [parent=#ConfirmView] #string _speedUp 
-- 
ConfirmView._speedUp = tr("<c8>使用<c1>%s<c8>元宝可立刻完成闭关修炼并获得<c1>%s<c8>经验，是否确定加速？")

---
-- 回调函数
-- @field [parent=#ConfirmView] #function _callback 
-- 
ConfirmView._callback = nil

---
-- 构造函数
-- @function [parent=#ConfirmView] ctor
-- @param self
-- 
function ConfirmView:ctor()
	ConfirmView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

---
-- 创建
-- @function [parent=#ConfirmView] _create
-- @param self
-- 
function ConfirmView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_biguan/ui_tipbox_chuguan.ccbi", true)
	
	self:handleButtonEvent("msgBoxCcb.aYesBtn", self._yesClkHandler)
	self:handleButtonEvent("msgBoxCcb.aNoBtn", self._noClkHandler)
end

--- 
-- 点击了确定
-- @function [parent=#ConfirmView] _yesClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function ConfirmView:_yesClkHandler(send, event)
	if( self._callback ) then
		self._callback()
	end
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

--- 
-- 点击了取消
-- @function [parent=#ConfirmView] _noClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function ConfirmView:_noClkHandler(send, event)
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 显示确认信息
-- @function [parent=#ConfirmView] showMsg
-- @param self
-- @param #string type 确认类型("chuguan"--出关， "speedUp"--加速)
-- @param #Function callback 回调函数
-- @param #table valueList 需要显示的值列表 
-- 
function ConfirmView:showMsg(type,callback,valueList)
	local msg
	if( type == "chuguan" ) then
		msg = string.format(self._chuguan, valueList[1])
	elseif( type == "speedUp" ) then
		msg = string.format(self._speedUp, valueList[1], valueList[2])
	end
	self["msgLab"]:setString(msg)
	self._callback = callback
end

---
-- 退出界面调用
-- @function [parent=#ConfirmView] onExit
-- @param self
-- 
function ConfirmView:onExit()
	instance = nil
	ConfirmView.super.onExit(self)
end






