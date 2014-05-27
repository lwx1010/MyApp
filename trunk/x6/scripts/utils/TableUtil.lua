--- 
-- table工具类
-- @module utils.TableUtil
-- 

local ipairs = ipairs
local pairs = pairs
local table = require("table")
local require = require

local moduleName = "utils.TableUtil"
module(moduleName)


--- 
-- 查找索引
-- @function [parent=#utils.TableUtil] indexOf
-- @param #table arr 数组
-- @param #table obj 要查找的对象
-- @return #number 对象的索引或者nil
-- 
function indexOf( arr, obj )
	if( not arr or not obj ) then return end
	
	for i, v in ipairs(arr) do
		if( v==obj ) then
			return i
		end
	end
end

--- 
-- 查找键
-- @function [parent=#utils.TableUtil] keyOf
-- @param #table tbl 数组
-- @param #table obj 要查找的对象
-- @return #table 对象的key
-- 
function keyOf( tbl, obj )
	if( not tbl or not obj ) then return end
	
	for k, v in pairs(tbl) do
		if( v==obj ) then
			return k
		end
	end
end

--- 
-- 从数组里删除
-- @function [parent=#utils.TableUtil] removeFromArr
-- @param #table arr 数组
-- @param #table obj 要查找的对象
-- @return #number 对象的索引或者nil
-- 
function removeFromArr( arr, obj )
	if( not arr or not obj ) then return end
	
	for i, v in ipairs(arr) do
		if( v==obj ) then
			table.remove(arr, i)
			return i
		end
	end
end

---
-- 判断表是否为空
-- @function [parent=#utils.TableUtil] tableIsEmpty
-- @param #table t
-- @return #bool  
-- 
function tableIsEmpty(t)
	if not t then
		return true
	end
	
	local _G = require("_G")
	return _G.next( t ) == nil
end

---
-- 计算表里面有多少个元素
-- @function [parent=#utils.TableUtil] tableElemCount
-- @param #table t
-- @return #number
--   
function tableElemCount(t)
	local num = 0
	for k, v in pairs(t) do
		num = num + 1		
	end
	return num
end

