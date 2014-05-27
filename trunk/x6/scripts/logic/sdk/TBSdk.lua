---
-- 同步平台逻辑
-- @module logic.sdk.TBSdk
-- 

local require = require
local printf = printf
local tr = tr
local CONFIG = CONFIG
local CCCrypto = CCCrypto
local CCHTTPRequest = CCHTTPRequest
local pcall = pcall
local tonumber = tonumber
local CCLuaLog = CCLuaLog
local SUPPORT_TALKINGDATA = SUPPORT_TALKINGDATA

local moduleName = "logic.sdk.TBSdk"
module(moduleName)

---
-- 账号
-- @field [parent=#logic.sdk.TBSdk] #string _uin
-- 
local _uin = nil

---
-- 会话id
-- @field [parent=#logic.sdk.TBSdk] #string _sessionId
-- 
local _sessionId = nil

---
-- 初始化平台
-- @function [parent=#logic.sdk.TBSdk] initPlatform
-- @return #boolean 是否正确初始化
-- 
function initPlatform( )
	local PlatformLogic = require("logic.PlatformLogic")
	PlatformLogic.setSupportReconnect(false)
	
	local className = "TBSdk"
	local methodName = "init"
	local args = {callback=_callback}

	local luaoc = require("framework.client.luaoc")
	luaoc.callStaticMethod(className, methodName, args)
	return true
end

---
-- 打开登录界面
-- @function [parent=#logic.sdk.TBSdk] openLoginView
-- 
function openLoginView( )
	local luaoc = require("framework.client.luaoc")
	luaoc.callStaticMethod("TBSdk", "showLogin", nil)
	
	local GameView = require("view.GameView")
	local PlatformLoginView = require("view.login.PlatformLoginView")
	GameView.replaceMainView(PlatformLoginView.new())
end

---
-- 切换账号
-- @function [parent=#logic.sdk.TBSdk] switchAccount
-- 
function switchAccount( )
	local luaoc = require("framework.client.luaoc")
	luaoc.callStaticMethod("TBSdk", "switchAccount", nil)
	
	local GameView = require("view.GameView")
	local PlatformLoginView = require("view.login.PlatformLoginView")
	GameView.replaceMainView(PlatformLoginView.new())
end

---
-- 打开sdk的登录界面
-- @function [parent=#logic.sdk.TBSdk] openSdkLogin
-- 
function openSdkLogin( )
	local luaoc = require("framework.client.luaoc")
	luaoc.callStaticMethod("TBSdk", "showLogin", nil)
end

---
-- 发送登录协议
-- @function [parent=#logic.sdk.TBSdk] sendLoginProto
-- 
function sendLoginProto()
	local GameNet = require("utils.GameNet")
	local User = require("model.User")
	local ConfigParams = require("model.const.ConfigParams")
	
	local pbObj = {}
	pbObj.token = "1"
	pbObj.account_id = _uin
	pbObj.corpid = tonumber(CONFIG[ConfigParams.PLATFORM_ID])
	pbObj.serverid = tonumber(CONFIG[ConfigParams.SERVER_ID])
	pbObj.extdata = "sessionid=".._sessionId
	GameNet.send("C2s_ptduijie_login", pbObj)
end

---
-- 回调
-- @function [parent=#logic.sdk.TBSdk] _callback
-- @param #string type 回调类型
-- @param #string retStr 回调结果
-- 
function _callback(type, retStr)
	printf(type.." "..retStr)
	
	if type=="login" then
		if retStr=="success" then
			local luaoc = require("framework.client.luaoc")
			local ret, uin = luaoc.callStaticMethod("TBSdk", "getUin", nil)
			local ret, sessionId = luaoc.callStaticMethod("TBSdk", "getSessionId", nil)
			if not uin or not sessionId then
				local Alert = require("view.notify.Alert")
				Alert.show({text=tr("登录失败：账号或者会话错误")}, {{text=tr("确定")}})
				return
			end
			
			_uin = uin
			_sessionId = sessionId
			
			local LocalConfig = require("utils.LocalConfig")
			local UserConfigs = require("model.const.UserConfigs")
		
			local curAcct = LocalConfig.getValue(false, UserConfigs.ACCT_ID)
			if( not curAcct or uin~=curAcct ) then
				LocalConfig.loadUserConfig(uin)
			end
			
			local ret, userName = luaoc.callStaticMethod("TBSdk", "getNickName", nil)
			
			-- 选服
			local SelectServerView = require("view.login.SelectServerView")
			SelectServerView.createInstance():openUi(uin, "", sessionId, userName)
			return
		end
		
		-- 错误
		local hasLogined = _uin~=nil
		_uin = nil
		_sessionId = nil
		
		-- 注销了
		if hasLogined then
			local LoginLogic = require("logic.LoginLogic")
			LoginLogic.restartApp(false)
			return
		end
		
		local error = tonumber(retStr)
		
		local string = require("string")
		local msg = string.format(tr("登录失败，错误码为：%d"), error)
		
		local Alert = require("view.notify.Alert")
		Alert.show({text=msg}, {{text=tr("确定")}})
		return
	end
	
	if type=="leave" then
		return
	end
	
	if type=="pay" then
		return
	end
end


---
-- 返回货币名字
-- @function [parent=#logic.sdk.TBSdk] getCurrencyName
-- @return #string 货币名字
-- 
function getCurrencyName()
	return tr("推币")
end

---
-- 返回货币类型
-- @function [parent=#logic.sdk.TBSdk] getCurrencyType
-- @return #string 支付账号
-- 
function getCurrencyType()
	return "TB"
end

---
-- 返回汇率类型
-- @function [parent=#logic.sdk.TBSdk] getRateType
-- @return #string 汇率类型
-- 
function getRateType()
	return "TB"
end

---
-- 返回汇率
-- @function [parent=#logic.sdk.TBSdk] getCurrencyRate
-- @return #number
-- 
function getCurrencyRate()
	return 10
end

---
-- 返回支付账号
-- @function [parent=#logic.sdk.TBSdk] getPayAccount
-- @return #string 支付账号
-- 
function getPayAccount()
	return _uin
end

---
-- 调用sdk的支付接口
-- @function [parent=#logic.sdk.TBSdk] payBySdk
-- @param #number rmb 人民币
-- @param #number yuanBao 兑换元宝数量
-- @param #string sn 订单号
-- 
function payBySdk(rmb, yuanBao, sn)
	local ConfigParams = require("model.const.ConfigParams")
	local serverId = CONFIG[ConfigParams.SERVER_ID]
	
	local className = "TBSdk"
	local methodName = "pay"
	local args = {}
	args["sn"] = sn
	args["desc"] = ""..serverId
	args["price"] = rmb

	local luaoc = require("framework.client.luaoc")
	luaoc.callStaticMethod(className, methodName, args)
end