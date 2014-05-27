--- 
-- string工具类
-- @module utils.StringUtil
-- 

local string = string
local table = table
local printf = printf

local moduleName = "utils.StringUtil"
module(moduleName)

---
-- utf8字符串长度
-- @function [parent=#utils.StringUtil] utf8len
-- @param #string str 字符串
-- @return #number
-- 
function utf8len( str )
	local _, count = string.gsub(str, "[^\128-\193]", "")
	return count
end

---
-- 取utf8字符数组
-- @function [parent=#utils.StringUtil] utf8Chars
-- @param #string str 字符串
-- @return #table
-- 
function utf8Chars( str )
	local chars = {}
	for uchar in string.gfind(str, "[%z\1-\127\194-\244][\128-\191]*") do 
		chars[#chars+1] = uchar 
	end
	
	return chars
end

---
-- 取utf8字串
-- @function [parent=#utils.StringUtil] utf8sub
-- @param #string str 字符串
-- @param #number i 开始索引
-- @param #number j 结束索引
-- @return #string
-- 
function utf8sub( str, i, j )
	i = i or 1
	j = j or -1
	
	-- only set l if i or j is negative
	local l = (i >= 0 and j >= 0) or utf8len(str)
	local startChar = (i >= 0) and i or l + i + 1
	local endChar = (j >= 0) and j or l + j + 1
	
	-- can't have start before end!
	if startChar > endChar then
		return ""
	end
	
	local subStr = {}
	local curChar = 1
	for uchar in string.gmatch(str, "[%z\1-\127\194-\244][\128-\191]*") do 
		if( startChar>=curChar and curChar<=endChar ) then
			subStr[#subStr+1] = uchar
		end
		curChar = curChar+1
	end
	
	return table.concat(subStr)
end

--- 
-- 串接字符串.
-- 在每个字符中间插入分割字符，生成新字符串
-- @function [parent=#utils.StringUtil] utf8join
-- @param #string str 字符串
-- @param #string sep 分隔符
-- @return #string
-- 
function utf8join( str, sep )
	local chars = utf8Chars(str)
	return table.concat(chars, sep)
end

---
-- utf8字符替换
-- @function [parent=#utils.StringUtil] utf8replace
-- @param #string str 字符串
-- @param #string old 旧字符
-- @param #string new 新字符
-- @return #string
-- 
function utf8replace( str, old, new )
	if( not old or not new ) then return str end
	
	local chars = {}
	for uchar in string.gfind(str, "[%z\1-\127\194-\244][\128-\191]*") do
		chars[#chars+1] = uchar==old and new or old
	end
	
	return table.concat(chars)
end

--- 
-- 串接字符串.
-- 在每个字符中间插入分割字符，生成新字符串
-- @function [parent=#utils.StringUtil] join
-- @param #string str 字符串
-- @param #string sep 分隔符
-- @return #string
-- 
function join( str, sep )
	return string.gsub(str, "(.)", "%1"..sep)
end

---
-- 判断字符串是否以subStr结束
-- @function [parent=#utils.StringUtil] endWith
-- @param #string str 字符串
-- @param #string subStr 子串
-- @return 和string.find的返回值相同
--
function endWith( str, subStr )
    return string.find(str, subStr, #str-#subStr+1)
end

---
-- 解析服务端的字段
-- @function [parent=#utils.StringUtil] subStringToTable
-- @param #string line (str "xxx=ssss&xxxx=131&"类似)
-- @return #table tbl
-- 
function subStringToTable( line )
	if string.len(line) == 0 then return nil end

	local tbl = {} 
	
	local sep = "&"
	local pos = 1   
	local step = 0
	local key
	local value
	while true do   
		local from, to = string.find(line, sep, pos, true)
		step = step + 1
		if from == nil then
			local item = string.sub(line, pos)
			local newfrom, newto = string.find(item, "=", 1)
			if newfrom then 
				key = string.sub(item, 1, newfrom-1)
				value = string.sub(item, newto +1)
				tbl[key] = value
			end
			break
		else
			local item = string.sub(line, pos, from-1)
			local newfrom, newto = string.find(item, "=", 1)
			if newfrom then 
				key = string.sub(item, 1, newfrom-1)
				value = string.sub(item, newto +1)
				tbl[key] = value
			end
			pos = to + 1
		end
	end     
	
	return tbl  
end
