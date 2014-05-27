---
-- 每日福利界面
-- @module view.reward.RewardView
-- 

local class = class
local require = require
local printf = printf
local tr = tr

local moduleName = "view.reward.RewardView"
module(moduleName)

---
-- 类定义
-- @type RewardView
-- 
local RewardView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent=#RewardView] ctor
-- @param self
-- 
function RewardView:ctor()
	RewardView.super.ctor(self)
	
	self:_create()
	--self:retain()
end

---
-- 创建
-- @function [parent=#RewardView] _create
-- @param self
-- 
function RewardView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_tililingqu/ui_meirifuli.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self["rewardVBox"].owner = self
end

---
-- 点击了关闭
-- @function [parent=#RewardView] _closeClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function RewardView:_closeClkHandler(sender,event)
	self["rewardVBox"]:removeAllItems()
	local GameView = require("view.GameView")
	GameView.removePopUp(self)
end

---
-- 显示体力奖励
-- @function [parent=#RewardView] showReward
-- @param self
-- @param #table reward 
-- 
function RewardView:showTiLiReward(reward)
	local RewardCell = require("view.reward.RewardCell")
	local tilicell = RewardCell.new()
	tilicell:showItem("TiLi", reward)
	tilicell.owner = self["rewardVBox"]
	self["rewardVBox"]:addItem(tilicell)
end

---
-- 显示Vip奖励
-- @function [parent=#RewardView] showVipReward
-- @param self
-- @param #table reward 
-- 
function RewardView:showVipReward(reward)
	local itemArr = self["rewardVBox"]:getItemArr()
	local cell
	-- 如果已经存在vip奖励子项，则更新子项
	for i=1, #itemArr do
		cell = itemArr[i]
		local type = cell:getRewardType()
		if( type == "Vip" ) then
			cell:showItem("Vip", reward)
			return
		end
	end
	
	local RewardCell = require("view.reward.RewardCell")
	local vipcell = RewardCell.new()
	vipcell:showItem("Vip", reward)
	vipcell.owner = self["rewardVBox"]
	self["rewardVBox"]:addItem(vipcell)
end

---
-- 请求奖励信息
-- @function [parent=#RewardView] requestRewardInfo
-- @param self
-- 
function RewardView:requestRewardInfo()
	local RewardData = require("model.RewardData")
	if( RewardData.tiLiReward ) then
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_physicalbonus_info", {index = 1})
	end
	if( RewardData.vipReward ) then
		local reward = RewardData.vipRewardInfo.msg
		self:showVipReward(reward)
	end
end

---
-- 更新奖励领取状态
-- @function [parent=#RewardView] updateRewardStatus
-- @param self
-- @param #table cell 奖励子项
-- 
function RewardView:updateRewardStatus(cell)
	self["rewardVBox"]:removeItem(cell)
end

---
-- 场景退出后自动调用
-- @function [parent = #RewardView] onExit
-- @param #MainView self
-- 
function RewardView:onExit()
	instance = nil
	
	RewardView.super.onExit(self)
end








