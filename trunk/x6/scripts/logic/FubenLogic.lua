---
-- 副本handler数据
-- @module logic.FubenLogic
--

local require = require

local printf = printf
local dump = dump

local moduleName = "logic.FubenLogic"
module(moduleName)


---
-- 判断这个章节是否完成
-- @field [parent = #logic.FubenLogic] #number isOpen
-- 
local isOpen = 0

---
-- 一个章节的最大星星数
-- @field [parent = #logic.FubenLogic] #number ONE_CHAPTER_SCORE
-- 
ONE_CHAPTER_SCORE = 3

---
-- 篇章对应的章节表   格式 section -> chapter
-- @field [parent = #logic.FubenLogic] #table FubenSecChapterTable
-- 
FubenSecChapterTable = {}

---
-- 章节完成信息， 只判断章节有没有完成 格式 chapterno - isfinish  nil --- 1
-- @field [parent = #logic.FubenLogic] #table FubenChapterInfoTable
--
FubenChapterInfoTable = {}

---
-- 副本敌人信息，包含所有篇章的敌人信息
-- @field [parent = #logic.FubenLogic] #table FubenEnemyTable
-- 
FubenEnemyTable = {}

---
-- 副本章节是否有奖励记录 格式      chapterno->isreward(num)
-- @field [parent = #logic.FubenLogic] #table FubenRewardStateTable 
--
FubenRewardStateTable = {}

---
-- 玩家正在进行到的章节
-- @field [parent = #logic.FubenLogic] #number PlayerCurrChapter
-- 
PlayerCurrChapter = 0

---
-- 玩家进入的章节
-- @field [parent = #logic.FubenLogic] #number PlayerEnterChapter
-- 
PlayerEnterChapter = 0

---
-- 记录上次章节
-- @field [parent = #logic.FubenLogic] #number LastChapterNo
-- 
PlayerLastChapterNo = 0

---
-- 玩家当前章节的星星数
-- @field [parent = #logic.FubenLogic] #number EnterChapterCurrScore
-- 
EnterChapterCurrScore = 0

---
-- 玩家当前章节的总星星数
-- @field [parent = #logic.FubenLogic] #number EnterChapterAllScore
-- 
EnterChapterAllScore = 0

---
-- 判断是否可以进入章节
-- @function [parent = #logic.FubenLogic] isEnableEnterChapter
-- @param #number chapterNum 章节号码
-- @return #bool 
-- 
function isEnableEnterChapter(chapterNum)
	--dump(FubenChapterInfoTable)
	local lastChapterNum = chapterNum - 1
	--printf(lastChapterNum)
	--printf(chapterNum)
	if FubenChapterInfoTable[lastChapterNum] == nil then
		--printf("nil")
		return true
	end
	
	if FubenChapterInfoTable[lastChapterNum] == 1 then --已完成
		--printf("finish") 
		if FubenChapterInfoTable[chapterNum] ~= 1 then --说明该章节是最新章节
			 PlayerCurrChapter = chapterNum
		end
		return true
	else
		--printf("not finish")
		return false
	end
end

---
-- 更新章节的信息， 敌人数据，敌人是否完成，星星数，次数等
-- @function [parent = #logic.FubenLogic] updateFubenChapterItem
-- 
function updateFubenChapterItem()
	local fubenChapterData = require("xls.FubenChapterXls").data
	local fubenEnemyMsg = require("xls.FubenEnemyXls").data
	local chapterData = require("model.FubenChapterData")
	
	if PlayerEnterChapter == 0 then
		return
	end
	
	chapterData.clear()
	printf("PlayerEnterChapter = "..PlayerEnterChapter)
	local enemyTable = fubenChapterData[PlayerEnterChapter].Enemy
	
	EnterChapterAllScore = ONE_CHAPTER_SCORE * #enemyTable
	EnterChapterCurrScore = 0
	local addEnemyTable = {}
	for i = 1, #enemyTable do
		local enemyId = enemyTable[i]
		local enemyMsg = fubenEnemyMsg[enemyId]
		addEnemyTable[#addEnemyTable + 1] = enemyMsg
		
		--dump(FubenEnemyTable)
		if FubenEnemyTable[enemyId] then
			if FubenEnemyTable[enemyId].isFinish == 0 then
				--添加最新副本激活
        		local fubenChapterView = require("view.fuben.FubenChapterView")
        		--local currNo = fubenChapterView:getActiveItemNo()
        		--printf("currNo = "..i)
        		fubenChapterView.setActiveItemNo(i)
        		fubenChapterView.setLastItemNo(i)
        		
				if i < #enemyTable then
					addEnemyTable[#addEnemyTable + 1] = fubenEnemyMsg[enemyId + 1]
				end
				break
			end
		
			if FubenEnemyTable[enemyId].isFinish == 1 then
				if i == #enemyTable then
					local passTl = {}
					passTl.showPassCell = true
					addEnemyTable[#addEnemyTable + 1] = passTl
				end
			end
		
			EnterChapterCurrScore = EnterChapterCurrScore + FubenEnemyTable[enemyId].score
		end 
	end	
	
	-- 排序
	local table = require("table")	
	local function sort(a, b)
		return a.rowno < b.rowno
	end
	
	local savePassTl = addEnemyTable[#addEnemyTable] --passTl没有rowno字段
	addEnemyTable[#addEnemyTable] = nil  -- 先暂时排除passTl

	table.sort(addEnemyTable, sort)
	addEnemyTable[#addEnemyTable + 1] = savePassTl
	
	for i = 1, #addEnemyTable do
		addEnemyTable[i].itemSortNo = i
		chapterData.addChapterItem(addEnemyTable[i])
	end
	
	--printf("PlayerCurrChapter = "..PlayerCurrChapter)
end

---
-- 判断现在进入的章节和上次的章节是否相同，作一些刷新
-- @function [parent = #logic.FubenLogic] isSameChapter
-- 
function isSameChapter()
	if PlayerEnterChapter == PlayerLastChapterNo then 
		return true
	else
		PlayerLastChapterNo = PlayerEnterChapter
		return false
	end
end

---
-- 判断进入章节是否完成
-- @function [parent = #logic.FubenLogic] isEnterChapterFinish
-- @return #bool
function isEnterChapterFinish()
	return FubenChapterInfoTable[PlayerEnterChapter]
end

---
-- 清除副本信息
-- @function [parent = #logic.FubenLogic] clearFubenMsg
-- 
function clearFubenMsg()
	FubenSecChapterTable = {}
	FubenChapterInfoTable = {}
	FubenEnemyTable = {}
	FubenRewardStateTable = {}
end

---
-- 添加重启事件监听
-- @function [parent = #logic.FubenLogic] addRestartAppListener
-- 
function addRestartAppListener()
	-- 重启应用事件
	local EventCenter = require("utils.EventCenter")
	local Events = require("model.event.Events")
	EventCenter:addEventListener(Events.APP_RESTART.name, clearFubenMsg)
end

---
-- 初始化副本逻辑数据
-- @function [parent = #logic.FubenLogic] initFubenLogicData
--
function initFubenLogicData()
	isOpen = 0
	FubenSecChapterTable = {}
	FubenChapterInfoTable = {}
	FubenEnemyTable = {}
	FubenRewardStateTable = {}
	PlayerCurrChapter = 0
	PlayerEnterChapter = 0
	PlayerLastChapterNo = 0
	EnterChapterCurrScore = 0
	EnterChapterAllScore = 0
end