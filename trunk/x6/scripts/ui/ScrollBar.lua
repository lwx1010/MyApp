--- 
-- 滚动条.
-- @module ui.ScrollBar
-- 

local class = class
local printf = printf
local require = require
local ccp = ccp
local CCNode = CCNode


local moduleName = "ui.ScrollBar"
module(moduleName)

---
-- @type SCROLL_CHANGED
-- @field #string name SCROLL_CHANGED
-- @field #number value 滚动值
-- 

--- 
-- 滚动改变
-- @field [parent=#ui.ScrollBar] #SCROLL_CHANGED SCROLL_CHANGED
-- 
SCROLL_CHANGED = {name="SCROLL_CHANGED"}


--- 
-- 类定义
-- @type ScrollBar
-- 

---
-- ScrollBar类
-- @field [parent=#ui.ScrollBar] #ScrollBar ScrollBar
-- 
ScrollBar = class(moduleName, require("ui.UiComponent").UiComponent)

---
-- 滚动方向
-- @field [parent=#ScrollBar] #string _scrollDir
-- 
ScrollBar._scrollDir = nil

---
-- 滚动条的按钮
-- @field [parent=#ScrollBar] #CCNode _btn
-- 
ScrollBar._btn = nil

---
-- 滚动控件
-- @field [parent=#ScrollBar] ui.ScrollComponent#ScrollComponent _scrollComp
-- 
ScrollBar._scrollComp = nil

---
-- 是否启用
-- @field [parent=#ScrollBar] #boolean _enable
-- 
ScrollBar._enable = true

---
-- 滚动条的最小值
-- @field [parent=#ScrollBar] #number _min
-- 
ScrollBar._min = 0

---
-- 滚动条的最大值
-- @field [parent=#ScrollBar] #number _max
-- 
ScrollBar._max = 100

--- 
-- 创建实例
-- @function [parent=#ui.ScrollBar] new
-- @return #ScrollBar
-- 
function new()
	return ScrollBar.new()
end

--- 
-- 构造函数
-- @function [parent=#ScrollBar] ctor
-- @param self
-- 
function ScrollBar:ctor()
	ScrollBar.super.ctor(self)
	
	local EventProtocol = require("framework.client.api.EventProtocol")
	EventProtocol.extend(self)
	
	local Directions = require("ui.const.Directions")
	self._scrollDir = Directions.VERTICAL
	
	local ScrollComponent = require("ui.ScrollComponent")
	self._scrollComp = ScrollComponent.new()
	self._scrollComp:setBounceFactor(0)
	self._scrollComp:setSnapWidth(0)
	self._scrollComp:setSnapHeight(0)
	self._scrollComp:setScrollThreshold(0)
    self:addChild(self._scrollComp)
    
	self._scrollComp:addEventListener(ScrollComponent.SCROLL_CHANGED.name, self._onScrollChanged, self )
end

---
-- 滚动改变
-- @function [parent=#ScrollBar] _onScrollChanged
-- @param self
-- @param ui.ScrollComponent#SCROLL_CHANGED event 事件
-- 
function ScrollBar:_onScrollChanged( event )
	
	if not self._btn then return end

	local Directions = require("ui.const.Directions")
	if( self._scrollDir==Directions.HORIZONTAL ) then
		self._btn:setPositionX(self._scrollComp:getCurPosX())
	else
		local selfSize = self:getContentSize()
		local btnSize = self._btn:getContentSize()
		self._btn:setPositionY(selfSize.height-btnSize.height+self._scrollComp:getCurPosY())
	end
	
	self._scrollComp:setPosition(self._btn:getPosition())
	
	-- 派发事件
	if( self:hasListener(SCROLL_CHANGED.name) ) then
		SCROLL_CHANGED.value = self:getValue()
		self:dispatchEvent(SCROLL_CHANGED)
	end
	
	--printf("%d %d %s",event.curX, event.curY, event.autoSnap and "true" or "false")
end

--- 
-- 设置滚动条的按钮
-- @function [parent=#ScrollBar] setScrollBtn
-- @param self
-- @param #CCNode btn 按钮实例
-- 
function ScrollBar:setScrollBtn( btn )
	if self._btn==btn then return end
	
	if self._btn then
		self:removeChild(self._btn)
	end
	
	self._btn = btn
	
	if not self._btn then return end
	
	self._btn:setVisible(self._scrollComp:isEnabled())
	self._btn:setAnchorPoint(ccp(0,0))
	self._btn:setTouchEnabled(false)
	self:addChild(self._btn)
	
	self._scrollComp:setContentSize(self._btn:getContentSize())
	
	self:_adjustScrollParams()
end

---
-- 调整滚动参数
-- @function [parent=#ScrollBar] _adjustScrollParams
-- 
function ScrollBar:_adjustScrollParams()
	if not self._btn then return end
	
	local selfSize = self:getContentSize()
	local btnSize = self._btn:getContentSize()
	
	local Directions = require("ui.const.Directions")
	if( self._scrollDir==Directions.HORIZONTAL ) then
		self._scrollComp:setScrollSize(selfSize.width-btnSize.width, 0)
		self._btn:setPosition(self._scrollComp:getCurPosX(), (selfSize.height-btnSize.height)/2)
	else
		self._scrollComp:setScrollSize(0, btnSize.height-selfSize.height)
		self._btn:setPosition((selfSize.width-btnSize.width)/2, selfSize.height-btnSize.height+self._scrollComp:getCurPosY())
	end
	
	self._scrollComp:setPosition(self._btn:getPosition())
end

--- 
-- 取滚动条的按钮
-- @function [parent=#ScrollBar] getScrollBtn
-- @param self
-- @return #CCNode 按钮实例
-- 
function ScrollBar:getScrollBtn( )
	return self._btn
end

---
-- 设置滚动方向
-- @function [parent=#ScrollBar] setScrollDir
-- @param self
-- @param #string d 方向
-- 
function ScrollBar:setScrollDir( d )
	if( self._scrollDir==d ) then return end
	
	self._scrollDir = d
	
	self:_adjustScrollParams()
end

---
-- 取滚动方向
-- @function [parent=#ScrollBar] getScrollDir
-- @param self
-- @return #string
-- 
function ScrollBar:getScrollDir()
	return self._scrollDir
end

---
-- 设置内容大小
-- @function [parent=#ScrollBar] setContentSize
-- @param self
-- @param #CCSize s 视图大小
-- 
function ScrollBar:setContentSize( s )
	if self:getContentSize():equals(s) then return end
	
	CCNode.setContentSize(self, s)
		
	self:_adjustScrollParams()
end

---
-- 开启滚动
-- @function [parent=#ScrollBar] enable
-- @param self
-- @param #boolean e 是否开启
--
function ScrollBar:enable( e )
	self._enable = e
	
	self._scrollComp:enable(self._enable and self._max>self._min)
	
	if self._btn then
		self._btn:setVisible(self._scrollComp:isEnabled())
	end
end

---
-- 是否开启滚动
-- @function [parent=#ScrollBar] isEnabled
-- @param self
-- @return #boolean e 是否开启
--
function ScrollBar:isEnabled()
	return self._enable
end

---
-- 取滚动值
-- @function [parent=#ScrollBar] getValue
-- @return #number 滚动值
-- 
function ScrollBar:getValue()
	local w, h = self._scrollComp:getScrollSize()
	local percent = 0
	
	local Directions = require("ui.const.Directions")
	if self._scrollDir==Directions.HORIZONTAL and w~=0 then
		percent = self._scrollComp:getCurPosX()/w
	elseif h~=0 then
		percent = self._scrollComp:getCurPosY()/h
	end
	
	return (self._max-self._min)*percent+self._min
end

---
-- 设置滚动值
-- @function [parent=#ScrollBar] getValue
-- @param #number val 滚动值
-- @param #boolean sendEvent 是否派发事件，默认是
-- 
function ScrollBar:setValue( val, sendEvent )
	if val<self._min or val>self._max or self._min==self._max then return end
	
	if val==self:getValue() then return end
	
	if sendEvent==nil then sendEvent = true end
	
	local w, h = self._scrollComp:getScrollSize()
	local percent = (val-self._min)/(self._max-self._min)
	
	local Directions = require("ui.const.Directions")
	if self._scrollDir==Directions.HORIZONTAL then
		self._scrollComp:setCurPosX(percent*w)
	else
		self._scrollComp:setCurPosY(percent*h)
	end
	
	local selfSize = self:getContentSize()
	local btnSize = self._btn:getContentSize()
	if( self._scrollDir==Directions.HORIZONTAL ) then
		self._btn:setPosition(self._scrollComp:getCurPosX(), (selfSize.height-btnSize.height)/2)
	else
		self._btn:setPosition((selfSize.width-btnSize.width)/2, selfSize.height-btnSize.height+self._scrollComp:getCurPosY())
	end
	
	self._scrollComp:setPosition(self._btn:getPosition())
	
	-- 派发事件
	if( sendEvent and self:hasListener(SCROLL_CHANGED.name) ) then
		SCROLL_CHANGED.value = val
		self:dispatchEvent(SCROLL_CHANGED)
	end
end

---
-- 设置滚动值范围
-- @function [parent=#ScrollBar] setValueRange
-- @param #number min 最小值
-- @param #number max 最大值
-- 
function ScrollBar:setValueRange( min, max )
	self._min = min
	self._max = max
	
	self._scrollComp:enable(self._enable and self._max>self._min)
	if self._btn then
		self._btn:setVisible(self._scrollComp:isEnabled())
	end
end

---
-- 取滚动值范围
-- @function [parent=#ScrollBar] getValueRange
-- @return #number, #number 最小值，最大值
-- 
function ScrollBar:getValueRange( )
	return self._min, self._max
end

