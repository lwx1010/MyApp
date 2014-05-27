---
-- 游戏逻辑
-- @module logic.GameLogic
-- 

local require = require
local printf = printf

local moduleName = "logic.GameLogic"
module(moduleName)

--- 
-- 开始，显示主界面
-- @function [parent=#logic.GameLogic] start
-- 
function start( )
	-- 初始化
	require("logic.HeroLogic")
	
	-- 重连事件监听
	require("logic.ReconnectLogic")
	
	-- 重启应用事件监听
	require("logic.RestartLogic")
	
	local GameNet = require("utils.GameNet")
	-- 请求全部同伴列表
	GameNet.send("C2s_partner_list", {place_holder=0})
	-- 请求出战同伴列表
	GameNet.send("C2s_partner_warlist", {place_holder=0})

	-- 请求全部道具
	local ItemConst = require("model.const.ItemConst")
	GameNet.send("C2s_item_list", {frame=ItemConst.NORMAL_FRAME})
	GameNet.send("C2s_item_list", {frame=ItemConst.EQUIP_FRAME})
	GameNet.send("C2s_item_list", {frame=ItemConst.MARTIAL_FRAME})
	GameNet.send("C2s_item_list", {frame=ItemConst.PARTNERCHIP_FRAME})
	GameNet.send("C2s_item_list", {frame=ItemConst.EQUIPCHIP_FRAME})
	GameNet.send("C2s_item_list", {frame=ItemConst.MARTIALCHIP_FRAME})
	GameNet.send("C2s_item_list", {frame=ItemConst.TALENT_MARTIAL_FRAME})
	
	local RankData = require("model.RankData")
	RankData.init()
	
	local SignInView = require("view.task.SignInView")
	SignInView.requestRewardInfo()
	
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()
	
	-- 显示主界面
	local MainView = require("view.main.MainView")
    local GameView = require("view.GameView")

    GameView.replaceMainView(MainView.createInstance(), true)
    
    -- 初始化充值
    local PlatformLogic = require("logic.PlatformLogic")
	PlatformLogic.initPay()
end