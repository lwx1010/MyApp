---
-- 相同子项的翻页盒子容器
-- @module ui.PageCellBox
-- 

local class = class
local printf = printf
local require = require
local ipairs = ipairs
local CCSize = CCSize
local CCRect = CCRect
local pairs = pairs


local moduleName = "ui.PageCellBox"
module(moduleName)


--- 
-- 类定义
-- @type VBox
-- 

---
-- PageCellBox
-- @field [parent=#ui.PageCellBox] #PageCellBox PageCellBox
-- 
PageCellBox = class(moduleName, require("ui.CellBox").CellBox)

--- 
-- 创建实例
-- @function [parent=#ui.PageCellBox] new
-- @return #PageCellBox
-- 
function new()
	return PageCellBox.new()
end

--- 
-- 构造函数
-- @function [parent=#PageCellBox] ctor
-- @param self
-- 
function PageCellBox:ctor()
	PageCellBox.super.ctor(self)
	
	local Directions = require("ui.const.Directions")
	self._scrollDir = Directions.HORIZONTAL
	
	self._hCount = 1
	self._vCount = 1
end

---
-- 计算滚动范围
-- @function [parent=#PageCellBox] _calcScrollSize
-- @param self
-- @return #number, #number 宽，高
-- 
function PageCellBox:_calcScrollSize( )
	local bound = self:_calcItemBound()
	local size = self:getContentSize()
	
	--printf("size %d %d", size.width, size.height)
	--printf("bound %d %d", bound.size.width, bound.size.height)
	
	-- 将bound调整为contentSize的倍数
	local math = require("math")
	if( size.width>0 ) then
		bound.size.width = math.ceil(bound.size.width/size.width)*size.width
	end
	if( size.height>0 ) then
		bound.size.height = math.ceil(bound.size.height/size.height)*size.height
	end
	
	local w, h
	if( size.width<=0 or size.width>bound.size.width ) then
	 	w = 0
	else
		w = size.width-bound.size.width
	end
	
	if( size.height<=0 or size.height>bound.size.height ) then
	 	h = 0
	else
		h = -(size.height-bound.size.height)
	end
	
	--printf("scroll size %d %d", w, h)
	
	return w, h
end

---
-- 计算子项范围
-- @function [parent=#PageCellBox] _calcItemBound
-- @param self
-- @return #CCRect
-- 
function PageCellBox:_calcItemBound( )
	if not self._sameSizeCell then
		PageCellBox.super._calcItemBound(self)
		return
	end
	
	if not self._dataSet or self._dataSet:getLength()<=0 or #self._itemArr<=0 then
		return CCRect()
	end
	
	if not self._sameSizeCell or not self._cellWidth or not self._cellHeight then
		return PageCellBox.super._calcItemBound(self)
	end
	
	-- 相同大小
	local math = require("math")
	
	local numData = self._dataSet:getLength()
	local pageCnt = self._hCount*self._vCount
	local numPage = math.floor(numData/pageCnt)
	
	local numCol, numRow
	local Directions = require("ui.const.Directions")
	if self._scrollDir~=Directions.VERTICAL then
		numCol = numPage*self._hCount+(numData%pageCnt>self._hCount and self._hCount or numData%pageCnt)
		numRow = numPage>0 and self._vCount or math.ceil(numData/self._hCount)
	else
		numRow = math.ceil(numData/self._hCount)
		numCol = numData>self._hCount and self._hCount or numData
	end
	
	--printf("%d %d", numRow, numCol)
	
	local cellWidth = self._cellWidth+self._hSpace
	local cellHeight = self._cellHeight+self._vSpace
	
	return CCRect(0, 0, numCol*cellWidth, numRow*cellHeight)
end

---
-- 计算显示的子项数目
-- @function [parent=#PageCellBox] _calcShowItemCnt
-- @param self
-- 
function PageCellBox:_calcShowItemCnt()
	if not self._sameSizeCell then
		PageCellBox.super._calcShowItemCnt(self)
		return
	end
	
	if not self._cellWidth or not self._cellHeight then return 0 end
	
	local Directions = require("ui.const.Directions")
	if self._scrollDir~=Directions.VERTICAL then
		return (self._hCount+1)*self._vCount
	else
		return (self._vCount+1)*self._hCount
	end
end

---
-- 校验子项可视性
-- @function [parent=#PageCellBox] _validateItemVisible
-- @param self
-- 
function PageCellBox:_validateItemVisible( )
	if not self._sameSizeCell then
		PageCellBox.super._validateItemVisible(self)
		return
	end
	
	if not self._dataSet or #self._itemArr<=0 or not self._cellWidth or not self._cellHeight then return end
	
	local selfSize = self:getContentSize()
	local cellWidth = self._cellWidth+self._hSpace
	local cellHeight = self._cellHeight+self._vSpace
	
	local math = require("math")
	local beginCol = math.modf(-self._containerEndX/cellWidth)
	local endCol = math.modf((-self._containerEndX+selfSize.width)/cellWidth)
	local beginRow = math.modf(self._containerEndY/cellHeight)
	local endRow = math.modf((self._containerEndY+selfSize.height)/cellHeight)
	local pageCnt = self._hCount*self._vCount
	
	local Directions = require("ui.const.Directions")
	local isHor = self._scrollDir~=Directions.VERTICAL
	if isHor then
		endRow = math.min(self._vCount-1, endRow)
	else
		endCol = math.min(self._hCount-1, endCol)
	end
	beginRow = math.max(0, beginRow)
	beginCol = math.max(0, beginCol)
	
	--printf("%d %d %d %d %d %d", beginCol, endCol, beginRow, endRow, self._hCount, self._vCount)
	
	-- 收集重用的，要刷新的项
	local reuseCells, refreshCells = {}, {}
	local cell, col, row, pageIdx, inIdx
	for i=1, #self._itemArr do
		cell = self._itemArr[i]
		
		if cell.dataIdx then
			pageIdx = math.floor((cell.dataIdx-1)/pageCnt)
			inIdx = (cell.dataIdx-1)%pageCnt
			col = inIdx%self._hCount
			row = math.floor(inIdx/self._hCount)
			
			if isHor then
				col = col+pageIdx*self._hCount
			else
				row = row+pageIdx*self._vCount
			end
			
			if col>=beginCol and col<=endCol and row>=beginRow and row<=endRow then
				reuseCells[cell.dataIdx] = cell
			else
				refreshCells[#refreshCells+1] = cell
			end
		else
			refreshCells[#refreshCells+1] = cell
		end
	end
	
	local dataArr = self._dataSet:getArray()
	local dataCnt = #dataArr
	
	local adjustY = selfSize.height-cellHeight
	
	-- 更新显示的cell
	local inCol, inRow, dataIdx
	for r=beginRow, endRow do
		for c=beginCol, endCol do
			if isHor then
				pageIdx = math.floor(c/self._hCount)
			else
				pageIdx = math.floor(r/self._vCount)
			end
			
			inCol = c%self._hCount
			inRow = r%self._vCount
			dataIdx = pageIdx*pageCnt+inRow*self._hCount+inCol+1
			
			--printf("%d %d %d", inCol, inRow, dataIdx)
			
			if dataIdx>dataCnt then
				break
			end
			
			cell = reuseCells[dataIdx]
	
			if not cell then
				if #refreshCells<1 then
					printf("pagecellbox _validateItemVisible not enough cell!")
					break
				end
		
				cell = refreshCells[#refreshCells]
				refreshCells[#refreshCells] = nil
				
				cell.dataIdx = dataIdx
				
				-- 显示内容
				if cell.showItem then
					cell:showItem(dataArr[dataIdx])
				end
			else
				reuseCells[dataIdx] = nil
			end
			
			-- 设置可视性
			cell:setVisible(true)
			
			-- 选择
			if cell.setSelect then
				cell:setSelect(self:isSelected(dataIdx))
			end
			
			-- 位置
			cell:setPosition(c*cellWidth, adjustY-r*cellHeight)
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
	
	-- 显示起始变更
	if isHor then
		pageIdx = math.floor(beginCol/self._hCount)
	else
		pageIdx = math.floor(beginRow/self._vCount)
	end
	
	inCol = beginCol%self._hCount
	inRow = beginRow%self._vCount
	local showBeginIdx = pageIdx*pageCnt+inRow*self._hCount+inCol+1
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
-- 布局生效
-- @function [parent=#PageCellBox] _validateLayout
-- @param self
-- 
function PageCellBox:_validateLayout()
	-- 自动设置contentsize
	if self._sameSizeCell then
		if self._hCount and self._vCount and self._cellWidth and self._cellHeight then
			local pageWidth = (self._cellWidth+self._hSpace)*self._hCount
			local pageHeight = (self._cellHeight+self._vSpace)*self._vCount
			self:setContentSize(CCSize(pageWidth, pageHeight))
		end
	else
		if #self._itemArr>0 and self._hCount and self._vCount then
			local cellSize = self._itemArr[1]:getContentSize()
			local pageWidth = (cellSize.width+self._hSpace)*self._hCount
			local pageHeight = (cellSize.height+self._vSpace)*self._vCount
			self:setContentSize(CCSize(pageWidth, pageHeight))
		end
	end
		
	PageCellBox.super._validateLayout(self)
end

---
-- 计算自动对齐
-- @function [parent=#PageCellBox] _calcAutoSnap
-- @param self
-- 
function PageCellBox:_calcAutoSnap( )
	local cellWidth, cellHeight
	
	if self._sameSizeCell then
		if not self._cellWidth or not self._cellHeight then return end
		
		cellWidth = self._cellWidth
		cellHeight = self._cellHeight
	else
		if not self._itemArr[1] then return end
		
		local cellSize = self._itemArr[1]:getContentSize()
		cellWidth = cellSize.width
		cellHeight = cellSize.height
	end
	
	local Directions = require("ui.const.Directions")
	if self._scrollDir==Directions.HORIZONTAL then
		self:setSnapWidth((cellWidth+self._hSpace)*self._hCount)
		self:setSnapHeight(0)
	elseif self._scrollDir==Directions.VERTICAL then
		self:setSnapWidth(0)
		self:setSnapHeight((cellHeight+self._vSpace)*self._vCount)
	end
end

---
-- 取页数
-- @function [parent=#PageCellBox] getNumPage
-- @param self
-- @return #number 页数
-- 
function PageCellBox:getNumPage( )
	if not self._dataSet then return 0 end
	
	local math = require("math")
	local pageSize = self._hCount*self._vCount
	return math.ceil(self._dataSet:getLength()/pageSize)
end

---
-- 取当前页数
-- @function [parent=#PageCellBox] getCurPage
-- @param self
-- @return #number 当前页数
-- 
function PageCellBox:getCurPage( )
	if #self._itemArr<=0 then return 0 end
	if self._sameSizeCell and (not self._cellWidth or not self._cellHeight) then return 0 end
	
	local cellWidth, cellHeight
	if self._sameSizeCell then
		cellWidth = self._cellWidth
		cellHeight = self._cellHeight
	else
		local cellSize = self._itemArr[1]:getContentSize()
		cellWidth = cellSize.width
		cellHeight = cellSize.height
	end
	
	local page = 0
	local math = require("math")
	local Directions = require("ui.const.Directions")
	if self._scrollDir==Directions.HORIZONTAL then
		page = math.modf(-self._containerEndX/((cellWidth+self._hSpace)*self._hCount))+1
	elseif self._scrollDir==Directions.VERTICAL then
		page = math.modf(self._containerEndY/((cellHeight+self._vSpace)*self._vCount))+1
	end
	
	return page
end

---
-- 滚动到特定页
-- @function [parent=#PageCellBox] scrollToPage
-- @param self
-- @param #number page 页数
-- @param #boolean anim 是否动画方式滚动
-- 
function PageCellBox:scrollToPage( page, anim )
	if page<=0 or page>self:getNumPage() then return end
	
	if #self._itemArr<=0 then return 0 end
	if self._sameSizeCell and (not self._cellWidth or not self._cellHeight) then return 0 end
	
	local cellWidth, cellHeight
	if self._sameSizeCell then
		cellWidth = self._cellWidth
		cellHeight = self._cellHeight
	else
		local cellSize = self._itemArr[1]:getContentSize()
		cellWidth = cellSize.width
		cellHeight = cellSize.height
	end
	
	local x, y = 0, 0

	local math = require("math")
	local Directions = require("ui.const.Directions")
	if self._scrollDir==Directions.HORIZONTAL then
		x = (cellWidth+self._hSpace)*self._hCount*(page-1)
	elseif self._scrollDir==Directions.VERTICAL then
		y = (cellHeight+self._vSpace)*self._vCount*(page-1)
	end
	
	self:scrollToPos(x, y, anim)
end

---
-- 滚动到子项
-- @function [parent=#PageCellBox] scrollToItem
-- @param self
-- @param #table item 子项
-- @param #boolean anim 是否动画方式滚动 
-- 
function PageCellBox:scrollToItem( item, anim )
	if( not item or item:getParent()~=self._itemContainer ) then return end
	
	local Directions = require("ui.const.Directions")
	if self._scrollDir==Directions.ANY then
		PageCellBox.super.scrollToItem(self, item, anim)
		return
	end
	
	self:scrollToPage(self:getItemPage(item), anim)
end

---
-- 滚动子项的页数
-- @function [parent=#PageCellBox] getItemPage
-- @param self
-- @param #table item 子项
-- @return #number 页数
-- 
function PageCellBox:getItemPage( item )
	if( not item or item:getParent()~=self._itemContainer ) then return 0 end
	
	local cellSize = item:getContentSize()
	local page = 0
	
	local math = require("math")
	local Directions = require("ui.const.Directions")
	if self._scrollDir==Directions.HORIZONTAL then
		page = math.modf(item:getPositionX()/((cellSize.width+self._hSpace)*self._hCount))+1
	elseif self._scrollDir==Directions.VERTICAL then
		page = math.modf(item:getPositionY()/((cellSize.height+self._vSpace)*self._vCount))+1
	end
	
	return page
end

---
-- 滚动到特定索引
-- @function [parent=#PageCellBox] scrollToIndex
-- @param self
-- @param #number index 索引
-- @param #boolean anim 是否动画方式滚动
-- 
function PageCellBox:scrollToIndex( index, anim )
	if not self._sameSizeCell then
		PageCellBox.super.scrollToIndex(self, index, anim)
		return
	end
	
	if not self._cellWidth or not self._cellHeight then return end
	if not self._dataSet or index<1 or index>self._dataSet:getLength() then return end
	
	local math = require("math")
	
	local pageCnt = self._hCount*self._vCount
	
	local pageIdx = math.floor((index-1)/pageCnt)
	local inIdx = (index-1)%pageCnt
	local col = inIdx%self._hCount
	local row = math.floor(inIdx/self._hCount)
	
	local Directions = require("ui.const.Directions")
	if self._scrollDir~=Directions.VERTICAL then
		col = col+pageIdx*self._hCount
	else
		row = row+pageIdx*self._vCount
	end
			
	local x = (self._cellWidth+self._hSpace)*col
	local y = (self._cellHeight+self._vSpace)*row
	
	self:scrollToPos(x, y, anim)
end

---
-- 更新滚动条范围
-- @function [parent=#PageCellBox] _updateBarRange
-- 
function PageCellBox:_updateBarRange()
	if not self._dataSet then return end
	
	if self._vBar then
		self._vBar:setValueRange(1, self:getNumPage())
	end
	
	if self._hBar then
		self._hBar:setValueRange(1, self:getNumPage())
	end
end

---
-- 更新滚动条值
-- @function [parent=#PageCellBox] _updateBarValue
-- @param #number x 水平方向值
-- @param #number y 垂直方向值
-- 
function PageCellBox:_updateBarValue(x, y)
	
	if self._vBar then
		self._vBar:setValue(self:getCurPage(), false)
	end
	
	if self._hBar then
		self._hBar:setValue(self:getCurPage(), false)
	end
end

---
-- 滚动条改变
-- @function [parent=#PageCellBox] _onBarChanged
-- @param self
-- @param ui.ScrollBar#SCROLL_CHANGED event 事件
-- 
function PageCellBox:_onBarChanged( event )
	if event.target==self._vBar then
		self:scrollToPage(event.value, false)
	elseif event.target==self._hBar then
		self:scrollToPage(event.value, false)
	end
end