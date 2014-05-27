---
-- 处理副本的协议
-- @module protocol.handler.FubenHandle
--

local require = require
local printf = printf
local dump = dump
local math = math
local tr = tr
local CCSize = CCSize

local moduleName = "protocol.handler.FubenHandler"
module(moduleName)


local GameNet = require("utils.GameNet")

--获取逻辑数据
local fubenLogic = require("logic.FubenLogic")

---
-- 一个篇章的内容
-- 
GameNet["S2c_fuben_chapterlist"] = function(pb)
--	local fubenChapterData = require("model.FubenChapterData")
--	dump(pb)
--	for i = 1, #pb.list_info do
--		fubenChapterData.addChapterItem(pb.list_info[i])
--	end
	--local chapterSelectorData = require("model.FubenChapterSelectorData")
	local fubenSecChapTable = require("logic.FubenLogic").FubenSecChapterTable
	local fubenChapterInfoTable = require("logic.FubenLogic").FubenChapterInfoTable
	require("logic.FubenLogic").PlayerCurrChapter = pb.chapterno --当前章节ID
	local section = pb.section
	if fubenSecChapTable[section] == nil then
		fubenSecChapTable[section] = {}
	
		for i = 1, #pb.list_info do
			GameNet.send("C2s_fuben_info", {chapterno = pb.list_info[i].chapterno})
			fubenChapterInfoTable[pb.list_info[i].chapterno] = pb.list_info[i].isfinish
		end
		fubenSecChapTable[section].chapterTable = pb.list_info
		fubenSecChapTable[section].isFinish = pb.isfinish
		fubenSecChapTable[section].isOpen = pb.isopen
		fubenSecChapTable[section].score = pb.score
		
		
	end
	--dump(fubenChapterInfoTable)
	--dump(fubenSecChapTable)
	
	if fubenSecChapTable[2] == nil then
		local fubenMainView = require("view.fuben.FubenMainView")
	    local GameView = require("view.GameView")
		GameView.replaceMainView(fubenMainView.createInstance())
	end
end

---
-- 副本结束后奖励信息
--
GameNet["S2c_fuben_fightend"] = function(pb)
	local fubenSettlement = require("view.fuben.FubenSettlement")
	fubenSettlement.setRewardMsg(pb)
	
	require("view.fight.FightScene").BATTLE_RESULT = pb.iswin
	
	pb.structType = {}
	pb.structType.name = "S2c_fuben_fightend"
	
	--战斗结果信息
    local fightEva = require("view.fight.FightEvaluate")
    fightEva.push(pb)
end

---
-- 章节具体信息
-- 
GameNet["S2c_fuben_info"] = function(pb)
	--dump(pb)
	--dump(_isInit)
	
	local fubenChapterInfoTable = require("logic.FubenLogic").FubenChapterInfoTable
	fubenChapterInfoTable[pb.chapterno] = pb.isfinish
	
	local fubenRewardStateTable = require("logic.FubenLogic").FubenRewardStateTable
	fubenRewardStateTable[pb.chapterno] = pb.isreward
	
	local enemyTable = require("logic.FubenLogic").FubenEnemyTable
	for i = 1, #pb.list_info do
		local enemyId = pb.list_info[i].enemyno
		if enemyTable[enemyId] == nil then
			enemyTable[enemyId]= {}
		end
		
		enemyTable[enemyId].isFinish = pb.list_info[i].isfinish
		enemyTable[enemyId].leftTime = pb.list_info[i].maxtimes - pb.list_info[i].fighttimes
		enemyTable[enemyId].score = pb.list_info[i].score
		enemyTable[enemyId].buytimes = pb.list_info[i].buytimes
		enemyTable[enemyId].maxbuytimes = pb.list_info[i].maxbuytimes
		--
	end
	--dump(enemyTable)
	
	--更新章节信息
	fubenLogic.updateFubenChapterItem()
	
	local fubenMap = require("view.fuben.FubenMapView")
	fubenMap.updateChapter()
end

---
-- 更新章节星星数
-- 
GameNet["S2c_fuben_sectioninfo"] = function(pb)
--	local section = require("view.fuben.FubenMainView").instance
--	if section == nil then
--		section = require("view.fuben.FubenMainView").createInstance()
--	end
--	
--	local pcbox = section:getItemPCBox()
--	local secTable = pcbox:getItemArr()
--	secTable[pb.section]:setStarCount(pb.score)
end

---
-- 显示冷却时间
-- 
GameNet["S2c_fuben_physicaltime"] = function(pb)
	--pb.time
	local fubenChapter = require("view.fuben.FubenChapterView").instance
	if fubenChapter then	
		fubenChapter:setPhyCoolTime(pb.time)
	end
end

---
-- 扫荡结算
-- 
GameNet["S2c_fuben_raids"] = function(pb)
	local hangOutRewardIns = require("view.fuben.FubenHangOutRewardView").createInstance()

	hangOutRewardIns:setTextTl(pb)
		
	local gameView = require("view.GameView")
	gameView.addPopUp(hangOutRewardIns,true)
	gameView.center(hangOutRewardIns)
end


