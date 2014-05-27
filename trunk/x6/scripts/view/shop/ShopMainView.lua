---
-- 商城主界面
-- @module view.shop.ShopMainView
-- 

local require = require
local class = class
local math = math
local printf = printf
local tr = tr
local dump = dump
local PLATFORM_NAME = PLATFORM_NAME
local CONFIG = CONFIG

local moduleName = "view.shop.ShopMainView"
module(moduleName)

---
-- 类定义
-- @type ShopMainView
--
local ShopMainView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 聚贤界面
-- @field [parent=#ShopMainView] #CCNode _juXianUi
-- 
ShopMainView._juXianUi = nil

---
-- 充值界面
-- @field [parent=#ShopMainView] #CCNode _chongZhiView
-- 
ShopMainView._chongZhiView = nil

---
-- 构造函数
-- @function [parent = #ShopMainView] ctor
-- 
function ShopMainView:ctor()
	ShopMainView.super.ctor(self)
	self:_create()
end

---
-- 场景进入的时候自动回调
-- @function [parent = #ShopMainView] onEnter
-- 
function ShopMainView:onEnter()
	ShopMainView.super.onEnter(self)

--	local gameNet = require("utils.GameNet")
--	gameNet.send("C2s_shop_info", {place_holder = 1})
	local heroGrade = require("model.HeroAttr").Grade
	local info = require("xls.PlayOpenXls").data
	if heroGrade >= info["zhaocai"]["StartLevel"] then
		--self["zhaoCaiBtn"]:setEnabled(true)
	else
		--self["zhaoCaiBtn"]:setEnabled(false)
	end
	
	--更新物品栏
	self:_updateItem(heroGrade)
end

---
-- 加载ccbi文件
-- @function [parent = #ShopMainView] _create
--
function ShopMainView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_shop/ui_shop.ccbi")
	
	local heroAttr = require("model.HeroAttr")
	local NumberUtil = require("utils.NumberUtil")
	self["goldCountLab"]:setString(heroAttr.YuanBao)
	self["silverCountLab"]:setString(NumberUtil.numberForShort(heroAttr.Cash))
	
	self:_createItemPCBox()
	
	self:handleRadioGroupEvent("tabRGrp", self._tabClkHandler)
--	self:handleButtonEvent("chongZhiBtn", self._chongZhiBtnHandler)
--	self:handleButtonEvent("zhaoCaiBtn", self._zhaoCaiBtnHandler)
	self:handleButtonEvent("closeBtn", self._closeBtnHandler)
--	self:_tabClkHandler()
	
	-- 判断是否开充值
	local arr = self["tabRGrp"].menu:getChildren()
	local arr2 = self["tabRGrpLink"].menu:getChildren()
	local Platforms = require("model.const.Platforms")
	local ConfigParams = require("model.const.ConfigParams")
	if CONFIG[ConfigParams.OPEN_PAY] and CONFIG[ConfigParams.OPEN_PAY] > 0 then
		arr:objectAtIndex(3):setVisible(true)
		arr2:objectAtIndex(3):setVisible(true)
		self["yuanBaoSpr"]:setVisible(true)
	else
		arr:objectAtIndex(3):setVisible(false)
		arr2:objectAtIndex(3):setVisible(false)
		self["yuanBaoSpr"]:setVisible(false)
	end
	
	--监听
	local EventCenter = require("utils.EventCenter")
	local HeroEvents = require("model.event.HeroEvents")
	local event = HeroEvents.ATTRS_UPDATED
	EventCenter:addEventListener(event.name, self._attrsUpdatedHandler, self)
end

---
-- 创建pcbox
-- @function [parent = #ShopMainView] _createItemPCBox
-- 
function ShopMainView:_createItemPCBox()
	local pcBox = self["itemPCBox"]
	pcBox:setHCount(4)
	pcBox:setVCount(1)
	pcBox:setHSpace(3)
	pcBox:setVSpace(6)
	
	local itemCell = require("view.shop.ShopItemCell")

	local scrollView = require("ui.ScrollView")
	
	pcBox.owner = self
	pcBox:setCellRenderer(itemCell)
	
	local shopData = require("model.ShopData")
	pcBox:setDataSet(shopData.getItemData())
	--pcBox:setSameSizeCell(false)
	
	-- 添加聚贤界面
	local JuXianUi = require("view.shop.juxian.JuXianUi")
	self._juXianUi = JuXianUi.createInstance()
	self["jxLayer"]:addChild(self._juXianUi)
	local size = self._juXianUi:getContentSize()
	local boxsize = pcBox:getContentSize()
	self._juXianUi:setPosition((boxsize.width - size.width)/2,(boxsize.height - size.height)/2)
	
	--添加充值界面
	local chongZhi = require("view.shop.chongzhi.ShopChongZhiView")
	self._chongZhiView = chongZhi.createInstance()
	self["chongZhiLayer"]:addChild(self._chongZhiView)
	size = self._chongZhiView:getContentSize()
	self._chongZhiView:setPosition((boxsize.width - size.width)/2,(boxsize.height - size.height)/2)
	
	self["chongZhiLayer"]:setVisible(false)
--	self["jxLayer"]:setVisible(false)
end

---
-- 点击了充值按钮
-- @function [parent = #ShopMainView] _chongZhiBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
--function ShopMainView:_chongZhiBtnHandler(sender, event)
--	local gameView = require("view.GameView")
--	local chargeView = require("view.shop.ShopChargeView")
--	gameView.addPopUp(chargeView.createInstance(), true)
--end

---
-- 点击了招财按钮
-- @function [parent = #ShopMainView] _chongZhiBtnHandler
-- @param #CCControlButton sender
-- @param #table event
--
--function ShopMainView:_zhaoCaiBtnHandler(sender, event)
--	local gameView = require("view.GameView")
--	local shopGetMoney = require("view.shop.ShopGetMoneyView")
--	gameView.addPopUp(shopGetMoney.createInstance(), true)
--end

---
-- 点击了关闭按钮
-- @function [parent = #ShopMainView] _closeBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function ShopMainView:_closeBtnHandler(sender, event)
	local GameView = require("view.GameView")
--    local MainView = require("view.main.MainView")
--    GameView.replaceMainView(MainView.createInstance())
	GameView.removePopUp(self, true)
end

---
-- 打开界面调用
-- @function [parent=#ShopMainView] openUi
-- @param self
-- 
function ShopMainView:openUi( index )
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	
	if index then
		self["tabRGrp"]:setSelectedIndex(index, false)
	end
	
	self:_tabClkHandler()
end

---
-- 选中单选组
-- @function [parent = #ShopMainView] _tabClkHandler
-- @param self
-- @param #table event
-- 
function ShopMainView:_tabClkHandler(event)
	local selectedIndex = self["tabRGrp"]:getSelectedIndex()
	local pcBox = self["itemPCBox"]
	self["chongZhiLayer"]:setVisible(false)
	self["jxLayer"]:setVisible(false)
	if selectedIndex <= 1 then --聚贤
		self["jxLayer"]:setVisible(true)
		self._juXianUi:openUi()
		pcBox:setDataSet(nil)
	elseif selectedIndex == 2 then -- 宝物
		local shopData = require("model.ShopData")
		local itemData = shopData.getItemData()
		pcBox:setDataSet(itemData)
	elseif selectedIndex == 3 then -- vip物品
		local shopData = require("model.ShopData")
		local vipItemData = shopData.getVipItemData()			
		pcBox:setDataSet(vipItemData)
	elseif selectedIndex == 4 then -- 充值
		self["chongZhiLayer"]:setVisible(true)
		self._chongZhiView:openUi()
		pcBox:setDataSet(nil)
	end
end

---
-- 设置VIP界面
-- @function [parent=#ShopMainView] setVipView
-- 
function ShopMainView:setVipView()
	if self._chongZhiView then
		self._chongZhiView:setVipView()
	end
end

---
-- 设置下一等级经验
-- @function [parent=#ShopMainView] setNextExp
-- @param #number exp
-- 
function ShopMainView:setNextExp(exp)
	if self._chongZhiView then
		self._chongZhiView:setNextExp(exp)
	end
end

---
-- 数据更新回调
-- @function [parent = #ShopMainView] _attrsUpdatedHandler
-- @param #table event
-- 
function ShopMainView:_attrsUpdatedHandler(event)
	if event.attrs.YuanBao ~= nil then
		local NumberUtil = require("utils.NumberUtil")
		self["goldCountLab"]:setString(event.attrs.YuanBao)
	end
	
	if event.attrs.Cash ~= nil then
		local cash = event.attrs.Cash
		local NumberUtil = require("utils.NumberUtil")
		self["silverCountLab"]:setString(NumberUtil.numberForShort(cash))
	end
end

---
-- 更新物品数据
-- @function [parent = #ShopMainView] _updateItem
-- @param #number level
-- 
function ShopMainView:_updateItem(level)
	-- 添加满足等级条件的商品
	local shopData = require("model.ShopData")
	local notEnoughLevelItemTable = shopData.getNotEnoughLevelItemTable()
	local table = require("table")
	local needDelPos = {}
	local needAddItem = {}
	if #notEnoughLevelItemTable > 0 then
		for i = 1,  #notEnoughLevelItemTable do
			if notEnoughLevelItemTable[i].UserGrade <= level then
				needAddItem[#needAddItem + 1] = notEnoughLevelItemTable[i]
				needDelPos[#needDelPos + 1] = i
			end
		end
		
		--排序
		local function sortNo(a, b)
			return a.SortNo < b.SortNo
		end
		table.sort(needAddItem, sortNo)
		for i = 1, #needAddItem do
			shopData.addItem(needAddItem[i])
		end
		
		--删除物品元素
		if #needDelPos > 0 then
			for i = 1, #needDelPos do
				table.remove(notEnoughLevelItemTable, needDelPos[i])
			end
		end
	end
end

---
-- 场景退出自动回调
-- @function [parent = #view.shop.ShopMainView] onExit
-- 
function ShopMainView:onExit()
	local EventCenter = require("utils.EventCenter")
	local HeroEvents = require("model.event.HeroEvents")
	local event = HeroEvents.ATTRS_UPDATED
	EventCenter:removeEventListener(event.name, self._attrsUpdatedHandler, self)
	
	instance = nil
	
	ShopMainView.super.onExit(self)
end







