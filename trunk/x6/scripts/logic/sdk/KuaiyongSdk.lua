---
-- 91平台逻辑
-- @module logic.sdk.KuaiyongSdk
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
local CCCrypto = CCCrypto

local moduleName = "logic.sdk.KuaiyongSdk"
module(moduleName)

---
-- 账号
-- @field [parent=#logic.sdk.KuaiyongSdk] #string _uin
-- 
local _uin = nil

---
-- 会话id
-- @field [parent=#logic.sdk.KuaiyongSdk] #string _sessionId
-- 
local _sessionId = nil

---
-- guid
-- @field [parent=#logic.sdk.KuaiyongSdk] #string _guid
-- 
local _guid = nil

---
-- 初始化平台
-- @function [parent=#logic.sdk.KuaiyongSdk] initPlatform
-- @return #boolean 是否正确初始化
-- 
function initPlatform( )
	CCLuaLog("快用初始化")
	
	local PlatformLogic = require("logic.PlatformLogic")
	PlatformLogic.setSupportReconnect(false)
	
	local className = "KuaiyongSdk"
	local methodName = "init"
	local args = {callback=_callback}

	local luaoc = require("framework.client.luaoc")
	luaoc.callStaticMethod(className, methodName, args)
	
	-- 关闭游戏账号登陆(0:显示游戏账号登陆, 1:关闭游戏账号登陆)
	luaoc.callStaticMethod("KuaiyongSdk", "changeLogOption", {option = 1})
	return true
end

---
-- 打开登录界面
-- @function [parent=#logic.sdk.KuaiyongSdk] openLoginView
-- 
function openLoginView( )
	local luaoc = require("framework.client.luaoc")
	luaoc.callStaticMethod("KuaiyongSdk", "showLogin", nil)
	
	local GameView = require("view.GameView")
	local PlatformLoginView = require("view.login.PlatformLoginView")
	GameView.replaceMainView(PlatformLoginView.new())
end

---
-- 打开sdk的登录界面
-- @function [parent=#logic.sdk.KuaiyongSdk] openSdkLogin
-- 
function openSdkLogin( )
	local luaoc = require("framework.client.luaoc")
	luaoc.callStaticMethod("KuaiyongSdk", "showLogin", nil)
end

---
-- 注销(有回调)
-- @function [parent=#logic.sdk.KuaiyongSdk] logout
-- 
function logout( )
	local luaoc = require("framework.client.luaoc")
	luaoc.callStaticMethod("KuaiyongSdk", "logout", nil)
end

---
-- 发送登录协议
-- @function [parent=#logic.sdk.KuaiyongSdk] sendLoginProto
-- 
function sendLoginProto()
	local GameNet = require("utils.GameNet")
	local User = require("model.User")
	local ConfigParams = require("model.const.ConfigParams")
	
	local pbObj = {}
	pbObj.token = _sessionId
	pbObj.account_id = _uin
	pbObj.corpid = tonumber(CONFIG[ConfigParams.PLATFORM_ID])
	pbObj.serverid = tonumber(CONFIG[ConfigParams.SERVER_ID])
	pbObj.extdata = "app_id=".."bee01bba8af7411dc1b0a386c56ae856"
	GameNet.send("C2s_ptduijie_login", pbObj)
end

---
-- pp回调
-- @function [parent=#logic.sdk.KuaiyongSdk] _callback
-- @param #string type 回调类型
-- @param #string retStr 回调结果
-- 
function _callback(type, retStr)
	printf(type.." "..retStr)
	
	if type=="login" or type == "quicklogin" then
		if retStr=="success" then
			local luaoc = require("framework.client.luaoc")
            local uin = ""
			local ret, sessionId = luaoc.callStaticMethod("KuaiyongSdk", "getSessionId", nil)
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
			
			local userName = ""
			
			local appid = "bee01bba8af7411dc1b0a386c56ae856"
			local sign = CCCrypto:MD5Lua(appid .. sessionId, false)
			
			local url ="http://f_signin.bppstore.com/loginCheck.php?tokenKey="..sessionId.."&sign="..sign
			local request = CCHTTPRequest:createWithUrlLua(_requestAcctCallback, url, nil)
			if not request then
				local Alert = require("view.notify.Alert")
				Alert.show({text=tr("账号请求：创建网络失败")}, {{text=tr("确定")}})
				return
			end
	
			CCLuaLog(url)
			
			local NetLoading = require("view.notify.NetLoading")
			NetLoading.show()
	
			request:setTimeout(60)
			request:start()
			
			
			
		return
		end
		
		-- 错误
		local hasLogined = _uin~=nil
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
	
	if type=="session" then
		_uin = nil
		_sessionId = nil
		local device = require("framework.client.device")
		device.showAlert("", tr("网络会话失效，请检查网络"), {tr("确定")}, function(event)
			local LoginLogic = require("logic.LoginLogic")
			LoginLogic.restartApp(false)
		end)
		return
	end
	
	if type=="leave" then
		return
	end
	
	if type=="pause" then
		return
	end
	
	if type=="pay" then
		return
	end
end

---
-- 返回货币名字
-- @function [parent=#logic.sdk.KuaiyongSdk] getCurrencyName
-- @return #string 货币名字
-- 
function getCurrencyName()
	return ""
end

---
-- 返回货币单位
-- @function [parent=#logic.sdk.KuaiyongSdk] getCurrencyUnitName
-- @return #string 货币单位
-- 
function getCurrencyUnitName()
	return tr("元")
end

---
-- 返回货币类型
-- @function [parent=#logic.sdk.KuaiyongSdk] getCurrencyType
-- @return #string 支付账号
-- 
function getCurrencyType()
	return "KY"
end

---
-- 返回汇率类型
-- @function [parent=#logic.sdk.KuaiyongSdk] getRateType
-- @return #string 汇率类型
-- 
function getRateType()
	return "KY"
end

---
-- 返回支付账号
-- @function [parent=#logic.sdk.KuaiyongSdk] getPayAccount
-- @return #string 支付账号
-- 
function getPayAccount()
	return _uin
end

---
-- 设置支付账号
-- @function [parent=#logic.sdk.KuaiyongSdk] setPayAccount
-- @param #string uin 支付账号
-- 
function setPayAccount(uin)
	_uin = uin
end

---
-- 设置guid
-- @function [parent=#logic.sdk.KuaiyongSdk] setGuid
-- @param #string guid
-- 
function setGuid(guid)
	_guid = guid
end

---
-- 调用sdk的支付接口
-- @function [parent=#logic.sdk.KuaiyongSdk] payBySdk
-- @param #number rmb 人民币
-- @param #number yuanBao 兑换元宝数量
-- @param #string sn 订单号
-- 
function payBySdk(rmb, yuanBao, sn)
	local ConfigParams = require("model.const.ConfigParams")
	local serverId = CONFIG[ConfigParams.SERVER_ID]
	
	local className = "KuaiyongSdk"
	local methodName = "pay"
	local args = {}
	args["sn"] = sn
	args["desc"] = ""..serverId
	args["price"] = rmb
	args["billTitle"] = yuanBao..tr("元宝")
	args["amount"] = 1
    args["guid"] = _guid

	local luaoc = require("framework.client.luaoc")
	luaoc.callStaticMethod(className, methodName, args)
end

--- 
-- 支付sn下载回调
-- @function [parent=#logic.sdk.KuaiyongSdk] _requestAcctCallback
-- @param #table event 下载事件
-- 
function _requestAcctCallback( event )
	if event.name=="progress" then
		return
	end
	
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()
	
	local request = event.request
	local errCode = request:getErrorCode()
	local responseCode = request:getResponseStatusCode()
	if event.name~="completed" or errCode~=0 or responseCode~=200 then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("账号获取失败："..event.name.."_"..errCode.."_"..responseCode)}, {{text=tr("确定")}})
		return
	end
	
	local jsonStr = request:getResponseString()
	if jsonStr==nil or #jsonStr<=0 then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("账号获取失败：数据为空")}, {{text=tr("确定")}})
		return
	end
	
	printf(jsonStr)
	
	local cjson = require("cjson")
	local status, result = pcall(cjson.decode, jsonStr)
    if not status or not result or not result["code"] or not result["data"] then
   		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("账号数据解析失败："..jsonStr)}, {{text=tr("确定")}})
		return
    end
    
    local code = result["code"]
    
    if code ~= 0 then
    	local Alert = require("view.notify.Alert")
		Alert.show({text=tr("账号请求错误：错误码"..code)}, {{text=tr("确定")}})
		return
    end
    
    _guid = result["data"]["guid"]
    _uin = result["data"]["username"]
    
    -- 选服
	local UpdateLogic = require("logic.UpdateLogic")
	UpdateLogic.updateResource(function(ret, msg)
		if ret then
		-- 获取username,guid
					
			local SelectServerView = require("view.login.SelectServerView")
			SelectServerView.createInstance():openUi(_uin, "", _sessionId, _uin)
		else
			local device = require("framework.client.device")
			local LoginLogic = require("logic.LoginLogic")
					
			local string = require("string")
			local msg = string.format(tr("更新失败" .. msg));
			local yesBtn = tr("重启游戏")
					
			if device.platform=="ios" then
			device.showAlert("", msg, {yesBtn}, function(event)
					if event.buttonIndex==1 then
						logout()
						LoginLogic.restartApp()
					end
				end)
				return true
			end
		end
		end)
    
    
end