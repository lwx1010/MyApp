---
-- 提示购买物品数量界面
-- @module view.role.PayCountView
--

local require = require
local class = class
local tonumber = tonumber
local tr = tr
local math = math
local ccp = ccp
local printf = printf

local moduleName = "view.role.PayCountView"
module(moduleName)

---
-- 购买最大数量
-- @field [parent = #view.shop.PayCountView] #number _MAX_ITEM_COUNT
-- 
local _MAX_ITEM_COUNT = 10

---
-- 购买最小数量
-- @field [parent = #view.shop.PayCountView] #number _MIN_ITEM_COUNT
-- 
local _MIN_ITEM_COUNT = 1

---
-- 类定义
-- @type PayCountView
--
local PayCountView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 购买数量
-- @function [parent = #PayCountView] #number _num
--
PayCountView._num = 1

---
-- 已购买数量
-- @function [parent = #PayCountView] #number _buyNum
--
PayCountView._buyNum = 0

---
-- 构造函数
-- @function [parent = #PayCountView] ctor
--
function PayCountView:ctor()
	PayCountView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #PayCountView] _create
--
function PayCountView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_userinfo/ui_charge_piece1.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeBtnHandler)
	self:handleButtonEvent("buyItemCcb.aBtn", self._buyBtnHandler)
	self:handleButtonEvent("subItemBtn", self._subBtnHandler)
	self:handleButtonEvent("addItemBtn", self._addBtnHandler)
--	self:handleButtonEvent("maxItemBtn", self._maxBtnHandler)
--	self:handleButtonEvent("minItemBtn", self._minBtnHandler)
	self:showBtn("maxItemBtn", false)
	self:showBtn("minItemBtn", false)
	
	self["buyItemNameLab"]:setPositionX(43)
	self["buyItemNameLab"]:setString(tr("参悟次数不足，请选择购买的参悟次数"))
end 

-----
---- 设置该物品信息
---- @function [parent = #PayCountView] setShowMsg
---- @param #table msg
---- 
--function PayCountView:setShowMsg(msg)
--	self["buyItemNameLab"]:setString(msg.itemName)
--	self["buyItemCountLab"]:setString(_MIN_ITEM_COUNT)
--	self["sumPriceLab"]:setString(tr("合计: ")..msg.price..tr(" 元宝"))
--	
--	self._itemPrice = msg.price
--	self._shopTabNo = msg.shopTabNo  
--	self._sortNo = msg.sortNo
--	self._itemNo = msg.itemNo
--	self._buyCount = _MIN_ITEM_COUNT
--	
--	--限购
--	--printf("msg.limitCount = "..msg.limitCount)
--	if msg.limitCount then
--		_MAX_ITEM_COUNT = msg.limitCount
--		if _MAX_ITEM_COUNT == 0 then
--			self:updateItemCountPrice(0)
--		end
--	else
--		_MAX_ITEM_COUNT = 99
--	end
--			
--end

---
-- 打开界面
-- @function [parent=#PayCountView] openUi
-- @param self
-- @param #number num
--
function PayCountView:openUi(num)
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	
	self._buyNum = num
	self:updateItemCountPrice(1)
end

---
-- + 1
-- @function [parent = #PayCountView] addOne
-- @param self
-- 
function PayCountView:addOne()
	local num = self._num + 1
	self:updateItemCountPrice(num)	
end

---
-- 是否足够元宝数
-- @function [parent = #PayCountView] isEnoughYuanBao
-- @param #param self
-- 
function PayCountView:isEnoughYuanBao()
	local playerYuanbao = require("model.HeroAttr").YuanBao
	if (self:_countYuanBao(self._buyNum + self._num)  - self:_countYuanBao(self._buyNum)) > playerYuanbao then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("元宝不足!"))
		return false
	else
		return true
	end
end

---
-- - 1
-- @function [parent = #PayCountView] subOne
-- @param self
-- 
function PayCountView:subOne()
	local num = self._num - 1
	self:updateItemCountPrice(num)	
end

---
-- + max 加到最大值
-- @function [parent = #PayCountView] addToMax
--  
function PayCountView:addToMax()
	self:updateItemCountPrice(_MAX_ITEM_COUNT)
end

---
-- - min 减到最小
-- @function [parent = #PayCountView] subToMin
-- 
function PayCountView:subToMin()
	self:updateItemCountPrice(_MIN_ITEM_COUNT)
end

---
-- 更新物品个数以及价钱
-- @function [parent = #PayCountView] updateItemCountPrice
-- @param self
-- @param #number num 
-- 
function PayCountView:updateItemCountPrice(num)
--	if not (num >= 1 and num <= 10) then return end
	if not (num >= 1) then return end
	
	self._num = num
	self["buyItemCountLab"]:setString(self._num)
	
	
	self["sumPriceLab"]:setString(tr("合计: ").. (self:_countYuanBao(self._buyNum + self._num)  - self:_countYuanBao(self._buyNum))..tr(" 元宝"))
end

--- 
-- 点击了购买按钮
-- @function [parent = #PayCountView] _buyBtnHandler
-- 
function PayCountView:_buyBtnHandler(sender, event)
	if self:isEnoughYuanBao() then
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_buff_count_buy", {b_count = self._num})
	
		local GameView = require("view.GameView")
    	GameView.removePopUp(self, true)
    end
end

--- 
-- 点击了减一
-- @function [parent = #PayCountView] _subBtnHandler
-- 
function PayCountView:_subBtnHandler(sender,event)
	self:subOne()
end

--- 
-- 点击了加一
-- @function [parent = #PayCountView] _addBtnHandler
-- 
function PayCountView:_addBtnHandler(sender,event)
	self:addOne()
end

--- 
-- 点击了加至最大值
-- @function [parent = #PayCountView] _maxBtnHandler
-- 
function PayCountView:_maxBtnHandler(sender,event)
	self:addToMax()
end

--- 
-- 点击了减到最小值
-- @function [parent = #PayCountView] _minBtnHandler
-- 
function PayCountView:_minBtnHandler(sender,event)
	self:subToMin()
end

---
-- 点击了关闭按钮
-- @function [parent = #PayCountView] _closeBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function PayCountView:_closeBtnHandler(sender, event)
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

--- 
-- 根据数量数元宝数
-- @function [parent = #PayCountView] _countYuanBao
-- @param self
-- @param #number num
-- @return #number
-- 
function PayCountView:_countYuanBao(num)
	local price 
	if num == 0 then
		price = 0
	elseif num == 1 then
		price = 10
	elseif num == 2 then
		price = 10 + 20
	elseif num == 3 then
		price = 10 + 20 + 30
	elseif num == 4 then
		price = 10 + 20 + 30 + 40
	else
		price = 10 + 20 + 30 + 40 + (num - 4) * 50
	end
	return price
end

---
-- 场景退出自动回调
-- @function [parent = #PayCountView] onExit
-- 
function PayCountView:onExit()
	instance = nil
	
	PayCountView.super.onExit(self)
end