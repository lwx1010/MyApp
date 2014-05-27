--- 
-- 选择界面：武学
-- @module view.martial.SelectMartialView
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local math = math
local table = table


local moduleName = "view.martial.SelectMartialView"
module(moduleName)

--- 
-- 类定义
-- @type SelectMartialView
-- 
local SelectMartialView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 界面类型 1穿戴 ， 2更换
-- @field [parent=#SelectMartialView] #number _viewType
--
SelectMartialView._viewType = nil

---
-- 确定回调函数
-- @field [parent=#SelectMartialView] #function _confirmCallback
-- 
SelectMartialView._confirmCallback = nil

---
-- 选中的对象
-- @field [parent=#SelectMartialView] #table _selectObj
-- 
SelectMartialView._selectObj = nil

---
-- 调用本对象的界面
-- @field [parent=#SelectMartialView] ui.CCBView#CCBView _view
--
SelectMartialView._view = nil

---
-- 额外参数
-- @field [parent=#SelectMartialView] #number _extdata
-- 
SelectMartialView._extdata = nil

--- 创建实例
-- @return SelectMartialView实例
function new()
	return SelectMartialView.new()
end

--- 
-- 构造函数
-- @function [parent=#SelectMartialView] ctor
-- @param self
-- 
function SelectMartialView:ctor()
	SelectMartialView.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#SelectMartialView] _create
-- @param self
-- 
function SelectMartialView:_create()

	local node = self:load("ui/ccb/ccbfiles/ui_public/ui_publicselection.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	
	local objsBox = self["itemsPCBox"] -- ui.PageCellBox#PageCellBox
--	objsBox:setVSpace(8)
	objsBox:setVCount(1)
	objsBox:setHCount(4)
	objsBox:setHSpace(8)
	local SelectMartialCell = require("view.martial.SelectMartialCell")
	
	objsBox.owner = self
	objsBox:setCellRenderer(SelectMartialCell)
	
	local ScrollView = require("ui.ScrollView")
	objsBox:addEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
end

---
-- 点击了cell按钮
-- @function [parent=#SelectMartialView] clkHandler
-- @param self
-- @param view.martial.SelectMartialCell#SelectMartialCell cell
-- 
function SelectMartialView:clkHandler( cell )
	printf("SelectMartialView:" .. "you have clicked the confirmCcb.aBtn")
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
-- @function [parent=#SelectMartialView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function SelectMartialView:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

--- 
-- 显示数据
-- @function [parent=#SelectMartialView] showItem
-- @param self
-- @param utils.DataSet#DataSet dataset
-- @param #func callback
-- @param #tabel view (调用窗口)
-- @param #number type
-- @param #number extend (额外参数 可根据类型变化)
-- 
function SelectMartialView:showItem( dataset, callback, view, type, extend )
	if not dataset or not callback or not view then 
		return 
	end
	
	local arrs = dataset:getArray()
	-- 按品质进行排序
	local func = function(a, b)
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
	
	self._view = view
	self._confirmCallback = callback
	self._viewType = type
	self._extdata = extend
	self["zhenRongSpr"]:setVisible(false)
	self["martialSpr"]:setVisible(true)
	self["partnerSpr"]:setVisible(false)
	self["equipSpr"]:setVisible(false)
	self["zhenQiSpr"]:setVisible(false)
end

---
-- 获取选中类型
-- @function [parent=#SelectMartialView] getSelectType
-- @param self
function SelectMartialView:getSelectType()
	return self._viewType
end

---
-- 获取_extdata
-- @function [parent=#SelectMartialView] getExtData
-- @param self
-- @return #number (type == 1or2 时为侠客阶位)
-- 
function SelectMartialView:getExtData()
	return self._extdata or 0
end

---
-- 拖动
-- @function [parent=#SelectMartialView] _scrollChangedHandler
-- @param self
-- @param ui.ScrollView#SCROLL_CHANGED event
-- 
function SelectMartialView:_scrollChangedHandler( event )
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
-- @function [parent=#SelectMartialView] onExit
-- @param self
-- 
function SelectMartialView:onExit()
	local ScrollView = require("ui.ScrollView")
	self["itemsPCBox"]:removeEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
	
	instance = nil
	SelectMartialView.super.onExit(self)
end
