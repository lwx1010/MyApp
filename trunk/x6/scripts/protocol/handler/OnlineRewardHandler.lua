---
-- 在线奖励协议处理
-- @module protocol.handler.OnlineRewardHandler
--

local require = require

local dump = dump

local moduleName = "protocol.handler.OnlineRewardHandler"
module(moduleName)

local GameNet = require("utils.GameNet")

---
-- 领取奖励时间间隔
-- 
GameNet["S2c_onlinebonus_info"] = function (pb)
	dump(pb)
	local onlineRewardLogic = require("logic.OnlineRewardLogic")
	onlineRewardLogic.setReceveServUpdate(true)
	onlineRewardLogic.setOnlineRewardTime(pb.reward_time)
	onlineRewardLogic.setCurrBeatTime(pb.reward_time - pb.beat_time)
end

---
-- 奖励结果
--
GameNet["S2c_onlinebonus_reward"] = function (pb)
	--pb.is_ok
	local onlineRewardLogic = require("logic.OnlineRewardLogic")
	onlineRewardLogic.setNext()
	onlineRewardLogic.updateRewardTime(pb.reward_time)

	if pb.is_ok == 1 then -- 有奖励
		for i = 1, #pb.r_infos do
			local texiao = require("view.texiao.ScreenTeXiaoView")
			texiao.showItemSmallIconEffect(pb.r_infos[i].photo, pb.r_infos[i].name, pb.r_infos[i].count, "zaixianjiangli.png", "sucess.mp3")
		end
	else -- 空奖励
		local texiao = require("view.texiao.ScreenTeXiaoView")
		texiao.showNoItemEffect("zaixianjiangli1.png")
	end
end


