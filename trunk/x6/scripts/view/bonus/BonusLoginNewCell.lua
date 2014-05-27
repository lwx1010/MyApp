---
-- 新登陆奖励道具子项
-- @module view.bonus.BonusLoginNewCell
--

local require = require
local class = class
local printf = printf
local display = display
local tr = tr
local dump = dump


local moduleName = "view.bonus.BonusLoginNewCell"
module(moduleName)


--- 
-- 类定义
-- @type BonusLoginNewCell
-- 
local BonusLoginNewCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 创建实例
-- @return BonusLoginNewCell实例
function new()
	return BonusLoginNewCell.new()
end

---
-- 构造函数
-- @function [parent = #BonusLoginNewCell] ctor
-- 
function BonusLoginNewCell:ctor()
	BonusLoginNewCell.super.ctor(self)
	
	self:_create()
end

---
-- 创建加载ccbi文件
-- @function [parent = #BonusLoginNewCell] _create
-- 
function BonusLoginNewCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_loginbonus/ui_denglujianglipiece.ccbi", true)
	
	self:handleButtonEvent("receiveBtn", self._receiveClkHandler)
end

---
-- 点击了领取
-- @function [parent=#BonusLoginNewCell] _receiveClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BonusLoginNewCell:_receiveClkHandler(sender,event)
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_sumloginbonus_reward", {day=self._info.day})
end

---
-- 显示道具信息
-- @function [parent=#BonusLoginNewCell] showItem
-- @param self
-- @param #table info
-- 
function BonusLoginNewCell:showItem( info )
	self._info = info
	
	if not info then
		for i=1, 4 do
			self:changeTexture("itemCcb"..i..".headPnrSpr", nil)
			self:changeFrame("itemCcb"..i..".frameSpr", nil)
		end
		return
	end
	
	self["dayLab"]:setString(tr("第  "..info.day.."  天"))
	local rewardNum = #info.r_infos
	for i=1, 4 do
		if i <= rewardNum then
			self:_showReward(i, info.r_infos[i])
			self["itemCcb"..i]:setVisible(true)
		else
			self["itemCcb"..i]:setVisible(false)
		end
	end
	self["receiveBtn"]:setEnabled(info.isget==0)
end

---
-- 显示奖励信息
-- @function [parent=#BonusLoginNewCell] _showReward
-- @param self
-- @param #number idx 
-- @param #table info 
-- 
function BonusLoginNewCell:_showReward(idx,info)
	local PartnerShowConst = require("view.const.PartnerShowConst")
	local ItemViewConst = require("view.const.ItemViewConst")
	self:changeFrame("itemCcb"..idx..".frameSpr", PartnerShowConst.STEP_FRAME[info.step])
	-- 侠客、侠客碎片
	if info.item_kind == 11 or info.item_kind == 3 then
		self["itemCcb"..idx..".headPnrSpr"]:showReward("partner", info.photo)
		self["itemCcb"..idx..".headPnrSpr"]:setScaleX(0.5)
		self["itemCcb"..idx..".headPnrSpr"]:setScaleY(0.5)
		self:changeFrame("itemCcb"..idx..".frameSpr", PartnerShowConst.STEP_FRAME[info.step])
	else
		self["itemCcb"..idx..".headPnrSpr"]:showReward("item", info.photo)
		self["itemCcb"..idx..".headPnrSpr"]:setScaleX(0.7)
		self["itemCcb"..idx..".headPnrSpr"]:setScaleY(0.7)
		if info.item_kind == 1 then
			self:changeFrame("itemCcb"..idx..".frameSpr", ItemViewConst.EQUIP_RARE_COLORS1[info.step])
		elseif info.item_kind == 2 then
			self:changeFrame("itemCcb"..idx..".frameSpr", ItemViewConst.MARTIAL_RARE_COLORS1[info.step])
		elseif info.item_kind == -1 then
			self:changeFrame("itemCcb"..idx..".frameSpr", ItemViewConst.MARTIAL_RARE_COLORS1[1])
		else
			self:changeFrame("itemCcb"..idx..".frameSpr", PartnerShowConst.STEP_FRAME[info.step])
		end
	end
	
	self["itemCcb"..idx..".nameLab"]:setString(tr(info.name.."*"..info.count))
	
end












