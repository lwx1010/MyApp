---
-- boss 协议处理
-- @module protocol.handler.BossHandler
--

local require = require
local dump = dump
local printf = printf
local tr = tr

local modalName = "protocol.handler.BossHandler"
module(modalName)


local GameNet = require("utils.GameNet")

---
-- 世界boss开始/结束信息
-- 
GameNet["S2c_worldboss_sign"] = function(pb)
--	dump(pb)
	local bossEnterView = require("view.qiyu.boss.BossEnterView")
	if pb.is_sign == 0 then --需要显示图标
		--mainView:addBossItem()
		bossEnterView.setGoButtonEnable(true)
		
		--弹出BOSS提示
		local gameView = require("view.GameView")
		local bossNoticeView = require("view.boss.BossNoticeView").createInstance()
		gameView.addPopUp(bossNoticeView, true)
		gameView.center(bossNoticeView)
		
	elseif pb.is_sign == 1 then --移除图标
		--mainView:removeBossItem()
		bossEnterView.setGoButtonEnable(false)
	end
end

---
-- 世界BOSS的基本信息
-- 
GameNet["S2c_worldboss_base_info"] = function(pb)
	local boss = require("view.boss.BossMainView").instance
	if boss then	
		boss:setSilVer(pb.cash)
		boss:setGlod(pb.yuanbao)
		boss:setAddRewardSilver(pb.hurt_cash)
		boss:setCoolTime(pb.cool_time)
		boss:setBossBlood(pb.boss_now_hp, pb.max_hp)
		boss:setMySort(pb.my_rank)
		boss:setMyHurt(pb.my_hurt_hp/pb.max_hp)
		pb.one_user.max_hp = pb.max_hp
		boss:setSortPlayer(pb.one_user)
		boss:setBossName(pb.boss_name)
		boss:setEndTime(pb.act_rest_time)
	end
end

---
-- 玩家排名信息更新
-- 
GameNet["S2c_worldboss_self_rank_info"] = function(pb)
	local boss = require("view.boss.BossMainView").instance
	if boss then	
		boss:setMyHurt(pb.hurt_hp/pb.max_hp)
		boss:setMySort(pb.rank)
	end
end

---
-- 用户排名更新
-- 
GameNet["S2c_worldboss_top_5_info"] = function(pb)
	local boss = require("view.boss.BossMainView").instance
	if boss then	
		boss:setSortPlayer(pb.one_user)
	end
end

---
-- 玩家剩余冷却时间
-- 
GameNet["S2c_worldboss_rest_cooltime"] = function(pb)
	local boss = require("view.boss.BossMainView").instance
	if boss then
		boss:setGlod(pb.yuanbao)
		boss:setSilVer(pb.cash)
		boss:setCoolTime(pb.cool_time)
	end
end

---
-- boss血量更新
-- 
GameNet["S2c_worldboss_hp_info"] = function(pb)
	local boss = require("view.boss.BossMainView").instance
	if boss then	
		if pb.hurt_cash and pb.hurt_cash ~= -1 then
			boss:setAddRewardSilver(pb.hurt_cash)
		end
		boss:setBossBlood(pb.boss_now_hp, pb.boss_max_hp)
		
		local str = pb.user_name..tr(" 对 boss 造成了 ")..pb.boss_hurt_hp..tr(" 的伤害")
		boss:addAttackerMsg(str)
		boss:setHurtNum(pb.boss_hurt_hp)
	end
end

---
-- BOSS说话协议
-- 
GameNet["S2c_worldboss_talk"] = function(pb)
	local boss = require("view.boss.BossMainView").instance
	if boss then
		boss:setBossSay(pb.msg)
	end
end

---
-- boss战斗结算
-- 
GameNet["S2c_worldboss_end_fight_msg"] = function(pb)
	--local gameView = require("view.GameView")
	local popView
	
	printf(pb["get_killcash"])
	pb.get_killcash = pb.get_killcash or 0
	popView = require("view.fuben.FubenSettlement")
	
	local msg = {}
	local killCash = pb.get_killcash or 0
	msg.cash = pb.get_cash + killCash
	msg.partner_info = pb.partner_info
	popView.setRewardMsg(msg)
	--gameView.addPopUp(popView)
	
	pb.structType = {}
	pb.structType.name = "S2c_worldboss_end_fight_msg"
	
	--战斗结果信息
    local fightEva = require("view.fight.FightEvaluate")
    fightEva.push(pb)
end

---
-- BOSS战结算信息
-- 
GameNet["S2c_worldboss_end_msg"] = function(pb)
	if require("view.fight.FightCCBView").isInBattle() == true then
		require("view.boss.BossMainView").saveEndMsg(pb)
	else
		--弹出结算信息
		local gameView = require("view.GameView")
		local bossEndMsg = require("view.boss.BossEndMsgView").createInstance()
		
		bossEndMsg:setShowMsg(pb)
		gameView.addPopUp(bossEndMsg, true)
		gameView.center(bossEndMsg)
	end
end







