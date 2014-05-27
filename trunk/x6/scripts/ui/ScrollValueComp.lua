--- 
-- 滚动数值组件.
-- 添加了将数值映射到滚动范围的功能
-- @module ui.ScrollValueComp
-- 

local class = class
local printf = printf
local require = require
local CCLayer = CCLayer
local ccp = ccp
local CCSize = CCSize
local toint = toint


local moduleName = "ui.ScrollValueComp"
module(moduleName)

---
-- @type VALUE_CHANGED
-- @field #string name VALUE_CHANGED
-- @field #number curX	X方向当前值
-- @field #number curY	Y方向当前值
-- 

--- 
-- 值改变
-- @field [parent=#ui.ScrollValueComp] #VALUE_CHANGED VALUE_CHANGED
-- 
VALUE_CHANGED = {name="VALUE_CHANGED"}


--- 
-- 类定义
-- @type ScrollValueComp
-- 

---
-- ScrollValueComp
-- @field [parent=#ui.ScrollValueComp] #ScrollValueComp ScrollValueComp
-- 
ScrollValueComp = class(moduleName, require("ui.ScrollComponent").ScrollComponent)

---
-- x最大值
-- @field [parent=#ScrollValueComp] #number _maxX
-- 
ScrollValueComp._maxX = 0

---
-- x最小值
-- @field [parent=#ScrollValueComp] #number _minX
-- 
ScrollValueComp._minX = 0

---
-- y最大值
-- @field [parent=#ScrollValueComp] #number _maxY
-- 
ScrollValueComp._maxY = 0

---
-- y最小值
-- @field [parent=#ScrollValueComp] #number _minY
-- 
ScrollValueComp._minY = 0

---
-- x当前值
-- @field [parent=#ScrollValueComp] #number _curX
-- 
ScrollValueComp._curX = 0

---
-- y当前值
-- @field [parent=#ScrollValueComp] #number _curY
-- 
ScrollValueComp._curY = 0

--- 
-- 创建实例
-- @function [parent=#ui.ScrollValueComp] new
-- @return #ScrollValueComp
-- 
function new()
	return ScrollValueComp.new()
end

--- 
-- 构造函数
-- @function [parent=#ScrollValueComp] ctor
-- @param self
-- 
function ScrollValueComp:ctor()
	--ScrollValueComp.super.ctor(self)
end

---
-- 设置X方向值范围
-- @function [parent=#ScrollValueComp] setXRange
-- @param self
-- @param #number min 最小值
-- @param #number max 最大值
--
function ScrollValueComp:setXRange( min, max )
	if( self._maxX==max and self._minX==min ) then return end
	
	self._minX = min
	self._maxX = max
	
	local newX = self._curX
	if( newX<self._minX ) then newX = self._minX 
	elseif( newX>self._maxX ) then newX = self._maxX end
	
	self:setXValue(newX)
end

---
-- 取X方向值范围
-- @function [parent=#ScrollValueComp] getXRange
-- @param self
-- @return #number,#number 
--
function ScrollValueComp:getXRange( )
	return self._minX, self._maxX
end

---
-- 设置Y方向值范围
-- @function [parent=#ScrollValueComp] setYRange
-- @param self
-- @param #number min 最小值
-- @param #number max 最大值
--
function ScrollValueComp:setYRange( min, max )
	if( self._maxY==max and self._minY==min ) then return end
	
	self._minY = min
	self._maxY = max
	
	local newY = self._curY
	if( newY<self._minY ) then newY = self._minY 
	elseif( newY>self._maxY ) then newY = self._maxY end
	
	self:setYValue(newY)
end

---
-- 取Y方向值范围
-- @function [parent=#ScrollValueComp] getYRange
-- @param self
-- @return #number,#number 
--
function ScrollValueComp:getYRange( )
	return self._minY, self._maxY
end

---
-- 设置X方向值
-- @function [parent=#ScrollValueComp] setXValue
-- @param self
-- @param #number val 值
--
function ScrollValueComp:setXValue( val )
	if( self._curX==val ) then return end
	if( val<self._minX or val>self._maxX ) then return end
	
	self._curX = val
	
	if( self._minX==self._maxX ) then
		self._curPosX = 0
	else
		self._curPosX = toint(self._scrollWidth*(self._curX-self._minX)/(self._maxX-self._minX))
	end
end

---
-- 取X方向值
-- @function [parent=#ScrollValueComp] getXValue
-- @param self
-- @return #number 
--
function ScrollValueComp:getXValue( )
	return self._curX
end

---
-- 设置Y方向值
-- @function [parent=#ScrollValueComp] setYValue
-- @param self
-- @param #number val 值
--
function ScrollValueComp:setYValue( val )
	if( self._curY==val ) then return end
	if( val<self._minY or val>self._maxY ) then return end
	
	self._curY = val
	
	if( self._minY==self._maxY ) then
		self._curPosY = 0
	else
		self._curPosY = toint(self._scrollHeight*(self._curY-self._minY)/(self._maxY-self._minY))
	end
end

---
-- 取Y方向值
-- @function [parent=#ScrollValueComp] getYValue
-- @param self
-- @return #number 
--
function ScrollValueComp:getYValue( )
	return self._curY
end

---
-- 设置当前X方向位置.
-- 如果传入反弹范围，则位置可能超出上下限
-- @function [parent=#ScrollComponent] setCurPosX
-- @param self
-- @param #number curX 当前值
-- @param #number bouncRange 反弹范围，默认为0
--
function ScrollValueComp:setCurPosX( curX, bouncRange )
	local old = self._curPosX
	ScrollValueComp.super.setCurPosX(self, curX)
	
	if( self._curPosX==old ) then return end
	
	if( self._scrollWidth==0 ) then
		self._curX = self._minX
	else
		local percent = self._curPosX/self._scrollWidth
		
		-- 由于反弹，可能超出1
		if( percent>1 ) then percent = 1 end
		
		self._curX = self._minX+toint((self._maxX-self._minX)*percent)
	end
end

---
-- 设置当前Y方向位置
-- 如果传入反弹范围，则位置可能超出上下限
-- @function [parent=#ScrollComponent] setCurPosY
-- @param self
-- @param #number curY 当前值
-- @param #number bouncRange 反弹范围，默认为0
--
function ScrollValueComp:setCurPosY( curY, bouncRange )
	local old = self._curPosX 
	
	ScrollValueComp.super.setCurPosY(self, curY)
	
	if( self._curPosY==old ) then return end
	
	if( self._scrollHeight==0 ) then
		self._curY = self._minY
	else
		local percent = self._curPosY/self._scrollHeight
		
		-- 由于反弹，可能超出1
		if( percent>1 ) then percent = 1 end
		
		self._curY = self._minY+toint((self._maxY-self._minY)*percent)
	end
end

---
-- 触摸移动
-- @function [parent=#ScrollValueComp] _onTouchMoved
-- @param self
-- @param #number x
-- @param #number y
-- 
function ScrollValueComp:_onTouchMoved(x, y)
	local oldX, oldY = self._curX, self._curY
	
	ScrollValueComp.super._onTouchMoved(self, x, y)
	
	-- 派发事件
	local newX, newY = self._curX, self._curY
	if( oldX~=newX or oldY~=newY ) then
		VALUE_CHANGED.curX = newX
		VALUE_CHANGED.curY = newY
		self:dispatchEvent(VALUE_CHANGED)
	end
end