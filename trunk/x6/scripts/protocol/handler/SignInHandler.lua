---
-- 签到
-- 协议处理
-- @module protocol.handler.SignInHandler
--

local require = require
local class = class
local printf = printf

local moduleName = "protocol.handler.SignInHandler"
module(moduleName)

local GameNet = require("utils.GameNet")

---
-- 获取签到奖励信息
-- 
GameNet["S2c_signin_info"] = function( pb )
	local RewardView = require("view.task.RewardView").instance
	if RewardView then
		local SignInView = RewardView:getSignInView()
		if SignInView then
			SignInView:initByPb(pb)
		end
	else
		if not pb then return end
		
		local SignInView = require("view.task.SignInView")
		SignInView.setGetSignInReward(pb.canget == 1)
	end
end