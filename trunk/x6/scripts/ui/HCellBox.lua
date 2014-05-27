---
-- 单元子项的水平盒子容器
-- @module ui.HCellBox
-- 

local class = class
local printf = printf
local require = require
local ipairs = ipairs
local CCRect = CCRect
local pairs = pairs


local moduleName = "ui.HCellBox"
module(moduleName)


--- 
-- 类定义
-- @type HCellBox
-- 

---
-- HCellBox
-- @field [parent=#ui.HCellBox] #HCellBox HCellBox
-- 
HCellBox = class(moduleName, require("ui.CellBox").CellBox)

--- 
-- 创建实例
-- @function [parent=#ui.HCellBox] new
-- @return #HCellBox
-- 
function new()
	return HCellBox.new()
end

--- 
-- 构造函数
-- @function [parent=#HCellBox] ctor
-- @param self
-- 
function HCellBox:ctor()
	HCellBox.super.ctor(self)
	
	local Directions = require("ui.const.Directions")
	self._scrollDir = Directions.HORIZONTAL
	
	self._hCount = nil
	self._vCount = 1
end

---
-- 计算自动对齐
-- @function [parent=#HCellBox] _calcAutoSnap
-- @param self
-- 
function HCellBox:_calcAutoSnap( )
	if not self._sameSizeCell then
		if not self._itemArr[1] then return end
		
		local cellSize = self._itemArr[1]:getContentSize()
		self:setSnapWidth(cellSize.width+self._hSpace)
		self:setSnapHeight(0)
		return
	end
	
	if not self._cellWidth then return end
	
	self:setSnapWidth(self._cellWidth+self._hSpace)
	self:setSnapHeight(0)
end

---
-- 计算显示的子项数目
-- @function [parent=#HCellBox] _calcShowItemCnt
-- @param self
-- 
function HCellBox:_calcShowItemCnt()
	if not self._sameSizeCell then
		return HCellBox.super._calcShowItemCnt(self)
	end
	
	if not self._cellWidth then return 0 end
	
	local math = require("math")
	
	local selfSize = self:getContentSize()
	local showColCnt = 1+math.modf((selfSize.width+self._cellWidth+self._hSpace-1)/(self._cellWidth+self._hSpace))
	return self._vCount*showColCnt
end 

---
-- 计算子项范围
-- @function [parent=#HCellBox] _calcItemBound
-- @param self
-- @return #CCRect
-- 
function HCellBox:_calcItemBound( )
	if not self._sameSizeCell then
		return HCellBox.super._calcItemBound(self)
	end
	
	if not self._dataSet or self._dataSet:getLength()<=0 or #self._itemArr<=0 then
		return CCRect()
	end
	
	if not self._sameSizeCell or not self._cellWidth or not self._cellHeight then
		return HCellBox.super._calcItemBound(self)
	end
	
	-- 相同大小
	local cellWidth = self._cellWidth+self._hSpace
	local cellHeight = self._cellHeight+self._vSpace
	
	local numData = self._dataSet:getLength()
	
	if numData<self._vCount then
		return CCRect(0, 0, cellWidth, numData*cellHeight)
	end
		
	local math = require("math")
	local numCol = math.ceil(numData/self._vCount)
	return CCRect(0, 0, numCol*cellWidth, self._vCount*cellHeight)
end

---
-- 校验子项可视性
-- @function [parent=#HCellBox] _validateItemVisible
-- @param self
-- 
function HCellBox:_validateItemVisible( )
	if not self._sameSizeCell then
		HCellBox.super._validateItemVisible(self)
		return
	end
	
	if not self._dataSet or #self._itemArr<=0 or not self._cellWidth or not self._cellHeight then return end
	
	-- 排位
	local math = require("math")
	local cellWidth = self._cellWidth+self._hSpace
	local cellHeight = self._cellHeight+self._vSpace
	local showBeginCol = math.modf(-self._containerEndX/cellWidth)
	showBeginCol = math.max(0, showBeginCol)
	
	local showEndCol = math.modf((-self._containerEndX+self:getContentSize().width)/cellWidth)
	local showBeginIdx = showBeginCol*self._vCount+1
	local showEndIdx = (showEndCol+1)*self._vCount
	
	local dataArr = self._dataSet:getArray()
	
	showEndIdx = math.min(showEndIdx, showBeginIdx+#self._itemArr-1, #dataArr)
	
	-- 收集重用的，要刷新的项
	local reuseCells, refreshCells = {}, {}
	local cell
	for i=1, #self._itemArr do
		cell = self._itemArr[i]
		
		if cell.dataIdx and cell.dataIdx>=showBeginIdx and cell.dataIdx<=showEndIdx then
			reuseCells[cell.dataIdx] = cell
		else
			refreshCells[#refreshCells+1] = cell
		end
	end
	
	-- 没设置自身大小，居中
	local selfSize = self:getContentSize()
	local adjustX, adjustY = 0, selfSize.height
	if selfSize.width<=0 or selfSize.height<=0 then
		local itemBound = self:_calcItemBound()
		if selfSize.width<=0 then
			adjustX = -itemBound.size.width*0.5
		end
		if selfSize.height<=0 then
			adjustY = itemBound.size.height*0.5
		end
	end
	
	adjustY = adjustY+self._vSpace
	
	--printf("%d %d %d %d", showBeginCol, showEndCol, showBeginIdx, showEndIdx)
	
	local colIdx = showBeginCol
	local rowIdx = 1
	
	-- 更新显示的cell
	for i=showBeginIdx, showEndIdx do
		
		cell = reuseCells[i]
		
		if not cell then
			if #refreshCells<1 then
				printf("hcellbox _validateItemVisible not enough cell!")
				break
			end
			
			cell = refreshCells[#refreshCells]
			refreshCells[#refreshCells] = nil
			
			cell.dataIdx = i
			
			-- 显示内容
			if cell.showItem then
				cell:showItem(dataArr[i])
			end
		else
			reuseCells[i] = nil
		end
		
		-- 设置可视性
		cell:setVisible(true)
		
		-- 选择
		if cell.setSelect then
			cell:setSelect(self:isSelected(i))
		end
		
		-- 位置
		cell:setPosition(adjustX+colIdx*cellWidth, adjustY-rowIdx*cellHeight)
		
		rowIdx = rowIdx+1
		if rowIdx>self._vCount then
			rowIdx = 1
			colIdx = colIdx+1
		end
	end
	
	-- 隐藏不显示的cell
	for _, cell in pairs(reuseCells) do
		if cell.showItem then
			cell:showItem(nil)
		end
		
		-- 设置可视性
		cell:setVisible(false)
		cell.dataIdx = nil
	end
	
	for i=1, #refreshCells do
		cell = refreshCells[i]
		
		if cell.showItem then
			cell:showItem(nil)
		end
		
		-- 设置可视性
		cell:setVisible(false)
		cell.dataIdx = nil
	end
	
	--printf("refresh count:"..#refreshCells)
	
	-- 显示起始变更
	if showBeginIdx~=self._firstVisibleIndex then
		self._firstVisibleIndex = showBeginIdx
		
		local CellBox = require("ui.CellBox")
		if self:hasListener(CellBox.ITEM_SELECTED.name) then
			-- 派发事件
			CellBox.ITEM_SELECTED.index = self._firstVisibleIndex
			self:dispatchEvent(CellBox.ITEM_SELECTED)
		end
	end
end

---
-- 滚动到特定索引
-- @function [parent=#HCellBox] scrollToIndex
-- @param self
-- @param #number index 索引
-- @param #boolean anim 是否动画方式滚动
-- 
function HCellBox:scrollToIndex( index, anim )
	if not self._sameSizeCell then
		HCellBox.super.scrollToIndex(self, index, anim)
		return
	end
	
	if not self._cellWidth or not self._cellHeight then return end
	if not self._dataSet or index<1 or index>self._dataSet:getLength() then return end
	
	local math = require("math")
	local row = (index-1)%self._vCount
	local col = math.floor((index-1)/self._vCount)
	local x = (self._cellWidth+self._hSpace)*col
	local y = (self._cellHeight+self._vSpace)*row
	
	self:scrollToPos(x, y, anim)
end
