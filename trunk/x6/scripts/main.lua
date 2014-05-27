--- 
-- 程序入口.
-- 1.检测app是否为最新，如果不是，下载或者跳转到更新页面
-- 2.如果内部资源版本比外部资源版本要新，将内部资源解压到外部
-- 3.检测远程资源版本，更新资源
-- 4.进入游戏

---
-- 是否加密路径
-- @field [parent=#global] #boolean ENCODE_PATH 
-- 
ENCODE_PATH = false

---
-- 外部资源路径
-- @field [parent=#global] #string EXTERNAL_PATH
-- 
EXTERNAL_PATH = ""

---
-- 内部版本信息,更新包分为:
-- core(核心程序)，包括c++代码和main.lua,update模块，以及涉及到的资源，config.txt等
-- play(玩法脚本，ui等)，包括其他所有lua脚本，ui界面等
-- res1(额外资源包)
-- res2(额外资源包)
-- ...
-- @field [parent=#global] #table INTERNAL_VERSIONS 
-- 
INTERNAL_VERSIONS = {}

---
-- 外部版本信息,更新包分为:
-- core(核心程序)，包括c++代码和main.lua,update模块，以及涉及到的资源，config.txt等
-- play(玩法脚本，ui等)，包括其他所有lua脚本，ui界面等
-- res1(额外资源包)
-- res2(额外资源包)
-- ...
-- @field [parent=#global] #table EXTERNAL_VERSIONS 
-- 
EXTERNAL_VERSIONS = {}

---
-- 远程最新版本信息,更新包分为:
-- core(核心程序)，包括c++代码和main.lua,update模块，以及涉及到的资源，config.txt等
-- play(玩法脚本，ui等)，包括其他所有lua脚本，ui界面等
-- res1(额外资源包)
-- res2(额外资源包)
-- ...
-- @field [parent=#global] #table REMOTE_VERSIONS 
-- 
REMOTE_VERSIONS = {}

---
-- 渠道id
-- @field [parent=#global] #string CHANNEL_ID
-- 
CHANNEL_ID = ""

---
-- 平台名字
-- @field [parent=#global] #string PLATFORM_NAME
-- 
PLATFORM_NAME = ""

---
-- 代理商名字
-- @field [parent=#global] #string AGENT_NAME
-- 
AGENT_NAME = ""

---
-- 是否支持talking data
-- @field [parent=#global] #boolean SUPPORT_TALKINGDATA
-- 
SUPPORT_TALKINGDATA = false

--- 
-- 读取版本文件
-- @function [parent=#global] readVersions
-- @param #string versionFile 版本文件
-- @return #table 版本信息
-- 
function readVersions( versionFile )
	local content = CCReadFile(versionFile)
	if not content then return {} end
		
	local cjson = require("cjson")
	local status, result = pcall(cjson.decode, content)
    if not status or not result then
   		CCLuaLog("版本文件解析失败："..versionFile)
		return {}
    end
    
    local vers = {}
    for k, v in pairs(result) do
    	if k~="core" then
    		vers[k] = tonumber(v)
    	else
    		vers[k] = v
    	end
    end
    
    return vers
end

--- 
-- 保存版本文件
-- @function [parent=#global] saveVersions
-- @param #string versionFile 版本文件
-- @param #table versions 版本信息
-- @return #boolean 是否保存成功
-- 
function saveVersions( versionFile, versions )
	local cjson = require("cjson")
	local status, result = pcall(cjson.encode, versions)
    if not status or not result then
   		CCLuaLog("version encode failed:"..versionFile)
		return false
    end
	
	local verFile, err = io.open(versionFile, "w")
    if not verFile then
		CCLuaLog("create version file failed:"..versionFile)
    	return false
    end
    
    -- 写入成功
    verFile:write(result)
    verFile:close()
    
    return true
end

---
-- 多语言转换
-- @function [parent=#global] tr
-- @param #string src 原始字符串
-- @return #string 转换后的字符串
-- 
function tr( src )
	return (TR_TBL and TR_TBL[src]) and TR_TBL[src] or src
end

---
-- 重新加载语言表
-- @function [parent=#global] reloadLanguage
-- 
function reloadLanguage()
    -- 重新加载语言表
	CCLuaLog("加载语言表")
	 
	package.loaded["language"] = nil
	_G["language"] = nil
	
	require("language")
end

---
-- 发送事件到云端
-- @function [parent=#global] sendCloudEvent
-- @param #string event 事件名
-- @param #string value	事件值
-- 
function sendCloudEvent(event, value)
	-- 友盟最大支持256个字符,但100个好像还是太多？
	if value and #value>100 then
		value = string.sub(value, 1, 100)
	end
	
	local target = CCApplication:sharedApplication():getTargetPlatform()
	if target==kTargetAndroid then
		local className = "org/cocos2dx/lib/Cocos2dxHelper"
		local args = {event, value or ""}
		local sig = "(Ljava/lang/String;Ljava/lang/String;)V"
		CCLuaJavaBridge.callStaticMethod(className, "sendUMengEvent", args, sig)
	elseif target~=kTargetWindows then
		value = string.gsub(value, '\n', ' ')
		CCLuaObjcBridge.callStaticMethod("SDKUmeng", "logEvent", {event=event, value=value})
		
--		if SUPPORT_TALKINGDATA then
--			CCLuaObjcBridge.callStaticMethod("TalkingDataSdk", "logEvent", {event=event, value=value})
--		end
	end
end

---
-- 发送错误到云端
-- @function [parent=#global] sendCloudError
-- @param #string err 错误值
-- 
function sendCloudError(err)
	local target = CCApplication:sharedApplication():getTargetPlatform()
	if target==kTargetAndroid then
		local className = "org/cocos2dx/lib/Cocos2dxHelper"
		local args = {err}
		local sig = "(Ljava/lang/String;)V"
		CCLuaJavaBridge.callStaticMethod(className, "sendUMengError", args, sig)
	elseif target~=kTargetWindows then
		sendCloudEvent("error", err)
	end
end

---
-- 开始云端事件
-- @function [parent=#global] beginCloudEvent
-- @param #string event 事件名
-- 
function beginCloudEvent(event)
	local target = CCApplication:sharedApplication():getTargetPlatform()
	if target==kTargetAndroid then
		local className = "org/cocos2dx/lib/Cocos2dxHelper"
		local args = {event}
		local sig = "(Ljava/lang/String;)V"
		CCLuaJavaBridge.callStaticMethod(className, "beginUMengEvent", args, sig)
	elseif target~=kTargetWindows then
		CCLuaObjcBridge.callStaticMethod("SDKUmeng", "beginEvent", {event=event})
	end
end

---
-- 结束云端事件
-- @function [parent=#global] endCloudEvent
-- @param #string event 事件名
-- 
function endCloudEvent(event)
	local target = CCApplication:sharedApplication():getTargetPlatform()
	if target==kTargetAndroid then
		local className = "org/cocos2dx/lib/Cocos2dxHelper"
		local args = {event}
		local sig = "(Ljava/lang/String;)V"
		CCLuaJavaBridge.callStaticMethod(className, "endUMengEvent", args, sig)
	elseif target~=kTargetWindows then
		CCLuaObjcBridge.callStaticMethod("SDKUmeng", "endEvent", {event=event})
	end
end

--- 
-- 主函数
-- @function [parent=#global] main
-- 
function main()
	local sharedApplication = CCApplication:sharedApplication()
	local target = sharedApplication:getTargetPlatform()
	
	local fileUtils = CCFileUtils:sharedFileUtils()
	local assetsPath = target==kTargetAndroid and "" or "assets/"

	-- 判断notread.txt文件是否存在来决定是否读取加密路径
	local notreadFlag = fileUtils:isFileExist(assetsPath.."notread.txt")
	ENCODE_PATH = not notreadFlag

	CCLuaLog(assetsPath.."notread.txt "..(notreadFlag and "yes" or "no"))

	-- 加密的话，会比原来多一层release文件夹
	-- 改变release名称的时候，也需要改AppDelegate.cpp了里面读取main.lua的地方

	-- 设置加密
	if( ENCODE_PATH ) then
		fileUtils:setEncodeFolder("/release/")
	end
	
	-- 取渠道ID
	CHANNEL_ID = CCReadFile(assetsPath.."channel.txt")
	if not CHANNEL_ID then CHANNEL_ID = "" end
	CCLuaLog("channel id: "..CHANNEL_ID)
	
	-- 取代理商名字
	AGENT_NAME = CCReadFile(assetsPath.."agent.txt")
	if not AGENT_NAME then AGENT_NAME = "" end
	CCLuaLog("agent name: "..AGENT_NAME)
	
	-- 友盟统计
	if target==kTargetAndroid then
		local ret, name = CCLuaJavaBridge.callStaticMethod("org/cocos2dx/lib/Cocos2dxHelper", "getStringProperty", {"PLATFORM_NAME"}, "(Ljava/lang/String;)Ljava/lang/String;")
		PLATFORM_NAME = ret and name or ""
		CCLuaLog("platform name: "..PLATFORM_NAME)
		
		--local ret, name = CCLuaJavaBridge.callStaticMethod("org/cocos2dx/lib/Cocos2dxHelper", "getStringProperty", {"UMENG_CHANNEL"}, "(Ljava/lang/String;)Ljava/lang/String;")
		--CHANNEL_ID = ret and name or ""
		--CCLuaLog("channel id: "..CHANNEL_ID)
		
		CCLuaJavaBridge.callStaticMethod("org/cocos2dx/lib/Cocos2dxHelper", "updateUMengConfig", {}, "()V")
	elseif target~=kTargetWindows then
		local ret, key = CCLuaObjcBridge.callStaticMethod("CCIosHelper", "getStringProperty", {key="umengKey"})
		local umengKey = ret and key or "5229809256240b140004bc3d"
		
		--local ret, channel = CCLuaObjcBridge.callStaticMethod("CCIosHelper", "getStringProperty", {key="MHChannel"})
		--CHANNEL_ID = ret and channel or ""
		
		local ret, name = CCLuaObjcBridge.callStaticMethod("CCIosHelper", "getStringProperty", {key="MHPlatform"})
		PLATFORM_NAME = ret and name or ""
		CCLuaLog("platform name: "..PLATFORM_NAME)
		
		CCLuaObjcBridge.callStaticMethod("SDKUmeng", "start", {appKey=umengKey, policy=6, channel=CHANNEL_ID})
		CCLuaObjcBridge.callStaticMethod("SDKUmeng", "setSendInterval", {interval=600})
		CCLuaObjcBridge.callStaticMethod("SDKUmeng", "updateOnlineConfig", nil)
		
		-- talkingData
		local ret, key = CCLuaObjcBridge.callStaticMethod("CCIosHelper", "getStringProperty", {key="talkingDataKey"})
		if ret and key and #key>0 then
			SUPPORT_TALKINGDATA = true
			CCLuaObjcBridge.callStaticMethod("TalkingDataSdk", "start", {appKey=key, channel=CHANNEL_ID})
		end
	end
	
	-- 初始化外部目录
	-- 暂不判断外部目录的正确性，留到升级时才判断
	EXTERNAL_PATH = fileUtils:getWritablePath() or ""
--	if CHANNEL_ID and target~=kTargetWindows then
--		EXTERNAL_PATH = EXTERNAL_PATH..CHANNEL_ID.."/"
--	end
	
	-- 设置搜索路径,lua路径
	local scriptPath = ""
	EXTERNAL_VERSIONS = readVersions(EXTERNAL_PATH.."assets/versions.txt")

	if( target==kTargetWindows ) then
		if( ENCODE_PATH ) then
			fileUtils:addSearchPath("assets/release/res/")
			fileUtils:addSearchPath("assets/release/") -- .pb文件
			fileUtils:addSearchPath("assets/") -- sound文件
			scriptPath = "assets/release/scripts/?.lua"
		else
			fileUtils:addSearchPath("res/")
			scriptPath = "scripts/?.lua"
		end
	else
		INTERNAL_VERSIONS = readVersions(assetsPath.."versions.txt")
		
		-- 外部可能没初始化，或者版本号不正确，还原一下core版本
		EXTERNAL_VERSIONS["core"] = INTERNAL_VERSIONS["core"]
		
		-- 加入apk路径
		if( ENCODE_PATH ) then
			fileUtils:addSearchPath(assetsPath.."release/res/")
			fileUtils:addSearchPath(assetsPath.."release/") -- .pb文件
			fileUtils:addSearchPath(assetsPath) -- sound等文件
			scriptPath = scriptPath..";"..assetsPath.."release/scripts/?.lua"
		else
			fileUtils:addSearchPath(assetsPath.."res/")
			fileUtils:addSearchPath(assetsPath) -- .pb文件,sound等文件
			scriptPath = scriptPath..";"..assetsPath.."scripts/?.lua"
		end
	end

	-- 设置Lua路径
    if( package.path[1]~=";" ) then
    	package.path = scriptPath..";"..package.path
    else
    	package.path = scriptPath..package.path
    end
    
    -- 打印版本号
    CCLuaLog("EXTERNAL_VERSIONS：")
    for k, v in pairs(EXTERNAL_VERSIONS) do
    	CCLuaLog(k.." "..v)
    end
    
    CCLuaLog("INTERNAL_VERSIONS：")
    for k, v in pairs(INTERNAL_VERSIONS) do
    	CCLuaLog(k.." "..v)
    end
    
    -- ccb的资源路径
	CCBProxy:setResRoot("ui/ccb/")
    
    -- 备份log
    local resPath = EXTERNAL_PATH
    if fileUtils:isFileExist(resPath.."err.txt") then
	    local oldLog = CCReadFile(resPath.."err.txt")
	    if( oldLog and #oldLog>0 ) then
	    	local bakFile = io.open(resPath.."err.txt.bak", "w")
	    	if( bakFile ) then
	    		bakFile:write(oldLog)
	    		bakFile:close()
	    	end
	    end
	end
	
    local logFile = io.open(resPath.."err.txt", "w")
    if( logFile ) then
    	logFile:close()
    end
    
    -- 定时写Log
    local scheduler = CCDirector:sharedDirector():getScheduler()
    scheduler:scheduleScriptFunc(_writeErrorLog, 10, false)
    
    -- 读取配置
    require("config")
    
    -- 加载语言表
    reloadLanguage()

    -- 关闭监听
    local proxy = CCBProxy:create()
    proxy:retain()
    proxy:handleKeypad(_keypadClkHandler)
    
	-- 更新游戏
    local update = require("update.update") 
    update.startup()
    
    -- 生成相关代码
    --local GenCodeUtil = require("utils.GenCodeUtil")
    --GenCodeUtil.genItemAttrFile("scripts/model/ItemAttr.lua", "proto/hero_attr.lua")
    --GenCodeUtil.genHandlersFile("scripts/protocol/handler")
    --GenCodeUtil.genPbcsFile("scripts/protocol/pbc")
    --GenCodeUtil.genHeroAttrFile("scripts/model/HeroAttr.lua", "proto/hero_attr.lua")
    --GenCodeUtil.genPartnerAttrFile("scripts/model/PartnerAttr.lua", "proto/hero_attr.lua")
end

---
-- 最后一次按back的时间
-- @field [parent=#global] #number _lastBackTime
-- 
local _lastBackTime = nil

--- 
-- 点击了按键
-- @function [parent=#global] _keypadClkHandler
-- @param #number key 点击的键
-- 
function _keypadClkHandler( key )
	if( key==kLuaEventKeyMenu ) then
		--
	elseif( key==kLuaEventKeyBack ) then
		local now = CCTime:millisecondNow()
		if( _lastBackTime and now-_lastBackTime<2500 ) then
			CCDirector:sharedDirector():endToLua()
			return
		end
		
		_lastBackTime = now
				
		local className = "org/cocos2dx/lib/Cocos2dxHelper"
		local args = {tr("再按一次退出游戏")}
		local sig  = "(Ljava/lang/String;)V"
		CCLuaJavaBridge.callStaticMethod(className, "showToast", args, sig)
	end
end

---
-- 错误信息
-- @field [parent=#global] #string _errs
-- 
local _errs = ""

---
-- 写Log
-- @function [parent=#global] _writeErrorLog
-- 
function _writeErrorLog()
	if( #_errs<=0 ) then return end
	
    local logFile = io.open(EXTERNAL_PATH.."err.txt", "a")
    if( logFile ) then
    	logFile:write(_errs)
    	logFile:close()
    end
    
    -- 不成功也清空，不然字符串太长爆内存了？
    _errs = ""
end

---
-- CCLuaEngine使用的traceback
-- @function [parent=#global] __G__TRACKBACK__
-- 
function __G__TRACKBACK__(errorMessage)
	local stack = debug.traceback("", 2)
	sendCloudError(tostring(errorMessage).."\n"..stack)
	
	local errStr = "----------------------------------------\n"
	errStr = errStr.."LUA ERROR: "..tostring(errorMessage).."\n"
	errStr = errStr..stack.."\n"
	errStr = errStr.."----------------------------------------\n"
	
	_errs = _errs..errStr
	
	CCLuaLog(errStr)
	
--    CCLuaLog("----------------------------------------")
--    CCLuaLog("LUA ERROR: "..tostring(errorMessage).."\n")
--    CCLuaLog(debug.traceback("", 2))
--    CCLuaLog("----------------------------------------")
end

xpcall(main, __G__TRACKBACK__)
