---
-- 金山平台逻辑
-- @module logic.sdk.KingsoftSdk
-- 

local require = require
local printf = printf
local tr = tr
local CCLuaJavaBridge = CCLuaJavaBridge
local tonumber = tonumber
local CONFIG = CONFIG

local moduleName = "logic.sdk.KingsoftSdk"
module(moduleName)

---
-- 初始化平台
-- @function [parent=#logic.sdk.KingsoftSdk] initPlatform
-- @return #boolean 是否正确初始化
-- 
function initPlatform( )
	local className = "org/cocos2dx/lib/Cocos2dxHelper"
	local args = {}
	local sig = "()Ljava/lang/String;"
	local ret, appPkg = CCLuaJavaBridge.callStaticMethod(className, "getCocos2dxPackageName", args, sig)
	
	if not ret or not appPkg then return end
	
	className = appPkg..".x6"
	args = {"200027", "yk3szq60p4mkj8", _loginCallback, _payCallback}
	sig = "(Ljava/lang/String;Ljava/lang/String;II)V"
	CCLuaJavaBridge.callStaticMethod(className, "start", args, sig)
	
	return true
end

---
-- 初始化支付
-- @function [parent=#logic.sdk.KingsoftSdk] initPay
-- 
function initPay( )
	
end

---
-- 打开登录界面
-- @function [parent=#logic.sdk.KingsoftSdk] openLoginView
-- 
function openLoginView( )
	local className = "com/ijinshan/ksmglogin/util/ViewUtil"
	local args = {}
	local sig = "()V"
	CCLuaJavaBridge.callStaticMethod(className, "login", args, sig)
	
	local GameView = require("view.GameView")
	local PlatformLoginView = require("view.login.PlatformLoginView")
	GameView.replaceMainView(PlatformLoginView.new())
end

---
-- 打开支付界面
-- @function [parent=#logic.sdk.KingsoftSdk] openPayView
-- @param #number rmb 人民币
-- @param #number yuanBao 兑换元宝数量
-- 
function openPayView(rmb, yuanBao)
	
end

---
-- 发送登录协议
-- @function [parent=#logic.sdk.KingsoftSdk] sendLoginProto
-- 
function sendLoginProto()
	local GameNet = require("utils.GameNet")
	local User = require("model.User")
	local ConfigParams = require("model.const.ConfigParams")
	
	local pbObj = {token=User.token, account=User.acct, serverid=tonumber(CONFIG[ConfigParams.SERVER_ID])}
	GameNet.send("C2s_kingsoft_login", pbObj)
end

---
-- 登录回调
-- @function [parent=#logic.sdk.KingsoftSdk] _loginCallback
-- @param #string retStr 回调结果
-- 
function _loginCallback(retStr)
	printf(retStr)

	local string = require("string")
	local params = string.split(retStr, " ")
	if params[1]~="success" or #params~=3 then
		return
	end
	
	local LocalConfig = require("utils.LocalConfig")
	local UserConfigs = require("model.const.UserConfigs")

	local curAcct = LocalConfig.getValue(false, UserConfigs.ACCT_ID)
	if( not curAcct or params[2]~=curAcct ) then
		LocalConfig.loadUserConfig(params[2])
	end
	
	-- 选服
	local SelectServerView = require("view.login.SelectServerView")
	SelectServerView.createInstance():openUi(params[2], "", params[3])
end

---
-- 充值回调
-- @function [parent=#logic.sdk.KingsoftSdk] _payCallback
-- 
function _payCallback()
end