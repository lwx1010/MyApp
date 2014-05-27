--- 
-- app升级模块.
-- 从远程服务器下载versions.txt获取最新版本号
-- 然后根据本地版本号下载最新的程序包并安装
-- 调用方可侦听UPGRADE_END,UPGRADER_PROGRESS事件
-- @module update.AppUpgrader
-- 

local require = require
local tr = tr
local CCApplication = CCApplication
local kTargetAndroid = kTargetAndroid
local kTargetWindows = kTargetWindows
local CCHTTPRequest = CCHTTPRequest
local CCLuaLog = CCLuaLog
local CONFIG = CONFIG
local fileUtils = CCFileUtils:sharedFileUtils()
local package = package
local tonumber = tonumber
local CCReadFile = CCReadFile
local CCLuaJavaBridge = CCLuaJavaBridge
local CCNative = CCNative
local CCDirector = CCDirector
local readVersions = readVersions
local INTERNAL_VERSIONS = INTERNAL_VERSIONS
local pairs = pairs
local EXTERNAL_PATH = EXTERNAL_PATH

local REMOTE_VERSIONS = REMOTE_VERSIONS

local moduleName = "update.AppUpgrader"
module(moduleName)

---
-- @type UPGRADE_END
-- @field #string name UPGRADE_END
-- @field #boolean success true|false
-- @field #string msg 错误信息
-- 

