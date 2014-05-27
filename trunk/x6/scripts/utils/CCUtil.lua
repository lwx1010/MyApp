--- 
-- cocos2d 工具类
-- @module utils.CCUtil
-- 

local tolua = tolua

local moduleName = "utils.CCUtil"
module(moduleName)


--- 
-- 将ccArray转换为table
-- @function [parent=#utils.CCUtil] ccArrayToTable
-- @param #ccArray arr 数组
-- @param #string castToType 要转为的类型
-- @return #table
-- 
function ccArrayToTable( arr, castToType )
	if( not arr ) then return {} end

	local tbl = {}
	local cnt = arr:count()

	if( castToType and #castToType>0 ) then
		for i=1,cnt do
			tbl[i] = tolua.cast(arr:objectAtIndex(i-1), castToType)
		end
	else
		for i=1,cnt do
			tbl[i] = arr:objectAtIndex(i-1)
		end
	end

	return tbl
end

--- 
-- 将CCDictionary转换为table
-- @function [parent=#utils.CCUtil] ccdictToTable
-- @param #CCDictionary dict 字典
-- @param #boolean strKey 是否字符串键，默认为true
-- @param #string castToType 要转为的类型
-- @return #table
-- 
function ccdictToTable( dict, strKey, castToType )
	if( not dict ) then return {} end
	
	strKey = strKey==nil and true or strKey

	local tbl = {}
	
	local keyArr = dict:allKeys()
	local cnt = keyArr:count()
	local key

	if castToType and #castToType>0 then
		for i=1,cnt do
			key = keyArr:objectAtIndex(i-1)
			key = strKey and tolua.cast(key, "CCString"):getCString() or tolua.cast(key, "CCInteger"):getValue()
			tbl[key] = tolua.cast(dict:objectForKey(key), castToType)
		end
	else
		for i=1,cnt do
			key = keyArr:objectAtIndex(i-1)
			key = strKey and tolua.cast(key, "CCString"):getCString() or tolua.cast(key, "CCInteger"):getValue()
			tbl[key] = dict:objectForKey(key)
		end
	end

	return tbl
end