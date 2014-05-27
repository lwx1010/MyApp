---
-- 战斗失败提示界面
-- @module view.fight.FightFailTip
--

local require = require
local class = class

local moduleName = "view.fight.FightFailTip"
module(moduleName)

---
-- 类定义
-- @type FightFailTip
--
local FightFailTip = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent = #FightFailTip] ctor
--
function FightFailTip:ctor()
	FightFailTip.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #FightFailTip] _create
--
function FightFailTip:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_battle/ui_failtips.ccbi", true)
	
	self:handleButtonEvent("zhenRongBtn", self._zhenRongBtnHandler)
	self:handleButtonEvent("getCardBtn", self._getCardBtnHandler)
	self:handleButtonEvent("changeBuZhenBtn", self._buZhenBtnHandler)
	self:handleButtonEvent("closeBtn", self._closeBtnHandler)
	self:handleButtonEvent("closeBtn1", self._closeBtnHandler)
end 

---
-- 点击了布阵按钮
-- @function [parent = #FightFailTip] _buZhenBtnHandler
-- 
function FightFailTip:_buZhenBtnHandler(sender, event)
	local partnerMainView = require("view.partner.PartnerMainView").instance
	if partnerMainView == nil then
		partnerMainView = require("view.partner.PartnerMainView").createInstance()
	end
	
	partnerMainView:openUi(2) --选中布阵TAB
	
	local gameView = require("view.GameView")
	gameView.removePopUp(self, true)
end

---
-- 点击了聚贤按钮
-- @function [parent = #FightFailTip] _getCardBtnHandler
-- 
function FightFailTip:_getCardBtnHandler(sender, event)
	local shopMainView = require("view.shop.ShopMainView")
	shopMainView.createInstance():openUi(1) --聚贤
	
	local gameView = require("view.GameView")
	gameView.removePopUp(self, true)
end

---
-- 点击了阵容按钮
-- @function [parent = #FightFailTip] _equitBtnHandler
-- 
function FightFailTip:_zhenRongBtnHandler(sender, event)
	local partnerMainView = require("view.partner.PartnerMainView").instance
	if partnerMainView == nil then
		partnerMainView = require("view.partner.PartnerMainView").createInstance()
	end
	
	partnerMainView:openUi(1) --选中阵容TAB
	
	local gameView = require("view.GameView")
	gameView.removePopUp(self, true)
end

---
-- 点击了关闭按钮
-- @function [parent = #FightFailTip] _closeBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function FightFailTip:_closeBtnHandler(sender, event)
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 场景退出自动回调
-- @function [parent = #FightFailTip] onExit
-- 
function FightFailTip:onExit()
	require("view.fight.FightFailTip").instance = nil
	FightFailTip.super.onExit(self)
end










