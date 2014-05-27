--- 
-- 更新模块.
-- 依赖模块 @{framework.client.api#EventProtocol},@{update#ResourceIniter},@{update#ResourceUpdater}
-- @module update.update
-- 

local string = require("string")
local math = require("math")
local require = require
local package = package
local _G = _G
local ccc3 = ccc3
local CCDirector = CCDirector
local CCSprite = CCSprite
local CCScene = CCScene
local CCSequence = CCSequence
local CCDelayTime = CCDelayTime
local CCFadeOut = CCFadeOut
local CCFadeIn = CCFadeIn
local CCCallFunc = CCCallFunc
local CCLabelTTF = CCLabelTTF
local CCLuaLog = CCLuaLog
local CONFIG_SCREEN_WIDTH = CONFIG_SCREEN_WIDTH
local CONFIG_SCREEN_HEIGHT = CONFIG_SCREEN_HEIGHT
local kResolutionNoBorder = kResolutionNoBorder
local CCBProxy = CCBProxy
local CCProgressTimer = CCProgressTimer
local kCCProgressTimerTypeBar = kCCProgressTimerTypeBar
local ccp = ccp
local CCMenuItemLabel = CCMenuItemLabel
local CCMenu = CCMenu
local CCSize = CCSize
local tr = tr
local CCFileUtils = CCFileUtils
local ENCODE_PATH = ENCODE_PATH
local EXTERNAL_VERSIONS = EXTERNAL_VERSIONS
local INTERNAL_VERSIONS = INTERNAL_VERSIONS
local REMOTE_VERSIONS = REMOTE_VERSIONS
local pcall = pcall
local saveVersions = saveVersions
local CCTextureCache = CCTextureCache
local CCSpriteFrameCache = CCSpriteFrameCache
local CCAnimation = CCAnimation
local CCArray = CCArray
local CCAnimate = CCAnimate
local CCShow = CCShow
local CCHide = CCHide
local CCRepeatForever = CCRepeatForever
local pairs = pairs
local CCApplication = CCApplication
local kTargetWindows = kTargetWindows
local kTargetAndroid = kTargetAndroid
local reloadLanguage = reloadLanguage
local EXTERNAL_PATH = EXTERNAL_PATH
local CCLuaObjcBridge = CCLuaObjcBridge
local DEBUG = DEBUG
local CHANNEL_ID = CHANNEL_ID
local PLATFORM_NAME = PLATFORM_NAME
local CCCrypto = CCCrypto
local CCHTTPRequest = CCHTTPRequest
local CONFIG = CONFIG
local type = type
local tostring = tostring
local CCNotificationCenter = CCNotificationCenter
local CCLuaJavaBridge = CCLuaJavaBridge
local AGENT_NAME = AGENT_NAME


local CONFIG_WEB = CONFIG["configWeb"]

local sharedScheduler = CCDirector:sharedDirector():getScheduler()

local moduleName = "update.update"
module(moduleName)

---
-- 运行中通知ID
-- @field [parent=#update.update] #number RUNNING_NOTIFY_ID
-- 
local RUNNING_NOTIFY_ID = 1000

--- 
-- 是否在前台
-- @field [parent=#update.update] #boolean _isForeground
-- 
local _isForeground = true

--- 
-- 信息文本
-- @field [parent=#update.update] #CCLableTTF _infoLab
-- 
local _infoLab

--- 
-- 进度条
-- @field [parent=#update.update] #CCProgressTimer _bar
-- 
local _bar

--- 
-- 游标
-- @field [parent=#update.update] #CCSprite _cursor
-- 
local _cursor

--- 
-- 眼睛
-- @field [parent=#update.update] #CCSprite _eye
-- 
local _eye

--- 
-- 错误信息
-- @field [parent=#update.update] #string _errInfo
-- 
local _errInfo

--- 
-- 配置是否更新
-- @field [parent=#update.update] #boolean _configUpdated
-- 
local _configUpdated

--- 
-- 版本是否更新
-- @field [parent=#update.update] #boolean _versionUpdated
-- 
local _versionUpdated

--- 
-- sdk是否更新
-- @field [parent=#update.update] #boolean _sdkUpdated
-- 
local _sdkUpdated

--- 
-- 是否已经添加路径
-- @field [parent=#update.update] #boolean _pathAdded
-- 
local _pathAdded = false

--- 
-- 配置更新的最大次数
-- @field [parent=#update.update] #number MAX_CONFIG_UPDATE
-- 
local MAX_CONFIG_UPDATE = 2

--- 
-- 当前配置更新的次数
-- @field [parent=#update.update] #number _curCfgUpdate
-- 
local _curCfgUpdate = 0

--- 
-- 启动
-- @function [parent=#update.update] startup
-- 
function startup( )

	-- 设置显示参数,从framework.client.display里面copy过来
	local sharedDirector = CCDirector:sharedDirector()
	local glview = sharedDirector:getOpenGLView()
	local fSize = glview:getFrameSize()
	
	local scaleX = fSize.width/CONFIG_SCREEN_WIDTH
	local scaleY = fSize.height/CONFIG_SCREEN_HEIGHT
	local scale
	
	if( scaleX>scaleY ) then
		scale = scaleX/scaleY
	else
		scale = scaleY/scaleX
	end
	
	glview:setDesignResolutionSize(CONFIG_SCREEN_WIDTH*scale, CONFIG_SCREEN_HEIGHT*scale, kResolutionNoBorder)
	
	-- 创建场景
	local scene = CCScene:create()
	scene.name = moduleName
	-- 可能是重启
	if sharedDirector:getRunningScene() then
        sharedDirector:replaceScene(scene)
    else
        sharedDirector:runWithScene(scene)
    end
	
	local winSize = sharedDirector:getWinSize()
	
	local logoNode = CCSprite:create()
	scene:addChild(logoNode)

	-- 创建logo
	local logo = CCSprite:create("ui/ccb/ccbResources/layout/companylogo.png")
	--logo:setScale(0.9)
	logo:setOpacity(255)
	logoNode:addChild(logo)
	
	if #AGENT_NAME>0 then
		logo:setPosition(winSize.width/2-195, winSize.height/2+16);
		
		local spr = CCSprite:create("res/ui/ccb/ccbResources/layout/"..AGENT_NAME.."logo.png")
		spr:setPosition(winSize.width/2+250, winSize.height/2+30);
		spr:setScale(0.83)
		logoNode:addChild(spr)
		
		local spr = CCSprite:create("res/ui/ccb/ccbResources/layout/line.png")
		spr:setPosition(winSize.width/2+20, winSize.height/2+50)
		logoNode:addChild(spr)
	else
		logo:setPosition(winSize.width/2, winSize.height/2+40);
	end
	
	local action = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCFadeOut:create(1))
	action = CCSequence:createWithTwoActions(action, CCCallFunc:create(_companyLogoFadeEnd))
	logoNode:runAction(action)
	
	-- ios禁止休眠
	local sharedApplication = CCApplication:sharedApplication()
	local target = sharedApplication:getTargetPlatform()
	if target~=kTargetAndroid and target~=kTargetWindows then
		CCLuaObjcBridge.callStaticMethod("CCIosHelper", "enableSysIdle", {enable=false})
	end
	
	-- 切换侦听
	local notifyCenter = CCNotificationCenter:sharedNotificationCenter()
	notifyCenter:unregisterScriptObserver(nil, "APP_ENTER_BACKGROUND")
    notifyCenter:unregisterScriptObserver(nil, "APP_ENTER_FOREGROUND")
    notifyCenter:registerScriptObserver(nil, _enterBackgroundHandler, "APP_ENTER_BACKGROUND")
    notifyCenter:registerScriptObserver(nil, _enterForegroundHandler, "APP_ENTER_FOREGROUND")
    
    _isForeground = true
    
    -- 初始化目录和更新配置
    _infoLab = nil
	_bar = nil
	_cursor = nil
	_eye = nil
	
    _configUpdated = false
	_versionUpdated = false
	_sdkUpdated = true
	_errInfo = nil
	_curCfgUpdate = 0
	
	-- pp平台需要检测sdk更新
	if PLATFORM_NAME=="pp" then
		_sdkUpdated = false
	end
	
    _initDirAndUpdateConfig()
end

--- 
-- 进入后台
-- @function [parent=#update.update] _enterBackgroundHandler
-- 
function _enterBackgroundHandler( )
	local sharedApplication = CCApplication:sharedApplication()
	local target = sharedApplication:getTargetPlatform()
	if target==kTargetAndroid then 
		local className = "org/cocos2dx/lib/Cocos2dxHelper"
		local args = {0, "", "", "正在运行中...", false, RUNNING_NOTIFY_ID}
		local sig  = "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;ZI)V"
		CCLuaJavaBridge.callStaticMethod(className, "pushNotify", args, sig)
	end
	
	_isForeground = false
end

--- 
-- 进入前台
-- @function [parent=#update.update] _enterForegroundHandler
-- 
function _enterForegroundHandler( )
	local sharedApplication = CCApplication:sharedApplication()
	local target = sharedApplication:getTargetPlatform()
	if target==kTargetAndroid then
		local className = "org/cocos2dx/lib/Cocos2dxHelper"
		local args = {RUNNING_NOTIFY_ID}
		local sig  = "(I)V"
		CCLuaJavaBridge.callStaticMethod(className, "cancelNotify", args, sig)
	end
	
	_isForeground = true
end

--- 
-- 公司logo隐藏结束
-- @function [parent=#update.update] _companyLogoFadeEnd
-- 
function _companyLogoFadeEnd()
	local sharedDirector = CCDirector:sharedDirector()
	local winSize = sharedDirector:getWinSize()
	
	-- 移除logo
	local scene = sharedDirector:getRunningScene()
	scene:removeAllChildrenWithCleanup(true)
	
--	-- 创建logo
--	local logo = CCSprite:create("ui/ccb/ccbResources/layout/logo.png")
--	logo:setPosition(winSize.width/2+14, winSize.height/2+50);
--	logo:setOpacity(0)
--	scene:addChild(logo)
--
--	local action = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCFadeIn:create(1))
--	action = CCSequence:createWithTwoActions(action, CCDelayTime:create(1))
--	action = CCSequence:createWithTwoActions(action, CCFadeOut:create(1))
--	action = CCSequence:createWithTwoActions(action, CCCallFunc:create(_logoFadeEnd))
--	logo:runAction(action)

	_logoFadeEnd()
end

--- 
-- logo隐藏结束
-- @function [parent=#update.update] _logoFadeEnd
-- 
function _logoFadeEnd()
	local sharedDirector = CCDirector:sharedDirector()
	local winSize = sharedDirector:getWinSize()

	-- 移除logo
	local scene = sharedDirector:getRunningScene()
	scene:removeAllChildrenWithCleanup(true)

	-- 加载界面
	local proxy = CCBProxy:create()
	local node = proxy:readCCBFromFile("ui/ccb/ccbfiles/ui_login/ui_loading.ccbi") -- CCNode#CCNode
	node:ignoreAnchorPointForPosition(false)
	node:setAnchorPoint(ccp(0.5, 0.5))
	node:setContentSize(CCSize(CONFIG_SCREEN_WIDTH, CONFIG_SCREEN_HEIGHT))
	node:setPosition(winSize.width/2, winSize.height/2)
	scene:addChild(node)

	_bar = _createProgressBar(proxy, "loadingPBar")
	_bar:setAnchorPoint(ccp(0,0.5))
	_bar:setPositionX(_bar:getPositionX()-_bar:getContentSize().width*0.5)
	_infoLab = proxy:getNodeWithType("infoLab", "CCLabelTTF")
	_infoLab:setString("")
	
	_cursor = proxy:getNodeWithType("cursorSpr", "CCSprite")
	_cursor:setAnchorPoint(ccp(0.5,0.5))
	_cursor:setPositionX(_bar:getPositionX())
	
	-- 眼睛动画
	local img = "ui/effect/login_loading"
	local frameCache = CCSpriteFrameCache:sharedSpriteFrameCache()
	frameCache:addSpriteFramesWithFile(img..".plist", img..".png")
	
	local frames = {}
	frames[1] = frameCache:spriteFrameByName("login_loading/eye_1.png")
	frames[2] = frameCache:spriteFrameByName("login_loading/eye_2.png")
	local arr = CCArray:create()
	arr:addObject(frames[1])
	arr:addObject(frames[2])
	local animation = CCAnimation:createWithSpriteFrames(arr, 0.1)
	local anim = CCAnimate:create(animation)
	
	local spr = CCSprite:create()
	spr:setPosition(673, 450)
	node:addChild(spr)
	
	local action = CCSequence:createWithTwoActions(CCDelayTime:create(4), CCShow:create())
	action = CCSequence:createWithTwoActions(action, anim)
	action = CCSequence:createWithTwoActions(action, CCHide:create())
	action = CCRepeatForever:create(action)
	spr:runAction(action)
	
	_eye = spr
	
	if PLATFORM_NAME=="pp" then
		-- 检测sdk更新
		_infoLab:setString(tr("检查升级中..."))
		
		local os = require("os")
		local beginTime = os.time()
		
		local sharedScheduler = CCDirector:sharedDirector():getScheduler()
		local handle
		handle = sharedScheduler:scheduleScriptFunc(function()
			local ret, isUpdated = CCLuaObjcBridge.callStaticMethod("PPSdk", "isUpdateEnd", nil)
			if not ret then
				_infoLab:setString(tr("检查升级失败"))
				sharedScheduler:unscheduleScriptEntry(handle)
				return
			end
			
			-- pp助手超时不回调，设定20秒超时
			if os.time()-beginTime>=20 then
				isUpdated = true
			end
			
			if isUpdated then
				sharedScheduler:unscheduleScriptEntry(handle)
				_sdkUpdated = true
				_tryGetRemoteVersions()
				return
			end
		    end, 0, false)
	else
		_sdkUpdated = true
		_tryGetRemoteVersions()
		return
	end
end

---
-- 初始化目录和更新配置
-- @function [parent=#update.update] _initDirAndUpdateConfig
-- 
function _initDirAndUpdateConfig()
	-- 检查外部目录是否正确
	local fileUtils = CCFileUtils:sharedFileUtils()
	local path = fileUtils:getWritablePath()
	if not path or #path==0 then
		_errInfo = tr("获取写入目录失败，请检查sd卡是否正确")
		_configUpdated = true
		return
	end
	
	-- 创建外部目录
	if( not fileUtils:isDirectoryExist(EXTERNAL_PATH) ) then
		local lfs = require("lfs")
		local ret, err = lfs.mkdir(EXTERNAL_PATH)
		if( not ret ) then
			CCLuaLog("create EXTERNAL_PATH failed："..err)
			local temp = string.sub(EXTERNAL_PATH, #EXTERNAL_PATH-20, #EXTERNAL_PATH)
			_errInfo = tr("创建写入目录失败，请检查sd卡是否正确."..temp)
			_configUpdated = true
			return
		end
	end
	
	-- 读取远程配置
	if CONFIG_WEB and #CONFIG_WEB>0 then
		if (CHANNEL_ID and #CHANNEL_ID>0) or (PLATFORM_NAME and #PLATFORM_NAME>0) then
			-- 更新配置
			_updateConfig()
			return
		end
	end
	
	_configUpdated = true
end

--- 
-- 更新配置
-- @function [parent=#update.update] _updateConfig
-- 
function _updateConfig()
	local gameKey = (PLATFORM_NAME and PLATFORM_NAME or "") .."_".. CHANNEL_ID
	
	if #gameKey<=1 then
		_configUpdated = true
		return
	end
	
	local os = require("os")
	
	local uri = "/api/game/tag/wsdx/version/"..gameKey
	local ts = os.time()
	local key = "mhis1,000kheros"
	local sign = CCCrypto:MD5Lua(uri..ts..key, false)
	
	local url = CONFIG_WEB..uri.."?ts="..ts.."&sign="..sign
	local request = CCHTTPRequest:createWithUrlLua(_cfgDownloadCallback, url, nil)
	if not request then
		_errInfo = tr("创建获取游戏配置线程失败.请检查网络")
		_configUpdated = true
		return
	end
	
	request:setTimeout(60)
	request:start()
	
--	_infoLab:setString(tr("获取游戏配置中..."))
--	_bar:setPercentage(0)
--	_cursor:setPositionX(_bar:getPositionX())
end

--- 
-- 配置下载回调
-- @function [parent=#update.update] _cfgDownloadCallback
-- @param #table event 下载事件
-- 
function _cfgDownloadCallback( event )
	if event.name=="progress" then
		-- 优先显示sdk更新信息
		if _sdkUpdated and _infoLab and _bar and _cursor then
			local info = tr("获取游戏配置中...(")..event.now.."/"..event.total..")"
			_infoLab:setString(info)
	
			_bar:setPercentage(event.now*100/event.total)
		
			local pos = _bar:getPositionX()+_bar:getContentSize().width*(event.now/event.total)
			_cursor:setPositionX(pos)
		end
		return
	end
	
	local error = false
	local status, result
	local gameKey
	while true do
		local request = event.request
		local errCode = request:getErrorCode()
		local responseCode = request:getResponseStatusCode()
		if event.name~="completed" or errCode~=0 or responseCode~=200 then
			_errInfo = tr("获取游戏配置失败.请检查网络."..event.name.."_"..errCode.."_"..responseCode)
			error = true
			break
		end
		
		local jsonStr = request:getResponseString()
		if jsonStr==nil or #jsonStr<=0 then
			_errInfo = tr("游戏配置内容为空.请检查网络")
			error = true
			break
		end
		
		CCLuaLog(jsonStr)
		
		local cjson = require("cjson")
		status, result = pcall(cjson.decode, jsonStr)
	    if not status or not result then
	   		_errInfo = tr("游戏配置解析失败.请检查网络."..jsonStr)
	   		error = true
			break
	    end
	    
	    gameKey = (PLATFORM_NAME and PLATFORM_NAME or "") .."_".. (CHANNEL_ID and CHANNEL_ID or "")
	    if type(result["rsync"])~="table" or type(result["rsync"][gameKey])~="table" or type(result["rsync"][gameKey]["ext"])~="table" then
	    	_errInfo = tr("游戏配置错误.请检查网络")
	    	error = true
			break
	    end
	    
	    break
	end
	
	-- 错误
	if error then
	    if _curCfgUpdate<MAX_CONFIG_UPDATE then
			_curCfgUpdate = _curCfgUpdate+1
			
			-- 下帧继续更新
			local sharedScheduler = CCDirector:sharedDirector():getScheduler()
			local handle
			handle = sharedScheduler:scheduleScriptFunc(function()
				sharedScheduler:unscheduleScriptEntry(handle)
				 _updateConfig()	
			    end, 0, false)
			return
		end
		
		_configUpdated = true
		_tryGetRemoteVersions()
		return
	end
    
    CCLuaLog("更新配置...")
    
    local cfgTbl = result["rsync"][gameKey]["ext"]
    local verTbl = cfgTbl["versions"]
    cfgTbl["versions"] = nil
    
    _versionUpdated = false
    if type(verTbl)=="table" then
    	for k, v in pairs(verTbl) do
    		REMOTE_VERSIONS[k] = v
    		CCLuaLog(k.."  "..tostring(v))
    		
    		_versionUpdated = true
   		end
    end
    
    for k, v in pairs(cfgTbl) do
    	CONFIG[k] = v
    	CCLuaLog(k.."  "..tostring(v))
   	end
   	
   	-- 初始化地址
    local web = CONFIG["updateWeb"]
    if web and string.sub(web, #web)~="/" then
    	CONFIG["updateWeb"] = web.."/"
    end
   	
   	-- 升级应用
   	_configUpdated = true
	_tryGetRemoteVersions()
end

--- 
-- 尝试获取版本
-- @function [parent=#update.update] _tryGetRemoteVersions
-- 
function _tryGetRemoteVersions( )
	if not _infoLab or not _configUpdated or not _sdkUpdated then
		return
	end
	
	if _errInfo then
		_infoLab:setString(_errInfo)
		return
	end
	
	if _versionUpdated then
		_upgradeApp()
		return
	end
	
	local remoteVersionFile = CONFIG["updateWeb"].."versions.txt"
	CCLuaLog("get versions..."..remoteVersionFile)
	
	-- 下载远程版本
	local request = CCHTTPRequest:createWithUrlLua(_versionDownloadCallback, remoteVersionFile, nil)
	if not request then
		CCLuaLog("create version http failed")
		_infoLab:setString("创建版本下载线程失败.请检查网络")
		return
	end
	
	request:setTimeout(60)
	request:start()
end

--- 
-- 版本下载回调
-- @function [parent=#update.update] _versionDownloadCallback
-- @param #table event 下载事件
-- 
function _versionDownloadCallback( event )
	if event.name=="progress" then
		local info = tr("获取版本信息中...(")..event.now.."/"..event.total..")"
		_infoLab:setString(info)

		_bar:setPercentage(event.now*100/event.total)
	
		local pos = _bar:getPositionX()+_bar:getContentSize().width*(event.now/event.total)
		_cursor:setPositionX(pos)
		return
	end
	
	local error = false
	local status, result
	while true do
		local request = event.request
		local errCode = request:getErrorCode()
		local responseCode = request:getResponseStatusCode()
		if event.name~="completed" or errCode~=0 or responseCode~=200 then
			_errInfo = tr("获取版本信息失败.请检查网络."..event.name.."_"..errCode.."_"..responseCode)
			error = true
			break
		end
		
		local jsonStr = request:getResponseString()
		if jsonStr==nil or #jsonStr<=0 then
			_errInfo = tr("版本信息内容为空.请检查网络")
			error = true
			break
		end
		
		CCLuaLog(jsonStr)
		
		local cjson = require("cjson")
		status, result = pcall(cjson.decode, jsonStr)
	    if not status or not result then
	   		_errInfo = tr("版本信息解析失败.请检查网络."..jsonStr)
	   		error = true
			break
	    end
	    break
	end
	
	if error then
		CCLuaLog(_errInfo)
		_infoLab:setString(_errInfo)
		
		local sharedApplication = CCApplication:sharedApplication()
		local target = sharedApplication:getTargetPlatform()
		if target==kTargetWindows then
			-- app升级
			_upgradeApp()
		end
		return
	end

	for k, v in pairs(result) do
		REMOTE_VERSIONS[k] = v
		_versionUpdated = true
	end
	
	-- app升级
	_upgradeApp()
end

--- 
-- 升级应用
-- @function [parent=#update.update] _upgradeApp
-- 
function _upgradeApp( )

	_infoLab:setString(tr("游戏程序升级中..."))
	_bar:setPercentage(0)
	_cursor:setPositionX(_bar:getPositionX())

	local AppUpgrader = require("update.AppUpgrader")
	AppUpgrader:addEventListener(AppUpgrader.UPGRADE_END.name, _upgradeEndHandler)
    AppUpgrader:addEventListener(AppUpgrader.UPGRADE_PROGRESS.name, _upgradeProgressHandler)
    AppUpgrader.checkUpgrade()
end

--- 
-- 升级结束
-- @function [parent=#update.update] _upgradeEndHandler
-- @param update.AppUpgrader#UPGRADE_END event 
-- 
function _upgradeEndHandler( event )

	local AppUpgrader = require("update.AppUpgrader")
	AppUpgrader:removeAllEventListeners()
	
	local sharedApplication = CCApplication:sharedApplication()
	local target = sharedApplication:getTargetPlatform()
	if( not event.success and target~=kTargetWindows ) then
		_infoLab:setString(tr("游戏自动升级失败！")..event.msg)
		
		if DEBUG>1 then
			-- 临时添加个继续菜单
			local sharedDirector = CCDirector:sharedDirector()
			local winSize = sharedDirector:getWinSize()
	
			local scene = sharedDirector:getRunningScene()
	
			local menu = CCMenu:create()
			menu:setPosition(0, 0)
			scene:addChild(menu)
	
			local lab = CCLabelTTF:create(tr("点我继续..."), "Arial", 40)
			local item = CCMenuItemLabel:create(lab)
			item:registerScriptTapHandler(function ( ... )
				scene:removeChild(menu, true)
				
				_infoLab:setString(tr("正在初始化游戏资源，请稍后……"))
				_bar:setPercentage(100)
				_cursor:setPositionX(_bar:getPositionX()+_bar:getContentSize().width)
				
				-- windows下，下面的调用会引起一系列回调，
				-- 最终导致退出的时候，C++会报内存错误
				local ResourceIniter = require("update.ResourceIniter")
				ResourceIniter:addEventListener(ResourceIniter.INIT_END.name, _initEndHandler)
			    ResourceIniter:addEventListener(ResourceIniter.INIT_PROGRESS.name, _initProgressHandler)
			    ResourceIniter.init()
			end)
			item:setColor(ccc3(255, 127, 0))
			item:setPosition(winSize.width/2, winSize.height/2-250)
			menu:addChild(item)
		end
		return
	end

	_infoLab:setString(tr("正在初始化游戏资源，请稍后……"))
	_bar:setPercentage(100)
	_cursor:setPositionX(_bar:getPositionX()+_bar:getContentSize().width)

	local ResourceIniter = require("update.ResourceIniter")
	ResourceIniter:addEventListener(ResourceIniter.INIT_END.name, _initEndHandler)
    ResourceIniter:addEventListener(ResourceIniter.INIT_PROGRESS.name, _initProgressHandler)
    ResourceIniter.init()
end

---
-- 生成体积字符串
-- @function [parent=#update.update] _createSizeStr
-- @param #number numByte 字节数
-- @return #string 格式化的字符串
-- 
function _createSizeStr( numByte )
	local numK = math.ceil(numByte/1024)
	
	if numK>1024 then
		local numM, subM = math.modf(numK/1024)
		subM = math.floor(subM*100)
		return numM.."."..subM.."Mb"
	else
		return numK.."kb"
	end
end

--- 
-- 升级进度
-- @function [parent=#update.update] _upgradeProgressHandler
-- @param update.AppUpgrader#UPGRADE_PROGRESS event
-- 
function _upgradeProgressHandler( event )

	local info = tr("游戏程序下载中...(").._createSizeStr(event.now).."/".._createSizeStr(event.total)..")"
	_infoLab:setString(info)

	_bar:setPercentage(event.now*100/event.total)
	
	local pos = _bar:getPositionX()+_bar:getContentSize().width*(event.now/event.total)
	_cursor:setPositionX(pos)

	--CCLuaLog(info)
end

--- 
-- 资源初始化结束
-- @function [parent=#update.update] _initEndHandler
-- @param update.ResourceIniter#INIT_END event 
-- 
function _initEndHandler( event )

	local ResourceIniter = require("update.ResourceIniter")
	ResourceIniter:removeAllEventListeners()
	
	if( not event.success ) then
		_infoLab:setString(tr("游戏初始化失败！")..event.msg)
		return
	end
	
	CCLuaLog("in vers:"..(INTERNAL_VERSIONS["core"] or "??").." "..(INTERNAL_VERSIONS["play"] or "??"))
	CCLuaLog("out vers:"..(EXTERNAL_VERSIONS["core"] or "??").." "..(EXTERNAL_VERSIONS["play"] or "??"))

	_infoLab:setString(tr("游戏正在检测更新..."))
	_bar:setPercentage(0)
	_cursor:setPositionX(_bar:getPositionX())

	local ResourceUpdater = require("update.ResourceUpdater")
	ResourceUpdater:addEventListener(ResourceUpdater.UPDATE_END.name, _updateEndHandler)
    ResourceUpdater:addEventListener(ResourceUpdater.DOWNLOAD_PROGRESS.name, _updateDownProgressHandler)
    ResourceUpdater:addEventListener(ResourceUpdater.UNCOMPRESS_PROGRESS.name, _updateUncompressProgressHandler)
    ResourceUpdater.checkUpdate()
end

--- 
-- 资源初始化进度
-- @function [parent=#update.update] _initProgressHandler
-- @param update.ResourceIniter#INIT_PROGRESS event
-- 
function _initProgressHandler( event )

	local info = tr("正在初始化游戏资源，请稍后……(")..event.now.."/"..event.total..")"
	_infoLab:setString(info)

	_bar:setPercentage(event.now*100/event.total)
	
	local pos = _bar:getPositionX()+_bar:getContentSize().width*(event.now/event.total)
	_cursor:setPositionX(pos)

	--CCLuaLog(info)
end

--- 
-- 更新下载进度
-- @function [parent=#update.update] _updateDownProgressHandler
-- @param update.ResourceUpdater#DOWNLOAD_PROGRESS event
-- 
function _updateDownProgressHandler( event )

	local info = tr("下载 ")..event.file..tr(" 中...(").._createSizeStr(event.now).."/".._createSizeStr(event.total)..")"
	_infoLab:setString(info)
	
	_bar:setPercentage(event.now*100/event.total)
	
	local pos = _bar:getPositionX()+_bar:getContentSize().width*(event.now/event.total)
	_cursor:setPositionX(pos)

	--CCLuaLog(info)
end

--- 
-- 更新解压进度
-- @function [parent=#update.update] _updateUncompressProgressHandler
-- @param update.ResourceUpdater#UNCOMPRESS_PROGRESS event
-- 
function _updateUncompressProgressHandler( event )

	local info = tr("解压 ")..event.file..tr(" 中...(")..event.now.."/"..event.total..")"
	_infoLab:setString(info)

	_bar:setPercentage(event.now*100/event.total)
	
	local pos = _bar:getPositionX()+_bar:getContentSize().width*(event.now/event.total)
	_cursor:setPositionX(pos)

	--CCLuaLog(info)
end

--- 
-- 更新结束
-- @function [parent=#update.update] _updateEndHandler
-- @param update.ResourceUpdater#UPDATE_END event
-- 
function _updateEndHandler( event )

	CCLuaLog("in vers:"..(INTERNAL_VERSIONS["core"] or "??").." "..(INTERNAL_VERSIONS["play"] or "??"))
	CCLuaLog("out vers:"..(EXTERNAL_VERSIONS["core"] or "??").." "..(EXTERNAL_VERSIONS["play"] or "??"))

	local ResourceUpdater = require("update.ResourceUpdater")
	ResourceUpdater:removeAllEventListeners()

	if( not event.success ) then
		_infoLab:setString(tr("游戏更新失败！")..event.msg)
		
		-- 更新失败，将版本文件更新
		local resFolder = EXTERNAL_PATH
		saveVersions(resFolder.."assets/versions.txt", EXTERNAL_VERSIONS)
		
		if DEBUG>1 then
			-- 临时添加个继续菜单
			local sharedDirector = CCDirector:sharedDirector()
			local winSize = sharedDirector:getWinSize()
	
			local scene = sharedDirector:getRunningScene()
	
			local menu = CCMenu:create()
			menu:setPosition(0, 0)
			scene:addChild(menu)
	
			local lab = CCLabelTTF:create(tr("点我继续..."), "Arial", 40)
			local item = CCMenuItemLabel:create(lab)
			item:registerScriptTapHandler(function ( ... )
				require("game").startup()
			end)
			item:setColor(ccc3(255, 127, 0))
			item:setPosition(winSize.width/2, winSize.height/2-250)
			menu:addChild(item)
		end
		return
	end

	_bar:setPercentage(50)

	--if( true ) then return end

	--mLabInfo:setString(tr("更新完毕！")..event.msg)

	-- 移除信息文本
	_infoLab:removeFromParentAndCleanup(true)
	_infoLab = nil

	_bar:removeFromParentAndCleanup(true)
	_bar = nil
	
	_cursor:removeFromParentAndCleanup(true)
	_cursor = nil
	
	_eye:removeFromParentAndCleanup(true)
	_eye = nil

	-- 清除缓存的文件
	local fileUtils = CCFileUtils:sharedFileUtils()
	fileUtils:purgeCachedEntries()
	
	-- 添加外部路径
	local needAddExternal = false
	for k, v in pairs(EXTERNAL_VERSIONS) do
		if k~="core" and (not INTERNAL_VERSIONS[k] or v>=INTERNAL_VERSIONS[k]) then
			needAddExternal = true
			break;
		end
	end
	
	CCLuaLog("in vers:"..(INTERNAL_VERSIONS["core"] or "??").." "..(INTERNAL_VERSIONS["play"] or "??"))
	CCLuaLog("out vers:"..(EXTERNAL_VERSIONS["core"] or "??").." "..(EXTERNAL_VERSIONS["play"] or "??"))
	CCLuaLog(needAddExternal and "add ext path" or "not add ext path")
	
	if needAddExternal and not _pathAdded then
		-- 初始化搜索路径和lua路径
		local resFolder = EXTERNAL_PATH
		local scriptPath
	
		if( ENCODE_PATH ) then
			fileUtils:addSearchPath(resFolder.."assets/release/res/", false)
			fileUtils:addSearchPath(resFolder.."assets/release/", false) -- .pb文件
			fileUtils:addSearchPath(resFolder.."assets/", false) -- sound等文件
			scriptPath = resFolder.."assets/release/scripts/?.lua"
		else
			fileUtils:addSearchPath(resFolder.."assets/res/", false)
			fileUtils:addSearchPath(resFolder.."assets/", false) -- .pb文件,sound等文件
			scriptPath = resFolder.."assets/scripts/?.lua"
		end
	
		-- 设置Lua路径
		if( package.path[1]~=";" ) then
			package.path = scriptPath..";"..package.path
		else
			package.path = scriptPath..package.path
		end
		
		_pathAdded = true
	end
	
	-- 移除没用的资源
	CCSpriteFrameCache:sharedSpriteFrameCache():removeUnusedSpriteFrames(false)
	CCTextureCache:sharedTextureCache():removeUnusedTextures(false)
	
	-- 重新加载语言包
	reloadLanguage()

	-- 进入游戏
	local game = require("game") 
    game.startup(_isForeground)
    
    -- ios启用休眠
	local sharedApplication = CCApplication:sharedApplication()
	local target = sharedApplication:getTargetPlatform()
	if target~=kTargetAndroid and target~=kTargetWindows then
		CCLuaObjcBridge.callStaticMethod("CCIosHelper", "enableSysIdle", {enable=true})
	end
end

--- 
-- 创建进度条
-- @function [parent=#update.update] _createProgressBar
-- @param #CCBProxy proxy
-- @param #string dumpName 要替代的dumpName
-- @return #CCProgressTimer
-- 
function _createProgressBar( proxy, dumpName )
	local dumpSprite = proxy:getNodeWithType(dumpName, "CCSprite")
	if( not dumpSprite ) then
		CCLuaLog("type is not CCSprite "..dumpName)
		return
	end

	local x = dumpSprite:getPositionX()
	local y = dumpSprite:getPositionY()
	local z = dumpSprite:getOrderOfArrival()
	local parent = dumpSprite:getParent()
	local anchorPt = dumpSprite:getAnchorPoint()

	parent:removeChild(dumpSprite, true)

	local bar = CCProgressTimer:create(nil)
	bar:setSprite(dumpSprite)
	bar:setType(kCCProgressTimerTypeBar)
	bar:setMidpoint(ccp(0,0))
	bar:setBarChangeRate(ccp(1,0))
	bar:setPosition(x, y)
	bar:setAnchorPoint(anchorPt)
	parent:addChild(bar)
	
	-- addchild设置才有效
	bar:setOrderOfArrival(z)

	return bar
end