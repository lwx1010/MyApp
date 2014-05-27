---
-- 万将用户平台逻辑
-- @module logic.sdk.MHSdk
-- 

local require = require
local printf = printf
local tr = tr
local CONFIG = CONFIG
local tonumber = tonumber
local CCHTTPRequest = CCHTTPRequest
local pcall = pcall
local CCLuaLog = CCLuaLog

local moduleName = "logic.sdk.MHSdk"
module(moduleName)

--- 
-- 密码加密的KEY
-- @field [parent=#logic.sdk.MHSdk] #string PWD_CRYPTO_KEY
-- 
local PWD_CRYPTO_KEY = "mhx6_pwd"

---
-- 账号最小长度
-- @field [parent=#logic.sdk.MHSdk] #number ACCOUNT_MIN_LEN
-- 
ACCOUNT_MIN_LEN = 4

---
-- 账号最大长度
-- @field [parent=#logic.sdk.MHSdk] #number ACCOUNT_MAX_LEN
-- 
ACCOUNT_MAX_LEN = 16

---
-- 密码最小长度
-- @field [parent=#logic.sdk.MHSdk] #number PWD_MIN_LEN
-- 
PWD_MIN_LEN = 4

---
-- 密码最大长度
-- @field [parent=#logic.sdk.MHSdk] #number PWD_MAX_LEN
-- 
PWD_MAX_LEN = 16

---
-- 接口地址
-- @field [parent=#logic.sdk.MHSdk] #string API_URL
-- 
local API_URL = "http://api.millionhero.com/v-1"

---
-- 通讯口令
-- @field [parent=#logic.sdk.MHSdk] #string SECRET
-- 
local SECRET = "mhapi"

---
-- 游戏名字
-- @field [parent=#logic.sdk.MHSdk] #string GAME_NAME
-- 
local GAME_NAME = "大豪侠"

---
-- 账号
-- @field [parent=#logic.sdk.MHSdk] #string _account
-- 
local _account = nil

---
-- 密码
-- @field [parent=#logic.sdk.MHSdk] #string _pwd
-- 
local _pwd = nil

---
-- 令牌
-- @field [parent=#logic.sdk.MHSdk] #string _token
-- 
local _token = nil

---
-- 参数表
-- @field [parent=#logic.sdk.MHSdk] #table _paramTb
-- 
local _paramTb = {}

---
-- 取账号
-- @function [parent=#logic.sdk.MHSdk] getAccount
-- @return #string 账号
-- 
function getAccount()
	return _account
end

---
-- 取密码
-- @function [parent=#logic.sdk.MHSdk] getPwd
-- @return #string 密码
-- 
function getPwd()
	return _pwd
end

---
-- 取令牌
-- @function [parent=#logic.sdk.MHSdk] getToken
-- @return #string 令牌
-- 
function getToken()
	return _token
end

---
-- 取参数表
-- @function [parent=#logic.sdk.MHSdk] getParamTb
-- @return #string 参数
-- 
function getParamTb()
	return _paramTb
end

---
-- 注册
-- @function [parent=#logic.sdk.MHSdk] signup
-- @param #string account 账号[必须，联合唯一]
-- @param #string refer 来源[可选，联合唯一]
-- @param #string password 密码[必须]
-- @param #string idcard 身份证号[可选]
-- @param #string email 电子邮件[可选]
-- 
function signup(account, refer, password, idcard, email )
	local string = require("string")
	account = string.urlencode(account)
	refer = string.urlencode(refer)
	password = string.urlencode(password)
	
	local url = API_URL.."/rpc/signup?secret="..SECRET.."&account="..account.."&refer="..refer.."&password="..password
	
	--email = "twj@millionhero.com"
	if email then
		email = string.urlencode(email)
		url = url.."&email="..email
	end
	
	if idcard then
		idcard = string.urlencode(idcard)
		url = url.."&idcard="..idcard
	end
	
	local function _requestCallback( event )
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
			if responseCode==409 then
				Alert.show({text=tr("注册失败：用户名已注册")}, {{text=tr("确定")}})
			elseif responseCode==400 then
				Alert.show({text=tr("注册失败：注册信息错误")}, {{text=tr("确定")}})
			elseif responseCode==403 or responseCode==404 or responseCode==500 then
				Alert.show({text=tr("注册失败：未知服务器返回值 "..responseCode)}, {{text=tr("确定")}})
			else
				Alert.show({text=tr("注册失败：网络错误 "..event.name.."_"..errCode.."_"..responseCode)}, {{text=tr("确定")}})
			end
			return
		end
		
		local jsonStr = request:getResponseString()
		if jsonStr==nil or #jsonStr<=0 then
			local Alert = require("view.notify.Alert")
			Alert.show({text=tr("注册失败，服务器返回内容为空")}, {{text=tr("确定")}})
			return
		end
		
		printf(jsonStr)
		
		local cjson = require("cjson")
		local status, result = pcall(cjson.decode, jsonStr)
	    if not status or not result then
	   		local Alert = require("view.notify.Alert")
			Alert.show({text=tr("注册失败，服务器返回内容解析失败："..jsonStr)}, {{text=tr("确定")}})
			return
	    end
	    
	    _account = account
	    _pwd = password
	    
	    if _callback then
	    	_callback( "signup", result )
	    end
	end
	
	local request = CCHTTPRequest:createWithUrlLua(_requestCallback, url, nil)
	if not request then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("注册：创建网络失败")}, {{text=tr("确定")}})
		return
	end
	
	CCLuaLog(url)
	
	request:setTimeout(60)
	request:start()
	
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
end

---
-- 登录
-- @function [parent=#logic.sdk.MHSdk] signin
-- @param #string account 账号[必须，联合唯一]
-- @param #string refer 来源[可选，联合唯一]
-- @param #string password 密码[必须]
-- 
function signin(account, refer, password )
	local string = require("string")
	account = string.urlencode(account)
	refer = string.urlencode(refer)
	password = string.urlencode(password)
	
	local url = API_URL.."/rpc/signin?secret="..SECRET.."&account="..account.."&refer="..refer.."&password="..password

	local function _requestCallback( event )
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
			if responseCode==404 then
				Alert.show({text=tr("登录失败：用户没注册")}, {{text=tr("确定")}})
			elseif responseCode==403 then
				Alert.show({text=tr("登录失败：用户密码错误")}, {{text=tr("确定")}})
			elseif responseCode==400 or responseCode==409 or responseCode==500 then
				Alert.show({text=tr("登录失败：未知服务器返回值 "..responseCode)}, {{text=tr("确定")}})
			else
				Alert.show({text=tr("登录失败：网络错误 "..event.name.."_"..errCode.."_"..responseCode)}, {{text=tr("确定")}})
			end
			return
		end
		
		local jsonStr = request:getResponseString()
		if jsonStr==nil or #jsonStr<=0 then
			local Alert = require("view.notify.Alert")
			Alert.show({text=tr("登录失败，服务器返回内容为空")}, {{text=tr("确定")}})
			return
		end
		
		printf(jsonStr)
		
		local cjson = require("cjson")
		local status, result = pcall(cjson.decode, jsonStr)
	    if not status or not result then
	   		local Alert = require("view.notify.Alert")
			Alert.show({text=tr("登录失败，服务器返回内容解析失败："..jsonStr)}, {{text=tr("确定")}})
			return
	    end
	    
	    _account = account
	    _pwd = password
	    _token = result["token"]
	    _paramTb = result["user"]
	    
	    if _callback then
	    	_callback( "signin", result )
	    end
	end
	
	local request = CCHTTPRequest:createWithUrlLua(_requestCallback, url, nil)
	if not request then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("登录：创建网络失败")}, {{text=tr("确定")}})
		return
	end
	
	CCLuaLog(url)
	
	request:setTimeout(60)
	request:start()
	
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
end

---
-- 登出
-- @function [parent=#logic.sdk.MHSdk] signout
-- @param #string account 账号[必须，联合唯一]
-- @param #string refer 来源[可选，联合唯一]
-- @param #string token 令牌[必须]
-- 
function signout(account, refer, token )
	local string = require("string")
	account = string.urlencode(account)
	refer = string.urlencode(refer)
	token = string.urlencode(token)
	
	local url = API_URL.."/rpc/signout?secret="..SECRET.."&account="..account.."&refer="..refer.."&token="..token

	local function _requestCallback( event )
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
			if responseCode==404 or responseCode==400 or responseCode==403 or responseCode==409 or responseCode==500 then
				Alert.show({text=tr("退出失败：未知服务器返回值 "..responseCode)}, {{text=tr("确定")}})
			else
				Alert.show({text=tr("退出失败：网络错误 "..event.name.."_"..errCode.."_"..responseCode)}, {{text=tr("确定")}})
			end
			return
		end
		
		local jsonStr = request:getResponseString()
		if jsonStr==nil or #jsonStr<=0 then
			local Alert = require("view.notify.Alert")
			Alert.show({text=tr("退出失败，服务器返回内容为空")}, {{text=tr("确定")}})
			return
		end
		
		printf(jsonStr)
		
		local cjson = require("cjson")
		local status, result = pcall(cjson.decode, jsonStr)
	    if not status or not result then
	   		local Alert = require("view.notify.Alert")
			Alert.show({text=tr("退出失败，服务器返回内容解析失败："..jsonStr)}, {{text=tr("确定")}})
			return
	    end
	    
	    _account = nil
	    _pwd = nil
	    
	    if _callback then
	    	_callback( "signout", result )
	    end
	end
	
	local request = CCHTTPRequest:createWithUrlLua(_requestCallback, url, nil)
	if not request then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("退出：创建网络失败")}, {{text=tr("确定")}})
		return
	end
	
	CCLuaLog(url)
	
	request:setTimeout(60)
	request:start()
	
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
end

---
-- 重置密码1
-- @function [parent=#logic.sdk.MHSdk] repass1
-- @param #string account 账号[必须，联合唯一]
-- @param #string refer 来源[可选，联合唯一]
-- 
function repass1(account, refer)
	local string = require("string")
	account = string.urlencode(account)
	refer = string.urlencode(refer)
	local game = string.urlencode(GAME_NAME)
	
	local url = API_URL.."/rpc/repass-1?secret="..SECRET.."&account="..account.."&refer="..refer.."&game="..game

	local function _requestCallback( event )
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
			if responseCode==404 then
				Alert.show({text=tr("发送重置密码邮件：账号不存在")}, {{text=tr("确定")}})
			elseif responseCode==204 then
				Alert.show({text=tr("发送重置密码邮件：没有绑定安全邮箱")}, {{text=tr("确定")}})
			elseif responseCode==400 or responseCode==403 or responseCode==409 or responseCode==500 then
				Alert.show({text=tr("发送重置密码邮件：未知服务器返回值 "..responseCode)}, {{text=tr("确定")}})
			else
				Alert.show({text=tr("发送重置密码邮件：网络错误 "..event.name.."_"..errCode.."_"..responseCode)}, {{text=tr("确定")}})
			end
			return
		end
	    
	    if _callback then
	    	_callback( "repass1", {acct=account} )
	    end
	end
	
	local request = CCHTTPRequest:createWithUrlLua(_requestCallback, url, nil)
	if not request then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("发送重置密码邮件：创建网络失败")}, {{text=tr("确定")}})
		return
	end
	
	CCLuaLog(url)
	
	request:setTimeout(60)
	request:start()
	
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
end

---
-- 重置密码2
-- @function [parent=#logic.sdk.MHSdk] repass2
-- @param #string account 账号[必须，联合唯一]
-- @param #string refer 来源[可选，联合唯一]
-- @param #string token 令牌
-- @param #string password 密码
-- 
function repass2(account, refer, token, password)
	local string = require("string")
	account = string.urlencode(account)
	refer = string.urlencode(refer)
	token = string.urlencode(token)
	password = string.urlencode(password)
	local game = string.urlencode("大豪侠")
	
	local url = API_URL.."/rpc/repass-2?secret="..SECRET.."&account="..account.."&refer="..refer.."&token="..token.."&password="..password

	local function _requestCallback( event )
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
			if responseCode==404 then
				Alert.show({text=tr("重置密码：账号不存在")}, {{text=tr("确定")}})
			elseif responseCode==400 or responseCode==403 or responseCode==409 or responseCode==500 then
				Alert.show({text=tr("重置密码：未知服务器返回值 "..responseCode)}, {{text=tr("确定")}})
			else
				Alert.show({text=tr("重置密码：网络错误 "..event.name.."_"..errCode.."_"..responseCode)}, {{text=tr("确定")}})
			end
			return
		end
	    
	    if _callback then
	    	_callback( "repass2", {acct=account, pwd=password} )
	    end
	end
	
	local request = CCHTTPRequest:createWithUrlLua(_requestCallback, url, nil)
	if not request then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("重置密码：创建网络失败")}, {{text=tr("确定")}})
		return
	end
	
	CCLuaLog(url)
	
	request:setTimeout(60)
	request:start()
	
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
end

---
-- 重置用户数据
-- @function [parent=#logic.sdk.MHSdk] reset
-- @param #string account 账号[必须，联合唯一]
-- @param #string refer 来源[可选，联合唯一]
-- @param #string token 令牌
-- @param #string password 密码
-- @param #string idcard 身份证
-- @param #string email 电子邮件
-- 
function reset(account, refer, token, password, idcard, email)
	if not _token then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("修改：令牌为空")}, {{text=tr("确定")}})
		return
	end
	
	local string = require("string")
	account = string.urlencode(account)
	refer = string.urlencode(refer)
	token = string.urlencode(token)
	
	local url = API_URL.."/rest/user?secret="..SECRET.."&account="..account.."&refer="..refer.."&token="..token
	
	if password then
		password = string.urlencode(password)
		url = url.."&password="..password
	end
	if idcard then
		idcard = string.urlencode(idcard)
		url = url.."&idcard="..idcard
	end
	if email then
		email = string.urlencode(email)
		url = url.."&email="..email
	end

	local function _requestCallback( event )
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
			if responseCode==404 then
				Alert.show({text=tr("修改：账号不存在")}, {{text=tr("确定")}})
			elseif responseCode==400 or responseCode==403 or responseCode==409 or responseCode==500 then
				Alert.show({text=tr("修改：未知服务器返回值 "..responseCode)}, {{text=tr("确定")}})
			else
				Alert.show({text=tr("修改：网络错误 "..event.name.."_"..errCode.."_"..responseCode)}, {{text=tr("确定")}})
			end
			return
		end
		
		CCLuaLog(request:getResponseString())
	    
	    if _callback then
	    	_callback( "reset", {password=password, idcard=idcard, email=email})
	    end
	end
	
	local request = CCHTTPRequest:createWithUrlLua(_requestCallback, url, nil, 1)
	if not request then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("修改：创建网络失败")}, {{text=tr("确定")}})
		return
	end
	
	CCLuaLog(url)
	
	request:setTimeout(60)
	request:start()
	
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
end

---
-- 默认回调
-- @function [parent=#logic.sdk.MHSdk] _defaultCallback
-- @param #string type 回调类型
-- @param #table resultTb 回调结果
-- 
function _callback(type, resultTb)
	printf(type)
	
	-- 注册
	if type=="signup" then
		local MHSdk = require("logic.sdk.MHSdk")
		
		-- 自动登录
		local Platforms = require("model.const.Platforms")
		MHSdk.signin(MHSdk.getAccount(), Platforms.MM, MHSdk.getPwd())
		return
	end
	
	-- 登录
	if type=="signin" then
		if not resultTb["token"] then
			local Alert = require("view.notify.Alert")
			Alert.show({text=tr("登录错误：服务器没有返回令牌")}, {{text=tr("确定")}})
			return
		end
		
		local MHSdk = require("logic.sdk.MHSdk")
		
		-- 没账号，或者账号变动
		local LocalConfig = require("utils.LocalConfig")
		local UserConfigs = require("model.const.UserConfigs")
		local GameConfigs = require("model.const.GameConfigs")
	
		local curAcct = MHSdk.getAccount()
		LocalConfig.save(false)
		LocalConfig.loadUserConfig(curAcct)
	
		LocalConfig.setValue(true, GameConfigs.LAST_ACCT, curAcct)
	
		-- 保存密码
		LocalConfig.setValue(false, UserConfigs.SAVE_PWD, 1)
		
		local crypto = require("framework.client.crypto")
		local savePwd = crypto.encryptAES256(MHSdk.getPwd(), PWD_CRYPTO_KEY)
		LocalConfig.setValue(false, UserConfigs.PWD, savePwd)
		
		-- 选服
		local SelectServerView = require("view.login.SelectServerView")
		SelectServerView.createInstance():openUi(MHSdk.getAccount(), MHSdk.getPwd(), resultTb["token"])
		return
	end
	
	-- 发送重置密码邮件
	if type=="repass1" then
		local GameView = require("view.GameView")
		local FindPwd2View = require("view.login.FindPwd2View")
		local view = FindPwd2View.new()
		view:setAccount(resultTb["acct"])
		
		GameView.replaceMainView(view)
		return
	end
	
	-- 重置密码
	if type=="repass2" then
		local GameView = require("view.GameView")
		local LoginView = require("view.login.LoginView")
		local view = LoginView.new()
		view:setAcctAndPwd(resultTb["acct"], resultTb["pwd"])
		
		GameView.replaceMainView(view)
		return
	end
	
	-- 设置数据
	if type=="reset" then
		if resultTb["password"] then
			local ChangePwdView = require("view.help.ChangePwdView")
			if ChangePwdView.instance then
				local GameView = require("view.GameView")
   		 		GameView.removePopUp(ChangePwdView.instance, true)
			end
			
			_pwd = resultTb["password"]
			
			local FloatNotify = require("view.notify.FloatNotify") 
			FloatNotify.show(tr("修改密码成功"))
		end
		
		if resultTb["email"] then
			local BindEmailView = require("view.help.BindEmailView")
			if BindEmailView.instance then
				local GameView = require("view.GameView")
   		 		GameView.removePopUp(BindEmailView.instance, true)
			end
			
			local FloatNotify = require("view.notify.FloatNotify") 
			FloatNotify.show(tr("绑定邮箱成功"))
		end
		
		if resultTb["idcard"] then
			local BindCardView = require("view.help.BindCardView")
			if BindCardView.instance then
				local GameView = require("view.GameView")
   		 		GameView.removePopUp(BindCardView.instance, true)
   		 		
   		 		local FloatNotify = require("view.notify.FloatNotify") 
				FloatNotify.show(tr("设置身份证成功"))
			end
		end
		return
	end
end