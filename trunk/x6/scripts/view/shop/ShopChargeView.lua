---
-- 商城充值界面
-- @module view.shop.ShopChargeView
-- 

local require = require
local class = class

local moduleName = "view.shop.ShopChargeView"
module(moduleName)

---
-- 类定义
-- @type ShopChargeView
--
local ShopChargeView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent = #ShopChargeView] ctor
-- 
function ShopChargeView:ctor()
	ShopChargeView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi文件
-- @function [parent = #ShopChargeView] _create
--
function ShopChargeView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_shop/ui_charge.ccbi")
	
	self:_createPCBox()
	self:handleButtonEvent("vipCcb.aBtn", self._vipBtnHandler)
	self:handleButtonEvent("closeBtn", self._closeBtnHandler)
end

---
-- 创建pcbox
-- @function [parent = #ShopChargeView] _createPCBox
-- 
function ShopChargeView:_createPCBox()
	local pcBox = self["chargePCBox"]
	pcBox:setHCount(2)
	pcBox:setVCount(3)
	
	local chargeCell = require("view.shop.ShopChargeCell")

	local scrollView = require("ui.ScrollView")
	
	pcBox.owner = self
	pcBox:setCellRenderer(chargeCell)
	
	local shopData = require("model.ShopData")
	pcBox:setDataSet(shopData.getVipTypeData())
	
	local currPage = pcBox:getCurPage()
	local maxPage = pcBox:getNumPage()
	if currPage < 1 then currPage = 1 end
	if currPage > maxPage then currPage = maxPage end
	pcBox:addEventListener(scrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
end

---
-- 点击了关闭按钮
-- @function [parent = #ShopChargeView] _closeBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function ShopChargeView:_closeBtnHandler(sender, event)
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 滑动pcbox回调
-- @function [parent = #ShopChargeView] _scrollChangedHandler
-- @param #table event 事件
-- 
function ShopChargeView:_scrollChangedHandler(event)
	local pcBox = self["chargePCBox"]
	local currPage = pcBox:getCurPage()
	local maxPage = pcBox:getNumPage()
	if currPage < 1 then currPage = 1 end
	if currPage > maxPage then currPage = maxPage end
	
	self["pageCcb.pageLab"]:setString(currPage.." / "..pcBox:getNumPage())
end

---
-- 点击了vip特权按钮
-- @function [parent = #ShopChargeView] _vipBtnHandler
-- @param #CCControlButton sender
-- @param #table event
--
function ShopChargeView:_vipBtnHandler(sender, event)
	local gameView = require("view.GameView")
	local shopVip = require("view.shop.ShopVipView")
	gameView.addPopUp(shopVip.createInstance(), true)
end

---
-- 场景退出自动回调
-- @function [parent = #ShopChargeView] onExit
-- 
function ShopChargeView:onExit()
	require("view.shop.ShopChargeView").instance = nil
	ShopChargeView.super.onExit(self)
end






