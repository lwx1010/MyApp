---
-- TalkingData 逻辑
-- @module logic.TalkingDataLogic
--

local require = require

local SUPPORT_TALKINGDATA = SUPPORT_TALKINGDATA

local moduleName = "logic.TalkingDataLogic"
module(moduleName)

---
-- 发送TalkingData 统计事件
-- @function [parent = #logic.TalkingDataLogic] sendTalkingDataEvent
-- @param #string event
--
function sendTalkingDataEvent(event)
	if SUPPORT_TALKINGDATA then
		local device = require("framework.client.device")
		if( device.platform=="ios" ) then
			local HeroAttr = require("model.HeroAttr")
			local luaoc = require("framework.client.luaoc")
			luaoc.callStaticMethod("TalkingDataSdk", "logEvent", {event=event, value=(HeroAttr["level"] or "-1")})
		end
	end
end