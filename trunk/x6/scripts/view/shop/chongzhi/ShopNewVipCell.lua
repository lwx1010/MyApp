---
-- 新vip界面子项
-- @module view.shop.chongzhi.ShopNewVipCell
--

local require = require
local class = class
local tr = tr
local ccp = ccp
local CCSize = CCSize

local dump = dump
local printf = printf

local moduleName = "view.shop.chongzhi.ShopNewVipCell"
module(moduleName)

---
-- 类定义
-- @type ShopNewVipCell
--
local ShopNewVipCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 新建一个实例
-- @function [parent = #view.shop.chongzhi.ShopNewVipCell] new
-- 
function new()
	return ShopNewVipCell.new()
end

---
-- 构造函数
-- @function [parent = #ShopNewVipCell] ctor
--
function ShopNewVipCell:ctor()
	ShopNewVipCell.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #ShopNewVipCell] _create
--
function ShopNewVipCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_shop/ui_vip_2.ccbi", true)
	self["contentLab"]:setAnchorPoint(ccp(0, 1))
	
	self:handleButtonEvent("buyBtnCcb.aBtn", self._buyBtnHandler)
end 

---
-- 显示内容
-- @function [parent = #ShopNewVipCell] showItem
-- 
function ShopNewVipCell:showItem(msg)
	if msg then
		--累计充值
		local vipLevelData = require("xls.VipLevelXls").data
		local levelMaxExp = vipLevelData[msg.VipLevel].VipProgress
		self["hasChongZhiLab"]:setString(levelMaxExp)
	
		local showText = ""
		if self._arrowTl == nil then
			self._arrowTl = {}
		else
			for i = 1, #self._arrowTl do
				self._arrowTl[i]:removeFromParentAndCleanup(true)
			end
			self._arrowTl = {}
		end
		local vipFuncData = require("xls.VipFuncXls").data
		local vipDesc = vipFuncData[msg.VipLevel].VipInfo
		local msgTl = self:_getVipStringMsg(vipDesc)
		for i = 1, #msgTl do
			showText = showText..msgTl[i].."\n"
			
			--添加小箭头
--			local display = require("framework.client.display")
--			local arrow = display.newSprite("#ccb/mark/sarrow.png")
--			local x = self["contentLab"]:getPositionX() - 16
--			local y = self["contentLab"]:getPositionY() - 9 - ((i - 1) *  30)  
--			arrow:setPosition(x, y)
--			self:addChild(arrow)
--			
--			self._arrowTl[#self._arrowTl + 1] = arrow
		end
		self["contentLab"]:setRowSpace(8)
		self["contentLab"]:setString(showText)
		
		--添加小箭头
		local labHeight = self["contentLab"]:getContentSize().height
		local vSpace = labHeight / #msgTl
		for i = 1, #msgTl do
			local display = require("framework.client.display")
			local arrow = display.newSprite("#ccb/mark/sarrow.png")
			local x = self["contentLab"]:getPositionX() - 16
			local y = self["contentLab"]:getPositionY() - ((i - 1) *  vSpace) - 8
			arrow:setPosition(x, y)
			self:addChild(arrow)
			
			self._arrowTl[#self._arrowTl + 1] = arrow
		end
		
		--dump(msg.VipLevel)
		self:changeFrame("vipLevelSpr", "ccb/number/"..msg.VipLevel..".png")
		
		--添加VIP物品
		local shopData = require("model.ShopData")
		local vipItemData = shopData.getVipItemData()
		--dump(vipItemData)
		local itemTl = vipItemData:getArray()
		local item = itemTl[msg.VipLevel]
		
		self["liBaoLab"]:setString(item.ItemName)
		self["descLab"]:setString(item.remark)
		
		if item.maxSellCount then
			self["limitBuyLab"]:setString(tr("限购: ")..item.maxSellCount)
			if item.maxSellCount == 0 then
				self["buyBtnCcb.aBtn"]:setEnabled(false)
			else
				self["buyBtnCcb.aBtn"]:setEnabled(true)
			end
		else
			self["limitBuyLab"]:setString("")
		end
		
		if self["itemSpr"] == nil then
			local display = require("framework.client.display")
			--self["itemSpr"] = display.newSprite("#ccb/icon_1/"..item.ItemPhoto..".jpg")
			self["itemSpr"] = display.newSprite()
			self:changeItemIcon("itemSpr", item.ItemPhoto)
			
			self["itemBgSpr"]:addChild(self["itemSpr"])
			self["itemSpr"]:setPosition(self["itemBgSpr"]:getContentSize().width/2, self["itemBgSpr"]:getContentSize().height/2)
		else
			self:changeFrame("itemSpr", "ccb/icon_1/"..item.ItemPhoto..".jpg")
		end
		
		self._shopTabNo = item.shopTabNo
		self._sortNo = item.SortNo
		self._itemNo = item.ItemNo
		if item.NowPrice ~= nil then
			self._price = item.NowPrice
		else
			self._price = item.BasePrice
		end
		self._itemName = item.ItemName
		self._limitCount = item.maxSellCount
		 
	else
		if self._arrowTl ~= nil then
			for i = 1, #self._arrowTl do
				self._arrowTl[i]:removeFromParentAndCleanup(true)
			end
			self._arrowTl = {}
		end
	end
end

---
-- 点击了购买
-- @function [parent = #ShopNewVipCell] _buyBtnHandler
-- 
function ShopNewVipCell:_buyBtnHandler(sender, event)
	local shopBuyMsgView = require("view.shop.ShopBuyMsgView").instance
	if shopBuyMsgView == nil then
		shopBuyMsgView = require("view.shop.ShopBuyMsgView").createInstance()
	end
	
	local msg = {}
	msg.shopTabNo = self._shopTabNo
	msg.sortNo = self._sortNo 
	msg.itemNo = self._itemNo
	msg.price = self._price
	msg.itemName = self._itemName
	msg.limitCount = self._limitCount
	
--	dump(msg)
	shopBuyMsgView:setShowMsg(msg)
	
	local gameView = require("view.GameView")
	gameView.addPopUp(shopBuyMsgView, true) 
	gameView.center(shopBuyMsgView)
end

---
-- 获取VIP描述内容
-- @function [parent = #ShopNewVipCell] _getVipStringMsg
-- @param #string str
-- @return #table
--  
function ShopNewVipCell:_getVipStringMsg(str)
	local string = require("string")
	
	local msgTable = {}
	local posSB, posStart = string.find(str, "<li>")
	local posEB, posEnd = string.find(str, "</li>")
	
	while posSB and posEB do
		local wantStr = string.sub(str, posStart + 1, posEB - 1)
		msgTable[#msgTable + 1] = wantStr
		
		str = string.sub(str, posEnd + 1)
		posSB, posStart = string.find(str, "<li>")
		posEB, posEnd = string.find(str, "</li>")
	end
	
	return msgTable
end




