---
-- 提示购买物品数量界面
-- @module view.shop.ShopBuyMsgView
--

local require = require
local class = class

local tonumber = tonumber
local tr = tr

local printf = printf

local moduleName = "view.shop.ShopBuyMsgView"
module(moduleName)

---
-- 类定义
-- @type ShopBuyMsgView
--
local ShopBuyMsgView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 购买物品最大值
-- @field [parent = #view.shop.ShopBuyMsgView] #number _MAX_ITEM_COUNT
-- 
local _MAX_ITEM_COUNT = 99

---
-- 物品最小值
-- @field [parent = #view.shop.ShopBuyMsgView] #number _MIN_ITEM_COUNT
-- 
local _MIN_ITEM_COUNT = 1

---
-- 构造函数
-- @function [parent = #ShopBuyMsgView] ctor
--
function ShopBuyMsgView:ctor()
	ShopBuyMsgView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #ShopBuyMsgView] _create
--
function ShopBuyMsgView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_shop/ui_charge_piece1.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeBtnHandler)
	self:handleButtonEvent("buyItemCcb.aBtn", self._buyBtnHandler)
	self:handleButtonEvent("subItemBtn", self._subBtnHandler)
	self:handleButtonEvent("addItemBtn", self._addBtnHandler)
	self:handleButtonEvent("maxItemBtn", self._maxBtnHandler)
	self:handleButtonEvent("minItemBtn", self._minBtnHandler)
end 

---
-- 设置该物品信息
-- @function [parent = #ShopBuyMsgView] setShowMsg
-- @param #table msg
-- 
function ShopBuyMsgView:setShowMsg(msg)
	self["buyItemNameLab"]:setString(msg.itemName)
	self["buyItemCountLab"]:setString(_MIN_ITEM_COUNT)
	self["sumPriceLab"]:setString(tr("合计: ")..msg.price..tr(" 元宝"))
	
	self._itemPrice = msg.price
	self._shopTabNo = msg.shopTabNo  
	self._sortNo = msg.sortNo
	self._itemNo = msg.itemNo
	self._buyCount = _MIN_ITEM_COUNT
	
	--限购
	--printf("msg.limitCount = "..msg.limitCount)
	if msg.limitCount then
		_MAX_ITEM_COUNT = msg.limitCount
		if _MAX_ITEM_COUNT == 0 then
			self:updateItemCountPrice(0)
		end
	else
		_MAX_ITEM_COUNT = 99
	end
			
end

---
-- + 1
-- @function [parent = #ShopBuyMsgView] addOne
-- 
function ShopBuyMsgView:addOne()
	local str = self["buyItemCountLab"]:getString()
	local num = tonumber(str)
	if num < _MAX_ITEM_COUNT and self:isEnoughYuanBao(num + 1) == true then
		num = num + 1
	end
	self:updateItemCountPrice(num)	
end

---
-- 是否足够元宝数
-- @function [parent = #ShopBuyMsgView] isEnoughYuanBao
-- @param #number num
-- 
function ShopBuyMsgView:isEnoughYuanBao(num)
	local playerYuanbao = require("model.HeroAttr").YuanBao
	if num * self._itemPrice > playerYuanbao then
		return false
	else
		return true
	end
end

---
-- - 1
-- @function [parent = #ShopBuyMsgView] subOne
-- 
function ShopBuyMsgView:subOne()
	local str = self["buyItemCountLab"]:getString()
	local num = tonumber(str)
	if num > _MIN_ITEM_COUNT then
		num = num - 1
	end
	self:updateItemCountPrice(num)	
end

---
-- + max 加到最大值
-- @function [parent = #ShopBuyMsgView] addToMax
--  
function ShopBuyMsgView:addToMax()
	local playerYuanbao = require("model.HeroAttr").YuanBao
	local math = require("math")
	local maxNum = math.floor(playerYuanbao/self._itemPrice)
	if maxNum > _MAX_ITEM_COUNT then
		maxNum = _MAX_ITEM_COUNT
	end
	self:updateItemCountPrice(maxNum)
end

---
-- - min 减到最小
-- @function [parent = #ShopBuyMsgView] subToMin
-- 
function ShopBuyMsgView:subToMin()
	self:updateItemCountPrice(_MIN_ITEM_COUNT)
end

---
-- 更新物品个数以及价钱
-- @function [parent = #ShopBuyMsgView] updateItemCountPrice
-- @param #number num 物品个数
-- 
function ShopBuyMsgView:updateItemCountPrice(num)
	self["buyItemCountLab"]:setString(num)
	self["sumPriceLab"]:setString(tr("合计: ")..self._itemPrice * num..tr(" 元宝"))
	self._buyCount = num
end

--- 
-- 点击了购买按钮
-- @function [parent = #ShopBuyMsgView] _buyBtnHandler
-- 
function ShopBuyMsgView:_buyBtnHandler(sender, event)
	local gameNet = require("utils.GameNet")
	gameNet.send("C2s_shop_buy", 
		{
			shop_tab_no = self._shopTabNo, 
			sort_no = self._sortNo,
			item_no = self._itemNo,
			buy_count = self._buyCount,
		}
	)
	
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

--- 
-- 点击了减一
-- @function [parent = #ShopBuyMsgView] _subBtnHandler
-- 
function ShopBuyMsgView:_subBtnHandler(sender,event)
	self:subOne()
end

--- 
-- 点击了加一
-- @function [parent = #ShopBuyMsgView] _addBtnHandler
-- 
function ShopBuyMsgView:_addBtnHandler(sender,event)
	self:addOne()
end

--- 
-- 点击了加至最大值
-- @function [parent = #ShopBuyMsgView] _maxBtnHandler
-- 
function ShopBuyMsgView:_maxBtnHandler(sender,event)
	self:addToMax()
end

--- 
-- 点击了减到最小值
-- @function [parent = #ShopBuyMsgView] _minBtnHandler
-- 
function ShopBuyMsgView:_minBtnHandler(sender,event)
	self:subToMin()
end

---
-- 点击了关闭按钮
-- @function [parent = #ShopBuyMsgView] _closeBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function ShopBuyMsgView:_closeBtnHandler(sender, event)
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 场景退出自动回调
-- @function [parent = #ShopBuyMsgView] onExit
-- 
function ShopBuyMsgView:onExit()
	require("view.shop.ShopBuyMsgView").instance = nil
	ShopBuyMsgView.super.onExit(self)
end









