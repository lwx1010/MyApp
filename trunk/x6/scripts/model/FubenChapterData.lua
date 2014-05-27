---
-- 副本章节数据
-- @module model.FubenChapterData
-- 

local require = require

local printf = printf
local tr = tr

local moduleName = "model.FubenChapterData" 
module(moduleName)

 
---
-- 章节数据集
-- @field [parent = #model.FubenChapterData] #DataSet _chapterDataArray
--
local _chapterDataArray = require("utils.DataSet").new()

---
-- 当前章节的数据，如果点击进入章节和当前章节不同，则需要刷新数据
-- @field [parent = #model.FubenChapterData] #number CurrSectionData
-- 
CurrSectionData = 0

---
-- 记录副本当前最新关卡
-- @field [parent = #model.FubenChapterData] #number LastItemNo
-- 
LastItemNo = 0

---
-- 记录当前玩家选中副本激活的关卡
-- @field [parent = #model.FubenChapterData] #number ActiveItemNo
-- 
ActiveItemNo = 0

---
-- 上一次战斗的人物ID
-- @field [parent = #model.FubenChapterData] #number LastBattleEnemyId
-- 
LastBattleEnemyId = 0

---
-- 保存上一次scrollview的x坐标
-- @field [parent = #model.FubenChapterData] #number LastHCBoxX
-- 
LastHCBoxX = 0

---
-- 记录大地图的X坐标
-- @field [parent = #model.FubenChapterData] #number LastChapterMapX
-- 
LastChapterMapX = 0

---
-- 记录非最新的激活数据
-- @field [parent = #model.FubenChapterData] #number NotNewActiveItemNo
-- 
NotNewActiveItemNo = nil

---
-- 添加数据项
-- @function [parent = #model.FubenChapterData] addChapterItem
-- @param #table 章节信息
-- 
function addChapterItem(item)
	_chapterDataArray:addItem(item)
end

---
-- 获取数据
-- @function [parent = #model.FubenChapterData] getData
-- 
function getData()
	return _chapterDataArray
end

---
-- 获取数据长度
-- @function [parent = #model.FubenChapterData] getDataLength
-- @return #number 
-- 
function getDataLength()
	return _chapterDataArray:getLength()
end

---
-- 是否是空的
-- @function [parent = #model.FubenChapterData] isEmpty
-- 
function isEmpty()
	if _chapterDataArray:getLength() == 0 then
		return true
	else
		return false
	end
end

---
-- 清空数据
-- @function [parent = #model.FubenChapterData] clear
-- 
function clear()
	printf(tr("清空了数据"))
	_chapterDataArray:removeAll()
end 

---
-- 初始化数据
-- @function [parent = #model.FubenChapterData] initFubenChapterData
-- 
function initFubenChapterData()
	CurrSectionData = 0 
	LastItemNo = 0 
	ActiveItemNo = 0 
	LastBattleEnemyId = 0 
	LastHCBoxX = 0 
	LastChapterMapX = 0 
	NotNewActiveItemNo = nil
end


