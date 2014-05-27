--- 
-- 点击辅助类基类
-- @module utils.ClickHelperBase
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local ccp = ccp

local moduleName = "utils.ClickHelperBase"
module(moduleName)

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
-- 类定义
-- @type ClickHelperBase
-- 

---
-- ClickHelperBase
-- @field [parent=#utils.ClickHelperBase] #ClickHelperBase ClickHelperBase
-- 
ClickHelperBase = class(moduleName)

---
-- 所属节点
-- @field [parent=#ClickHelperBase] #CCNode _ownerNoder
-- 
ClickHelperBase._ownerNoder = nil

---
-- 触摸区域
-- @field [parent=#ClickHelperBase] #CCRect _touchRect
-- 
ClickHelperBase._touchRect = nil

---
-- 点击处理,function(node, rect)
-- @field [parent=#ClickHelperBase] #function _clickHandler
-- 
ClickHelperBase._clickHandler = nil

---
-- 触摸优先者,如hbox,vbox等滚屏容器
-- @field [parent=#ClickHelperBase] #table _priorToucher
-- 
ClickHelperBase._priorToucher = nil

---
-- 触摸是否被打断
-- @field [parent=#ClickHelperBase] #boolean _touchBreaked
-- 
ClickHelperBase._touchBreaked = false

---
-- 可点击的UI,ui->{rect}
-- @field [parent=#ClickHelperBase] #table _uis
-- 
ClickHelperBase._uis = nil

---
-- 当前触摸的Ui
-- @field [parent=#ClickHelperBase] #CCNode _curTouchUi
-- 
ClickHelperBase._curTouchUi = nil

---
-- 当前触摸的Ui区域
-- @field [parent=#ClickHelperBase] #CCRect _curTouchRect
-- 
ClickHelperBase._curTouchRect = nil

---
-- 触摸源
-- @field [parent=#ClickHelperBase] #CCNode _touchSource
-- 
ClickHelperBase._touchSource = nil

---
-- 是否吞掉事件
-- @field [parent=#ClickHelperBase] #boolean _swallow
-- 
ClickHelperBase._swallow = true

--- 
-- 创建实例
-- @function [parent=#utils.ClickHelperBase] new
-- @return #ClickHelperBase
-- 
function new()
	return ClickHelperBase.new()
end

--- 
-- 构造函数
-- @function [parent=#ClickHelperBase] ctor
-- @param self
-- 
function ClickHelperBase:ctor()
	local EventProtocol = require("framework.client.api.EventProtocol")
	EventProtocol.extend(self)
	
	self._uis = {}
end

--- 
-- 初始化
-- @function [parent=#ClickHelperBase] init
-- @param self
-- @param #CCNode ownerNode 所属节点
-- @param #CCRect touchRect 触摸区域
-- @param #function clickHandler 点击处理函数
-- @param #boolean swallow 是否吞掉事件
-- 
function ClickHelperBase:init( ownerNode, touchRect, clickHandler, swallow )
	self._ownerNode = ownerNode
	self._touchRect = touchRect
	self._clickHandler = clickHandler
	self._swallow = swallow==nil and true or swallow
end

--- 
-- 设置触摸优先者
-- @function [parent=#ClickHelperBase] setPriorToucher
-- @param self
-- @param #table priorToucher 触摸优先者
-- 
function ClickHelperBase:setPriorToucher( priorToucher )
	self._priorToucher = priorToucher
end

--- 
-- 添加UI
-- @function [parent=#ClickHelperBase] addUi
-- @param self
-- @param #CCNode ui 接受点击的UI
-- @param #CCRect rect 点击区域,默认为nil,表示ui的contentSize
-- 
function ClickHelperBase:addUi( ui, rect )
	if( not ui ) then return end
	
	local rects = self._uis[ui]
	if( not rects ) then
		rects = {}
		self._uis[ui] = rects
	end
	
	for i=1, #rects do
		if( rects[i]:equals(rect) ) then
			return
		end
	end
	
	rects[#rects+1] = rect
end

--- 
-- 移除UI
-- @function [parent=#ClickHelperBase] removeUi
-- @param self
-- @param #CCNode ui 接受点击的UI
-- @param #CCRect rect 点击区域,如果为nil,会将所有rect移除
-- 
function ClickHelperBase:removeUi( ui, rect )
	if( not ui ) then return end
	
	if( not rect ) then
		self._uis[ui] = nil
		return
	end
	
	local rects = self._uis[ui]
	if( not rects ) then return end
	
	for i=1, #rects do
		if( rects[i]:equals(rect) ) then
			local table = require("table")
			table.remove(rects, i)
			return
		end
	end
end

--- 
-- 移除所有UI
-- @function [parent=#ClickHelperBase] removeAll
-- @param self
-- 
function ClickHelperBase:removeAll()
	self._uis = {}
end

---
-- 是否可以开始触摸
-- @function [parent=#ClickHelperBase] _canBeginTouch
-- @param self
-- @param #number x x坐标
-- @param #number y y坐标
-- 
function ClickHelperBase:_canBeginTouch( x, y )
	if( not self._ownerNode:isVisible() or not self._ownerNode:isParentsVisible() or self._ownerNode:isCliped() ) then
		return false
	end
	
	-- 是否在触摸区域
	if( self._touchRect ) then
		local pt = self._ownerNode:convertToNodeSpace(ccp(x, y))
		if( not self._touchRect:containsPoint(pt) ) then
			return false
		end
	end
	
	self._curTouchUi, self._curTouchRect = self:_getUiUnderPoint(x, y)
	
	return self._curTouchUi~=nil
end

---
-- 取坐标点下的UI
-- @function [parent=#ClickHelperBase] _getUiUnderPoint
-- @param self
-- @param #number x x坐标
-- @param #number y y坐标
-- @return #CCNode, #CCRect ui和触摸区域
-- 
function ClickHelperBase:_getUiUnderPoint( x, y )
	local localPt = nil
	local size = nil
	local rect = nil
	local touchPt = ccp(x, y)
	for ui, rects in pairs(self._uis) do
		localPt = ui:convertToNodeSpace(touchPt)
		if( #rects<=0 ) then
			size = ui:getContentSize()
			if( localPt.x>=0 and localPt.x<size.width and localPt.y>=0 and localPt.y<size.height ) then
				return ui
			end
		else
			for i=1, #rects do
				if( rects[i]:containsPoint(localPt) ) then
					return ui, rects[i]
				end
			end
		end
	end
end

---
-- 触摸事件处理
-- @function [parent=#ClickHelperBase] _onTouch
-- @param self
-- @param #string event
-- @param #number x
-- @param #number y
-- @return #boolean
-- 
function ClickHelperBase:_onTouch( event, x, y )
	local began = true
    if event == "began" then
        began = self:_onTouchBegan(x, y)
    elseif event == "moved" then
        self:_onTouchMoved(x, y)
    elseif event == "ended" then
        self:_onTouchEnded(x, y)
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
-- 打断触摸
-- @function [parent=#ClickHelperBase] breakTouch
-- @param self
-- 
function ClickHelperBase:breakTouch( )
	self._touchBreaked = true
	self._curTouchUi = nil
    self._curTouchRect = nil
end


---
-- 触摸开始
-- @function [parent=#ClickHelperBase] _onTouchBegan
-- @param self
-- @param #number x
-- @param #number y
-- @return #boolean
-- 
function ClickHelperBase:_onTouchBegan(x, y)
    if( self:_canBeginTouch(x, y) ) then
    	self._touchBreaked = false
    	
    	-- 标记正在触摸
    	if( self._priorToucher and self._priorToucher.markTouching ) then
    		self._priorToucher:markTouching(self)
    	end
    	return true
    end
    
    self._touchBreaked = true
    
    return false
end

---
-- 触摸移动
-- @function [parent=#ClickHelperBase] _onTouchMoved
-- @param self
-- @param #number x
-- @param #number y
-- 
function ClickHelperBase:_onTouchMoved(x, y)
	if( self._touchBreaked ) then return end
end

---
-- 触摸结束
-- @function [parent=#ClickHelperBase] _onTouchEnded
-- @param self
-- @param #number x
-- @param #number y
-- 
function ClickHelperBase:_onTouchEnded(x, y)
	if( self._touchBreaked ) then return end
	
	local ui, rect = self:_getUiUnderPoint(x, y)
	
	-- 点击
	if( self._clickHandler and self._curTouchUi==ui and self._curTouchRect==rect ) then
		local CCBView = require("ui.CCBView")
		if CCBView.isGuiding then
			--printf("1111111111111111111--touch")
			local EventCenter = require("utils.EventCenter")
			local Events = require("model.event.Events")
			local event = Events.GUIDE_CLICK
			EventCenter:dispatchEvent(event)
		end
	
		self._clickHandler(self._curTouchUi, self._curTouchRect)
	end
	
	-- 去掉正在触摸标记
	if( self._priorToucher and self._priorToucher.unmarkTouching ) then
    	self._priorToucher:unmarkTouching(self)
    end
    
    self._curTouchUi = nil
    self._curTouchRect = nil
end

---
-- 触摸取消
-- @function [parent=#ClickHelperBase] _onTouchCancelled
-- @param self
-- @param #number x
-- @param #number y
-- 
function ClickHelperBase:_onTouchCancelled(x, y)
	if( self._touchBreaked ) then return end
	
	-- 去掉正在触摸标记
	if( self._priorToucher and self._priorToucher.unmarkTouching ) then
    	self._priorToucher:unmarkTouching(self)
    end
    
    self._curTouchUi = nil
    self._curTouchRect = nil
end

--- 
-- 监听触摸
-- @function [parent=#ClickHelperBase] listenTouch
-- @param self
-- @param #CCNode touchSource 触摸源
-- 
function ClickHelperBase:listenTouch( touchSource )
end

--- 
-- 取消触摸监听
-- @function [parent=#ClickHelperBase] unlistenTouch
-- @param self
-- 
function ClickHelperBase:unlistenTouch( )
end

--- 
-- 是否cell点击
-- @function [parent=#ClickHelperBase] isCellClick
-- @param self
-- @return #boolean
-- 
function ClickHelperBase:isCellClick( )
	return false
end