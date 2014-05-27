---
-- 相同子项的垂直盒子容器
-- @module ui.VCellBox
-- 

local class = class
local printf = printf
local require = require
local ipairs = ipairs
local CCRect = CCRect
local pairs = pairs


local moduleName = "ui.VCellBox"
module(moduleName)


--- 
-- 类定义
-- @type VBox
-- 

---
-- VCellBox
-- @field [parent=#ui.VCellBox] #VCellBox VCellBox
-- 
VCellBox = class(moduleName, require("ui.CellBox").CellBox)

--- 
-- 创建实例
-- @function [parent=#ui.VCellBox] new
-- @return #VCellBox
-- 
function new()
	return VCellBox.new()
end

--- 
-- 构造函数
-- @function [parent=#VCellBox] ctor
-- @param self
-- 
function VCellBox:ctor()
	VCellBox.super.ctor(self)
	
	local Directions = require("ui.const.Directions")
	self._scrollDir = Directions.VERTICAL
	
	self._hCount = 1
	self._vCount = nil
end

---
-- 计算自动对齐
-- @function [parent=#VCellBox] _calcAutoSnap
-- @param self
-- 
function VCellBox:_calcAutoSnap( )
	if not self._sameSizeCell then
		local cellSize = self._itemArr[1]:getContentSize()
		self:setSnapWidth(0)
		self:setSnapHeight(cellSize.height+self._vSpace)
		return
	end
	
	if not self._cellHeight then return end
	
	self:setSnapWidth(0)
	self:setSnapHeight(self._cellHeight+self._vSpace)
end

---
-- 计算显示的子项数目
-- @function [parent=#VCellBox] _calcShowItemCnt
-- @param self
-- 
function VCellBox:_calcShowItemCnt()
	if not self._sameSizeCell then
		VCellBox.super._calcShowItemCnt(self)
		return
	end
	
	if not self._cellHeight then return 0 end
	
	local math = require("math")
	
	local selfSize = self:getContentSize()
	local showRowCnt = 1+math.modf((selfSize.height+self._cellHeight+self._vSpace-1)/(self._cellHeight+self._vSpace))
	return self._hCount*showRowCnt
end

---
-- 计算子项范围
-- @function [parent=#VCellBox] _calcItemBound
-- @param self
-- @return #CCRect
-- 
function VCellBox:_calcItemBound( )
	if not self._sameSizeCell then
		VCellBox.super._calcItemBound(self)
		return
	end
	
	if not self._dataSet or self._dataSet:getLength()<=0 or #self._itemArr<=0 then
		return CCRect()
	end
	
	if not self._sameSizeCell or not self._cellWidth or not self._cellHeight then
		return VCellBox.super._calcItemBound(self)
	end
	
	-- 相同大小
	local cellWidth = self._cellWidth+self._hSpace
	local cellHeight = self._cellHeight+self._vSpace
	
	local numData = self._dataSet:getLength()
	
	if numData<self._hCount then
		return CCRect(0, 0, numData*cellWidth, cellHeight)
	end
	
	local math = require("math")
	local numRow = math.ceil(numData/self._hCount)
	return CCRect(0, 0, self._hCount*cellWidth, numRow*cellHeight)
end

---
-- 校验子项可视性
-- @function [parent=#VCellBox] _validateItemVisible
-- @param self
-- 
function VCellBox:_validateItemVisible( )
	if not self._sameSizeCell then
		VCellBox.super._validateItemVisible(self)
		return
	end
	
	if not self._dataSet or #self._itemArr<=0 or not self._cellWidth or not self._cellHeight then return end
	
	-- 排位
	local math = require("math")
	local cellWidth = self._cellWidth+self._hSpace
	local cellHeight = self._cellHeight+self._vSpace
	local showBeginRow = math.modf(self._containerEndY/cellHeight)
	showBeginRow = math.max(0, showBeginRow)
	
	local showEndRow = math.modf((self._containerEndY+self:getContentSize().height)/cellHeight)
	local showBeginIdx = showBeginRow*self._hCount+1
	local showEndIdx = (showEndRow+1)*self._hCount
	
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
	
	local rowIdx = showBeginRow+1
	local colIdx = 0
	
	-- 更新显示的cell
	for i=showBeginIdx, showEndIdx do
		
		cell = reuseCells[i]
		
		if not cell then
			if #refreshCells<1 then
				printf("vcellbox _validateItemVisible not enough cell!")
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
		
		--printf("%d %d", cell:getPositionX(), cell:getPositionY())
		
		colIdx = colIdx+1
		if colIdx>=self._hCount then
			colIdx = 0
			rowIdx = rowIdx+1
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
-- @function [parent=#VCellBox] scrollToIndex
-- @param self
-- @param #number index 索引
-- @param #boolean anim 是否动画方式滚动
-- 
function VCellBox:scrollToIndex( index, anim )
	if not self._sameSizeCell then
		VCellBox.super.scrollToIndex(self, index, anim)
		return
	end
	
	if not self._cellWidth or not self._cellHeight then return end
	if not self._dataSet or index<1 or index>self._dataSet:getLength() then return end
	
	local math = require("math")
	local row = math.floor((index-1)/self._hCount)
	local col = (index-1)%self._hCount
	local x = (self._cellWidth+self._hSpace)*col
	local y = (self._cellHeight+self._vSpace)*row
	
	self:scrollToPos(x, y, anim)
end