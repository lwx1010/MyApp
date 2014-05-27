--- 
-- 盒子容器
-- @module ui.Box
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local ccp = ccp
local ipairs = ipairs
local math = math

local moduleName = "ui.Box"
module(moduleName)

---
-- 顶部对齐
-- @field [parent=#ui.Box] #string ALIGN_TOP
-- 
ALIGN_TOP = "ALIGN_TOP"

---
-- 居中对齐
-- @field [parent=#ui.Box] #string ALIGN_CENTER
-- 
ALIGN_CENTER = "ALIGN_CENTER"

---
-- 底部对齐
-- @field [parent=#ui.Box] #string ALIGN_BOTTOM
-- 
ALIGN_BOTTOM = "ALIGN_BOTTOM"

---
-- 向左对齐
-- @field [parent=#ui.Box] #string ALIGN_LEFT
-- 
ALIGN_LEFT = "ALIGN_LEFT"

---
-- 向右对齐
-- @field [parent=#ui.Box] #string ALIGN_RIGHT
-- 
ALIGN_RIGHT = "ALIGN_RIGHT"

--- 
-- 类定义
-- @type Box
-- 

---
-- Box类
-- @field [parent=#ui.Box] #Box Box
-- 
Box = class(moduleName, require("ui.ScrollView").ScrollView)

---
-- 水平间隔
-- @field [parent=#Box] #number _hSpace
-- 
Box._hSpace = 0

---
-- 垂直间隔
-- @field [parent=#Box] #number _vSpace
-- 
Box._vSpace = 0

---
-- 水平数量
-- @field [parent=#Box] #number _hCount
-- 
Box._hCount = nil

---
-- 垂直数量
-- @field [parent=#Box] #number _vCount
-- 
Box._vCount = nil

---
-- 水平对齐方式
-- @field [parent=#Box] #string _hAlign
-- 
Box._hAlign = ALIGN_LEFT

---
-- 垂直对齐方式
-- @field [parent=#Box] #string _vAlign
-- 
Box._vAlign = ALIGN_TOP

--- 
-- 创建实例
-- @function [parent=#ui.Box] new
-- @return #Box
-- 
function new()
	return Box.new()
end

--- 
-- 构造函数
-- @function [parent=#Box] ctor
-- @param self
-- 
function Box:ctor()
	Box.super.ctor(self)
end

---
-- 设置水平间隔
-- @function [parent=#Box] setHSpace
-- @param self
-- @param #number s 间隔
-- 
function Box:setHSpace( s )
	if( self._hSpace==s ) then return end
	
	self._hSpace = s
	
	self:invalidLayout()
end

---
-- 获取水平间隔
-- @function [parent=#Box] getHSpace
-- @param self
-- @return #number
-- 
function Box:getHSpace()
	return self._hSpace
end

---
-- 设置垂直间隔
-- @function [parent=#Box] setVSpace
-- @param self
-- @param #number s 间隔
-- 
function Box:setVSpace( s )
	if( self._vSpace==s ) then return end
	
	self._vSpace = s
	
	self:invalidLayout()
end

---
-- 获取垂直间隔
-- @function [parent=#Box] getVSpace
-- @param self
-- @return #number
-- 
function Box:getVSpace()
	return self._vSpace
end

---
-- 设置水平数量
-- @function [parent=#Box] setHCount
-- @param self
-- @param #number c 数量
-- 
function Box:setHCount( c )
	if( self._hCount==c ) then return end
	
	self._hCount = c
	
	self:invalidLayout()
end

---
-- 取水平数量
-- @function [parent=#Box] getHCount
-- @param self
-- @return #number
-- 
function Box:getHCount()
	return self._hCount
end

---
-- 设置垂直数量
-- @function [parent=#Box] setVCount
-- @param self
-- @param #number c 数量
-- 
function Box:setVCount( c )
	if( self._vCount==c ) then return end
	
	self._vCount = c
	
	self:invalidLayout()
end

---
-- 取垂直数量
-- @function [parent=#Box] getVCount
-- @param self
-- @return #number
-- 
function Box:getVCount()
	return self._vCount
end

--- 
-- 设置水平对齐方式
-- @function [parent=#Box] setHAlign
-- @param self
-- @param #string a 对齐方式
-- 
function Box:setHAlign( a )
	if( self._hAlign==a ) then return end
	
	self._hAlign = a
	
	self:invalidLayout()
end

---
-- 取水平对齐方式
-- @function [parent=#Box] getHAlign
-- @param self
-- @return #string
-- 
function Box:getHAlign()
	return self._hAlign
end

--- 
-- 设置垂直对齐方式
-- @function [parent=#Box] setVAlign
-- @param self
-- @param #string a 对齐方式
-- 
function Box:setVAlign( a )
	if( self._vAlign==a ) then return end
	
	self._vAlign = a
	
	self:invalidLayout()
end

---
-- 取垂直对齐方式
-- @function [parent=#Box] getVAlign
-- @param self
-- @return #string
-- 
function Box:getVAlign()
	return self._vAlign
end

---
-- 布局生效
-- @function [parent=#Box] _validateLayout
-- @param self
-- 
function Box:_validateLayout()
	self:_gridLayout()
	
	Box.super._validateLayout(self)
end

---
-- 格子布局
-- @function [parent=#Box] _gridLayout
-- @param self
-- 
function Box:_gridLayout()
	local Directions = require("ui.const.Directions")
	
	local math = require("math")
	local hCnt = self._hCount or math.huge
	local vCnt = self._vCount or math.huge 
	
	local selfSize = self:getContentSize()
	local needAdjustX, needAdjustY = selfSize.width<=0, selfSize.height<=0
	local totalWidth, totalHeight = 0, 0
	local xPoses, yPoses = {}, {}
	local pageX, pageY = 0, 0
	local beginIdx, endIdx = 1, #self._itemArr
	local pageEndIdx, maxChildWidths, maxChildHeights
	while beginIdx<=endIdx do
		-- 计算一页的最大宽高
		pageEndIdx, maxChildWidths, maxChildHeights = self:_calcMaxChildSizes(beginIdx)
		
		--printf("page  "..pageX.." "..pageY)
		
		-- 计算页内孩子布局
		local xBegin, yBegin = pageX, pageY
		local h, v = 1, 1
		local curMaxWidth, curMaxHeight = maxChildWidths[1], maxChildHeights[1]
		local x, y
		local child
		local childSize
		for i=beginIdx, pageEndIdx do
			child = self._itemArr[i]
			childSize = child:getContentSize()
			
			-- 水平对齐
			if self._hAlign==ALIGN_LEFT  then
				x = xBegin
			elseif self._hAlign==ALIGN_CENTER then
				x = xBegin+(curMaxWidth-childSize.width)*0.5
			else
				x = xBegin+(curMaxWidth-childSize.width)
			end
			
			-- 垂直对齐
			if self._vAlign==ALIGN_TOP  then
				y = yBegin-childSize.height
			elseif self._vAlign==ALIGN_CENTER then
				y = yBegin-childSize.height-(curMaxHeight-childSize.height)*0.5
			else
				y = yBegin-curMaxHeight
			end
			
			--printf("child  "..childSize.width.." "..childSize.height)
			--printf(x.." "..y)
			
			-- 设置位置
			--child:setPosition(x, -y)
			xPoses[#xPoses+1] = x
			yPoses[#yPoses+1] = y
			
			-- 计算下个位置
			h = h+1
			xBegin = xBegin+self._hSpace+curMaxWidth
			
			if( h>hCnt ) then
				h = 1
				v = v+1
				
				xBegin = pageX
				yBegin = yBegin-self._vSpace-curMaxHeight
				curMaxHeight = v>#maxChildHeights and maxChildHeights[1] or maxChildHeights[v]
			end
			
			curMaxWidth = h>#maxChildWidths and maxChildWidths[1] or maxChildWidths[h]
			
			--printf("max  "..curMaxWidth.." "..curMaxHeight)
		end
		
		-- 计算页宽，页高
		local pageWidth, pageHeight = 0, 0
		if needAdjustX or self._scrollDir~=Directions.VERTICAL then
			if self._hCount and #maxChildWidths<self._hCount then
				pageWidth = (maxChildWidths[1]+self._hSpace)*self._hCount
			else
				for i=1, #maxChildWidths do
					pageWidth = pageWidth+maxChildWidths[i]+self._hSpace
				end
			end
		end
		
		if needAdjustY or self._scrollDir==Directions.VERTICAL then
			if self._vCount and #maxChildHeights<self._vCount then
				pageHeight = (maxChildHeights[1]+self._vSpace)*self._vCount
			else
				for i=1, #maxChildHeights do
					pageHeight = pageHeight+maxChildHeights[i]+self._vSpace
				end
			end
		end
		
		-- 计算页起始位置
		if self._scrollDir==Directions.VERTICAL then
			pageX = 0
			pageY = pageY-pageHeight
			
			-- 计算总宽高
			totalHeight = totalHeight+pageHeight
			
			if( pageWidth>totalWidth ) then
				totalWidth = pageWidth
			end
		else
			pageX = pageX+pageWidth
			pageY = 0
			
			-- 计算总宽高
			totalWidth = totalWidth+pageWidth
			
			if( pageHeight>totalHeight ) then
				totalHeight = pageHeight
			end
		end
		
		beginIdx = pageEndIdx+1
	end
	
	-- 纠正XY坐标，设置位置
	local adjustX = needAdjustX and -totalWidth*0.5 or 0
	local adjustY = needAdjustY and totalHeight*0.5 or selfSize.height
	--printf("adjust "..totalHeight.." "..adjustHeight)
	for i=1, #self._itemArr do
		--printf(xPoses[i].." "..(adjustHeight+yPoses[i]))
		self._itemArr[i]:setPosition(adjustX+xPoses[i], adjustY+yPoses[i])
		self._itemArr[i]:setVisible(true)
	end
end

---
-- 计算一页孩子的水平和垂直方向最大宽高
-- @function [parent=#Box] _calcMaxChildSizes
-- @param self
-- @param #number beginIdx 开始索引
-- @return #number, #table, #table 结束索引，水平方向的最大宽，垂直方向的最大高
-- 
function Box:_calcMaxChildSizes( beginIdx )
	local math = require("math")
	local hCnt = self._hCount or math.huge
	local vCnt = self._vCount or math.huge 
	
	local endIdx = #self._itemArr
	local h, v = 1, 1
	local maxChildHeights = {}
	local maxChildWidths = {}
	local childSize
	for i=beginIdx, #self._itemArr do
		childSize = self._itemArr[i]:getContentSize()

		-- 记录最大的孩子高度
		if( v>#maxChildHeights or childSize.height>maxChildHeights[v] ) then
			maxChildHeights[v] = childSize.height
		end
		
		-- 记录最大的孩子宽度
		if( h>#maxChildWidths or childSize.width>maxChildWidths[h] ) then
			maxChildWidths[h] = childSize.width
		end
		
		-- 计算下个位置
		h = h+1
		if( h>hCnt ) then
			h = 1
			v = v+1
			
			if( v>vCnt ) then
				endIdx = i
				break
			end
		end
	end
	
	return endIdx, maxChildWidths, maxChildHeights
end