--- 
-- 玩法整合界面：vip福利界面
-- @module view.qiyu.vip.VipRewardView
-- 

local class = class
local printf = printf
local require = require
local tr = tr


local moduleName = "view.qiyu.vip.VipRewardView"
module(moduleName)

--- 
-- 类定义
-- @type VipRewardView
-- 
local VipRewardView = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 构造函数
-- @function [parent=#VipRewardView] ctor
-- @param self
-- 
function VipRewardView:ctor()
	VipRewardView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#VipRewardView] _create
-- @param self
-- 
function VipRewardView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_vipjiangli.ccbi", true)
	
	self:handleButtonEvent("rewardCcb.aBtn", self._rewardClkHandler)
end

---
-- 点击了领取
-- @function [parent=#VipRewardView] _rewardClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function VipRewardView:_rewardClkHandler( sender, event )
	local gameNet = require("utils.GameNet")
	gameNet.send("C2s_vip_get_gift", {vip_lv_gift = self._giftLv})
end

---
-- 打开界面调用
-- @function [parent=#VipRewardView] openUi
-- @param self
-- @param #Randomev_info info
-- 
function VipRewardView:openUi( info )
	if not info then return end
	
	self:setVisible(true)
	
	local vipLevel = require("model.HeroAttr").Vip
	if vipLevel <= 0 then
		self["vipTipLab"]:setString(tr("您当前还不是VIP玩家，充值成为VIP可以领取每日福利"))
		self["rewardCcb.aBtn"]:setEnabled(false)
		self["vipRewardLab"]:setVisible(false)
		self["hasRewardLab"]:setVisible(false)
	else
		self["vipTipLab"]:setString(tr("您是尊贵的VIP")..vipLevel..tr("玩家"))
		self["vipRewardLab"]:setVisible(true)
		local gameNet = require("utils.GameNet")
		gameNet.send("C2s_vip_next_giftlv", {place_holder = 1})
	end
	
end

---
-- 设置vip礼品lv
-- @function [parent = #VipRewardView] setVipGiftLv
-- @param #number lv
-- 
function VipRewardView:setVipGiftLv(lv)
	self._giftLv = lv
end

---
-- 设置vip奖励描述
-- @function [parent = #VipRewardView] setVipGiftDesc
-- @param #string msg
-- 
function VipRewardView:setVipGiftDesc(msg)
	self["vipRewardLab"]:setString(msg)	
	if msg == "" then --说明奖励已经领取完了
		self["hasRewardLab"]:setVisible(true)
		self["rewardCcb.aBtn"]:setEnabled(false)
	else
		self["hasRewardLab"]:setVisible(false)
		self["rewardCcb.aBtn"]:setEnabled(true)
	end
end

---
-- 关闭界面
-- @function [parent=#VipRewardView] closeUi
-- @param self
-- 
function VipRewardView:closeUi()
	self:setVisible(false)
end

---
-- 退出界面调用
-- @function [parent=#VipRewardView] onExit
-- @param self
-- 
function VipRewardView:onExit()
	instance = nil
	
	self.super.onExit(self)
end