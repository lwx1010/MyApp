--- 
-- 背包界面
-- @module view.bag.BagView
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local math = math
local table = table
local rawget = rawget


local moduleName = "view.bag.BagView"
module(moduleName)


--- 
-- 类定义
-- @type BagView
-- 
local BagView = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 当前显示tab（1，装备，2，碎片）
-- @field [parent=#BagView] #number _selectedIndex
--
BagView._selectedIndex = 0

--- 
-- 构造函数
-- @function [parent=#BagView] ctor
-- @param self
-- 
function BagView:ctor()
	BagView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#BagView] _create
-- @param self
-- 
function BagView:_create()
	-- 注册ccb生成器
	local PartnerSprite = require("view.partner.PartnerSprite")
	PartnerSprite.registerCcbCreator()
	
	local node = self:load("ui/ccb/ccbfiles/ui_bag/ui_bag.ccbi")
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleRadioGroupEvent("tab1RGrp", self._tabClkHandler)
	
	self["tab2RGrp"].menu:setEnabled(false)
	self["tab2RGrp"].menu:setEnabled(false)
	self["tab3RGrp"]:setVisible(false)
	
	for i=1, 4 do
		self["fullSpr"..i]:setVisible(false)
	end
	
	local box = self["itemPCBox"] -- ui.PageCellBox#PageCellBox
	box:setHCount(4)
	box:setVCount(1)
	box:setHSpace(8)
	box.owner = self
	
	-- 侦听背包数量变化
	local EventCenter = require("utils.EventCenter")
	local BagEvents = require("model.event.BagEvents")
	EventCenter:addEventListener(BagEvents.BAG_NUM_CHANGE.name, self._bagNumChangedHandler, self)
	-- 侦听宝物数据集变化
	local DataSet = require("utils.DataSet")
	local ItemData = require("model.ItemData")
	local set = ItemData.itemNormalShowListSet
	set:addEventListener(DataSet.CHANGED.name, self._itemsChangedHandler, self)
	--侦听拖动事件
	local ScrollView = require("ui.ScrollView")
	box:addEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
end

--- 
-- 点击了关闭
-- @function [parent=#BagView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BagView:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
    --local MainView = require("view.main.MainView")
    --GameView.replaceMainView(MainView.instance)
    GameView.removePopUp(self, true)
end

---
-- 打开界面时调用
-- @function [parent=#BagView] onEnter
-- @param self
-- 
function BagView:onEnter()
	BagView.super.onEnter(self)
	
	-- 请求背包数量信息
	local GameNet = require("utils.GameNet")
	local Uiid = require("model.Uiid")
	GameNet.send("C2s_hero_baginfo", {place_holder = 1, uiid = Uiid.UIID_BAG})
end

---
-- 关闭界面时调用
-- @function [parent=#BagView] onExit
-- @param self
-- 
function BagView:onExit()
	-- 请求背包数量信息
	local GameNet = require("utils.GameNet")
	local Uiid = require("model.Uiid")
	GameNet.send("C2s_hero_baginfo", {place_holder = 1, uiid = Uiid.UIID_MAINVIEW})
	
	-- 移除事件侦听
	local EventCenter = require("utils.EventCenter")
	local BagEvents = require("model.event.BagEvents")
	EventCenter:removeEventListener(BagEvents.BAG_NUM_CHANGE.name, self._bagNumChangedHandler, self)
	
	local DataSet = require("utils.DataSet")
	local ItemData = require("model.ItemData")
	local set = ItemData.itemNormalShowListSet
	set:removeEventListener(DataSet.CHANGED.name, self._itemsChangedHandler, self)
	
	local ScrollView = require("ui.ScrollView")
	self["itemPCBox"]:removeEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
	
	instance = nil
	BagView.super.onExit(self)
end

--- 
-- 打开界面调用
-- @function [parent=#BagView] showView
-- @param #number index
-- @param self
-- 
function BagView:showView(index)
	local GameView = require("view.GameView")
	--GameView.replaceMainView(self)
	GameView.addPopUp(self, true)
		
	if index then
		self["tab1RGrp"]:setSelectedIndex(index)
	end
	
	self:_tabClkHandler()
end

--- 
-- 点击了tab
-- @function [parent=#BagView] _tabClkHandler
-- @param self
-- @param ui.RadioGroup#SEL_CHANGED event
-- 
function BagView:_tabClkHandler( event )
	local DataSet = require("utils.DataSet")
	local box = self["itemPCBox"] -- ui.PageCellBox#PageCellBox
	local set
	self._selectedIndex = self["tab1RGrp"]:getSelectedIndex()
	
	-- 显示侠客
	if(self._selectedIndex <= 1) then
		local PartnerData = require("model.PartnerData")
		local cell = require("view.bag.BagPartnerCell")
		box:setCellRenderer(cell)
		set = PartnerData.partnerShowSet
		local arrs = set:getArray()
		-- 按品质进行排序
		local func = function(a, b)
			if a.isFalse then  return false end
			if b.isFalse then  return true end
			
			local rareA = rawget(a, "Step")
			local rareB = rawget(b, "Step")
			if not rareA then return false end
			if not rareB then return true end
			if a.War == b.War then
				if a.Step == b.Step then
					if a.Grade == b.Grade then
						return a.PartnerNo > b.PartnerNo
					else
						return a.Grade > b.Grade
					end
				else
					return a.Step > b.Step
				end
			else
				return a.War > b.War
			end
		end
		table.sort(arrs, func)
		box:setDataSet(set)
	-- 显示装备
	elseif(self._selectedIndex == 2) then
		local ItemData = require("model.ItemData")
		local cell = require("view.bag.BagEquipCell")
		box:setCellRenderer(cell)
		set = ItemData.itemEquipShowListSet
		local arrs = set:getArray()
		-- 按品质进行排序
		local func = function(a, b)
			if a.isFalse then  return false end
			if b.isFalse then  return true end
			
			local rareA = rawget(a, "Rare")
			local rareB = rawget(b, "Rare")
			if not rareA then return false end
			if not rareB then return true end
			if a.Rare == b.Rare  then
				if a.NeedGrade == b.NeedGrade then
					if a.Kind == b.Kind then
						if a.ItemNo == b.ItemNo then
							local strengA = rawget(a, "StrengGrade")
							local strengB = rawget(b, "StrengGrade")
							if not strengA then return false end
							if not strengB then return true end
							
							return a.StrengGrade > b.StrengGrade
						else
							return a.ItemNo > b.ItemNo
						end
					else
						return a.Kind > b.Kind
					end
				else
					return a.NeedGrade > b.NeedGrade
				end
			else
				return a.Rare > b.Rare
			end
		end
		table.sort(arrs, func)
		box:setDataSet(set)
	-- 显示武功
	elseif(self._selectedIndex == 3) then
		local ItemData = require("model.ItemData")
		local cell = require("view.bag.BagMartialCell")
		box:setCellRenderer(cell)
		set = ItemData.itemMartialShowListSet
		local arrs = set:getArray()
		-- 按品质进行排序
		local func = function(a, b)
			if a.isFalse then  return false end
			if b.isFalse then  return true end
			
			local rareA = rawget(a, "Rare")
			local rareB = rawget(b, "Rare")
			if not rareA then return false end
			if not rareB then return true end
			if a.Rare == b.Rare then
				if a.MartialLevel == b.MartialLevel then
					return a.ItemNo > b.ItemNo
				else
					return a.MartialLevel > b.MartialLevel
				end
			else
				return a.Rare > b.Rare
			end
		end
		table.sort(arrs, func)
		box:setDataSet(set)
	-- 显示宝物
	elseif(self._selectedIndex == 4) then
		local ItemData = require("model.ItemData")
		local cell = require("view.bag.BagTreasureCell")
		box:setCellRenderer(cell)
		set = ItemData.itemNormalShowListSet
		local arrs = set:getArray()
		-- 按品质进行排序
		local func = function(a, b)
			if a.isFalse then  return false end
			if b.isFalse then  return true end
			
			local rareA = rawget(a, "SubKind")
			local rareB = rawget(b, "SubKind")
			if not rareA then return false end
			if not rareB then return true end
			if a.SubKind == b.SubKind then
				return a.Rare > b.Rare
			else
				return a.SubKind < b.SubKind
			end
		end
		table.sort(arrs, func)
		box:setDataSet(set)
	end
end

---
-- 拖动
-- @function [parent=#BagView] _scrollChangedHandler
-- @param self
-- @param ui.ScrollView#SCROLL_CHANGED event
-- 
function BagView:_scrollChangedHandler( event )
	if(event==nil) then return end
	
	local curPage = self["itemPCBox"]:getCurPage()
	if( curPage < 1 ) then curPage = 1 end
	local numPage = self["itemPCBox"]:getNumPage()
	if( numPage < 1 ) then numPage = 1 end
	self["pageCcb.pageLab"]:setString(curPage.."/"..numPage)
end

---
-- 显示背包物品是否已满
-- @function [parent=#BagView] showBagNumInfo
-- @param self
-- @param #table info 
-- 
function BagView:showBagNumInfo(info)
	local COUNT = 1
	if( info.partner_max - info.partner_num < COUNT ) then
		self["fullSpr1"]:setVisible(true)
	else
		self["fullSpr1"]:setVisible(false)
	end
	
	if( info.equip_max - info.equip_num < COUNT ) then
		self["fullSpr2"]:setVisible(true)
	else
		self["fullSpr2"]:setVisible(false)
	end
	
	if( info.martial_max - info.martial_num < COUNT ) then
		self["fullSpr3"]:setVisible(true)
	else
		self["fullSpr3"]:setVisible(false)
	end
	
	if( info.item_max - info.item_num < COUNT ) then
		self["fullSpr4"]:setVisible(true)
	else
		self["fullSpr4"]:setVisible(false)
	end
end

---
-- 背包数量变化
-- @function [parent=#BagView] _bagNumChangedHandler
-- @param self
-- @param model.event.BagEvents#BAG_NUM_CHANGE event
-- 
function BagView:_bagNumChangedHandler(event)
	local COUNT = 1
	local attrTbl = event.attrs
	if( attrTbl.maxnum - attrTbl.num < COUNT ) then
		-- 侠客
		if(attrTbl.frameno == 0) then
			self["fullSpr1"]:setVisible(true)
		-- 宝物
		elseif(attrTbl.frameno == 1) then
			self["fullSpr4"]:setVisible(true)
		-- 装备、武功
		else
			self["fullSpr"..attrTbl.frameno]:setVisible(true)
		end
	else
		-- 侠客
		if(attrTbl.frameno == 0) then
			self["fullSpr1"]:setVisible(false)
		-- 宝物
		elseif(attrTbl.frameno == 1) then
			self["fullSpr4"]:setVisible(false)
		-- 装备、武功
		else
			self["fullSpr"..attrTbl.frameno]:setVisible(false)
		end
	end
end

---
-- 宝物数据集改变
-- @function [parent=#BagView] _itemsChangedHandler
-- @param self
-- @param utils.DataSet#CHANGED event
-- 
function BagView:_itemsChangedHandler(event)
	if(event==nil) then return end
	
	local ItemData = require("model.ItemData")
	local set = ItemData.itemNormalShowListSet
	local arrs = set:getArray()
	-- 按品质进行排序
	local func = function(a, b)
		if a.isFalse then  return false end
		if b.isFalse then  return true end
		
		local rareA = rawget(a, "SubKind")
		local rareB = rawget(b, "SubKind")
		if not rareA then return false end
		if not rareB then return true end
		if a.SubKind == b.SubKind then
			return a.Rare > b.Rare
		else
			return a.SubKind < b.SubKind
		end
	end
	table.sort(arrs, func)
end



