---
-- 武林榜协议处理
-- @module protocol.handler.WuLinHandler
-- 

local require = require
local printf = printf

local modalName = "protocol.handler.WuLinHandler"
module(modalName)


local GameNet = require("utils.GameNet")

---
-- 武林帮玩家界面信息
--  
GameNet["S2c_wulin_info"] = function( pb )
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()
	
	if not pb then return end 
	
	local WuLinBangView = require("view.wulinbang.WuLinBangView")
	if WuLinBangView.instance then
		WuLinBangView.instance:showPlayers( pb.wulin_info, pb.is_change )
	end
end

---
-- 武林榜基础信息
--
GameNet["S2c_wulin_user_info"] = function( pb )
	if not pb then return end 
	
	local WuLinBangView = require("view.wulinbang.WuLinBangView")
	if WuLinBangView.instance then
		WuLinBangView.instance:showBaseInfo(pb)
	end
	
	--能否领取奖励
	local mainView = require("view.main.MainView")
	if mainView.instance then
		if pb.can_reward == 1 then
			mainView.instance:showWulinBangRewardIcon(true)
		else
			mainView.instance:showWulinBangRewardIcon(false)
		end
	end
end

---
-- 点击了购买次数
-- 
GameNet["S2c_wulin_buy_result"] = function( pb )
	if not pb then return end
	
	local WuLinBangView = require("view.wulinbang.WuLinBangView")
	if WuLinBangView.instance then
		WuLinBangView.instance:updateChallengeCnt( pb.pk_num, pb.can_buy_pk == 1, pb.buy_pk_yb )
	end
end

---
-- 点击了pk
-- 
GameNet["S2c_wulin_pk_result"] = function( pb )
	if not pb then return end 
	
	local GameView = require("view.GameView")
	if pb.user_win == 0 then
		local PkLoseView = require("view.wulinbang.PkLoseView")
		PkLoseView.setRewardMsg(pb)
	else
		local PkWinView = require("view.wulinbang.PkWinView")
		PkWinView.setRewardMsg(pb)
	end
	
	pb.structType = {}
	pb.structType.name = "S2c_wulin_pk_result"
	
	--战斗结果信息
    local fightEva = require("view.fight.FightEvaluate")
    fightEva.push(pb)
end