--- 
-- 升级完毕事件
-- @field [parent=#update.AppUpgrader] #UPGRADE_END UPGRADE_END
-- 
UPGRADE_END = {name="UPGRADE_END"}

---
-- @type UPGRADE_PROGRESS
-- @field #string name UPGRADE_PROGRESS
-- @field #number total 初始化总量
-- @field #number now 已初始化量
-- 

--- 
-- 升级进度事件
-- @field [parent=#update.AppUpgrader] #UPGRADE_PROGRESS UPGRADE_PROGRESS
-- 
UPGRADE_PROGRESS = {name="UPGRADE_PROGRESS"}


local self = package.loaded[moduleName]

local EventProtocol = require("framework.client.api.EventProtocol")
EventProtocol.extend(self)

--- 
-- 远程资源目录
-- @field [parent=#update.AppUpgrader] #string REMOTE_RES_PATH
-- 
local REMOTE_RES_PATH = CONFIG["updateWeb"]

--- 
-- 资源目录
-- @field [parent=#update.AppUpgrader] #string RES_FOLDER
-- 
local RES_FOLDER = EXTERNAL_PATH

--- 
-- 正在下载的文件名，version表示版本文件
-- @field [parent=#update.AppUpgrader] #string _downingFile
-- 
local _downingFile

--- 
-- 下载回调函数
-- @function [parent=#update.AppUpgrader] _downloadCallback
-- @param #table event 下载事件
-- 
function _downloadCallback( event )

	--CCLuaLog(event.name)

	if( event.name=="progress" ) then
		UPGRADE_PROGRESS.file = _downingFile
		UPGRADE_PROGRESS.total = event.total
		UPGRADE_PROGRESS.now = event.now
		self:dispatchEvent(UPGRADE_PROGRESS)
		return
	end

	_appDownEnd(event)
end

--- 
-- 检测核心包版本
-- @function [parent=#update.AppUpgrader] _checkCoreVersion
-- 
function _checkCoreVersion( )
	local sharedApplication = CCApplication:sharedApplication()
	local target = sharedApplication:getTargetPlatform()
	if( target==kTargetWindows ) then
		UPGRADE_END.success = true
		self:dispatchEvent(UPGRADE_END)
		return
	end
	
	local newVer = REMOTE_VERSIONS["core"]
	if( not newVer ) then
		CCLuaLog("remote app version err："..newVer)
		UPGRADE_END.success = false
		UPGRADE_END.msg = tr("远程程序版本错误：")..newVer
		self:dispatchEvent(UPGRADE_END)
		return
	end
	
	--CCLuaLog("remote app version："..newVer)
	
	-- 本地版本
	local oldVer = INTERNAL_VERSIONS["core"]

	-- 版本一致
	if( tonumber(oldVer)>=tonumber(newVer) ) then
		CCLuaLog("app version matches")
		UPGRADE_END.success = true
		UPGRADE_END.msg = tr("已经是最新版本程序")
		self:dispatchEvent(UPGRADE_END)
		return
	end

	-- 版本异常
--	if( oldVer>newVer ) then
--		CCLuaLog("app version exception!!!")
--		UPGRADE_END.success = false
--		UPGRADE_END.msg = tr("app版本异常：")..oldVer..","..newVer
--		self:dispatchEvent(UPGRADE_END)
--		return
--	end
	
	-- 苹果版本手动更新
	if( target~=kTargetAndroid ) then
		CCNative:createAlert("", tr("发现新版客户端，必须更新后才能进入游戏."), tr("立即更新"))
		CCNative:showAlertLua(function(...)
			local url = "itms-services://?action=download-manifest&url="..REMOTE_RES_PATH..CONFIG["appFileName"]..".plist"
			CCNative:openURL(url)
		end)
		return
	end

	-- 下载新版
	_downingFile = CONFIG["appFileName"].."_"..newVer..".apk"
	
	CCLuaLog("download app：".._downingFile)
	
	local request = CCHTTPRequest:createWithUrlLua(_downloadCallback, REMOTE_RES_PATH.."pkgs/".._downingFile, RES_FOLDER.._downingFile)
	if not request then
		CCLuaLog("create pkg http failed")
		UPGRADE_END.success = false
		UPGRADE_END.msg = tr("创建程序包下载失败")
		self:dispatchEvent(UPGRADE_END)
		return
	end
	
	request:setTimeout(0)
	request:start()
end

--- 
-- 程序下载结束
-- @function [parent=#update.AppUpgrader] _appDownEnd
-- @param #table event 下载事件
-- 
function _appDownEnd( event )
	local request = event.request
	local errCode = request:getErrorCode()
	local responseCode = request:getResponseStatusCode()
	if( event.name~="completed" or errCode~=0 or responseCode~=200 ) then
		local os = require("os")
		os.remove(RES_FOLDER.._downingFile)
		
		local err = _downingFile..","..responseCode.." "..request:getErrorMessage()
		CCLuaLog("down app error："..err)
		UPGRADE_END.success = false
		UPGRADE_END.msg = tr("程序下载失败：")..err
		self:dispatchEvent(UPGRADE_END)
		return
	end
	
	-- 删除旧版本程序
	local oldVer = INTERNAL_VERSIONS["core"]
	local oldVerApp = CONFIG["appFileName"].."_"..oldVer..".apk"
	
	-- 移除文件
	local os = require("os")
	local ret, err = os.remove(RES_FOLDER..oldVerApp)
	if( not ret ) then
		CCLuaLog("remove old app failed: "..err)
	end
	
	-- 安装程序
	local className = "org/cocos2dx/lib/Cocos2dxHelper"
    local args = {RES_FOLDER.._downingFile}
    local sig  = "(Ljava/lang/String;)Z"
	CCLuaJavaBridge.callStaticMethod(className, "installApk", args, sig)
	
	CCDirector:sharedDirector():endToLua()
end

--- 
-- 检测升级
-- @function [parent=#update.AppUpgrader] checkUpgrade
-- 
function checkUpgrade( )

	-- 禁用app升级
	if CONFIG["noAppUpgrade"] and CONFIG["noAppUpgrade"]>0 then
		UPGRADE_END.success = true
		self:dispatchEvent(UPGRADE_END)
		return
	end

	local sharedApplication = CCApplication:sharedApplication()
	local target = sharedApplication:getTargetPlatform()

	-- 其它地方可能用到外部目录，建立外部资源目录
	local resFolder = EXTERNAL_PATH

	if( not fileUtils:isDirectoryExist(resFolder) ) then
		CCLuaLog("create res folder...")
		local lfs = require("lfs")
		local ret, err = lfs.mkdir(resFolder)
		if( not ret ) then
			CCLuaLog("create res folder failed："..err)
			UPGRADE_END.success = false
			UPGRADE_END.msg = tr("创建资源目录失败:")..err
			self:dispatchEvent(UPGRADE_END)
			return
		end
	end
	
	_checkCoreVersion()
end