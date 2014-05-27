---
-- vip奖励协议处理
-- @module protocol.handler.VipRewardHandler
-- 

local require = require

local dump = dump

local moduleName = "protocol.handler.VipRewardHandler"
module(moduleName)

local GameNet = require("utils.GameNet")

---
-- 活动信息
-- 
GameNet["S2c_vip_gift_info"] = function( pb )
	local vipRewardView = require("view.qiyu.vip.VipRewardView").instance
	if vipRewardView == nil then
		return 
	end
	
	vipRewardView:setVipGiftLv(pb.vip_lv_gift)
	vipRewardView:setVipGiftDesc(pb.msg)
	
end














