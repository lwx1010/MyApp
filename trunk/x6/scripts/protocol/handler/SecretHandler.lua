---
-- 支付加密协议处理
-- @module protocol.handler.SecretHandler
-- 

local require = require
local printf = printf
local pairs = pairs
local SUPPORT_TALKINGDATA = SUPPORT_TALKINGDATA

local moduleName = "protocol.handler.SecretHandler"
module(moduleName)

local GameNet = require("utils.GameNet")

---
-- 支付key
--
GameNet["S2c_secret_send"] = function( pb )
	if pb.key=="app" and #pb.secret>0 and pb.secret~="-" then
		local PlatformLogic = require("logic.PlatformLogic")
		PlatformLogic.setSnKey(pb.secret)
	end
end

---
-- 支付成功
--
GameNet["S2c_secret_order_id"] = function( pb )
	local PlatformLogic = require("logic.PlatformLogic")
	PlatformLogic.onServerPayEnd(pb.order_id)
end
