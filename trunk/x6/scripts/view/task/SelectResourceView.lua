---
-- 选择物资界面
-- @module view.task.SelectResourceView
--

local require = require
local class = class
local CCSize = CCSize
local ccp = ccp
local tr = tr
local pairs = pairs
local table = table
local math = math
local ipairs = ipairs
local printf = printf

local moduleName = "view.task.SelectResourceView"
module(moduleName)

---
-- 类定义
-- @type SelectResourceView
--
local SelectResourceView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 选择cell表
-- @field [parent = #SelectResourceView] #table _selectedTbl
-- 
SelectResourceView._selectedTbl = nil

---
-- 选中数量限制 
-- @field [parent = #SelectResourceView] #number selectedCountLimit
-- 
SelectResourceView.selectedCountLimit = 0

---
-- 选择提示
-- @field [parent = #SelectResourceView] #string selectedTipStr
-- 
SelectResourceView.selectedTipStr = nil

---
-- 没有选择时提示
-- -- @field [parent = #SelectResourceView] #string noSelectedTipStr
-- 
SelectResourceView.noSelectedTipStr = nil

---
-- 提示颜色
-- @field [parent = #SelectResourceView] #string _selectedTipCor
-- 
SelectResourceView._selectedTipCor = nil

---
-- 构造函数
-- @function [parent = #SelectResourceView] ctor
--
function SelectResourceView:ctor()
	SelectResourceView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #SelectResourceView] _create
--
function SelectResourceView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_public/ui_publicselection2.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeBtnHandler)
	self:handleButtonEvent("selectCcb.aBtn", self._selectClkHandler)
	
	-- 隐藏top,center精灵
	self["zhenQiSpr"]:setVisible(false)
	self["zhenRongSpr"]:setVisible(false)
	self["partnerSpr"]:setVisible(false)
	self["equipSpr"]:setVisible(false)
	self["martialSpr"]:setVisible(false)
	
	self._selectedTbl = {}
	
	local itemBox = self["itemsPCBox"] -- ui.CellBox#CellBox
--	itemBox:setVSpace(8)
	itemBox:setVCount(1)
	itemBox:setHCount(4)
	itemBox:setHSpace(8)
	itemBox.owner = self
	
	local ScrollView = require("ui.ScrollView")
	itemBox:addEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
end

---
-- 打开界面
-- @function [parent = #SelectResourceView] openUi
-- @param self
-- @param #number type 类型
-- @param #number subType 子类型
-- 
function SelectResourceView:openUi(type, subType, number)
--	if not type or not subType or not number then return end
	local GameView = require("view.GameView")
    GameView.addPopUp(self, true)
    
    self.selectedCountLimit = number
    
    
    local ItemConst = require("model.const.ItemConst")
    
    local cell, str
    if type == ItemConst.ITEM_TYPE_EQUIP then
    	local ItemViewConst = require("view.const.ItemViewConst")
    	self._selectedTipCor = ItemViewConst.EQUIP_STEP_COLORS[subType]
    	cell = require("view.task.SelectResourceEquipCell")
    	str = tr("装备")
    elseif type == ItemConst.ITEM_TYPE_MARTIAL then
    	local ItemViewConst = require("view.const.ItemViewConst")
    	self._selectedTipCor = ItemViewConst.MARTIAL_STEP_COLORS[subType]
    	cell = require("view.task.SelectResourceMartialCell")
    	str = tr("武学")
    else
    	local PartnerShowConst = require("view.const.PartnerShowConst")
    	self._selectedTipCor = PartnerShowConst.STEP_COLORS[subType]
    	cell = require("view.task.SelectResourcePartnerCell")
    	str = tr("侠客")
    end
    
    self["tipLab"]:setString(tr("当前未选择") .. str)
    self.noSelectedTipStr = tr("当前未选择") .. str
    
    -- 配dataset
    local DataSet = require("utils.DataSet")
    local ds = DataSet.new()
--    ds:setArray(arr)
    ds:setArray(self:getArr(type, subType))

    
    local itemBox = self["itemsPCBox"] -- ui.CellBox#CellBox
	itemBox:setCellRenderer(cell)
	itemBox:setDataSet(ds)   
    -- 根据子类型从背包搜索
end

---
-- 根据类型，子类型返回道具或侠客数组
-- @function [parent = #SelectResourceView] getArr
-- @param self
-- @param #number type 类型
-- @param #number subType 子类型
-- @return #table
--
function SelectResourceView:getArr(type, subType)
	local arr
	if type ~= 11 then
		local ItemData = require("model.ItemData")
		local ItemConst = require("model.const.ItemConst")
		local frame
		
		if type == ItemConst.ITEM_TYPE_EQUIP then
			frame = ItemConst.EQUIP_FRAME
		else
			frame = ItemConst.MARTIAL_FRAME
		end
		
		arr = self:getItemsByFrameAndRare(frame, subType)
	else
		arr = self:getPartnerByRare(subType)
	end
	
	return arr
end

---
-- 根据道具背包和品阶，所需等级获取道具列表
-- @function [parent=#SelectResourceView] getItemsBySubKindAndFrame
-- @param #number frame
-- @param #number rare
-- @return #table 道具列表
-- 
function SelectResourceView:getItemsByFrameAndRare(frame, rare)
	local ItemData = require("model.ItemData")
	local dataSet = ItemData.itemAllListTbl[frame]
	if not dataSet then
		printf(tr("没有这种类型的背包").."   "..frame)
		return
	end
	
	local ret = {}
	local table = require("table")
	for k, v in pairs(dataSet:getArray()) do
		if v and (v.Rare == rare) and (v.EquipPartnerId == 0) then
			table.insert(ret, v)
		end
	end
	
	if #ret > 0 then
		local sortByGrade = function(a, b)
			return a.NeedGrade < b.NeedGrade
		end
		
		table.sort(ret, sortByGrade)
	end
	
	local addCount = 4 - #ret % 4
	if addCount ~= 0 or addCount ~= 4 then
		for i = 1, addCount do
			table.insert(ret, {isFalse = true})
		end
	end
	
	return ret
end

---
-- 获取背包里某一品阶的侠客数组
-- @function [parent = #SelectResourceView] getPartnerByStep
-- @param self
-- @param #number step
-- @return #table
-- 
function SelectResourceView:getPartnerByRare(step)
	local PartnerData = require("model.PartnerData")
	
	local ret = {}
	for k, v in pairs(PartnerData.partnerTbl) do
		if v and v.Step == step and v.War == 0 then
			table.insert(ret, v)
		end
	end
	
	if #ret > 0 then
		local sortByGrade = function(a, b)
			return a.Grade < b.Grade
		end
		
		table.sort(ret, sortByGrade)
	end
	
	local addCount = 4 - #ret % 4
	if addCount ~= 0 or addCount ~= 4 then
		for i = 1, addCount do
			table.insert(ret, {isFalse = true})
		end
	end
	
	return ret
end

---
-- 刷新选择cell
-- @function [parent = #SelectResourceView] selectObjUpdate
-- @param self
-- @param #SelectResourceCell cell(为cell的item)
-- @param #boolean 选中or取消选中
-- 
function SelectResourceView:selectObjUpdate(cell, isSelected)
	if isSelected then
		if #self._selectedTbl >= self.selectedCountLimit then
			local FloatNotify = require("view.notify.FloatNotify")
			FloatNotify.show(tr("已达到可选择最大数量"))
			cell.owner["selectCcb.aChk"]:setSelectedIndex(0)
			return
		end
		cell.selected = true
		table.insert(self._selectedTbl, cell)
	else
		cell.selected = false
		
		local TableUtil = require("utils.TableUtil")
		TableUtil.removeFromArr(self._selectedTbl, cell)
	end
	
	local tipStr = self.noSelectedTipStr
	if #self._selectedTbl > 0 then
		tipStr = tr("已选择:")
		local subStr = ""
		for k, v in ipairs(self._selectedTbl) do
			subStr = subStr .. self._selectedTipCor .. v.Name .. "</c>" .. " "
		end
		tipStr = tipStr .. subStr
		self.selectedTipStr = subStr
	end
	self["tipLab"]:setString(tipStr)
end

---
-- 点击了关闭按钮
-- @function [parent = #SelectResourceView] _closeBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function SelectResourceView:_closeBtnHandler(sender, event)
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 交换物资并关闭界面
-- @function [parent = #SelectResourceView] payResourceAndCloseView
-- @param self
-- 
function SelectResourceView:payResourceAndCloseView()
	local list = {}
	for i = 1, #self._selectedTbl do
		local item = self._selectedTbl[i]
		table.insert(list, item.Id)
		table.insert(list, 1)
	end
	
	for _, v in ipairs(list) do
		printf(v)
	end
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_dailytask_giveitem", {itemlist = list})
	
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 点击了选择按钮
-- @function [parent = #SelectResourceView] _selectClkHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function SelectResourceView:_selectClkHandler(sender, event)
	if not self.selectedTipStr then return end
	
	if #self._selectedTbl < self.selectedCountLimit then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("<c3>未达到要求数量，请继续选择"))
	else
		local TaskConfirmView = require("view.task.TaskConfirmView").createInstance()
		TaskConfirmView:openUi(self.payResourceAndCloseView, self)
		TaskConfirmView:setText(tr("是否确认选择 ") .. self.selectedTipStr .. tr("进行交付?"))
	end
end

---
-- 拖动
-- @function [parent=#SelectResourceView] _scrollChangedHandler
-- @param self
-- @param ui.ScrollView#SCROLL_CHANGED event
-- 
function SelectResourceView:_scrollChangedHandler( event )
	if event == nil then return end
	
	local objsBox = self["itemsPCBox"] -- ui.PageCellBox#PageCellBox
	local width = objsBox:getSnapWidth()
	local dataSet = objsBox:getDataSet()
	local len = 0
	if dataSet then 
		len = dataSet:getLength()
	end
	
	local max = math.ceil(len/ 4)
	local index = 0
	if width > 0 then
		index = math.floor(( 0 - event.curX )/width) + 1
	end
	
	if index < 1 then index = 1 end
	if index > max then index = max end
	
	self["pageCcb.pageLab"]:setString( index .. "/" .. max )
end

---
-- 窗口退出自动回调
-- @function [parent = #SelectResourceView] onExit
-- 
function SelectResourceView:onExit()
	self["itemsPCBox"]:setDataSet(nil)
	
	if self._selectedTbl and #self._selectedTbl > 0 then
		for i = 1, #self._selectedTbl do
			local item = self._selectedTbl[i]
			item.selected = false
		end
	end
	
	SelectResourceView._selectedTbl = nil
	
	local ScrollView = require("ui.ScrollView")
	self["itemsPCBox"]:addEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)

	instance = nil
	SelectResourceView.super.onExit(self)
end