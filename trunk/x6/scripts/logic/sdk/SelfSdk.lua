---
-- 自身(无)平台逻辑
-- @module logic.sdk.SelfSdk
-- 

local require = require
local printf = printf
local tr = tr
local tostring = tostring
local CONFIG = CONFIG
local tonumber = tonumber

local moduleName = "logic.sdk.SelfSdk"
module(moduleName)

---
-- 初始化平台
-- @function [parent=#logic.sdk.SelfSdk] initPlatform
-- @return #boolean 是否正确初始化
-- 
function initPlatform( )
	
	local ConfigParams = require("model.const.ConfigParams")
	
	if CONFIG[ConfigParams.IS_FCM] and CONFIG[ConfigParams.IS_FCM]>0 then
		local PlatformLogic = require("logic.PlatformLogic")
		PlatformLogic.setUseMHSdk(true)
	end
	
	return true
end

---
-- 初始化支付
-- @function [parent=#logic.sdk.SelfSdk] initPay
-- 
function initPay( )
	
end

---
-- 打开登录界面
-- @function [parent=#logic.sdk.SelfSdk] openLoginView
-- 
function openLoginView( )
	local GameView = require("view.GameView")
	local LoginView = require("view.login.LoginView")
	GameView.replaceMainView(LoginView.new())
end

---
-- 打开支付界面
-- @function [parent=#logic.sdk.SelfSdk] openPayView
-- @param #number rmb 人民币
-- @param #number yuanBao 兑换元宝数量
-- 
function openPayView(rmb, yuanBao)
	
end

---
-- 发送登录协议
-- @function [parent=#logic.sdk.SelfSdk] sendLoginProto
-- 
function sendLoginProto()
	local GameNet = require("utils.GameNet")
	local User = require("model.User")
	local os = require("os")
	local ConfigParams = require("model.const.ConfigParams")
	
	local corpId = 1000
	if CONFIG[ConfigParams.IS_FCM] and CONFIG[ConfigParams.IS_FCM]>0 then
		corpId = tonumber(CONFIG[ConfigParams.PLATFORM_ID])
	end
	
	local pbObj = {corp_id=corpId,acct=tostring(User.acct),adult=0,login_time=os.time(),sign="",extdata="jihuo=1|serverid="..CONFIG[ConfigParams.SERVER_ID].."|acct_id=123789"}
	GameNet.send("C2s_login_corp_account", pbObj)
end