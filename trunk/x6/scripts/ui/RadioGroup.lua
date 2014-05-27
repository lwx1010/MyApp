--- 
-- 单选组
-- @module ui.RadioGroup
-- 

local require = require
local printf = printf
local class = class
local tolua = tolua


local moduleName = "ui.RadioGroup"
module(moduleName)

---
-- @type SEL_CHANGED
-- @field #string name SEL_CHANGED
-- @field #number index 索引
-- 

--- 
-- 选择改变事件
-- @field [parent=#ui.RadioGroup] #SEL_CHANGED SEL_CHANGED
-- 
SEL_CHANGED = {name="SEL_CHANGED"}

--- 
-- 类定义
-- @type RadioGroup
-- 

---
-- RadioGroup
-- @field [parent=#ui.RadioGroup] #RadioGroup RadioGroup
-- 
local RadioGroup = class(moduleName, function()
	local EventProtocol = require("framework.client.api.EventProtocol")
	local display = require("framework.client.display")
	return EventProtocol.extend(display.newNode())
end)

--- 
-- 孩子数组
-- @field [parent=#RadioGroup] #table _childArr
-- 
RadioGroup._childArr = nil

--- 
-- 选择的索引
-- @field [parent=#RadioGroup] #number _selIndex
-- 
RadioGroup._selIndex = nil

---
-- 链接的单选组
-- 链接的单选组也当前单选组保持一样的选项
-- @field [parent=#RadioGroup] #RadioGroup _linkGrp
-- 
RadioGroup._linkGrp = nil

--- 
-- 相关的菜单
-- @field [parent=#RadioGroup] #CCMenu menu
-- 
RadioGroup.menu = nil

--- 
-- 创建实例
-- @function [parent=#ui.RadioGroup] new
-- @param #CCMenu menu 相关的菜单
-- @return #RadioGroup 实例
-- 
function new( menu )
	return RadioGroup.new(menu)
end

--- 
-- 构造函数
-- @function [parent=#RadioGroup] ctor
-- @param self
-- @param #CCMenu menu 相关的菜单
-- 
function RadioGroup:ctor( menu )

	self:addChild(menu)

	self._childArr = {}
	self.menu = menu

	local childArr = menu:getChildren()
	local cnt = childArr and childArr:count() or 0

	local item
	for i=1,cnt do
		item = tolua.cast(childArr:objectAtIndex(i-1), "CCMenuItemToggle")
		item:setTag(i)
		item:setEnabled(true)
		item:setSelectedIndex(0)
		item:registerScriptTapHandler( function(...) self:_itemTapHandler(...) end )

		self._childArr[#self._childArr+1] = item
	end

	-- 选择第一个
	self:setSelectedIndex(1, false)
end

--- 
-- 点击了一项
-- @function [parent=#RadioGroup] _itemTapHandler
-- @param self
-- @param #number tag 点选项的标签
-- @param #CCMenuItemToggle item 选项实例
-- 
function RadioGroup:_itemTapHandler( tag, item )
	self:setSelectedIndex(tag)
end

--- 
-- 设置选择的索引
-- @function [parent=#RadioGroup] setSelectedIndex
-- @param self
-- @param #number idx 索引
-- @param #boolean dispatchEvent 是否派发事件，默认是
-- 
function RadioGroup:setSelectedIndex( idx, dispatchEvent )

	if( not idx ) then return end

	if( idx<1 ) then idx = 1
	elseif( idx>#self._childArr ) then idx = #self._childArr end

	if( self._selIndex==idx ) then return end

	local item;
	if( self._selIndex ) then
		item = self._childArr[self._selIndex]
		if( item ) then
			item:setEnabled(true)
			item:setSelectedIndex(0)
		end
	end

	self._selIndex = idx

	item = self._childArr[self._selIndex]
	item:setEnabled(false)
	item:setSelectedIndex(1)

	-- 派发事件
	if( dispatchEvent or dispatchEvent==nil ) then
		SEL_CHANGED.index = self._selIndex
		self:dispatchEvent(SEL_CHANGED)
	end

	-- 同步选项
	if( self._linkGrp ) then
		self._linkGrp:setSelectedIndex(self._selIndex)
	end
end

--- 
-- 获取选择的索引
-- @function [parent=#RadioGroup] getSelectedIndex
-- @param self
-- @return #number 索引
-- 
function RadioGroup:getSelectedIndex()
	return self._selIndex
end

--- 
-- 设置选择项
-- @function [parent=#RadioGroup] setSelectedItem
-- @param self
-- @param #CCMenuItemToggle item 选择的项
-- @param #boolean dispatchEvent 是否派发事件，默认是
-- 
function RadioGroup:setSelectedItem( item, dispatchEvent )
	for i,v in ipairs(self._childArr) do
		if( v==item ) then
			self:setSelectedIndex(i, dispatchEvent)
			return
		end
	end
end

--- 
-- 获取选择的项
-- @function [parent=#RadioGroup] getSelectedItem
-- @param self
-- @return #CCMenuItemToggle
-- 
function RadioGroup:getSelectedItem()
	if( self._selIndex ) then
		return self._childArr[self._selIndex]
	end
end

--- 
-- 设置链接的单选组
-- @function [parent=#RadioGroup] setLinkCtrl
-- @param self
-- @param #RaidoGroup grp 链接的单选组
-- 
function RadioGroup:setLinkCtrl( grp )
	self._linkGrp = grp

	-- 设置选项
	if( self._linkGrp ) then
		self._linkGrp.menu:setTouchEnabled(false)
		self._linkGrp:setSelectedIndex(self._selIndex)
	end
end

--- 
-- 获取链接的单选组
-- @function [parent=#RadioGroup] getLinkCtrl
-- @param self
-- @return #RadioGroup
-- 
function RadioGroup:getLinkCtrl( )
	return self._linkGrp
end