--- 
-- Number工具类
-- @module utils.NumberUtil
-- 

local string = string
local table = table
local printf = printf
local tr = tr
local tostring = tostring
local require = require


local moduleName = "utils.NumberUtil"
module(moduleName)

--- 
-- 获取银两（超过1w之后显示xxx万）
-- @function [parent=#utils.NumberUtil] numberForShort
-- @param #number num
-- @return #string
-- 
function numberForShort( num )
	local ret
	local math = require("math")
	if string.len(tostring(num)) > 4  then
		ret = "" .. math.floor(num/10000) .. tr("万")
	else
		ret = "" .. num
	end
	
	return ret
end

---
-- 把秒数转化为时间 00:00:00
-- @function [parent=#NumberUtil] secondToDate
-- @param #number time
-- @return #string
-- 
function secondToDate( time )
	local ret
	if not time then return "" end
	
	local math = require("math")
	local second = time % 60
	local minute = (math.floor(time / 60)) % 60
	local hour = math.floor(time / 60 / 60	)
	
	ret = string.format("%02d:%02d:%02d", hour, minute, second)
	return ret
end

---
-- 把秒数转化为时间  00:00
-- @function [parent=#NumberUtil] secondToDate
-- @param #number time
-- @return #string
-- 
function secondToDate2( time )
	local ret
	if not time then return "" end
	
	local math = require("math")
	local second = time % 60
	local minute = (math.floor(time / 60)) % 60
	
	ret = string.format("%02d:%02d", minute, second)
	return ret
end

