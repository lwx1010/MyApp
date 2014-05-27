---
-- 排行榜协议处理
-- @module protocol.handler.RankHandler
-- 

local require = require
local printf = printf
local pairs = pairs

local dump = dump

local modalName = "protocol.handler.RankHandler"
module(modalName)


local GameNet = require("utils.GameNet")

---
-- 排行榜列表信息
--  
GameNet["S2c_ranklist_info"] = function( pb )
	if not pb then return end
	
	local RankData = require("model.RankData")
	RankData.constructData(pb)
	
--	local RankView = require("view.rank.RankView")
--	if RankView.instance then
--		RankView.instance:showRankList( pb )
--		-- 隐藏加载动画
--		local NetLoading = require("view.notify.NetLoading")
--		NetLoading.hide()
--	end
end

---
-- 排行榜个人基础信息
--
GameNet["S2c_ranklist_selfinfo"] = function( pb )
	if not pb then return end 
	
	local RankData = require("model.RankData")
	RankData.constructRank(pb)
--	local RankView = require("view.rank.RankView")
--	if RankView.instance then
--		RankView.instance:showBaseInfo(pb)
--	end
end

---
-- 排行榜切磋冷却时间
--
GameNet["S2c_ranklist_fight_time"] = function( pb )
	local RankView = require("view.rank.RankView")
	if RankView.instance then
		RankView.instance:updateFightTime(pb.fight_time)
	end
end

---
-- 排行榜结算
-- 
GameNet["S2c_ranklist_fight_result"] = function(pb)

	--战斗结果信息
	pb.structType = {}
	pb.structType.name = "S2c_ranklist_fight_result"
    local fightEva = require("view.fight.FightEvaluate")
    fightEva.push(pb)
end
