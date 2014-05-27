---
-- 新vip界面
-- @module view.shop.chongzhi.ShopNewVipView
--

local require = require
local class = class
local CCFadeTo = CCFadeTo
local CCRepeatForever = CCRepeatForever

local moduleName = "view.shop.chongzhi.ShopNewVipView"
module(moduleName)

---
-- 类定义
-- @type ShopNewVipView
--
local ShopNewVipView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent = #ShopNewVipView] ctor
--
function ShopNewVipView:ctor()
	ShopNewVipView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #ShopNewVipView] _create
--
function ShopNewVipView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_shop/ui_vip_1.ccbi", true)
	
	self:_createPCBox()
	
	local scrollView = require("ui.ScrollView")
	self["itemPCBox"]:addEventListener(scrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
	self["itemPCBox"]:invalidData()
	
end 

---
-- 创建pcbox
-- @function [parent = #ShopNewVipView] _createPCBox
-- 
function ShopNewVipView:_createPCBox()
	local pCBox = self["itemPCBox"]
	
	local vipLevelData = require("model.ShopData").getVipLevelData()
	local vipCell = require("view.shop.chongzhi.ShopNewVipCell")
	
	pCBox.owner = self
	pCBox:setVCount(1)
	pCBox:setHCount(1)
	pCBox:setCellRenderer(vipCell)
	
	--初始化VIP数据内容
	local vipFunc = require("xls.VipFuncXls").data
	require("model.ShopData").clearVipLevelData()
	for i = 1, #vipFunc do
		require("model.ShopData").addVipLevelDescItem(vipFunc[i])
	end
	pCBox:setDataSet(vipLevelData)
end	

---
-- 获取pcbox
-- @function [parent = #ShopNewVipView] getPCBox
-- 
function ShopNewVipView:getPCBox()
	return self["itemPCBox"]
end

---
-- 打开界面
-- @function [parent=#ShopNewVipView] openUi
-- @param self
-- 
function ShopNewVipView:openUi()
	self:setVisible(true)
	
--	local GameNet = require("utils.GameNet")
--	GameNet.send("", {placeholder = 1})
	local vipLevel = require("model.HeroAttr").Vip
	self["itemPCBox"]:scrollToPage(vipLevel, true)
end

---
-- 滑动pcbox回调
-- @function [parent = #ShopNewVipView] _scrollChangedHandler
-- @param #table event 事件
-- 
function ShopNewVipView:_scrollChangedHandler(event)
	local pcBox = self["itemPCBox"]
	local currPage = pcBox:getCurPage()
	local maxPage = pcBox:getNumPage()
	
	if currPage < 1 then currPage = 1 end
	if currPage > maxPage then currPage = maxPage end
	
	local transition = require("framework.client.transition")
	if currPage > 1 then --左边需要闪烁
		if self._leftTabRight == nil then
			local actionleft = transition.sequence({
				CCFadeTo:create(0.5, 50),
				CCFadeTo:create(0.5, 255),
				})
			actionleft = CCRepeatForever:create(actionleft)
			self._leftTabFlash = actionleft
			self["leftSpr"]:runAction(actionleft)
		end
		self["leftSpr"]:setVisible(true)
	else
		if self._leftTabFlash ~= nil then
			self["leftSpr"]:stopAllActions()
			self._leftTabFlash = nil
		end
		self["leftSpr"]:setVisible(false)
	end
	
	if currPage < maxPage then --右边需要闪烁
		if self._rightTabRight == nil then
			local actionRight = transition.sequence({
				CCFadeTo:create(0.5, 50),
				CCFadeTo:create(0.5, 255),
				})
			actionRight = CCRepeatForever:create(actionRight)
			self._rightTabRight = actionRight
			self["rightSpr"]:runAction(actionRight)
		end
		self["rightSpr"]:setVisible(true)
	else
		if self._rightTabRight ~= nil then
			self["rightSpr"]:stopAllActions()
			self._rightTabRight = nil
		end
		self["rightSpr"]:setVisible(false)
	end
end

---
-- 场景退出自动回调
-- @function [parent = #ShopNewVipView] onExit
-- 
function ShopNewVipView:onExit()
	require("view.shop.chongzhi.ShopNewVipView").instance = nil
	ShopNewVipView.super.onExit(self)	
end





