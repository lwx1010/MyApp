---
-- 连续登陆奖励协议处理
-- @module protocol.handler.LoginBonusHandler
-- 

local require = require
local printf = printf
local tostring = tostring
local dump = dump
local tr = tr

local modalName = "protocol.handler.LoginBonusHandler"
module(modalName)

local GameNet = require("utils.GameNet")

---
-- 登陆奖励信息
--  
GameNet["S2c_loginbonus_info"] = function( pb )
	--[[
	--检测是否有引导
	local isGuiding = require("ui.CCBView").isGuiding
	if isGuiding == false then
		if pb.can_play == 1 then
			local BonusLoginView = require("view.bonus.BonusLoginView")
			local view = BonusLoginView.createInstance()
			view:openUi()
			view:showBaseInfo( pb.login_num, pb.can_play==1)
		end
	end
	--]]
end

---
-- 摇出的奖励信息
-- 
GameNet["S2c_loginbonus_play"] = function( pb )
	--[[
	local BonusLoginView = require("view.bonus.BonusLoginView")
	if not BonusLoginView.instance then return end
	
	local scheduler = require("framework.client.scheduler")
	local func = function()
		if BonusLoginView.instance then
			BonusLoginView.instance:stopRoll( pb )
		end
	end
	
	scheduler.performWithDelayGlobal(func, 1)
	--]]
end



---
-- 奖励信息
--
GameNet["S2c_sumloginbonus_rewardlist"] = function( pb )
	local BonusLoginData = require("model.BonusLoginData")
	BonusLoginData.updateAllReward(pb.list_info)
	
	local HeroAttr = require("model.HeroAttr")
	if HeroAttr.Grade < 2 then return end
	
	--检测是否有引导
	local isGuiding = require("ui.CCBView").isGuiding
	if isGuiding == false then
		local BonusLoginNewView = require("view.bonus.BonusLoginNewView")
		local GameView = require("view.GameView")
		BonusLoginNewView.createInstance():scrollToIndex()
		GameView.addPopUp(BonusLoginNewView.instance, true)
		GameView.center(BonusLoginNewView.instance)
	end
end

---
-- 可领取奖励的天数信息
--
GameNet["S2c_sumloginbonus_info"] = function( pb )
	--检测是否有引导
	local isGuiding = require("ui.CCBView").isGuiding
	if isGuiding == false then
		local days = pb.reward_days
		local BonusLoginData = require("model.BonusLoginData")
		BonusLoginData.setDaysTbl(days)
		
		local GameNet = require("utils.GameNet")
		local pbObj = {}
		if days[#days] <= 30 then
			for i=1, 30 do
				pbObj[i] = i
			end
		elseif days[#days] > 30 and days[#days] <= 60 then
			for i=31, 60 do
				pbObj[i-30] = i
			end
		elseif days[#days] > 60 and days[#days] <= 90 then
			for i=61, 90 do
				pbObj[i-60] = i
			end
		elseif days[#days] > 90 and days[#days] <= 120 then
			for i=91, 120 do
				pbObj[i-90] = i
			end
		end
		GameNet.send("C2s_sumloginbonus_rewardlist",{reward_days = pbObj})
	end
end

---
-- 领取奖励成功
--
GameNet["S2c_sumloginbonus_reward"] = function( pb )
	local BonusLoginData = require("model.BonusLoginData")
	BonusLoginData.updateReward(pb.day)
	BonusLoginData.setReceiveDay(pb.day)
	
	local FloatNotify = require("view.notify.FloatNotify")
	local BonusLoginNewView = require("view.bonus.BonusLoginNewView")
	if pb.day == -1 then
--		FloatNotify.show(tr("背包已满，无法获得奖励！"))
		if BonusLoginNewView.instance then
			BonusLoginNewView.instance:closeView()
		end
	else
		local des = "恭喜您获得："
		local reward
		for i=1, #pb.r_infos do
			reward = pb.r_infos[i]
			des = des..reward.name.."*"..reward.count.." "
		end
		FloatNotify.show(tr(des))
		
		if BonusLoginNewView.instance then
			BonusLoginNewView.instance:checkClose()
		end
	end
end
