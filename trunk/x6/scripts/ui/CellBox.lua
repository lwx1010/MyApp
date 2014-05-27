--- 
-- 相同子项的盒子容器.
-- 每个单元渲染器需要实现接口showItem(item)，当单元可见时，
-- 传入相应的data，否则传入nil
-- 同时，会设置单元渲染器的属性dataIdx会相应的数据索引
-- @module ui.CellBox
-- 

local class = class
local printf = printf
local require = require
local ipairs = ipairs
local CCRect = CCRect

local moduleName = "ui.CellBox"
module(moduleName)

---
-- @type ITEM_SELECTED
-- @field #string name ITEM_SELECTED
-- @field #number index	当前可见选项索引
-- 

--- 
-- 选项变化
-- @field [parent=#ui.CellBox] #ITEM_SELECTED ITEM_SELECTED
-- 
ITEM_SELECTED = {name="ITEM_SELECTED"}

---
-- 子项可见性失效
-- @field [parent=#ui.CellBox] #string ITEM_VISIBLE ITEM_VISIBLE
-- 
local ITEM_VISIBLE = "ItemVisible"

--- 
-- 类定义
-- @type CellBox
-- 

---
-- CellBox类
-- @field [parent=#ui.CellBox] #CellBox CellBox
-- 
CellBox = class(moduleName, require("ui.Box").Box)

---
-- 数据集
-- @field [parent=#CellBox] utils.DataSet#DataSet _dataSet
-- 
CellBox._dataSet = nil

---
-- 子项渲染器
-- @field [parent=#CellBox] #table _cellRenderer
-- 
CellBox._cellRenderer = nil

---
-- 是否自动计算对齐
-- @field [parent=#CellBox] #table _autoSizeSnap
-- 
CellBox._autoSizeSnap = true

---
-- 子项渲染器是否大小一样
-- @field [parent=#CellBox] #table _sameSizeCell
-- 
CellBox._sameSizeCell = true

---
-- 子项宽
-- @field [parent=#CellBox] #number _cellWidth
-- 
CellBox._cellWidth = nil

---
-- 子项高
-- @field [parent=#CellBox] #number _cellHeight
-- 
CellBox._cellHeight = nil

---
-- 第一个可见项的索引
-- @field [parent=#CellBox] #table _firstVisibleIndex
-- 
CellBox._firstVisibleIndex = 0

--- 
-- 构造函数
-- @function [parent=#CellBox] ctor
-- @param self
-- 
function CellBox:ctor()
	CellBox.super.ctor(self)
	
	self._validateOrderArr[#self._validateOrderArr+1] = ITEM_VISIBLE
	self._selectByIndex = true
end

--- 
-- 设置子项渲染器是否大小一样
-- @function [parent=#CellBox] setSameSizeCell
-- @param self
-- @param #boolean s 是否一样
-- 
function CellBox:setSameSizeCell( s )
	self._sameSizeCell = s
end

--- 
-- 子项渲染器是否大小一样
-- @function [parent=#CellBox] isSameSizeCell
-- @param self
-- @return #boolean
-- 
function CellBox:isSameSizeCell( )
	return self._sameSizeCell
end

--- 
-- 设置自动计算对齐
-- @function [parent=#CellBox] setAutoSizeSnap
-- @param self
-- @param #boolean a 是否自动计算对齐
-- 
function CellBox:setAutoSizeSnap( a )
	self._autoSizeSnap = a
end

--- 
-- 是否自动计算对齐
-- @function [parent=#CellBox] isAutoSizeSnap
-- @param self
-- @return #boolean
-- 
function CellBox:isAutoSizeSnap( )
	return self._autoSizeSnap
end

--- 
-- 设置子项渲染器
-- @function [parent=#CellBox] setCellRenderer
-- @param self
-- @param #table r 子项渲染器
-- 
function CellBox:setCellRenderer( r )
	if( not r or not r.new or self._cellRenderer==r ) then return end
	
	self._cellRenderer = r
	self._cellWidth = nil
	self._cellHeight = nil
	
	self:clearSelect(nil, false)
	self:removeAllItems()
	self:scrollToPos(0, 0)
	self:invalidData()
end

--- 
-- 获取子项渲染器
-- @function [parent=#CellBox] getCellRenderer
-- @param self
-- @return #table
-- 
function CellBox:getCellRenderer( )
	return self._cellRenderer
end

--- 
-- 设置数据集
-- @function [parent=#CellBox] setDataSet
-- @param self
-- @param utils.DataSet#DataSet s 数据集
-- 
function CellBox:setDataSet( s )
	if self._dataSet==s then return end
	
	local DataSet = require("utils.DataSet")
	if( self._dataSet ) then
		self._dataSet:removeEventListener(DataSet.CHANGED.name, self._dataChangedHandler, self)
		self._dataSet:removeEventListener(DataSet.ITEM_UPDATED.name, self._itemUpdatedHandler, self)
	end
	
	self._dataSet = s
	
	if( self._dataSet ) then
		self._dataSet:addEventListener(DataSet.CHANGED.name, self._dataChangedHandler, self)
		self._dataSet:addEventListener(DataSet.ITEM_UPDATED.name, self._itemUpdatedHandler, self)
	end
	
	self:clearSelect(nil, false)
	self:scrollToPos(0, 0)
	self:invalidData()
end

--- 
-- 取数据集
-- @function [parent=#CellBox] getDataSet
-- @param self
-- @return utils.DataSet#DataSet 数据集
-- 
function CellBox:getDataSet( )
	return self._dataSet
end

--- 
-- 数据改变处理
-- @function [parent=#CellBox] _dataChangedHandler
-- @param self
-- @param utils.DataSet#CHANGED event 数据集改变事件
-- 
function CellBox:_dataChangedHandler( event )
	self:invalidData()
end

--- 
-- 数据项更新处理
-- @function [parent=#CellBox] _itemUpdatedHandler
-- @param self
-- @param utils.DataSet#ITEM_UPDATED event 数据项更新事件
-- 
function CellBox:_itemUpdatedHandler( event )
	local cell
	for i=1, #self._itemArr do
		cell = self._itemArr[i]
		
		if cell.dataIdx==event.index then
			if not cell:isVisible() then return end
			
			-- 强制刷新
			if( cell.showItem ) then
				cell:showItem(nil)
				cell:showItem(event.item)
			end
			
			return
		end
	end
end

---
-- 计算显示的子项数目
-- @function [parent=#CellBox] _calcShowItemCnt
-- @param self
-- 
function CellBox:_calcShowItemCnt()
	return self._dataSet and self._dataSet:getLength() or 0
end 

---
-- 校验数据
-- @function [parent=#CellBox] _validateData
-- @param self
-- 
function CellBox:_validateData()
	if( not self._dataSet or not self._cellRenderer ) then
		self:clearSelect(nil, false)
		self:removeAllItems()
		return
	end
	
	-- 保存一下宽，高
	if self._sameSizeCell and not self._cellWidth or not self._cellHeight then
		local cell = self._cellRenderer.new()
		self:addItem(cell)
		
		local cellSize = cell:getContentSize()
		self._cellWidth = cellSize.width
		self._cellHeight = cellSize.height
	end
	
	local math = require("math")
	
	local dataArr = self._dataSet:getArray()
	local dataCnt = math.min(#dataArr, self:_calcShowItemCnt())
	local itemCnt = #self._itemArr
	
	-- 添加缺少的
	for i=itemCnt+1, dataCnt do
		self:addItem(self._cellRenderer.new())
	end
	
	-- 删掉多余的
	local cell
	for i=itemCnt, dataCnt+1, -1 do
		cell = self._itemArr[i]
		if( cell.showItem ) then
			cell:showItem(nil)
		end
		
		self:removeItemAt(i)
		
		self:clearSelect({i}, false)
	end
	
	-- 将索引清掉
	for i=1, #self._itemArr do
		cell = self._itemArr[i]
		cell:setVisible(false)
		cell.dataIdx = nil
	end
	
	-- 自动对齐
	if self._sameSizeCell and self._autoSizeSnap and #self._itemArr>0 then
		self:_calcAutoSnap( )
	end
end

---
-- 计算自动对齐
-- @function [parent=#CellBox] _calcAutoSnap
-- @param self
-- 
function CellBox:_calcAutoSnap( )
end

---
-- 布局生效
-- @function [parent=#CellBox] _validateLayout
-- @param self
-- 
function CellBox:_validateLayout()
	if not self._sameSizeCell then
		CellBox.super._validateLayout(self)
		return
	end
	
	-- 只滚屏
	local ScrollView = require("ui.ScrollView")
	ScrollView.ScrollView._validateLayout(self)
end

---
-- 校验子项可视性
-- @function [parent=#CellBox] _validateItemVisible
-- @param self
-- 
function CellBox:_validateItemVisible( )
	if( not self._dataSet or #self._itemArr<=0 ) then return end
	
	local dataArr = self._dataSet:getArray()
	
	local viewRect = CCRect(0, 0, 0, 0)
	viewRect.size = self:getContentSize()
	
	local cellRect = CCRect()
	
	local oldVisible = self._firstVisibleIndex
	self._firstVisibleIndex = 0
	
	local visible
	local cell
	for i=1, #self._itemArr do
		cell = self._itemArr[i]
		
		cellRect.size = cell:getContentSize()
		cellRect.origin.x = cell:getPositionX()+self._containerEndX
		cellRect.origin.y = cell:getPositionY()+self._containerEndY
		
		visible = viewRect:intersectsRect(cellRect)
		
		-- 设置可视性
		cell:setVisible(visible)
		cell.dataIdx = visible and i or nil
		
		-- 选择
		if visible then
			if cell.setSelect then
				cell:setSelect(self:isSelected(i))
			end
		end
		
		-- 显示内容
		if( cell.showItem ) then
			if( visible ) then
				cell:showItem(dataArr[i])
			else
				cell:showItem(nil)
			end
		end
		
		-- 记录第一个可见项
		if visible and not (self._firstVisibleIndex>0) then
			self._firstVisibleIndex = i
		end
	end
	
	if oldVisible~=self._firstVisibleIndex and self:hasListener(ITEM_SELECTED.name) then
		-- 派发事件
		ITEM_SELECTED.index = self._firstVisibleIndex
		self:dispatchEvent(ITEM_SELECTED)
	end
	
	--self:_updateBarValue()
end

---
-- 取第一可见项的索引
-- @function [parent=#CellBox] getFirstVisibleIndex
-- @return #number 索引
-- 
function CellBox:getFirstVisibleIndex( )
	return self._firstVisibleIndex
end

---
-- 滚动到特定位置
-- @function [parent=#CellBox] _doScrollToPos
-- @param self
-- @param #number x x方向位置
-- @param #number y y方向位置
-- @param #boolean anim 是否动画方式滚动
-- 
function CellBox:_doScrollToPos( x, y, anim )
	CellBox.super._doScrollToPos(self, x, y, anim)
	
	self:invalidItemVisible()
end

---
-- 数据失效
-- @function [parent=#CellBox] invalidData
-- @param self
-- 
function CellBox:invalidData()
	CellBox.super.invalidData(self)
	
	self:invalidLayout()
	self:invalidItemVisible()
end

---
-- 布局失效
-- @function [parent=#CellBox] invalidLayout
-- @param self
-- 
function CellBox:invalidLayout()
	CellBox.super.invalidLayout(self)
	
	self:invalidItemVisible()
end

---
-- 子项可见性失效
-- @function [parent=#CellBox] invalidItemVisible
-- @param self
-- 
function CellBox:invalidItemVisible()
	self:_invalid(ITEM_VISIBLE)
end

---
-- 计算一页孩子的水平和垂直方向最大宽高
-- @function [parent=#CellBox] _calcMaxChildSizes
-- @param self
-- @param #number beginIdx 开始索引
-- @return #number, #table, #table 结束索引，水平方向的最大宽，垂直方向的最大高
-- 
function CellBox:_calcMaxChildSizes( beginIdx )
	if not self._sameSizeCell then
		CellBox.super._calcMaxChildSizes(self, beginIdx)
		return
	end
	
	-- 相同大小
	local cellSize = self._itemArr[1]:getContentSize()
	
	local endIdx = #self._itemArr
	if( self._hCount and self._vCount ) then
		endIdx = beginIdx+self._hCount*self._vCount-1
		
		if endIdx>#self._itemArr then
			endIdx = #self._itemArr
		end 
	end
	
	return endIdx, {cellSize.width}, {cellSize.height}
end

---
-- 取子项索引
-- @function [parent=#CellBox] getItemIndex
-- @param self
-- @param #CCNode item
-- @return #number 索引值
-- 
function CellBox:getItemIndex( item )
	if item then
		return item.dataIdx
	end
end

---
-- 取特定位置的子项
-- @function [parent=#CellBox] getItemAt
-- @param self
-- @param #number index 索引
-- @return #table 子项
-- 
function CellBox:getItemAt( index )
	for i=1, #self._itemArr do
		if self._itemArr[i].dataIdx==index then
			return self._itemArr[i]
		end
	end
end

-----
---- 更新滚动条范围
---- @function [parent=#CellBox] _updateBarRange
---- 
--function CellBox:_updateBarRange()
--	if not self._dataSet then return end
--	
--	local math = require("math")
--	if self._vBar then
--		if self._hCount then
--			self._vBar:setValueRange(1, math.ceil(self._dataSet:getLength()/self._hCount))
--		else
--			self._vBar:setValueRange(1, self._dataSet:getLength())
--		end
--	end
--	
--	if self._hBar then
--		if self._vCount then
--			self._hBar:setValueRange(1, math.ceil(self._dataSet:getLength()/self._vCount))
--		else
--			self._hBar:setValueRange(1, self._dataSet:getLength())
--		end
--	end
--end
--
-----
---- 更新滚动条值
---- @function [parent=#CellBox] _updateBarValue
---- @param #number x 水平方向值
---- @param #number y 垂直方向值
---- 
--function CellBox:_updateBarValue(x, y)
--	
--	if self._vBar then
--		self._vBar:setValue(self._firstVisibleIndex, false)
--	end
--	
--	if self._hBar then
--		self._hBar:setValue(self._firstVisibleIndex, false)
--	end
--end
--
-----
---- 滚动条改变
---- @function [parent=#CellBox] _onBarChanged
---- @param self
---- @param ui.ScrollBar#SCROLL_CHANGED event 事件
---- 
--function CellBox:_onBarChanged( event )
--	if event.target==self._vBar then
--		self:scrollToIndex(event.value, false)
--	elseif event.target==self._hBar then
--		self:scrollToIndex(event.value, false)
--	end
--end

---
-- 清理
-- @function [parent=#CellBox] onCleanup
-- @param self
--
function CellBox:onCleanup()
	
	if self._dataSet then
		local DataSet = require("utils.DataSet")
		self._dataSet:removeEventListener(DataSet.CHANGED.name, self._dataChangedHandler, self)
		self._dataSet:removeEventListener(DataSet.ITEM_UPDATED.name, self._itemUpdatedHandler, self)
	end
	
	self._dataSet = nil
	
	CellBox.super.onCleanup(self)
end