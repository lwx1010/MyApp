---
-- 日常任务协议
-- @module protocol.handler.EverydayTaskHandler
-- 

local require = require
local printf = printf
local os = os
local dump = dump

local moduleName = "protocol.handler.EverydayTaskHandler"
module(moduleName)

local GameNet = require("utils.GameNet")

---
-- 日常任务列表
-- 
GameNet["S2c_dailytask_infolist"] = function( pb )
	if not pb or not pb.list_info then return end
	
	-- 获取任务列表
	local EverydayTaskData = require("model.EverydayTaskData")
	EverydayTaskData.getTaskList(pb.list_info)
end

--- 
-- 主界面图标显示
-- 
GameNet["S2c_randomev_btn"] = function( pb )
	local MainView = require("view.main.MainView")
	if MainView.instance then
		MainView.instance:showQiYuBtn(pb.isshow == 1)
	end
end

---
-- 触发奇遇协议
-- 
GameNet["S2c_randomev_start"] = function( pb )
	local QiYuEnterUi = require("view.qiyu.QiYuEnterUi")
--	if QiYuEnterUi.instance then
--		QiYuEnterUi.instance:setQiYuInfo(pb.info)
--	end

	QiYuEnterUi.setQiYuMsg(pb.info)
	local FightCCBView = require("view.fight.FightCCBView")
	if FightCCBView.isInBattle() then
		return
	else
		local GameView = require("view.GameView")
		GameView.addPopUp(QiYuEnterUi.createInstance(), true)
		GameView.center(QiYuEnterUi.instance)
    	QiYuEnterUi.instance:openUi()
	end
end

---
-- 切磋结算
-- 
GameNet["S2c_qiecuo_result"] = function( pb )
	if not pb then return end
	
	local GameView = require("view.GameView")
	if pb.win_lose == 1 then
		local QieCuoWinView = require("view.qiyu.qiecuo.QieCuoWinView")
		QieCuoWinView.setRewardMsg(pb)
	else
		local QieCuoLoseView = require("view.qiyu.qiecuo.QieCuoLoseView")
		QieCuoLoseView.setRewardMsg(pb)
	end
	
	pb.structType = {}
	pb.structType.name = "S2c_qiecuo_result"
	
	--战斗结果信息
    local fightEva = require("view.fight.FightEvaluate")
    fightEva.push(pb)
end

---
-- 大侠挑战结算
-- 
GameNet["S2c_daxia_result"] = function( pb )
	local ChallengeResultView = require("view.qiyu.challenge.ChallengeResultView")
	ChallengeResultView.setResultInfo(pb.msg)
end

---
-- 百发百中
-- 
GameNet["S2c_baifa_shoot"] = function( pb )
	if not pb then return end
	
	local SheJianView = require("view.qiyu.shejian.SheJianView")
	if SheJianView.instance and SheJianView.instance:getParent() then
		SheJianView.instance:showEnd(pb)
	end
end

---
-- 摇钱树
-- 
GameNet["S2c_yaoqian_play"] = function( pb )
	local CashCowView = require("view.qiyu.cashcow.CashCowView")
	if CashCowView.instance then
		CashCowView.instance:showResult(pb)
		-- 隐藏加载动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.hide()
	end
end

---
-- 猜拳
-- 
GameNet["S2c_caiquan_result"] = function( pb )
	if not pb then return end
	
	local CaiQuanView = require("view.qiyu.caiquan.CaiQuanView")
	if CaiQuanView.instance then
		CaiQuanView.instance:recResult(pb)
	end
end

---
-- 单个奇遇事件信息
-- 
GameNet["S2c_randomev_info"] = function( pb )
	-- 摇钱树
	if pb.info.type == 2 then
		local CashCowView = require("view.qiyu.cashcow.CashCowView")
		if CashCowView.instance then
			CashCowView.instance:showCashCowNum(pb.info)
			-- 隐藏加载动画
			local NetLoading = require("view.notify.NetLoading")
			NetLoading.hide()
		end
	end
end









