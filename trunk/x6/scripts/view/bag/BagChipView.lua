--- 
-- 背包碎片界面
-- @module view.bag.BagChipView
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local math = math
local transition = transition
local display = display
local table = table
local rawget = rawget


local moduleName = "view.bag.BagChipView"
module(moduleName)


--- 
-- 类定义
-- @type BagChipView
-- 
local BagChipView = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 当前显示tab（1，装备，2，碎片）
-- @field [parent=#BagChipView] #number _selectedIndex
--
BagChipView._selectedIndex = 0

--- 
-- 当前点击合成的信息
-- @field [parent=#BagChipView] #table _formulaInfo
-- 
BagChipView._formulaInfo = nil

---
-- 合成完成特效
-- @field [parent=#BagChipView] #CCSprite _mergeSprite
-- 
BagChipView._mergeSprite = nil

---
-- 当前选中的cell
-- @field [parent=#BagChipView] #cell _selectCell
-- 
BagChipView._selectCellIndex = nil

--- 
-- 构造函数
-- @function [parent=#BagChipView] ctor
-- @param self
-- 
function BagChipView:ctor()
	BagChipView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#BagChipView] _create
-- @param self
-- 
function BagChipView:_create()
	-- 注册ccb生成器
	local PartnerSprite = require("view.partner.PartnerSprite")
	PartnerSprite.registerCcbCreator()
	
	local node = self:load("ui/ccb/ccbfiles/ui_bag/ui_bag.ccbi")
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleRadioGroupEvent("tab1RGrp", self._tabClkHandler)
	
	self["tab2RGrp"].menu:setEnabled(false)
	self["tab3RGrp"].menu:setEnabled(false)
	self["tab2RGrp"]:setVisible(false)
	
	for i=1, 4 do
		self["fullSpr"..i]:setVisible(false)
	end
	
	local arr1 = self["tab1RGrp"].menu:getChildren()
	arr1:objectAtIndex(arr1:count()-1):setVisible(false)
	local arr3 = self["tab3RGrp"].menu:getChildren()
	arr3:objectAtIndex(arr3:count()-1):setVisible(false)
	
	local box = self["itemPCBox"] -- ui.PageCellBox#PageCellBox
	box:setHCount(4)
	box:setVCount(1)
	box:setHSpace(8)
	box.owner = self
	
	-- 侦听背包数量变化
	local EventCenter = require("utils.EventCenter")
	local BagEvents = require("model.event.BagEvents")
	EventCenter:addEventListener(BagEvents.CHIP_NUM_CHANGE.name, self._chipNumChangedHandler, self)
	
	--侦听拖动事件
	local ScrollView = require("ui.ScrollView")
	box:addEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
end

--- 
-- 点击了关闭
-- @function [parent=#BagChipView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BagChipView:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
    local MainView = require("view.main.MainView")
    GameView.replaceMainView(MainView.createInstance(), true)
end

---
-- 打开界面时调用
-- @function [parent=#BagChipView] onEnter
-- @param self
-- 
function BagChipView:onEnter()
	BagChipView.super.onEnter(self)
	
	-- 请求背包数量信息
	local GameNet = require("utils.GameNet")
	local Uiid = require("model.Uiid")
	GameNet.send("C2s_hero_baginfo", {place_holder = 1, uiid = Uiid.UIID_CHIP})
end

---
-- 关闭界面时调用
-- @function [parent=#BagChipView] onExit
-- @param self
-- 
function BagChipView:onExit()
	-- 移除侦听
	local EventCenter = require("utils.EventCenter")
	local BagEvents = require("model.event.BagEvents")
	EventCenter:removeEventListener(BagEvents.CHIP_NUM_CHANGE.name, self._chipNumChangedHandler, self)
	
	local ScrollView = require("ui.ScrollView")
	self["itemPCBox"]:removeEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
	
	instance = nil
	BagChipView.super.onExit(self)
end

--- 
-- 打开界面调用
-- @function [parent=#BagChipView] showView
-- @param self
-- 
function BagChipView:showView()
	local GameView = require("view.GameView")
	GameView.replaceMainView(self)
	self:_tabClkHandler()
end

--- 
-- 点击了tab
-- @function [parent=#BagChipView] _tabClkHandler
-- @param self
-- @param ui.RadioGroup#SEL_CHANGED event
-- 
function BagChipView:_tabClkHandler( event )
	local DataSet = require("utils.DataSet")
	local box = self["itemPCBox"] -- ui.PageCellBox#PageCellBox
	local set
	self._selectedIndex = self["tab1RGrp"]:getSelectedIndex()
	
	-- 显示侠客碎片
	if(self._selectedIndex <= 1) then
		local ItemData = require("model.ItemData")
		local cell = require("view.bag.BagItemChipCell")
		box:setCellRenderer(cell)
		set = ItemData.itemPartnerChipShowListSet
		local arrs = set:getArray()
		-- 按品质进行排序
		local func = function(a, b)
			if a.isFalse then  return false end
			if b.isFalse then  return true end
			
			local rareA = rawget(a, "Rare")
			local rareB = rawget(b, "Rare")
			if not rareA then return false end
			if not rareB then return true end
			return a.Rare > b.Rare
		end
		table.sort(arrs, func)
		box:setDataSet(set)
	-- 显示装备碎片
	elseif(self._selectedIndex == 2) then
		local ItemData = require("model.ItemData")
		local cell = require("view.bag.BagItemChipCell")
		box:setCellRenderer(cell)
		set = ItemData.itemEquipChipShowListSet
		local arrs = set:getArray()
		-- 按品质进行排序
		local func = function(a, b)
			if a.isFalse then  return false end
			if b.isFalse then  return true end
			
			local rareA = rawget(a, "Rare")
			local rareB = rawget(b, "Rare")
			if not rareA then return false end
			if not rareB then return true end
			return a.Rare > b.Rare
		end
		table.sort(arrs, func)
		box:setDataSet(set)
	-- 显示武功碎片
	elseif(self._selectedIndex == 3) then
		local cell = require("view.bag.BagMartialChipCell")
		box:setDataSet(nil)
		box:setCellRenderer(cell)
		
		--取武学合成公式
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_item_formulainfo", {placeholder = 1})
	end
end

---
-- 拖动
-- @function [parent=#BagChipView] _scrollChangedHandler
-- @param self
-- @param ui.ScrollView#SCROLL_CHANGED event
-- 
function BagChipView:_scrollChangedHandler( event )
	if(event==nil) then return end
	
	local curPage = self["itemPCBox"]:getCurPage()
	if( curPage < 1 ) then curPage = 1 end
	local numPage = self["itemPCBox"]:getNumPage()
	if( numPage < 1 ) then numPage = 1 end
	self["pageCcb.pageLab"]:setString(curPage.."/"..numPage)
end

--- 
-- 筛选确定有哪些可合成的道具
-- @function [parent=#BagChipView] showMartialChip
-- @param #table list
-- 
function BagChipView:showMartialChip( list )
	if not list then return end
	
	local box = self["itemPCBox"] -- ui.PageCellBox#PageCellBox
	local arr
	if box:getDataSet() then
		arr = box:getDataSet():getArray()
	else
		arr = {}
	end
	
	function sortByFormulaNo(a, b)
		if a.isFalse then return false end
		if b.isFalse then return true end
	
		local rareA = rawget(a, "genstep")
		local rareB = rawget(b, "genstep")
		if not rareA then return false end
		if not rareB then return true end
		return a.genstep > b.genstep
	end
	
	local table = require("table")
	
	for i = 1, #list do
		local info = list[i]
		if info then
			info.isFalse = false
			table.insert(arr, info)
		end
	end
	
	table.sort(arr, sortByFormulaNo)
	
	local left = #arr%4
	if left > 0 or #arr == 0 then
		local info = {}
		info.formulano = -1
		info.isFalse = true
		for i = 1, (4-left) do
			table.insert(arr, info)
		end
	end
	
	local DataSet = require("utils.DataSet")
	local set = DataSet.new()
	set:setArray(arr)
	
	box:setDataSet(set)
end

--- 
-- 点击合成的武学（武学合成后会删除cell）
-- @function [parent=#BagChipView] setMergeCell
-- @param #table info
-- 
function BagChipView:setMergeCell( info )
	if not info then return end
	
	self._formulaInfo = info
end

--- 
-- 合成完成
-- @function [parent=#BagChipView] martialMergeEnd
-- @param self
-- 
function BagChipView:martialMergeEnd()
	if not self._formulaInfo then return end
	
	local box = self["itemPCBox"] -- ui.PageCellBox#PageCellBox
	if box:getDataSet() then
		box:getDataSet():removeItem(self._formulaInfo)
	end
end

---
-- 合成的时候保存cell
-- @function [parent=#BagChipView] 
function BagChipView:setSelectCellIndex( cell )
	self._selectCellIndex = cell
end

---
-- 显示合成成功特效
-- @function [parent=#BagChipView] showOverTeXiao
-- @param self
-- 
function BagChipView:showOverTeXiao()
	if not self._mergeSprite then
		display.addSpriteFramesWithFile("res/ui/effect/itembox_118.plist", "res/ui/effect/itembox_118.png")
		self._mergeSprite = display.newSprite()
		self:addChild(self._mergeSprite)
	end
	
	local frames = display.newFrames("itembox_118/1000%d.png", 0, 5)
	local ImageUtil = require("utils.ImageUtil")
	local frame = ImageUtil.getFrame()
	frames[#frames + 1] = frame
	local animation = display.newAnimation(frames, 1/6)
	transition.playAnimationOnce(self._mergeSprite, animation)
end


---
-- 显示背包物品是否已满
-- @function [parent=#BagChipView] showBagNumInfo
-- @param self
-- @param #table info 
-- 
function BagChipView:showBagNumInfo(info)
	local COUNT = 1
	if( info.partnerchip_max - info.partnerchip_num < COUNT ) then
		self["fullSpr1"]:setVisible(true)
	else
		self["fullSpr1"]:setVisible(false)
	end
	
	if( info.equipchip_max - info.equipchip_num < COUNT ) then
		self["fullSpr2"]:setVisible(true)
	else
		self["fullSpr2"]:setVisible(false)
	end
	
	if( info.martialchip_max - info.martialchip_num < COUNT ) then
		self["fullSpr3"]:setVisible(true)
	else
		self["fullSpr3"]:setVisible(false)
	end
end

---
-- 背包数量变化
-- @function [parent=#BagChipView] _chipNumChangedHandler
-- @param self
-- @param model.event.BagEvents#CHIP_NUM_CHANGE event
-- 
function BagChipView:_chipNumChangedHandler(event)
	local COUNT = 1
	local attrTbl = event.attrs
	local index = attrTbl.frameno - 3
	if( attrTbl.maxnum - attrTbl.num < COUNT ) then
		self["fullSpr"..index]:setVisible(true)
	else
		self["fullSpr"..index]:setVisible(false)
	end
end