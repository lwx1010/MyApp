--- 
-- 选中武学增加几率界面
-- @module view.martial.SelectRateMartialView
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local math = math
local pairs = pairs
local table = table

local moduleName = "view.martial.SelectRateMartialView"
module(moduleName)

--- 
-- 类定义
-- @type SelectRateMartialView
-- 
local SelectRateMartialView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 界面类型 （1选择淬炼材料，2选择装备穿戴, 3选择武学使用）
-- @field [parent=#SelectRateMartialView] #number _viewType
--
SelectRateMartialView._viewType = nil

---
-- 确定回调函数
-- @field [parent=#SelectRateMartialView] #function _confirmCallback
-- 
SelectRateMartialView._confirmCallback = nil

--- 
-- 选中的对象s
-- @field [parent=#SelectRateMartialView] #table _selectObjs
-- 
SelectRateMartialView._selectObjs = nil

---
-- 调用本对象的界面
-- @field @field [parent=#SelectRateMartialView] ui.CCBView#CCBView _view
--
SelectRateMartialView._view = nil

--- 创建实例
-- @return SelectRateMartialCell实例
function new()
	return SelectRateMartialView.new()
end

--- 
-- 构造函数
-- @function [parent=#SelectRateMartialView] ctor
-- @param self
-- 
function SelectRateMartialView:ctor()
	SelectRateMartialView.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#SelectRateMartialView] _create
-- @param self
-- 
function SelectRateMartialView:_create()

	local node = self:load("ui/ccb/ccbfiles/ui_public/ui_publicselection2.ccbi", true)
	
	self:handleButtonEvent("selectCcb.aBtn", self._selectClkHandler)
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	
	local objsBox = self["itemsPCBox"] -- ui.CellBox#CellBox
--	objsBox:setVSpace(8)
	objsBox:setVCount(1)
	objsBox:setHCount(4)
	objsBox:setHSpace(8)
	local SelectRateMartialCell = require("view.martial.SelectRateMartialCell")
	
	objsBox.owner = self
	objsBox:setCellRenderer(SelectRateMartialCell)
	
	local ScrollView = require("ui.ScrollView")
	objsBox:addEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
end

---
-- 点击了确定
-- @function [parent=#SelectRateMartialView] _confirmClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function SelectRateMartialView:_selectClkHandler( sender, event )
	printf("SelectRateMartialView:" .. "you have clicked the confirmCcb.aBtn")
	if self._confirmCallback and self._selectObjs  then 
		self._confirmCallback( self._selectObjs, self._view )
		local GameView = require("view.GameView")
		GameView.removePopUp(self, true)
	end
end

---
-- 点击了关闭
-- @function [parent=#SelectRateMartialView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function SelectRateMartialView:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

--- 
-- 显示数据
-- @function [parent=#SelectRateMartialView] showItem
-- @param self
-- @param utils.DataSet#DataSet dataset
-- @param #string title
-- @param #string tip
-- @param #func callback
-- @param #tabel view (调用窗口)
-- @param #number type
-- 
function SelectRateMartialView:showView( dataset, title, tip, callback, view, type )
	if not dataset or not title or not callback or not view then 
		return 
	end
	
	local arrs = dataset:getArray()
	-- 按品质进行排序
	local func = function(a, b)
		if a.Rare == b.Rare then
			if a.MartialLevel == b.MartialLevel then
				return a.IconNo < b.IconNo
			else
				return a.MartialLevel < b.MartialLevel
			end
		else
			return a.Rare < b.Rare
		end
	end
	table.sort(arrs, func)
	
	local len = dataset:getLength()
	local left = len%4
	if len == 0 or left > 0 then
		for i = 1, 4-left do
			local martial = {}
			martial.isFalse = true
			dataset:addItem(martial)
		end
	end
	
	local objsBox = self["itemsPCBox"] -- ui.CellBox#CellBox
	objsBox:setDataSet(dataset)
	
	self._selectObjs = {}
	for k, v in pairs(dataset:getArray()) do
		if v.selected then
			self._selectObjs[v.Id] = v
		end
	end
	
	self._view = view
	self._confirmCallback = callback
	self._viewType = type
	self["martialSpr"]:setVisible(true)
	self["partnerSpr"]:setVisible(false)
	self["equipSpr"]:setVisible(false)
	self["zhenQiSpr"]:setVisible(false)
	self["zhenRongSpr"]:setVisible(false)
--	self["titleLab"]:setString( title or " ")
	self["tipLab"]:setString( "" )
	
	self:updateSelected()
end

---
-- 选中更新 (view.equip.SelectRateMartialCell)
-- @function [parent=#SelectRateMartialView] selectObjUpdate
-- @param self
-- @param view.equip.SelectRateMartialCell#SelectRateMartialCell selectCell
-- 
function SelectRateMartialView:selectObjUpdate( selectCell )
	if not selectCell then return end
	
	local count = 0
	for k, v in pairs(self._selectObjs) do 
		if v then
			count = count + 1
		end
	end
	
	if selectCell["selectCcb.aChk"]:getSelectedIndex() == 1 then
		if count >= 5 then 
			selectCell["selectCcb.aChk"]:setSelectedIndex(0)
			selectCell:getItem().selected = false
			local FloatNotify = require("view.notify.FloatNotify")
			FloatNotify.show(tr("提升几率最多只能选择5本秘籍!"))
			return
		end
		
		self._selectObjs[selectCell:getItem().Id] = selectCell:getItem()
	else
		selectCell:getItem().selected = false
		self._selectObjs[selectCell:getItem().Id] = nil
	end
	
	self:updateSelected()
end

---
-- 显示提示更新
-- @function [parent=#SelectRateMartialView] updateSelected
-- @param self
-- 
function SelectRateMartialView:updateSelected()
	local whiteCnt = 0
	local greenCnt = 0
	local blueCnt = 0
	local purpleCnt = 0
	local orangeCnt = 0
	for k, v in pairs( self._selectObjs ) do
		if v.Rare == 1 then
			whiteCnt = whiteCnt + 1
		elseif v.Rare == 2 then
			greenCnt = greenCnt + 1
		elseif v.Rare == 3 then
			blueCnt = blueCnt + 1
		elseif v.Rare == 4 then
			purpleCnt = purpleCnt + 1
		elseif v.Rare == 5 then
			orangeCnt = orangeCnt + 1
		end
	end
	
	if (whiteCnt + greenCnt + blueCnt + purpleCnt + orangeCnt) == 0 then
		self["tipLab"]:setString("当前未选择秘籍")
		return 
	end
	
	local str = "已选择秘籍:"
	local rate = 0  --1,2,3,5,6(百分比)
	if whiteCnt > 0 then
		str = str .. "<c0>白色<c0>*" .. whiteCnt .. " " 
		rate = rate + 1*whiteCnt
	end
	
	if greenCnt > 0 then
		str = str .. "<c1>绿色<c0>*" .. greenCnt .. " " 
		rate = rate + 2*greenCnt
	end
	
	if blueCnt > 0 then
		str = str .. "<c2>蓝色<c0>*" .. blueCnt .. " " 
		rate = rate + 3*blueCnt
	end
	
	if purpleCnt > 0 then
		str = str .. "<c3>紫色<c0>*" .. purpleCnt .. " " 
		rate = rate + 5*purpleCnt
	end
	
	if orangeCnt > 0 then
		str = str .. "<c4>橙色<c0>*" .. orangeCnt .. " " 
		rate = rate + 6*orangeCnt
	end
	
	self["tipLab"]:setString(str)
end

---
-- 拖动
-- @function [parent=#SelectRateMartialView] _scrollChangedHandler
-- @param self
-- @param ui.ScrollView#SCROLL_CHANGED event
-- 
function SelectRateMartialView:_scrollChangedHandler( event )
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