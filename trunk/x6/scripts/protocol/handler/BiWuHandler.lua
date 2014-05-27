---
-- 比武协议处理
-- @module protocol.handler.BiWuHandler
-- 

local require = require
local printf = printf
local pairs = pairs
local ipairs = ipairs
local tostring = tostring

local modalName = "protocol.handler.BiWuHandler"
module(modalName)


local GameNet = require("utils.GameNet")

---
-- 比武结果
--  
GameNet["S2c_biwu_result"] = function( pb )
	if not pb then return end 
	
	local GameView = require("view.GameView")
	if pb.is_win == 0 then
		local BWLoseView = require("view.biwu.BWLoseView")
		BWLoseView.setRewardMsg(pb)
	else
		local BWWinView = require("view.biwu.BWWinView")
		BWWinView.setRewardMsg(pb)
	end
	
	pb.structType = {}
	pb.structType.name = "S2c_biwu_result"
	
	--战斗结果信息
    local fightEva = require("view.fight.FightEvaluate")
    fightEva.push(pb)
end

---
-- 比武界面信息
-- 
GameNet["S2c_biwu_info"] = function( pb )
	local BiWuView = require("view.biwu.BiWuView")
	if BiWuView.instance then
		BiWuView.instance:showListInfo(pb)
	end
	local netLoading = require("view.notify.NetLoading")
	netLoading.hide()
end

---
-- 比武积分商店信息
-- 
GameNet["S2c_biwu_shop_info"] = function(pb)
	local BiWuView = require("view.biwu.BiWuView")
	if BiWuView.instance then
		BiWuView.instance:showShopInfo(pb)
	end
end

---
-- 查看玩家侠客信息
-- 
GameNet["S2c_biwu_fight_info"] = function( pb )
	local BWPlayerInfoUi = require("view.biwu.BWPlayerInfoUi")
	if BWPlayerInfoUi.instance and BWPlayerInfoUi.instance:getParent() then
		BWPlayerInfoUi.instance:showInfo( pb.fight_info )
	end
end

