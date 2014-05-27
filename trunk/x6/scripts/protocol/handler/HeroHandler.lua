---
-- 角色协议处理
-- @module protocol.handler.HeroHandler
-- 

local require = require
local printf = printf
local pairs = pairs
local ipairs = ipairs
local tostring = tostring
local dump = dump

local modalName = "protocol.handler.HeroHandler"
module(modalName)


local GameNet = require("utils.GameNet")

---
-- 角色进入游戏
--  
GameNet["S2c_hero_enter_info"] = function( pb )
	local HeroAttr = require("model.HeroAttr")	
	local string = require("string")
	
	local attrs = {}
	for k, v in pairs(pb) do
		k = string.upper(string.sub(k,1,1))..string.sub(k,2)
		HeroAttr[k] = v
		attrs[k] = v
		
		printf("hero enter %s -> %s", k, tostring(v))
	end
	
	local EventCenter = require("utils.EventCenter") -- framework.client.api#EventProtocol
	local HeroEvents = require("model.event.HeroEvents")
	
	local event = HeroEvents.ATTRS_UPDATED
	event.attrs = attrs
	EventCenter:dispatchEvent(event)
end

---
-- 角色int属性更新
-- 
GameNet["S2c_hero_info_int"] = function( pb )
	local HeroAttr = require("model.HeroAttr")
	
	local attrs = {}
	for i, subPb in ipairs(pb.info) do
		if subPb.key == "Score" then
			--保存战力信息
			--printf("HeroAttr.BeforeScore = "..HeroAttr.BeforeScore.."  HeroAttr.Score = "..HeroAttr.Score)
			HeroAttr.BeforeScore = HeroAttr.Score
		end
		
		HeroAttr[subPb.key] = subPb.value
		attrs[subPb.key] = subPb.value
		
		printf("hero %s -> %s", subPb.key, tostring(subPb.value))
	end
	
	local EverydayTaskData = require("model.EverydayTaskData")
	EverydayTaskData.IsTaskReward = HeroAttr.IsTaskReward
	EverydayTaskData.IsDailyTaskReward = HeroAttr.IsDailyTaskReward
	
	local EventCenter = require("utils.EventCenter") -- framework.client.api#EventProtocol
	local HeroEvents = require("model.event.HeroEvents")
	local event = HeroEvents.ATTRS_UPDATED
	event.attrs = attrs
	EventCenter:dispatchEvent(event)
end

---
-- 角色string属性更新
-- 
GameNet["S2c_hero_info_string"] = function( pb )
	local HeroAttr = require("model.HeroAttr")
	local attrs = {}
	for i, subPb in ipairs(pb.info) do
		HeroAttr[subPb.key] = subPb.value
		attrs[subPb.key] = subPb.value
		
		printf("hero %s -> %s", subPb.key, tostring(subPb.value))
	end
	
	local EventCenter = require("utils.EventCenter") -- framework.client.api#EventProtocol
	local HeroEvents = require("model.event.HeroEvents")
	local event = HeroEvents.ATTRS_UPDATED
	event.attrs = attrs
	EventCenter:dispatchEvent(event)
end

--- 
-- 角色界面背包格子信息
--
GameNet["S2c_hero_maininfo"] = function( pb )
	local RoleView = require("view.role.RoleView")
	if RoleView.instance then
		RoleView.instance:showInfo( pb )
	end
end

---
-- 角色背包物品数量信息
-- 
GameNet["S2c_hero_baginfo"] = function( pb )
	--隐藏loading动画
    local netLoading = require("view.notify.NetLoading")
	netLoading.hide()

	local Uiid = require("model.Uiid")
	if pb.uiid == Uiid.UIID_MAINVIEW  then
		local MainView = require("view.main.MainView")
		if MainView.instance then
			MainView.instance:showBagNumInfo(pb)
		end
	elseif pb.uiid == Uiid.UIID_BAG  then
		local BagView = require("view.bag.BagView")
		if BagView.instance then
			BagView.instance:showBagNumInfo(pb)
		end
	elseif pb.uiid == Uiid.UIID_CHIP  then
		local BagChipView = require("view.bag.BagChipView")
		if BagChipView.instance then
			BagChipView.instance:showBagNumInfo(pb)
		end
	elseif pb.uiid == Uiid.UIID_ITEMBATCHUSEVIEW  then
		local ItemBatchUseView = require("view.treasure.ItemBatchUseView")
		if ItemBatchUseView.instance then
			ItemBatchUseView.instance:showBagNumInfo(pb)
		end
		-- 隐藏加载动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.hide()
	elseif pb.uiid == Uiid.UIID_SHEJIAN then
		if pb.equip_num >= pb.equip_max then
			local SheJianView = require("view.qiyu.shejian.SheJianView").instance
			if SheJianView then
				SheJianView:showEquipFullTip()
			end
		end
	end
	
	-- 更新战斗保存的背包/碎片元素的最大值项
	local fightData = require("model.FightData")
	fightData.BagPartnerMaxNum = pb.partner_max
	fightData.BagEquitMaxNum = pb.equip_max
	fightData.BagMartialMaxNum = pb.martial_max
	
	fightData.PartnerChipMaxNum = pb.partnerchip_max
	fightData.EquitChipMaxNum = pb.equipchip_max
	fightData.MartialChipMaxNum = pb.martialchip_max
end

---
-- 角色背包物品数量变化
-- 
GameNet["S2c_hero_bagnum"] = function( pb )
	-- 不处理天赋武学
	if pb.frameno == 7 then return end
	
	local attrs = {}
	for k, v in pairs(pb) do
		attrs[k] = v
	end
	
	local EventCenter = require("utils.EventCenter") -- framework.client.api#EventProtocol
	local BagEvents = require("model.event.BagEvents")
	local event
	if( pb.frameno < 4 ) then
		event = BagEvents.BAG_NUM_CHANGE
	else
		event = BagEvents.CHIP_NUM_CHANGE
	end
	event.attrs = attrs
	EventCenter:dispatchEvent(event)
end

---
-- 角色升级
-- 
GameNet["S2c_hero_upgradeinfo"] = function(pb)
	local levelUpMsgBox = require("view.levelup.LevelUpMsgBoxView")
	levelUpMsgBox.dealGradeUp(pb)
end

---
-- 角色升级推送信息
-- 
GameNet["S2c_hero_gradeinfo"] = function(pb)
	if pb.info ~= "" then
		local levelupLogic = require("logic.LevelUpLogic")
		levelupLogic.addLevelUpMsg("view.levelup.LevelUpDescView", pb.info)
		
		local fightCCBView = require("view.fight.FightCCBView")
		if fightCCBView.isInBattle() == false then
			levelupLogic.dealMsg()
		end
	end
end
