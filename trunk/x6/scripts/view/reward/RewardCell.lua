---
-- 奖励界面子项
-- @module view.reward.RewardCell
-- 

local class = class
local require = require
local tr = tr
local string = string

local moduleName = "view.reward.RewardCell"
module(moduleName)

---
-- 类定义
-- @type RewardCell
-- 
local RewardCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 奖励信息
-- @field [parent=#RewardCell] #table _reward 
-- 
RewardCell._reward = nil

---
-- 奖励类型
-- @field [parent=#RewardCell] #string _type 
-- 
RewardCell._type = nil

---
-- 体力奖励描述
-- @field [parent=#RewardCell] #string _tiliDes 
-- 
RewardCell._tiliDes = tr("<c4>每日12时</c>与<c4>18时</c>在线可恢复<c4>5</c>点体力，持续半小时<c4>12时</c>前胜利通关累计次数><c4>12</c>，可恢复更多体力<c4>18时</c>前胜利通关累计次数><c4>24</c>，可恢复更多体力")

---
-- 创建实例
-- @return #RewardCell 
-- 
function new()
	return RewardCell.new()
end

---
-- 构造函数
-- @function [parent=#RewardCell] ctor
-- @param self
-- 
function RewardCell:ctor()
	RewardCell.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#RewardCell] _create
-- @param self
-- 
function RewardCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_tililingqu/ui_meiri1.ccbi", true)

	self:handleButtonEvent("receiveBtn", self._receiveClkHandler)
end

---
-- 显示数据
-- @function [parent=#RewardCell] showItem
-- @param self
-- @param #string type ("TiLi"--体力奖励， "Vip"--vip奖励)
-- @param #table reward 
-- 
function RewardCell:showItem(type, reward)
	self._reward = reward
	self._type = type
	
	if( type == "Vip" ) then
		self:changeItemIcon("itemSpr", 4000005)
		self["infoLab"]:setString(reward)
	elseif( type == "TiLi" ) then
		self:changeItemIcon("itemSpr", 4000018)
		self["infoLab"]:setString(self._tiliDes)
	end
end

---
-- 点击了领取
-- @function [parent=#RewardCell] _receiveClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function RewardCell:_receiveClkHandler(sender,event)
	local GameNet = require("utils.GameNet")
	if( self._type == "TiLi" ) then
		GameNet.send("C2s_physicalbonus_bonus", {index = 1})
	elseif( self._type == "Vip" ) then
		local RewardData = require("model.RewardData")
		GameNet.send("C2s_vip_get_gift", {vip_lv_gift = RewardData.vipRewardInfo.vip_lv_gift})
	end
	
	local view = self.owner.owner
	view:updateRewardStatus(self)
end

---
-- 取奖励类型
-- @function [parent=#RewardCell] getRewardType
-- @param self
-- @return #string 
-- 
function RewardCell:getRewardType()
	return self._type
end







