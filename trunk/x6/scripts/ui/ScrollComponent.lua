--- 
-- 滚动组件.
-- 支持x,y两个方向的滚动，只需要设置正负的滚动范围即可
-- 支持滚动阀值，超过该阀值，才开始滚动
-- 支持滚动自动对齐，设置对齐宽高，对齐阀值即可
-- 支持边界反弹，最大反弹宽度为 反弹因子*对齐宽高
-- 滚动值的改变由SCROLL_CHANGED事件派发
-- @module ui.ScrollComponent
-- 

local class = class
local printf = printf
local require = require
local CCLayer = CCLayer
local ccp = ccp
local CCSize = CCSize
local toint = toint


local moduleName = "ui.ScrollComponent"
module(moduleName)

---
-- @type SCROLL_CHANGED
-- @field #string name SCROLL_CHANGED
-- @field #number curX	X方向当前位置
-- @field #number curY	Y方向当前位置
-- @field #boolean autoSnap 是否自动对齐
-- 

--- 
-- 滚动改变
-- @field [parent=#ui.ScrollComponent] #SCROLL_CHANGED SCROLL_CHANGED
-- 
SCROLL_CHANGED = {name="SCROLL_CHANGED"}

---
-- @type TOUCHED
-- @field #string name TOUCHED
-- @field #string event 事件类型, began, moved, ended, canceled
-- @field #number x	触摸位置，世界坐标
-- @field #number y	触摸位置，世界坐标
-- 

--- 
-- 触摸事件
-- @field [parent=#ui.ScrollComponent] #TOUCHED TOUCHED
-- 
TOUCHED = {name="TOUCHED"}

--- 
-- 当前正在滚动的组件
-- @field [parent=#ui.ScrollComponent] #CCNode _gCurScrolling
-- 
local _gCurScrolling = nil

--- 
-- 类定义
-- @type ScrollComponent
-- 

---
-- ScrollComponent
-- @field [parent=#ui.ScrollComponent] #ScrollComponent ScrollComponent
-- 
ScrollComponent = class(moduleName, function()
	local display = require("framework.client.display")
	local EventProtocol = require("framework.client.api.EventProtocol")
	return EventProtocol.extend(display.newLayer())
end)

---
-- 反弹因子.
-- 与对齐宽度，高度相关
-- @field [parent=#ScrollComponent] #number _bouncFactor
-- 
ScrollComponent._bouncFactor = 0.8

---
-- 对齐宽度
-- @field [parent=#ScrollComponent] #number _snapWidth
-- 
ScrollComponent._snapWidth = 0

---
-- 对齐高度
-- @field [parent=#ScrollComponent] #number _snapHeight
-- 
ScrollComponent._snapHeight = 0

---
-- 滚动宽度为0时是否自动对齐
-- @field [parent=#ScrollComponent] #boolean _snapWhenNoScrollWidth
-- 
ScrollComponent._snapWhenNoScrollWidth = true

---
-- 滚动高度为0时是否自动对齐
-- @field [parent=#ScrollComponent] #boolean _snapWhenNoScrollHeight
-- 
ScrollComponent._snapWhenNoScrollHeight = true

---
-- 对齐阀值
-- 根据阀值，判断是前对齐还是后对齐
-- @field [parent=#ScrollComponent] #number _snapHeight
-- 
ScrollComponent._snapThreshold = 0.2

---
-- 滚动阀值
-- @field [parent=#ScrollComponent] #number _scrollThreshold
-- 
ScrollComponent._scrollThreshold = 10

---
-- 滚动高度
-- @field [parent=#ScrollComponent] #number _scrollHeight
-- 
ScrollComponent._scrollHeight = 0

---
-- 滚动宽度
-- @field [parent=#ScrollComponent] #number _scrollWidth
-- 
ScrollComponent._scrollWidth = 0

---
-- 滚动高度
-- @field [parent=#ScrollComponent] #number _scrollHeight
-- 
ScrollComponent._scrollHeight = 0

---
-- 最小滚动位置X
-- @field [parent=#ScrollComponent] #number _minPosX
-- 
ScrollComponent._minPosX = 0

---
-- 最大滚动位置X
-- @field [parent=#ScrollComponent] #number _maxPosX
-- 
ScrollComponent._maxPosX = 0

---
-- 最小滚动位置Y
-- @field [parent=#ScrollComponent] #number _minPosY
-- 
ScrollComponent._minPosY = 0

---
-- 最大滚动位置Y
-- @field [parent=#ScrollComponent] #number _maxPosY
-- 
ScrollComponent._maxPosY = 0

---
-- x方向当前滚动位置
-- @field [parent=#ScrollComponent] #number _curPosX
-- 
ScrollComponent._curPosX = 0

---
-- y方向当前滚动位置
-- @field [parent=#ScrollComponent] #number _curPosY
-- 
ScrollComponent._curPosY = 0

---
-- 是否启用
-- @field [parent=#ScrollComponent] #boolean _enable
--
ScrollComponent._enable = true

---
-- 触摸的起始位置X
-- @field [parent=#ScrollComponent] #number _touchBeginX
--
ScrollComponent._touchBeginX = nil

---
-- 触摸的起始位置Y
-- @field [parent=#ScrollComponent] #number _touchBeginY
--
ScrollComponent._touchBeginY = nil

---
-- 滚动的起始位置X
-- @field [parent=#ScrollComponent] #number _scrollBeginX
--
ScrollComponent._scrollBeginX = nil

---
-- 滚动的起始位置Y
-- @field [parent=#ScrollComponent] #number _scrollBeginY
--
ScrollComponent._scrollBeginY = nil

---
-- 是否在滚动
-- @field [parent=#ScrollComponent] #number _scrolling
--
ScrollComponent._scrolling = false

--- 
-- 创建实例
-- @function [parent=#ui.ScrollComponent] new
-- @return #ScrollComponent
-- 
function new()
	return ScrollComponent.new()
end

--- 
-- 构造函数
-- @function [parent=#ScrollComponent] ctor
-- @param self
-- 
function ScrollComponent:ctor()
	self:setVisible(false)
	self:_checkScrollable()
    self:addTouchEventListener(function(...) return self:_onTouch(...) end)
end

---
-- 是否在滚动
-- @function [parent=#ScrollComponent] isScrolling
-- @param self
-- @return #boolean
--
function ScrollComponent:isScrolling()
	return self._scrolling
end

---
-- 设置反弹因子.
-- 与对齐宽度，高度相关
-- @function [parent=#ScrollComponent] setBounceFactor
-- @param self
-- @param #number f 因子
--
function ScrollComponent:setBounceFactor( f )
	self._bounceFactor = f
end

---
-- 取反弹因子
-- @function [parent=#ScrollComponent] getBounceFactor
-- @param self
-- @return #number
--
function ScrollComponent:getBounceFactor()
	return self._bounceFactor
end

---
-- 设置对齐宽度
-- @function [parent=#ScrollComponent] setSnapWidth
-- @param self
-- @param #number w 宽度
--
function ScrollComponent:setSnapWidth( w )
	self._snapWidth = w
end

---
-- 取对齐宽度
-- @function [parent=#ScrollComponent] getSnapWidth
-- @param self
-- @return #number
--
function ScrollComponent:getSnapWidth()
	return self._snapWidth
end

---
-- 设置对齐高度
-- @function [parent=#ScrollComponent] setSnapHeight
-- @param self
-- @param #number h 高度
--
function ScrollComponent:setSnapHeight( h )
	self._snapHeight = h
end

---
-- 取对齐高度
-- @function [parent=#ScrollComponent] getSnapHeight
-- @param self
-- @return #number
--
function ScrollComponent:getSnapHeight()
	return self._snapHeight
end

---
-- 设置对齐阀值
-- 根据阀值判断是向前对齐还是向后对齐
-- @function [parent=#ScrollComponent] setSnapThreshold
-- @param self
-- @param #number t 阀值
--
function ScrollComponent:setSnapThreshold( t )
	self._snapThreshold = t
end

---
-- 取对齐阀值
-- @function [parent=#ScrollComponent] getSnapThreshold
-- @param self
-- @return #number
--
function ScrollComponent:getSnapThreshold()
	return self._snapThreshold
end

---
-- 开启滚动
-- @function [parent=#ScrollComponent] enable
-- @param self
-- @param #boolean e 是否开启
--
function ScrollComponent:enable( e )
	if( self._enable==e ) then return end
	
	self._enable = e
	self:_checkScrollable()
end

---
-- 是否开启滚动
-- @function [parent=#ScrollComponent] isEnabled
-- @param self
-- @return #boolean
--
function ScrollComponent:isEnabled()
	return self._enable
end

---
-- 设置滚动阀值
-- @function [parent=#ScrollComponent] setScrollThreshold
-- @param self
-- @param #number t 阀值
--
function ScrollComponent:setScrollThreshold( t )
	self._scrollThreshold = t
end

---
-- 取滚动阀值
-- @function [parent=#ScrollComponent] getScrollThreshold
-- @param self
-- @return #number
--
function ScrollComponent:getScrollThreshold()
	return self._scrollThreshold
end

---
-- 设置滚动范围
-- @function [parent=#ScrollComponent] setScrollSize
-- @param self
-- @param #number w 宽
-- @param #number h 高
--
function ScrollComponent:setScrollSize( w, h )
	if( self._scrollWidth==w and self._scrollHeight==h ) then return end

	if( w<0 ) then
		self._minPosX = w
		self._maxPosX = 0
	else
		self._minPosX = 0
		self._maxPosX = w
	end
	
	if( h<0 ) then
		self._minPosY = h
		self._maxPosY = 0
	else
		self._minPosY = 0
		self._maxPosY = h
	end

	self._scrollWidth = w
	self._scrollHeight = h
	
	-- 重设一下值
	self:setCurPosX(self._curPosX)
	self:setCurPosY(self._curPosY)
	
	self:_checkScrollable()
end

---
-- 获取滚动范围
-- @function [parent=#ScrollComponent] getScrollSize
-- @param self
-- @return #number, #number
--
function ScrollComponent:getScrollSize()
	return self._scrollWidth, self._scrollHeight
end

---
-- 获取当前X方向位置
-- @function [parent=#ScrollComponent] getCurPosX
-- @param self
-- @return #number
--
function ScrollComponent:getCurPosX()
	return self._curPosX
end

---
-- 设置当前X方向位置.
-- 如果传入反弹范围，则位置可能超出上下限
-- @function [parent=#ScrollComponent] setCurPosX
-- @param self
-- @param #number curX 当前值
-- @param #number bouncRange 反弹范围，默认为0
-- @return #number 返回当前X位置
--
function ScrollComponent:setCurPosX( curX, bouncRange )
	self._curPosX = curX
	
	local min = self._minPosX-(bouncRange or 0)
	local max = self._maxPosX+(bouncRange or 0)
	if( self._curPosX<min ) then self._curPosX=min
	elseif( self._curPosX>max ) then self._curPosX=max end
	
	return self._curPosX
end

---
-- 获取当前Y方向位置
-- @function [parent=#ScrollComponent] getCurPosY
-- @param self
-- @return #number
--
function ScrollComponent:getCurPosY()
	return self._curPosY
end

---
-- 设置当前Y方向位置
-- 如果传入反弹范围，则位置可能超出上下限
-- @function [parent=#ScrollComponent] setCurPosY
-- @param self
-- @param #number curY 当前值
-- @param #number bouncRange 反弹范围，默认为0
-- @return #number 返回当前Y位置
--
function ScrollComponent:setCurPosY( curY, bouncRange )
	self._curPosY = curY
	
	local min = self._minPosY-(bouncRange or 0)
	local max = self._maxPosY+(bouncRange or 0)
	if( self._curPosY<min ) then self._curPosY=min
	elseif( self._curPosY>max ) then self._curPosY=max end
	
	return self._curPosY
end

---
-- 检测是否可滚动
-- @function [parent=#ScrollComponent] _checkScrollable
-- @param self
-- 
function ScrollComponent:_checkScrollable()
	--local enable = (self._scrollWidth~=0 or self._scrollHeight~=0) and self._enable
	local enable = self._enable
		
	self:setTouchEnabled(enable)
end

---
-- 触摸事件处理
-- @function [parent=#ScrollComponent] _onTouch
-- @param self
-- @param #string event
-- @param #number x
-- @param #number y
-- @return #boolean
-- 
function ScrollComponent:_onTouch( event, x, y )
	local began = true
    if event == "began" then
        began = self:_onTouchBegan(x, y)
    elseif event == "moved" then
    	if _gCurScrolling and _gCurScrolling~=self then return end
    	
        self:_onTouchMoved(x, y)
    elseif event == "ended" then
        self:_onTouchEnded(x, y)
        _gCurScrolling = nil
    else -- cancelled
        self:_onTouchCancelled(x, y)
    end
    
    -- 触摸事件
    if( began and self:hasListener(TOUCHED.name) ) then
    	TOUCHED.event = event
    	TOUCHED.x = x
    	TOUCHED.y = y
    	self:dispatchEvent(TOUCHED)
    end
    
    return began
end

---
-- 退出场景
-- @function [parent=#ScrollComponent] onExit
-- @param self
-- 
function ScrollComponent:onExit()
	if self==_gCurScrolling then
		_gCurScrolling = nil
	end
end

---
-- 触摸开始
-- @function [parent=#ScrollComponent] _onTouchBegan
-- @param self
-- @param #number x
-- @param #number y
-- @return #boolean
-- 
function ScrollComponent:_onTouchBegan(x, y)
	if( not self:isParentsVisible() or self:isCliped() ) then
		return false
	end
	
	local size = self:getContentSize()
	local localPt = self:convertToNodeSpace(ccp(x, y))
    if( localPt.x<0 or localPt.y<0 or localPt.x>size.width or localPt.y>size.height ) then
    	return false
    end
    
    local os = require("os")
    
	self._touchBeginX = x
	self._touchBeginY = y
	self._scrollBeginX = self._curPosX
	self._scrollBeginY = self._curPosY
	self._startClock = os.clock()
	self._scrolling = false
	
    return true
end

---
-- 触摸移动
-- @function [parent=#ScrollComponent] _onTouchMoved
-- @param self
-- @param #number x
-- @param #number y
-- 
function ScrollComponent:_onTouchMoved(x, y)
	-- 判断是否可以开始滚动
	if( not self._scrolling ) then
		local math = require("math")
		if self._scrollWidth~=0 or (self._scrollWidth==0 and self._snapWhenNoScrollWidth) then
			self._scrolling = math.abs(x-self._touchBeginX)>=self._scrollThreshold
		end
		
		if not self._scrolling and (self._scrollHeight~=0 or (self._scrollHeight==0 and self._snapWhenNoScrollHeight)) then
			self._scrolling = math.abs(y-self._touchBeginY)>=self._scrollThreshold
		end
		
		if( not self._scrolling ) then return end
	end
	
	if not _gCurScrolling then _gCurScrolling = self end

	-- 处理滚动
	local oldX, oldY = self._curPosX, self._curPosY
	
--	if self._scrollHorizontal then
		self:setCurPosX(x-self._touchBeginX+self._scrollBeginX, self._snapWidth*self._bouncFactor)
--	end
	
--	if self._scrollVertical then
		self:setCurPosY(y-self._touchBeginY+self._scrollBeginY, self._snapHeight*self._bouncFactor)
--	end
	
	-- 派发事件
	if( (oldX~=self._curPosX or oldY~=self._curPosY) and self:hasListener(SCROLL_CHANGED.name) ) then
		SCROLL_CHANGED.curX = self._curPosX
		SCROLL_CHANGED.curY = self._curPosY
		SCROLL_CHANGED.autoSnap = false
		self:dispatchEvent(SCROLL_CHANGED)
	end
end

---
-- 触摸结束
-- @function [parent=#ScrollComponent] _onTouchEnded
-- @param self
-- @param #number x
-- @param #number y
-- 
function ScrollComponent:_onTouchEnded(x, y)
	-- 没有滚动，直接返回
	if not self._scrolling then return end
	
	self._scrolling = false
	
	local snap = false
	
	--如果设置了平滑滚动
	if self._smooth then
		
	end
	
	-- x对齐
	if( self._snapWidth and self._snapWidth>0 and x~=self._touchBeginX) then
		
		local dragRight = self._curPosX>self._scrollBeginX
		local scrollRight = self._scrollWidth>0
		
		local oldX = self._curPosX
		
		-- 由于有反弹，重置一下位置
		self:setCurPosX(oldX)
	
		local math = require("math")
		local newX = 0
		if self._smooth == nil or self._smooth == false then
			local intPart, fracPart = math.modf(self._curPosX/self._snapWidth)
			
			-- 相同方向
			if( dragRight==scrollRight ) then
				if( fracPart>self._snapThreshold ) then
					intPart = intPart+1
				elseif( fracPart<(-self._snapThreshold) ) then
					intPart = intPart-1
				end
			else
				if( fracPart>1-self._snapThreshold ) then
					intPart = intPart+1
				elseif( fracPart<self._snapThreshold-1 ) then
					intPart = intPart-1
				end
			end
			
			newX = intPart*self._snapWidth
		else
			--设置了平滑
			local offsetX = 0
			local os = require("os")
			offsetX = (x - self._touchBeginX)/(os.clock() - self._startClock)/5
			newX = self:getCurPosX() + offsetX
		end
			
		if( newX~=oldX ) then
			self:setCurPosX(newX)
			snap = true
		end
	end
	
	-- y对齐
	if( self._snapHeight and self._snapHeight>0 and y~=self._touchBeginY) then
	
		local dragUp = self._curPosY>self._scrollBeginY
		local scrollUp = self._scrollHeight>0
		
		local oldY = self._curPosY
		
		-- 由于有反弹，重置一下位置
		self:setCurPosY(oldY)
		
		local math = require("math")
		local newY = 0
		if self._smooth == nil or self._smooth == false then
			local intPart, fracPart = math.modf(self._curPosY/self._snapHeight)
			
			-- 方向相同
			if( dragUp==scrollUp ) then
				if( fracPart>self._snapThreshold ) then
					intPart = intPart+1
				elseif( fracPart<(-self._snapThreshold) ) then
					intPart = intPart-1
				end
			else
				if( fracPart>1-self._snapThreshold ) then
					intPart = intPart+1
				elseif( fracPart<self._snapThreshold-1 ) then
					intPart = intPart-1
				end
			end
			
			newY = intPart*self._snapHeight
		else
			--设置了平滑
			local offsetY = 0
			local os = require("os")
			offsetY = (y - self._touchBeginY)/(os.clock() - self._startClock)/5
			newY = self:getCurPosY() + offsetY
		end
		if( newY~=oldY ) then
			self:setCurPosY(newY)
			snap = true
		end
	end
	
	if( snap and self:hasListener(SCROLL_CHANGED.name) ) then
		SCROLL_CHANGED.curX = self._curPosX
		SCROLL_CHANGED.curY = self._curPosY
		SCROLL_CHANGED.autoSnap = true
		self:dispatchEvent(SCROLL_CHANGED)
	end
end

---
-- 触摸取消
-- @function [parent=#ScrollComponent] _onTouchCancelled
-- @param self
-- @param #number x
-- @param #number y
-- 
function ScrollComponent:_onTouchCancelled(x, y)
	self._scrolling = false
end

---
-- 设置平滑滚动
-- @function [parent=#ScrollComponent] setSmoothScroll
-- @param #bool smooth
--
function ScrollComponent:setSmoothScroll(smooth)
	self._smooth = smooth	
end

---
-- 是否是平滑滚动
-- @function [parent=#ScrollComponent] isSmoothScroll
-- @return #bool
-- 
function ScrollComponent:isSmoothScroll()
	return self._smooth
end

---
-- 获取滚动宽度为0时是否自动对齐
-- @function [parent=#ScrollComponent] isSnapWhenNoScrollWidth
-- @param self
-- @return #boolean
-- 
function ScrollComponent:isSnapWhenNoScrollWidth()
	return self._snapWhenNoScrollWidth
end

---
-- 获取滚动宽度为0时是否自动对齐
-- @function [parent=#ScrollComponent] isSnapWhenNoScrollWidth
-- @param self
-- @return #boolean
-- 
function ScrollComponent:isSnapWhenNoScrollHeight()
	return self._snapWhenNoScrollHeight
end

---
-- 设置滚动宽度为0时是否自动对齐
-- @function [parent=#ScrollComponent] setSnapWhenNoScrollWidth
-- @param self
-- @param #boolean snap
-- 
function ScrollComponent:setSnapWhenNoScrollWidth(snap)
	 self._snapWhenNoScrollWidth = snap
end

---
-- 设置滚动宽度为0时是否自动对齐
-- @function [parent=#ScrollComponent] setSnapWhenNoScrollHeight
-- @param self
-- @param #boolean snap
-- 
function ScrollComponent:setSnapWhenNoScrollHeight(snap)
	 self._snapWhenNoScrollHeight = snap
end