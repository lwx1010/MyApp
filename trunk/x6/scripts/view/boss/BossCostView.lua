---
-- boss站复活消耗元宝界面
-- @module view.boss.BossCostView
--

local require = require
local class = class

local moduleName = "view.boss.BossCostView"
module(moduleName)

---
-- 类定义
-- @type BossCostView
--
local BossCostView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 是否勾选了不再显示确认框
-- @field [parent = #view.boss.BossCostView] #bool _isNoShow 
-- 
local _isShow = true

---
-- 构造函数
-- @function [parent = #BossCostView] ctor
--
function BossCostView:ctor()
	BossCostView.super.ctor(self)
	self:_create()
	--self:retain()
end

---
-- 加载ccbi
-- @function [parent = #ShopGetMoneyView] _create
--
function BossCostView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_boss/ui_cost.ccbi", true)
	
	self:handleButtonEvent("msgboxCcb.aYesBtn", self._clearTimeHandler)
	self:handleButtonEvent("msgboxCcb.aNoBtn", self._cancelHandler)
	self:handleButtonEvent("msgboxCcb.closeBtn", self._closeBtnHandler)
end 

---
-- 点击了关闭按钮
-- @function [parent = #BossCostView] _closeBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function BossCostView:_closeBtnHandler(sender, event)
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 点击了确定，清除冷却时间
-- @function [parent = #BossCostView] _clearTimeHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function BossCostView:_clearTimeHandler(sender, event)
	local gameNet = require("utils.GameNet")
	gameNet.send("C2s_worldboss_accelerate", {place_holder = 1})
	
	local index = self["chkCcb.aChk"]:getSelectedIndex()
	if index == 1 then
		_isShow = false
	end
	
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 点击了取消
-- @function [parent = #BossCostView] _cancelHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function BossCostView:_cancelHandler(sender, event)
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 场景退出后自动调用
-- @function [parent = #BossCostView] onExit
-- @param #BossCostView self
-- 
function BossCostView:onExit()
	instance = nil
	
	BossCostView.super.onExit(self)
end

---
-- 是否显示这个确定框
-- @function [parent = #view.boss.BossCostView] isShowWindow
-- 
function isShowWindow()
	return _isShow
end



