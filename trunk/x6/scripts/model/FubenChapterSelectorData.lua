---
-- 副本章节选择界面数据
-- @module model.FubenChapterSelectorData
-- 

local require = require

local moduleName = "model.FubenChapterSelectorData" 
module(moduleName)

 
---
-- 数据集
-- @field [parent = #model.FubenChapterSelectorData] #DataSet _chapterSelectorDataArray
--
local _chapterSelectorDataArray = require("utils.DataSet").new()

---
-- 当前章节的数据，如果点击进入章节和当前章节不同，则需要刷新数据
-- @field [parent = #model.FubenChapterSelectorData] #number CurrSectionData
-- 
CurrSectionData = 0

---
-- 添加数据项
-- @function [parent = #model.FubenChapterSelectorData] addChapterSelectorItem
-- @param 图片信息
-- 
function addChapterSelectorItem(item)
	_chapterSelectorDataArray:addItem(item)
end


---
-- 获取数据
-- @function [parent = #model.FubenChapterSelectorData] getData
-- 
function getData()
	return _chapterSelectorDataArray
end

---
-- 是否是空的
-- @function [parent = #model.FubenChapterSelectorData] isEmpty
-- 
function isEmpty()
	if _chapterSelectorDataArray:getLength() == 0 then
		return true
	else
		return false
	end
end

---
-- 清空数据
-- @function [parent = #model.FubenChapterSelectorData] removeAll
-- 
function clear()
	_chapterSelectorDataArray:removeAll()
end 



