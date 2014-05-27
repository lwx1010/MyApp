---
-- 道具模块
-- @module model.Item
--

local class = class
local require = require
local printf = printf


local moduleName = "model.Item"
module(moduleName)


--- 
-- 类定义
-- @type Item
-- 

---
-- Item
-- @field [parent=#model.Item] #Item Item
-- 
Item = class(moduleName, require("model.ItemAttr").ItemAttr)

--- 
-- 创建实例
-- @function [parent=#model.Item] new
-- @return #Item 实例
-- 
function new( )
	return Item.new()
end

--- 
-- 构造函数
-- @function [parent=#Item] ctor
-- @param self
-- 
function Item:ctor( )
end