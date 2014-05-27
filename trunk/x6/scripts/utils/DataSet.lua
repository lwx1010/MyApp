--- 
-- 数据集
-- 数据变更时派发时间
-- @module utils.DataSet
-- 

local class = class
local printf = printf
local require = require
local table = table
local ipairs = ipairs

local moduleName = "utils.DataSet"
module(moduleName)

---
-- @type CHANGED
-- @field #string name CHANGED
-- @field #number beginIndex 开始位置
-- @field #number endIndex 结束位置
-- 

--- 
-- 数据集改变
-- @field [parent=#utils.DataSet] #CHANGED CHANGED
-- 
CHANGED = {name="CHANGED"}

---
-- @type ITEM_UPDATED
-- @field #string name ITEM_UPDATED
-- @field #number index 索引
-- @field #table item 数据项
-- 

--- 
-- 数据项更新
-- @field [parent=#utils.DataSet] #ITEM_UPDATED ITEM_UPDATED
-- 
ITEM_UPDATED = {name="ITEM_UPDATED"}

--- 
-- 类定义
-- @type DataSet
-- 

---
-- DataSet
-- @field [parent=#utils.DataSet] #DataSet DataSet
-- 
DataSet = class(moduleName, function()
	local EventProtocol = require("framework.client.api.EventProtocol")
	return EventProtocol.extend({})
end)

---
-- 数组
-- @field [parent=#DataSet] #DataSet _arr
-- 
DataSet._arr = nil

---
-- 是否派发事件
-- @field [parent=#DataSet] #DataSet _enableEvent
-- 
DataSet._enableEvent = true

--- 
-- 创建实例
-- @function [parent=#utils.DataSet] new
-- @return #DataSet
-- 
function new()
	return DataSet.new()
end

--- 
-- 构造函数
-- @function [parent=#DataSet] ctor
-- @param self
-- 
function DataSet:ctor()
	self._arr = {}
end

--- 
-- 取长度
-- @function [parent=#DataSet] getLength
-- @param self
-- @return #number
-- 
function DataSet:getLength()
	return #self._arr
end

--- 
-- 取数组
-- @function [parent=#DataSet] getArray
-- @param self
-- @return #table
-- 
function DataSet:getArray()
	return self._arr
end

--- 
-- 设置数组.
-- 直接赋值，不clone
-- @function [parent=#DataSet] setArray
-- @param self
-- @param #table arr 数组
-- 
function DataSet:setArray( arr )
	self._arr = arr or {}
	self:dispatchChangedEvent()
end

--- 
-- 添加数据项
-- @function [parent=#DataSet] addItem
-- @param self
-- @param #table item 数据项
-- 
function DataSet:addItem( item )
	local pos = #self._arr+1
	self._arr[pos] = item
	self:dispatchChangedEvent(pos, pos)
end

--- 
-- 在特定位置添加数据项
-- @function [parent=#DataSet] addItemAt
-- @param self
-- @param #table item 数据项
-- @param #number pos 位置
-- 
function DataSet:addItemAt( item, pos )
	if( pos<1 or pos>#self._arr+1 ) then
		printf("DataSet:addItemAt 位置错误：%d", pos)
		return
	end
	
	table.insert(self._arr, pos, item)
	self:dispatchChangedEvent(pos)
end

--- 
-- 移除数据项
-- @function [parent=#DataSet] removeItem
-- @param self
-- @param #table item 数据项
-- 
function DataSet:removeItem( item )
	for i, v in ipairs(self._arr) do
		if( v==item ) then
			table.remove(self._arr, i)
			self:dispatchChangedEvent(i)
			return
		end
	end
end

--- 
-- 移除特定位置的数据项
-- @function [parent=#DataSet] removeItemAt
-- @param self
-- @param #number pos 位置
-- @return #table 移除的数据项
-- 
function DataSet:removeItemAt( pos )
	if( pos<1 or pos>#self._arr ) then
		printf("DataSet:removeItemAt 位置错误：%d", pos)
		return
	end
	
	local old = self._arr[pos]
	table.remove(self._arr, pos)
	self:dispatchChangedEvent(pos)
	
	return old
end

--- 
-- 移除所有数据项
-- @function [parent=#DataSet] removeAll
-- @param self
-- 
function DataSet:removeAll( )
	self._arr = {}
	self:dispatchChangedEvent()
end

--- 
-- 取特定位置的数据项
-- @function [parent=#DataSet] getItemAt
-- @param self
-- @param #number pos 位置
-- @return #table 数据项
-- 
function DataSet:getItemAt( pos )
	if( pos<1 or pos>#self._arr ) then
		printf("DataSet:getItemAt 位置错误：%d %d", pos, #self._arr)
		return
	end
	
	return self._arr[pos]
end

--- 
-- 取数据项的索引
-- @function [parent=#DataSet] getItemIndex
-- @param self
-- @param #table item 数据项
-- @return #number 索引
-- 
function DataSet:getItemIndex( item )
	for i, v in ipairs(self._arr) do
		if( v==item ) then
			return i
		end
	end
end

--- 
-- 替换数据项
-- @function [parent=#DataSet] setItem
-- @param self
-- @param #table newItem 新数据项
-- @param #table oldItem 旧数据项
-- 
function DataSet:setItem( newItem, oldItem )
	for i, v in ipairs(self._arr) do
		if( v==oldItem ) then
			self._arr[i] = newItem
			self:dispatchChangedEvent(i, i)
			return
		end
	end
end

--- 
-- 替换特定位置的数据项
-- @function [parent=#DataSet] setItemAt
-- @param self
-- @param #table newItem 新数据项
-- @param #number pos 位置
-- @return #table 旧数据项
-- 
function DataSet:setItemAt( newItem, pos )
	if( pos<1 or pos>#self._arr ) then
		printf("DataSet:setItemAt 位置错误：%d", pos)
		return
	end
	
	local old = self._arr[pos]
	self._arr[pos] = newItem
	self:dispatchChangedEvent(pos, pos)
	
	return old
end

--- 
-- 启用事件
-- @function [parent=#DataSet] enableEvent
-- @param self
-- @param #boolean e 是否启用
-- 
function DataSet:enableEvent( e )
	self._enableEvent = e
end

--- 
-- 是否启用事件
-- @function [parent=#DataSet] isEventEnabled
-- @param self
-- @return #boolean
-- 
function DataSet:isEventEnabled( )
	return self._enableEvent
end

--- 
-- 派发更新事件
-- @function [parent=#DataSet] dispatchChangedEvent
-- @param self
-- @param #number beginIndex 开始位置
-- @param #number endIndex 结束位置
-- 
function DataSet:dispatchChangedEvent( beginIndex, endIndex )
	if( not self._enableEvent ) then return end
	
	CHANGED.beginIndex = beginIndex or 1
	CHANGED.endIndex = endIndex or #self._arr
	self:dispatchEvent(CHANGED)
end

--- 
-- 数据项更新
-- 派发数据项更新事件
-- @function [parent=#DataSet] itemUpdated
-- @param self
-- @param #table item 数据项
-- 
function DataSet:itemUpdated( item )
	if( not self._enableEvent ) then return end
	
	if( not self:hasListener(ITEM_UPDATED.name) ) then return end
	
	for i, v in ipairs(self._arr) do
		if( v==item ) then
			ITEM_UPDATED.index = i
			ITEM_UPDATED.item = item
			self:dispatchEvent(ITEM_UPDATED)
			return
		end
	end
end

--- 
-- 特定位置的数据项更新
-- 派发数据项更新事件
-- @function [parent=#DataSet] itemUpdatedAt
-- @param self
-- @param #number pos 位置
-- 
function DataSet:itemUpdatedAt( pos )
	if( not self._enableEvent ) then return end
	
	if( not self:hasListener(ITEM_UPDATED.name) ) then return end
	
	if( pos<1 or pos>#self._arr ) then
		printf("DataSet:itemUpdatedAt 位置错误：%d", pos)
		return
	end
	
	ITEM_UPDATED.index = pos
	ITEM_UPDATED.item = self._arr[pos]
	self:dispatchEvent(ITEM_UPDATED)
end