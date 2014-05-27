---
-- 体力奖励协议处理
-- @module protocol.handler.TiLiRewardHandler
-- 

local require = require

local moduleName = "protocol.handler.TiLiRewardHandler"
module(moduleName)

local GameNet = require("utils.GameNet")

---
-- 奖励信息
-- 
GameNet["S2c_physicalbonus_info"] = function( pb )
	local PlayEatView = require("view.qiyu.eat.PlayEatView")
	if( PlayEatView.instance ) then
		PlayEatView.instance:showInfo(pb.bonus_info)
		-- 隐藏加载动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.hide()
	end
end












