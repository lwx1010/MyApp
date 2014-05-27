---
-- 运营活动协议
-- @module protocol.handler.ActivityHandler
-- 

local require = require
local printf = printf
local dump = dump

local moduleName = "protocol.handler.ActivityHandler"
module(moduleName)

local GameNet = require("utils.GameNet")

---
-- 运营活动图标是否显示
-- 
GameNet["S2c_partybase_sign"] = function( pb )
--dump(pb)
	local RewardData = require("model.RewardData")
	RewardData.activityInfo = pb.party_infos
	
	local MainView = require("view.main.MainView")
	if MainView.instance then
		MainView.instance:showHideActEffect(pb.is_sign == 1)
	end
	
	local HeroAttr = require("model.HeroAttr")
	local CCBView = require("ui.CCBView")
	if CCBView.isGuiding == false then
		if HeroAttr.Grade >= 2 and HeroAttr.Grade < 6 or HeroAttr.Grade > 37 then
			local ActivityView = require("view.activity.ActivityNewView")
			local GameView = require("view.GameView")
			GameView.addPopUp(ActivityView.createInstance(), true)
			GameView.center(ActivityView.instance)
		end
	end
end

---
-- 推送活动
-- 
GameNet["S2c_partybase_1014_info"] = function( pb )
--dump(pb)
	local RewardData = require("model.RewardData")
	RewardData.pushActInfo = pb
	
	if pb.is_login == 1 then
		local CCBView = require("ui.CCBView")
		if CCBView.isGuiding == false then
			local ActivityView = require("view.activity.ActivityNewView")
			local GameView = require("view.GameView")
			GameView.addPopUp(ActivityView.createInstance(), true)
			GameView.center(ActivityView.instance)
		end
	elseif pb.is_login == 0 then
		if pb.type == 1 then
			local MainView = require("view.main.MainView")
			if MainView.instance then
				MainView.instance:showHideActEffect(pb.type == 1)
			end
			
			local YouHuiXls = require("xls.YouHuiXls").data
			local actInfo = YouHuiXls[pb.gift_id]
			if not actInfo then return end
			
			local scheduler = require("framework.client.scheduler")
			local CCBView = require("ui.CCBView")
			if CCBView.isGuiding then
				if _guidHandle then
					scheduler.unscheduleGlobal(_guidHandle)
					_guidHandle = nil
				end
				
				local func = function()
					if not CCBView.isGuiding then
						local BuyTipView = require("view.activity.BuyTipView")
						if not BuyTipView.instance then
							BuyTipView.createInstance():openUi(actInfo)
						end
						
						scheduler.unscheduleGlobal(_guidHandle)
						_guidHandle = nil
						return
					end
				end
				_guidHandle = scheduler.scheduleGlobal(func, 5)
				
			else
				-- 判断是否进行了战斗
				local FightCCBView = require("view.fight.FightCCBView")
				if FightCCBView.isInBattle() then
					local ActivityNewView = require("view.activity.ActivityNewView")
					ActivityNewView.addDelayMsg(actInfo)
				else
					if _handle then
						scheduler.unscheduleGlobal(_handle)
						_handle = nil
					end
					
					local func = function()
						if not CCBView.isGuiding then
							local BuyTipView = require("view.activity.BuyTipView")
							if not BuyTipView.instance then
								BuyTipView.createInstance():openUi(actInfo)
							end
							
							scheduler.unscheduleGlobal(_handle)
							_handle = nil
							return
						end
					end
					_handle = scheduler.scheduleGlobal(func, 0.4)
				end
			end
		end
	end
end

