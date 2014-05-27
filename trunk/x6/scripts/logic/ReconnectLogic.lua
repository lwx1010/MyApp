---
-- 应用重连的逻辑
-- @module logic.ReconnectLogic
--

local require = require
local printf = printf

local moduleName = "logic.ReconnectLogic"
module(moduleName)

---
-- 监听事件
-- @function [parent = #logic.ReconnectLogic] addRestartListener
-- 
function addReconnectListener()
	-- 应用重连事件
	local EventCenter = require("utils.EventCenter")
	local Events = require("model.event.Events")
	EventCenter:addEventListener(Events.APP_RECONNECT.name, _reconnectHandler)
end

---
-- 应用重启
-- @function [parent=#logic.ReconnectLogic] _restartHandler
-- @param #table
--  
function _reconnectHandler(event)
	--初始化引导数据
	local guideView = require("view.guide.GuideUi")
	guideView.guideInitVar()
	
	-- 清除武学数量
	local ItemData = require("model.ItemData")
	ItemData.count = 0
--	printf("开始执行重连事件")

	--重置在线奖励
	local onlineRewardLogic = require("logic.OnlineRewardLogic")
	onlineRewardLogic.setReceveServUpdate(false)
end

---
-- 初始化
-- @function [parent = #logic.ReconnectLogic] _init
-- 
function _init()
	addReconnectListener()
end

-- 加载的时候一次初始化
_init()