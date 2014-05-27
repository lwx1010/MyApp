--- 
-- 道具出售提示
-- @module view.bag.BagItemSellTipUi
-- 

local class = class
local printf = printf
local require = require
local tr = tr

local moduleName = "view.bag.BagItemSellTipUi"
module(moduleName)


--- 
-- 类定义
-- @type BagItemSellTipUi
-- 
local BagItemSellTipUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 确定回调函数
-- @function [parent=#BagItemSellTipUi] _callBack
-- 
BagItemSellTipUi._callBack = nil

--- 创建实例
-- @return BagItemSellTipUi实例
function new()
	return BagItemSellTipUi.new()
end

--- 
-- 构造函数
-- @function [parent=#BagItemSellTipUi] ctor
-- @param self
-- 
function BagItemSellTipUi:ctor()
	BagItemSellTipUi.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#BagItemSellTipUi] _create
-- @param self
-- 
function BagItemSellTipUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_bag/ui_sale.ccbi", true)
	
	self:handleButtonEvent("okCcb.aBtn", self._okClkHandler)
	self:handleButtonEvent("cancelCcb.aBtn", self._cancelClkHandler)
	self:handleButtonEvent("closeBtn", self._cancelClkHandler)
end

---
-- 点击了确定
-- @function [parent=#BagItemSellTipUi] _okClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BagItemSellTipUi:_okClkHandler( sender, event )
	if self._callBack then 
		self._callBack()
		local GameView = require("view.GameView")
		GameView.removePopUp(self, true)
	end
end

--- 
-- 点击了取消
-- @function [parent=#BagItemSellTipUi] _cancelClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BagItemSellTipUi:_cancelClkHandler( sender, event )
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 打开界面调用
-- @function [parent=#BagItemSellTipUi] openUi
-- @param self
-- @param #function func
-- @param #string tip
-- @param #string title
-- 
function BagItemSellTipUi:openUi( func, tip, title )
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	
	if not title then
		title = tr("出售物品")
	end
	
	self["nameLab"]:setString(title)
	self._callBack = func
	self["tipLab"]:setString(tip or "")
end

---
-- 退出界面调用
-- @function [parent=#BagPartnerFadeTipUi] onExit
-- @param self
-- 
function BagItemSellTipUi:onExit()
	instance = nil
	BagItemSellTipUi.super.onExit(self)
end
