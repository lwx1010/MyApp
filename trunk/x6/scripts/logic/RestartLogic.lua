---
-- 重启应用的逻辑
-- @module logic.RestartLogic
--

local require = require
local printf = printf

local moduleName = "logic.RestartLogic"
module(moduleName)

---
-- 监听事件
-- @function [parent = #logic.RestartLogic] addRestartListener
-- 
function addRestartListener()
	-- 应用重启事件
	local EventCenter = require("utils.EventCenter")
	local Events = require("model.event.Events")
	EventCenter:addEventListener(Events.APP_RESTART.name, _restartHandler)
end

---
-- 应用重启
-- @function [parent=#logic.RestartLogic] _restartHandler
-- @param #table
--  
function _restartHandler(event)
	-- 释放主界面
	local MainView = require("view.main.MainView")
	if MainView.instance then
		MainView.instance:releaseMainView()
	end
	--重置引导数据
	local guideView = require("view.guide.GuideUi")
	guideView.guideInitVar()
	-- 重置真气数据
	local ZhenQiData = require("model.ZhenQiData")
	ZhenQiData.receiveZhenQiList = false
	-- 清除武学数量
	local ItemData = require("model.ItemData")
	ItemData.count = 0
	-- 重置副本大地图数据
	local fubenMapView = require("view.fuben.FubenMapView")
	fubenMapView.initFubenMapData()
	-- 重置副本章节数据
	local fubenChapterData = require("model.FubenChapterData")
	fubenChapterData.initFubenChapterData()
	local fubenChapterCell = require("view.fuben.FubenChapterCell")
	fubenChapterCell.initChapterCellModelData()
	local fubenLogic = require("logic.FubenLogic")
	fubenLogic.initFubenLogicData()
	--重置活动信息
	local qiYuActivityData = require("model.QiYuActivityData")
	qiYuActivityData.initQiYuActivityData()
	--重置在线奖励
	local onlineRewardLogic = require("logic.OnlineRewardLogic")
	onlineRewardLogic.setReceveServUpdate(false)
	
	
--	printf("开始执行重启应用事件")
end

---
-- 初始化
-- @function [parent = #logic.RestartLogic] _init
-- 
function _init()
	addRestartListener()
end

-- 加载的时候一次初始化
_init()