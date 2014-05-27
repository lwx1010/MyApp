--- 
-- 屏蔽字
-- @module utils.SensitiveWord
-- 

local string = string
local require = require
local printf = printf

local moduleName = "utils.SensitiveWord"
module(moduleName)

--- 
-- 屏蔽字
-- @field [parent=#SensitiveWord] #table _words
-- 
local _words = {
	"毛泽东","周恩来","刘少奇","朱德","彭德怀","林彪","刘伯承","陈毅","贺龙","聂荣臻","徐向前","罗荣桓",
	"叶剑英","李大钊","陈独秀","孙中山","孙文","孙逸仙","邓小平","陈云","江泽民","李鹏","朱镕基","李瑞环",
	"尉健行","李岚清","胡锦涛","罗干","温家宝","吴邦国","曾庆红","贾庆林","黄菊","吴官正","李长春","吴仪",
	"回良玉","曾培炎","周永康","曹刚川","唐家璇","华建敏","陈至立","陈良宇","张德江","张立昌","俞正声","王乐泉",
	"刘云山","王刚","王兆国","刘淇","贺国强","郭伯雄","胡耀邦","王乐泉","王兆国","周永康","李登辉","连战","陈水扁",
	"宋楚瑜","吕秀莲","郁慕明","蒋介石","蒋中正","蒋经国","马英九","习近平","李克强","吴帮国","无帮国","无邦国",
	"无帮过","瘟家宝","假庆林","甲庆林","假青林","离长春","习远平","袭近平","李磕墙","贺过墙","和锅枪","粥永康",
	"轴永康","肘永康","周健康","粥健康","周小康","钓鱼岛","尖阁列岛","赌场",
}

---
-- 替换屏蔽字
-- @function [parent=#SensitiveWord] filter
-- @string str
-- @string replacement
-- @return #string
-- 
function filter(str, replacement)
	if not str or #str == 0 then return "" end
	
	local len = #_words
	
	if not replacement then
		replacement = "*"
	end
	
	for i = 1, len do
		local word = _words[i]
		str = string.gsub(str, word, replacement)
	end
	
	return str
end

--- 
-- 判断str中是否有敏感词
-- @function [parent=#SensitiveWord] isSensitive
-- @return #boolean
-- 
function isSensitive( str )
	if not str or #str == 0 then return false end
	
	local len = #_words
	for i = 1, len do
		local word = _words[i]
		if string.find(str, word) then
			return true
		end 
	end
	
	return false
end
