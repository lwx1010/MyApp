--- 
-- 滚动视图.
-- 根据contentSize的范围进行滚动和裁剪
-- 相关的滚动特性可以参考 @{ui#ScrollComponent}
-- 视图的滚动功能和子项的触摸功能相冲突
-- 解决方案是：子项和视图都分别处理触摸事件，
-- 子项触摸开始和结束时，调用视图的markTouching和
-- unmarkTouching接口来通知子项的触摸状态，同时，
-- 子项还需要实现打断触摸接口breakTouch.当视图
-- 滚动时，会打断所有触摸状态的子项的触摸操作，即
-- 调用子项的breakTouch接口，并清除触摸状态.
-- 子项在breakTouch接口里应处理相关被打断触摸的细节
-- 
-- 为了支持单选或者多选，子项要实现接口setSelect(#boolean)
-- 选中的话，会传入true，否则传入false
-- @module ui.ScrollView
-- 

local class = class
local printf = printf
local require = require
local CCRect = CCRect
local CCSize = CCSize
local ccp = ccp
local ipairs = ipairs
local pairs = pairs
local tolua = tolua
local CCNode = CCNode


local moduleName = "ui.ScrollView"
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
-- @field [parent=#ui.ScrollView] #SCROLL_CHANGED SCROLL_CHANGED
-- 
SCROLL_CHANGED = {name="SCROLL_CHANGED"}


--- 
-- 类定义
-- @type ScrollView
-- 

---
-- ScrollView类
-- @field [parent=#ui.ScrollView] #ScrollView ScrollView
-- 
ScrollView = class(moduleName, require("ui.UiComponent").UiComponent)

---
-- 滚动方向
-- @field [parent=#ScrollView] #string _scrollDir
-- 
ScrollView._scrollDir = nil

---
-- 子项容器
-- @field [parent=#ScrollView] #CCNode _itemContainer
-- 
ScrollView._itemContainer = nil

---
-- 滚动控件
-- @field [parent=#ScrollView] ui.ScrollComponent#ScrollComponent _scrollComp
-- 
ScrollView._scrollComp = nil

---
-- 子项数组
-- @field [parent=#ScrollView] #table _itemArr
--
ScrollView._itemArr = nil

---
-- 正在触摸的子项表.
-- key-true
-- @field [parent=#ScrollView] #table _touchingItemTbl
--
ScrollView._touchingItemTbl = nil

---
-- 容器的最终坐标X
-- @field [parent=#ScrollView] #number _containerEndX
--
ScrollView._containerEndX = 0

---
-- 容器的最终坐标Y
-- @field [parent=#ScrollView] #number _containerEndY
--
ScrollView._containerEndY = 0

---
-- 水平滚动条
-- @field [parent=#ScrollView] ui.ScrollBar#ScrollBar _hBar
-- 
ScrollView._hBar = nil

---
-- 垂直滚动条
-- @field [parent=#ScrollView] ui.ScrollBar#ScrollBar _vBar
-- 
ScrollView._vBar = nil

---
-- 是否可选
-- @field [parent=#ScrollView] #boolean _selectable
-- 
ScrollView._selectable = true

---
-- 是否多选
-- @field [parent=#ScrollView] #boolean _multiSelection
-- 
ScrollView._multiSelection = false

---
-- 选择的子项或者子项映射表
-- @field [parent=#ScrollView] #table _selects
-- 
ScrollView._selects = nil

---
-- 是否通过索引选择
-- @field [parent=#ScrollView] #boolean _selectByIndex
-- 
ScrollView._selectByIndex = false

--- 
-- 创建实例
-- @function [parent=#ui.ScrollView] new
-- @return #ScrollView
-- 
function new()
	return ScrollView.new()
end

--- 
-- 构造函数
-- @function [parent=#ScrollView] ctor
-- @param self
-- 
function ScrollView:ctor()
	ScrollView.super.ctor(self)
	
	local EventProtocol = require("framework.client.api.EventProtocol")
	EventProtocol.extend(self)
	
	local Directions = require("ui.const.Directions")
	self._scrollDir = Directions.ANY
	
	self._itemArr = {}
	
	self:setClipEnabled(true)
	
	local display = require("framework.client.display")
	self._itemContainer = display.newNode()
	self._itemContainer:setAnchorPoint(ccp(0, 0))
    self:addChild(self._itemContainer)
	
	local ScrollComponent = require("ui.ScrollComponent")
	self._scrollComp = ScrollComponent.new()
    self:addChild(self._scrollComp, -1000)
    
    self:enableScroll(true)
end

---
-- 设置滚动方向
-- @function [parent=#ScrollView] setScrollDir
-- @param self
-- @param #string d 方向
-- 
function ScrollView:setScrollDir( d )
	if( self._scrollDir==d ) then return end
	
	self._scrollDir = d
	
	local w, h = self._scrollComp:getScrollSize()
	
	local Directions = require("ui.const.Directions")
	if( self._scrollDir==Directions.ANY ) then
		self._scrollComp:setScrollSize(w, h)
	elseif( self._scrollDir==Directions.HORIZONTAL ) then
		self._scrollComp:setScrollSize(w, 0)
	else
		self._scrollComp:setScrollSize(0, h)
	end
	
	self:_updateBarRange()
	
	self:scrollToPos(-self._scrollComp:getCurPosX(),self._scrollComp:getCurPosY())
end

---
-- 取滚动方向
-- @function [parent=#ScrollView] getScrollDir
-- @param self
-- @return #string
-- 
function ScrollView:getScrollDir()
	return self._scrollDir
end

---
-- 设置内容大小
-- @function [parent=#ScrollView] setContentSize
-- @param self
-- @param #CCSize s 视图大小
-- 
function ScrollView:setContentSize( s )
	if self:getContentSize():equals(s) then return end
	
	CCNode.setContentSize(self, s)
		
	self._scrollComp:setContentSize(s)
	
	self:invalidLayout()
end

---
-- 开启滚动
-- @function [parent=#ScrollView] enableScroll
-- @param self
-- @param #boolean e 是否开启
--
function ScrollView:enableScroll( e )
	self._scrollComp:enable(e)
	
	local ScrollComponent = require("ui.ScrollComponent")
	if( e ) then
		self._scrollComp:addEventListener(ScrollComponent.SCROLL_CHANGED.name, self._onScrollChanged, self )
	else
		self._scrollComp:removeEventListener(ScrollComponent.SCROLL_CHANGED.name, self._onScrollChanged)
	end
end

---
-- 滚动改变
-- @function [parent=#ScrollView] _onScrollChanged
-- @param self
-- @param ui.ScrollComponent#SCROLL_CHANGED event 事件
-- 
function ScrollView:_onScrollChanged( event )
	-- 打断子项的触摸
	if self._itemArr then
		local item
		for i=1, #self._itemArr do
			item = self._itemArr[i]
			if item.breakTouch then
				item:breakTouch()
			end
		end
	end
	
	if( self._touchingItemTbl ) then
		for v, _ in pairs(self._touchingItemTbl) do
			if( v.breakTouch ) then
				v:breakTouch()
			end
		end
		
		self._touchingItemTbl = nil
	end

	self:_doScrollToPos(event.curX, event.curY, event.autoSnap)
	
	--printf("%d %d %s",event.curX, event.curY, event.autoSnap and "true" or "false")
end

---
-- 滚动到特定位置
-- @function [parent=#ScrollView] scrollToPos
-- @param self
-- @param #number x x方向位置
-- @param #number y y方向位置
-- @param #boolean anim 是否动画方式滚动
-- 
function ScrollView:scrollToPos( x, y, anim )
	x = -x
	
	x = self._scrollComp:setCurPosX(x)
	y = self._scrollComp:setCurPosY(y)
	
	self:_doScrollToPos(x, y, anim)
end

---
-- 滚动到特定位置
-- @function [parent=#ScrollView] _doScrollToPos
-- @param self
-- @param #number x x方向位置
-- @param #number y y方向位置
-- @param #boolean anim 是否动画方式滚动
-- 
function ScrollView:_doScrollToPos( x, y, anim )
	-- 停止动画
	local transition = require("framework.client.transition")
	transition.stopTarget(self._itemContainer)
	
	-- 自动对齐，使用动画
	if self._scrollComp:isSmoothScroll() == nil or self._scrollComp:isSmoothScroll() == false then
		if( anim ) then
		    transition.moveTo(self._itemContainer, {
		        x = x,
		        y = y,
		        time = 0.4,
		        easing = "backOut",
		    })
		else
			self._itemContainer:setPosition(x, y)
		end
	else
		if( anim ) then
		    transition.moveTo(self._itemContainer, {
		        x = x,
		        y = y,
		        time = 0.7,
		        easing = "SINEOUT",
		    })
		else
			self._itemContainer:setPosition(x, y)
		end
	end
	
	self._containerEndX = x
	self._containerEndY = y
	
	self:_updateBarValue(x, y)
	
	-- 派发事件
	if( self:hasListener(SCROLL_CHANGED.name) ) then
		SCROLL_CHANGED.curX = x
		SCROLL_CHANGED.curY = y
		SCROLL_CHANGED.autoSnap = anim
		self:dispatchEvent(SCROLL_CHANGED)
	end
end

---
-- 滚动到特定索引
-- @function [parent=#ScrollView] scrollToIndex
-- @param self
-- @param #number index 索引
-- @param #boolean anim 是否动画方式滚动
-- 
function ScrollView:scrollToIndex( index, anim )
	self:scrollToItem(self._itemArr[index], anim)
end

---
-- 滚动到子项
-- @function [parent=#ScrollView] scrollToItem
-- @param self
-- @param #table item 子项
-- @param #boolean anim 是否动画方式滚动 
-- 
function ScrollView:scrollToItem( item, anim )
	if( not item or item:getParent()~=self._itemContainer ) then return end
	
	local w, h = self._scrollComp:getScrollSize()
	if( w==0 and h==0 ) then return end
	
	local x, y = 0, 0
	
	local math = require("math")
	if( w~=0 ) then
		x = math.min(-w, item:getPositionX())
	end
	
	if( h~=0 ) then
		y = math.min(h, self:getContentSize().height-item:getPositionY()-item:getContentSize().height)
	end
	
	self:scrollToPos(x, y, anim)
end

---
-- 是否开启滚动
-- @function [parent=#ScrollView] isScrollEnabled
-- @param self
-- @return #boolean e 是否开启
--
function ScrollView:isScrollEnabled()
	return self._scrollComp:isEnabled()
end

---
-- 设置反弹因子.
-- 与对齐宽度，高度相关
-- @function [parent=#ScrollView] setBounceFactor
-- @param self
-- @param #number f 因子
--
function ScrollView:setBounceFactor( f )
	self._scrollComp:setBounceFactor(f)
end

---
-- 取反弹因子
-- @function [parent=#ScrollView] getBounceFactor
-- @param self
-- @return #number
--
function ScrollView:getBounceFactor()
	return self._scrollComp:getBounceFactor()
end

---
-- 设置对齐宽度
-- @function [parent=#ScrollView] setSnapWidth
-- @param self
-- @param #number w 宽度
--
function ScrollView:setSnapWidth( w )
	self._scrollComp:setSnapWidth(w)
end

---
-- 取对齐宽度
-- @function [parent=#ScrollView] getSnapWidth
-- @param self
-- @return #number
--
function ScrollView:getSnapWidth()
	return self._scrollComp:getSnapWidth()
end

---
-- 设置对齐高度
-- @function [parent=#ScrollView] setSnapHeight
-- @param self
-- @param #number h 高度
--
function ScrollView:setSnapHeight( h )
	self._scrollComp:setSnapHeight(h)
end

---
-- 取对齐高度
-- @function [parent=#ScrollView] getSnapHeight
-- @param self
-- @return #number
--
function ScrollView:getSnapHeight()
	return self._scrollComp:getSnapHeight()
end

---
-- 设置对齐阀值
-- 根据阀值判断是向前对齐还是向后对齐
-- @function [parent=#ScrollView] setSnapThreshold
-- @param self
-- @param #number t 阀值
--
function ScrollView:setSnapThreshold( t )
	self._scrollComp:setSnapThreshold(t)
end

---
-- 取对齐阀值
-- @function [parent=#ScrollView] getSnapThreshold
-- @param self
-- @return #number
--
function ScrollView:getSnapThreshold()
	return self._scrollComp:getSnapThreshold()
end

---
-- 添加子项
-- @function [parent=#ScrollView] addItem
-- @param self
-- @param #CCNode item
-- 
function ScrollView:addItem( item )
	self:addItemAt(item, #self._itemArr+1)
end

---
-- 在特定位置添加子项
-- @function [parent=#ScrollView] addItemAt
-- @param self
-- @param #CCNode item 子项
-- @param #number pos 位置
-- 
function ScrollView:addItemAt( item, pos )
	if( not item or item:getParent() ) then
		printf("ScrollView:addItem failed")
		return
	end
	
	if( pos<1 or pos>#self._itemArr+1 ) then
		printf("ScrollView:addItemAt 位置错误：%d", pos)
		return
	end
	
	local table = require("table")
	table.insert(self._itemArr, pos, item)
	
	item.owner = self
	
	-- 默认放左上角
	item:setPosition(0, self:getContentSize().height-item:getContentSize().height)
	
	item:setAnchorPoint(ccp(0, 0))
	item:setVisible(false)
	self._itemContainer:addChild(item)
	
	self:invalidLayout()
end

---
-- 移除子项
-- @function [parent=#ScrollView] removeItem
-- @param self
-- @param #CCNode item
-- @param #boolean cleanUp 是否释放，默认为true
-- 
function ScrollView:removeItem( item, cleanUp )
	return self:removeItemAt(self:getItemIndex(item), cleanUp)
end

---
-- 移除特定位置的子项
-- @function [parent=#ScrollView] removeItemAt
-- @param self
-- @param #number pos
-- @param #boolean cleanUp 是否释放，默认为true
-- @return #CCNode
-- 
function ScrollView:removeItemAt( pos, cleanUp )
	if( not pos or pos<1 or pos>#self._itemArr ) then
		printf("ScrollView:removeItemAt 位置错误：%d", pos)
		return
	end
	
	local item = self._itemArr[pos]
	
	if not self._selectByIndex then
		self:clearSelect({item}, false)
	end
	
	local table = require("table")
	table.remove(self._itemArr, pos)
	
	cleanUp = cleanUp==nil and true or cleanUp
	self._itemContainer:removeChild(item, cleanUp)
	
	item.owner = nil
	
	self:invalidLayout()
	
	return item
end

---
-- 移除所有子项
-- @function [parent=#ScrollView] removeAllItems
-- @param self
-- @param #boolean cleanUp 是否释放，默认为true
-- 
function ScrollView:removeAllItems( cleanUp )
	if( #self._itemArr<=0 ) then return end
	
	if not self._selectByIndex then
		self:clearSelect(nil, false)
	end
	
	cleanUp = cleanUp==nil and true or cleanUp
	for i, v in ipairs(self._itemArr) do
		self._itemContainer:removeChild(v, cleanUp)
		v.owner = nil
	end
	
	self._itemArr = {}
	
	self:invalidLayout()
end

---
-- 取子项数组
-- @function [parent=#ScrollView] getItemArr
-- @param self
-- @return #table 子项数组
-- 
function ScrollView:getItemArr()
	return self._itemArr
end

---
-- 取特定位置的子项
-- @function [parent=#ScrollView] getItemAt
-- @param self
-- @param #number index 索引
-- @return #table 子项
-- 
function ScrollView:getItemAt( index )
	return self._itemArr[index]
end

---
-- 取子项索引
-- @function [parent=#ScrollView] getItemIndex
-- @param self
-- @param #CCNode item
-- @return #number 索引值
-- 
function ScrollView:getItemIndex( item )
	local TableUtil = require("utils.TableUtil")
	return TableUtil.indexOf(self._itemArr, item)
end

---
-- 布局生效
-- @function [parent=#ScrollView] _validateLayout
-- @param self
-- 
function ScrollView:_validateLayout()
	local w, h = self:_calcScrollSize()
	
	local Directions = require("ui.const.Directions")
	if( self._scrollDir==Directions.ANY ) then
		self._scrollComp:setScrollSize(w, h)
	elseif( self._scrollDir==Directions.HORIZONTAL ) then
		self._scrollComp:setScrollSize(w, 0)
	else
		self._scrollComp:setScrollSize(0, h)
	end
	
	self:_updateBarRange()
	
	--printf(self._scrollComp:getCurPosX().." "..self._scrollComp:getCurPosY())
	self:_doScrollToPos(self._scrollComp:getCurPosX(),self._scrollComp:getCurPosY())
end

---
-- 计算滚动范围
-- @function [parent=#ScrollView] _calcScrollSize
-- @param self
-- @return #number, #number 宽，高
-- 
function ScrollView:_calcScrollSize( )
	local bound = self:_calcItemBound()
	local size = self:getContentSize()
	
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
	
	return w, h
end

---
-- 计算子项范围
-- @function [parent=#ScrollView] _calcItemBound
-- @param self
-- @return #CCRect
-- 
function ScrollView:_calcItemBound( )
	if( #self._itemArr==0 ) then
		return CCRect()
	end
	
	local math = require("math")
	
	local minX = math.huge
	local minY = math.huge
	local maxX = -math.huge
	local maxY = -math.huge
	
	local x, y
	local size
	for i, item in ipairs(self._itemArr) do
		x, y = item:getPosition(0, 0)
		size = item:getContentSize()
		
		minX = math.min(x, minX)
		minY = math.min(y, minY)
		maxX = math.max(x+size.width, maxX)
		maxY = math.max(y+size.height, maxY)
	end
	
	--printf("%d %d %d %d",minX, minY, maxX, maxY)
	
	return CCRect(minX, minY, maxX-minX, maxY-minY)
end

---
-- 标记子项为正在触摸.
-- 子项需实现打断触摸的接口breakTouch()
-- 在滚动的时候，会调用该接口，并将子项从触摸表里去掉
-- @function [parent=#ScrollView] markTouching
-- @param self
-- @param #CCNode item 子项
-- 
function ScrollView:markTouching( item )
	if( not self._touchingItemTbl ) then
		self._touchingItemTbl = {}
	end
	
	self._touchingItemTbl[item] = true
end

---
-- 去掉子项正在触摸的标记
-- @function [parent=#ScrollView] unmarkTouching
-- @param self
-- @param #CCNode item 子项
-- 
function ScrollView:unmarkTouching( item )
	if( not self._touchingItemTbl ) then return end
	
	self._touchingItemTbl[item] = nil
end

---
-- 链接滚动条
-- @function [parent=#ScrollView] linkBar
-- @param self
-- @param ui.ScrollBar#ScrollBar bar 滚动条
-- @param #boolean hor 是否水平滚动条
-- 
function ScrollView:linkBar( bar, hor )
	local ScrollBar = require("ui.ScrollBar")
	if hor then
		if self._hBar then
			self._hBar:removeEventListener(ScrollBar.SCROLL_CHANGED.name, self._onBarChanged)
		end
		self._hBar = bar
		if self._hBar then
			self._hBar:addEventListener(ScrollBar.SCROLL_CHANGED.name, self._onBarChanged, self)
		end
		return
	end
	
	if self._vBar then
		self._vBar:removeEventListener(ScrollBar.SCROLL_CHANGED.name, self._onBarChanged)
	end
	self._vBar = bar
	if self._vBar then
		self._vBar:addEventListener(ScrollBar.SCROLL_CHANGED.name, self._onBarChanged, self)
	end
	
	self:_updateBarRange()
	self:_updateBarValue(self._scrollComp:getCurPosX(), self._scrollComp:getCurPosY())
end

---
-- 更新滚动条范围
-- @function [parent=#ScrollView] _updateBarRange
-- 
function ScrollView:_updateBarRange()
	local w, h = self._scrollComp:getScrollSize()
	
	if self._vBar then
		if h>0 then
			self._vBar:setValueRange(0, h)
		else
			self._vBar:setValueRange(h, 0)
		end
	end
	
	if self._hBar then
		if w>0 then
			self._hBar:setValueRange(0, w)
		else
			self._hBar:setValueRange(w, 0)
		end
	end
end

---
-- 更新滚动条值
-- @function [parent=#ScrollView] _updateBarValue
-- @param #number x 水平方向值
-- @param #number y 垂直方向值
-- 
function ScrollView:_updateBarValue(x, y)
	
	if self._vBar then
		self._vBar:setValue(y, false)
	end
	
	if self._hBar then
		self._hBar:setValue(x, false)
	end
end

---
-- 滚动条改变
-- @function [parent=#ScrollView] _onBarChanged
-- @param self
-- @param ui.ScrollBar#SCROLL_CHANGED event 事件
-- 
function ScrollView:_onBarChanged( event )
	if event.target==self._vBar then
		self:scrollToPos(-self._scrollComp:getCurPosX(), event.value, false)
	elseif event.target==self._hBar then
		self:scrollToPos(-event.value, self._scrollComp:getCurPosY(), false)
	end
end

---
-- 清理
-- @function [parent=#ScrollView] onCleanup
-- @param self
-- 
function ScrollView:onCleanup()
	ScrollView.super.onCleanup(self)
	
	local ScrollBar = require("ui.ScrollBar")
	if self._vBar then
		self._vBar:removeEventListener(ScrollBar.SCROLL_CHANGED.name, self._onBarChanged)
	end
	if self._hBar then
		self._hBar:removeEventListener(ScrollBar.SCROLL_CHANGED.name, self._onBarChanged)
	end
	
	self._vBar = nil
	self._hBar = nil
end

---
-- 添加触摸侦听处理
-- @function [parent=#ScrollView] addTouchListener
-- @param #function handler 处理器
-- @param #table owner 处理器所属
-- 
function ScrollView:addTouchListener(handler, owner)
	local ScrollComponent = require("ui.ScrollComponent")
	self._scrollComp:addEventListener(ScrollComponent.TOUCHED.name, handler, owner)
end

---
-- 移除触摸侦听处理
-- @function [parent=#ScrollView] removeTouchListener
-- @param #function handler 处理器
-- @param #table owner 处理器所属
-- 
function ScrollView:removeTouchListener(handler, owner)
	local ScrollComponent = require("ui.ScrollComponent")
	self._scrollComp:removeEventListener(ScrollComponent.TOUCHED.name, handler, owner)
end

---
-- 设置平滑滚动
-- @function [parent=#ScrollView] setSmoothScroll
-- @param #bool smooth
-- 
function ScrollView:setSmoothScroll(smooth)
	self._scrollComp:setSmoothScroll(smooth)
end

---
-- 设置是否可选
-- @function [parent=#ScrollView] setSelectable
-- @param self
-- @param #boolean value 是否可选
-- 
function ScrollView:setSelectable( value )
	if self._selectable==value then return end
	
	if not value then
		self:clearSelect()
	end
	
	self._selectable = value
end

---
-- 是否可选
-- @function [parent=#ScrollView] isSelectable
-- @param self
-- @return #boolean 是否可选
-- 
function ScrollView:isSelectable()
	return self._selectable
end

---
-- 设置是否多选
-- @function [parent=#ScrollView] setMultiSelection
-- @param self
-- @param #boolean value 是否多选
-- 
function ScrollView:setMultiSelection( value )
	if self._multiSelection==value then return end
	
	-- 转换选项的存储方式
	if self._selects then
		if value then
			self._selects = {self._selects}
		else
			local firstSel
			for item, _ in pairs(self._selects) do
				if not firstSel then
					firstSel = item
				else
					if self._selectByIndex then
						item = self:getItemAt(item)
					end
					if item.setSelect then
						item:setSelect(false)
					end
				end
			end
			self._selects = firstSel
		end
	end
	
	self._multiSelection = value
end

---
-- 是否多选
-- @function [parent=#ScrollView] isMultiSelection
-- @param self
-- @return #boolean 是否多选
-- 
function ScrollView:isMultiSelection()
	return self._multiSelection
end

---
-- 取选择的子项,多选的话，返回子项映射表，否则返回子项
-- @function [parent=#ScrollView] getSelects
-- @param self
-- @return #table 子项映射表或单个子项
-- 
function ScrollView:getSelects()
	return self._selects
end

---
-- 设置子项选中
-- @function [parent=#ScrollView] setSelect
-- @param self
-- @param #table item 子项
-- 
function ScrollView:setSelect( item )
	if not item or not self._selectable then return end
	
	-- 单选
	if not self._multiSelection then
		local oldItem = self._selects
		local realItem = item
		
		if self._selectByIndex then
			oldItem = self:getItemAt(oldItem)
			realItem = self:getItemAt(item)
		end
		
		if oldItem and oldItem.setSelect then
			oldItem:setSelect(false)
		end
		
		if realItem and realItem.setSelect then
			realItem:setSelect(true)
		end
		
		self._selects = item
		return
	end
	
	-- 多选
	if not self._selects then
		self._selects = {}
	end
	
	if self._selects[item] then return end
	
	local realItem = item
	if self._selectByIndex then
		realItem = self:getItemAt(item)
	end
	
	if realItem.setSelect then
		realItem:setSelect(true)
	end
	
	self._selects[item] = true
end

---
-- 切换选中或不选中状态
-- @function [parent=#ScrollView] switchSelect
-- @param self
-- @param #table item 子项
-- 
function ScrollView:switchSelect( item )
	if self:isSelected(item) then
		self:clearSelect({item})
	else
		self:setSelect(item)
	end
end

---
-- 子项是否选中
-- @function [parent=#ScrollView] isSelected
-- @param self
-- @param #table item 子项
-- 
function ScrollView:isSelected( item )
	if not item or not self._selects then return end
	
	-- 单选
	if not self._multiSelection then
		return self._selects==item
	end
	
	-- 多选
	return self._selects[item]
end

---
-- 清除选项
-- @function [parent=#ScrollView] clearSelects
-- @param self
-- @param #table items 清除的项，如果是nil，则清空所有项
-- @param #boolean updateView 是否更新子项视图，默认为是
-- 
function ScrollView:clearSelect( items, updateView )
	if not self._selects then return end
	
	updateView = updateView==nil and true or updateView
	
	-- 单选
	if not self._multiSelection then
		if not items or self._selects==items[1] then
			local item = self._selects
			if self._selectByIndex then
				item = self:getItemAt(item)
			end
	
			if updateView and item and item.setSelect then
				item:setSelect(false)
			end
			
			self._selects = nil
		end
		return
	end
	
	-- 多选
	if not items then
		if updateView then
			for item, _ in pairs(self._selects) do
				if self._selectByIndex then
					item = self:getItemAt(item)
				end
			
				if item and item.setSelect then
					item:setSelect(false)
				end
			end
		end
		self._selects = nil
		return
	end
	
	local item, realItem
	for i=1, #items do
		item = items[i]
			
		if updateView and self._selects[item] then
			realItem = item
		
			if self._selectByIndex then
				realItem = self:getItemAt(item)
			end
			
			if realItem and realItem.setSelect then
				realItem:setSelect(false)
			end
		end
		self._selects[item] = nil
	end
end

---
--获取容器的最终坐标X
--@function [parent=#ScrollView] getContainerEndX
--@param self
--@return #number
--
function ScrollView:getContainerEndX()
	return self._containerEndX
end

---
--获取容器的最终坐标Y
--@function [parent=#ScrollView] getContainerEndX
--@param self
--@return #number
--
function ScrollView:getContainerEndY()
	return self._containerEndY
end

---
-- 设置滚动阀值
-- @function [parent=#ScrollView] setScrollThreshold
-- @param self
-- @param #number t 阀值
--
function ScrollView:setScrollThreshold( t )
	self._scrollComp:setScrollThreshold( t )
end

---
-- 获取滚动宽度为0时是否自动对齐
-- @function [parent=#ScrollView] isSnapWhenNoScrollWidth
-- @param self
-- @return #boolean
-- 
function ScrollView:isSnapWhenNoScrollWidth()
	return self._scrollComp:isSnapWhenNoScrollWidth()
end

---
-- 获取滚动宽度为0时是否自动对齐
-- @function [parent=#ScrollView] isSnapWhenNoScrollWidth
-- @param self
-- @return #boolean
-- 
function ScrollView:isSnapWhenNoScrollHeight()
	return self._scrollComp:isSnapWhenNoScrollHeight()
end

---
-- 设置滚动宽度为0时是否自动对齐
-- @function [parent=#ScrollView] setSnapWhenNoScrollWidth
-- @param self
-- @param #boolean snap
-- 
function ScrollView:setSnapWhenNoScrollWidth(snap)
	 self._scrollComp:setSnapWhenNoScrollWidth(snap)
end

---
-- 设置滚动宽度为0时是否自动对齐
-- @function [parent=#ScrollView] setSnapWhenNoScrollHeight
-- @param self
-- @param #boolean snap
-- 
function ScrollView:setSnapWhenNoScrollHeight(snap)
	 self._scrollComp:setSnapWhenNoScrollHeight(snap)
end