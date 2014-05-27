--- 
-- 选择界面装备
-- @module view.equip.SelectEquipView
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local math = math
local table = table
local rawget = rawget

local moduleName = "view.equip.SelectEquipView"
module(moduleName)

--- 
-- 类定义
-- @type SelectEquipView
-- 
local SelectEquipView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 界面类型 1穿戴， 2更换， 3转移
-- @field [parent=#SelectEquipView] #number _viewType
--
SelectEquipView._viewType = nil

---
-- 确定回调函数
-- @field [parent=#SelectEquipView] #function _confirmCallback
-- 
SelectEquipView._confirmCallback = nil

---
-- 选中的对象
-- @field [parent=#SelectEquipView] #table _selectObj
-- 
SelectEquipView._selectObj = nil

---
-- 调用本对象的界面
-- @field @field [parent=#SelectEquipView] ui.CCBView#CCBView _view
--
SelectEquipView._view = nil

---
-- 额外参数
-- @field [parent=#SelectEquipView] #number _extdata
-- 
SelectEquipView._extdata = nil

--- 创建实例
-- @return SelectEquipView实例
function new()
	return SelectEquipView.new()
end

--- 
-- 构造函数
-- @function [parent=#SelectEquipView] ctor
-- @param self
-- 
function SelectEquipView:ctor()
	SelectEquipView.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#SelectEquipView] _create
-- @param self
-- 
function SelectEquipView:_create()

	local node = self:load("ui/ccb/ccbfiles/ui_public/ui_publicselection.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	
	local objsBox = self["itemsPCBox"] -- ui.PageCellBox#PageCellBox
--	objsBox:setVSpace(8)
	objsBox:setVCount(1)
	objsBox:setHCount(4)
	objsBox:setHSpace(8)
	local SelectEquipCell = require("view.equip.SelectEquipCell")
	
	objsBox.owner = self
	objsBox:setCellRenderer(SelectEquipCell)
	
	local ScrollView = require("ui.ScrollView")
	objsBox:addEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
end

---
-- 点击了cell按钮
-- @function [parent=#SelectEquipView] clkHandler
-- @param self
-- @param view.equip.SelectEquipCell#SelectEquipCell cell
-- 
function SelectEquipView:clkHandler( cell )
	if not cell then return end
	self._selectObj = cell:getItem()
	
	if self._confirmCallback and self._selectObj  then 
		self._confirmCallback( self._selectObj.Id, self._view )
		local GameView = require("view.GameView")
		GameView.removePopUp(self, true)
	end
end

---
-- 点击了关闭
-- @function [parent=#SelectEquipView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function SelectEquipView:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

--- 
-- 显示数据
-- @function [parent=#SelectEquipView] showItem
-- @param self
-- @param utils.DataSet#DataSet dataset
-- @param #func callback
-- @param #tabel view (调用窗口)
-- @param #number type
-- @param #number extend (额外参数 可根据类型变化)
-- 
function SelectEquipView:showItem( dataset, callback, view, type, extend )
	if not dataset or not callback or not view then 
		return 
	end
	
	local arrs = dataset:getArray()
	-- 按品质进行排序
	local func = function(a, b)
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
	
	local len = dataset:getLength()
	local left = len%4
	if len == 0 or left > 0 then
		for i = 1, 4-left do
			local equip = {}
			equip.isFalse = true
			dataset:addItem(equip)
		end
	end
	
	local objsBox = self["itemsPCBox"] -- ui.CellBox#CellBox
	objsBox:setDataSet(dataset)
	
	self._view = view
	self._confirmCallback = callback
	self._viewType = type
	self._extdata = extend
	self["zhenRongSpr"]:setVisible(false)
	self["martialSpr"]:setVisible(false)
	self["partnerSpr"]:setVisible(false)
	self["equipSpr"]:setVisible(true)
	self["zhenQiSpr"]:setVisible(false)
end

---
-- 获取选中类型
-- @function [parent=#SelectEquipView] getSelectType
-- @param self
function SelectEquipView:getSelectType()
	return self._viewType
end

---
-- 获取_extdata
-- @function [parent=#SelectEquipView] getExtData
-- @param self
-- @return #number (type == 1or2 时为侠客阶位)
-- 
function SelectEquipView:getExtData()
	return self._extdata or 0
end

---
-- 拖动
-- @function [parent=#SelectEquipView] _scrollChangedHandler
-- @param self
-- @param ui.ScrollView#SCROLL_CHANGED event
-- 
function SelectEquipView:_scrollChangedHandler( event )
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
-- 退出界面调用
-- @function [parent=#SelectEquipView] onExit
-- @param self
-- 
function SelectEquipView:onExit()
	local ScrollView = require("ui.ScrollView")
	self["itemsPCBox"]:removeEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
	
	instance = nil
	SelectEquipView.super.onExit(self)
end
