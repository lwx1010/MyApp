---
-- 登录逻辑
-- @module logic.LoginLogic
-- 

local os = require("os")
local CCLuaLog = CCLuaLog
local tostring = tostring
local require = require
local ENCODE_PATH = ENCODE_PATH
local tr = tr
local CCDirector = CCDirector
local DEBUG = DEBUG
local CONFIG = CONFIG
local PLATFORM_NAME = PLATFORM_NAME

local moduleName = "logic.LoginLogic"
module(moduleName)

--- 
-- 是否初始化网络
-- @field [parent=#logic.LoginLogic] #boolean _initNet
-- 
local _initNet = false

--- 
-- 是否重连
-- @field [parent=#logic.LoginLogic] #boolean _isReconnecting
-- 
local _isReconnecting = false

--- 
-- 重连警告框
-- @field [parent=#logic.LoginLogic] view.notify.Alert#Alert _reconnectAlert
-- 
local _reconnectAlert

--- 
-- 是否已登录
-- @field [parent=#logic.LoginLogic] #boolean hasLogin
-- 
hasLogin = false

--- 
-- 开始，显示登录界面
-- @function [parent=#logic.LoginLogic] start
-- 
function start( )
	
	local PlatformLogic = require("logic.PlatformLogic")
	PlatformLogic.openLoginView()

	-- 读取配置是否播放音乐
	local LocalConfig = require("utils.LocalConfig")
	local GameConfigs = require("model.const.GameConfigs")
	local audio = require("framework.client.audio")
	--audio.setEffectsVolume(0.1)
	
	local isMusicOff = LocalConfig.getValue(true, GameConfigs.MUSIC_OFF)
	if isMusicOff then
		audio.musicDisable()
	end
	
	local isSoundOff =  LocalConfig.getValue(true, GameConfigs.SOUND_OFF)
	if isSoundOff then
		audio.soundDisable()
	end
	
	audio.playBackgroundMusic("sound/bgm.mp3")
end

--- 
-- 登录
-- @function [parent=#logic.LoginLogic] login
-- @param #string acct 账号
-- @param #string pwd 密码
-- @param #string token 口令
-- @return #boolean, #error msg
-- 
function login( acct, pwd, token )

	local GameNet = require("utils.GameNet")
	
	-- 连接了，直接发协议
	if GameNet.isConnected() then
		local User = require("model.User")
		User.acct = acct
		User.pwd = pwd
		User.token = token or ""
	
		local PlatformLogic = require("logic.PlatformLogic")
		PlatformLogic.sendLoginProto()
	
		--- 将配置保存一下
		local LocalConfig = require("utils.LocalConfig")
		LocalConfig.save(true)
		LocalConfig.save(false)
		return true
	end
	
	-- 正在连接
	if GameNet.isConnecting() then
		local User = require("model.User")
		User.acct = acct
		User.pwd = pwd
		User.token = token or ""
		return true
	end
	
	-- 初始化协议
	if not _initNet then
		local device = require("framework.client.device")
		
		local p2pFile = "scripts/protocol/proto.conf"
		local pbFolder = "scripts/protocol/pbc"
		local p2pDebug = (not ENCODE_PATH) and device.platform=="windows"
		local handlerDebug = p2pDebug
		
		-- windows特殊处理
		if( device.platform=="windows" ) then
			local io = require("io")
			if( io.exists("proto.conf") ) then
				p2pFile = "proto.conf"
				pbFolder = "pbc"
				p2pDebug = true
			end
		end
	
		local ret = GameNet.loadPbAndP2p( pbFolder, p2pFile, p2pDebug)
		if( not ret ) then return false, "pb error" end
		
		ret = GameNet.registerHandlers("scripts/protocol/handler", handlerDebug)
		if( not ret ) then return false, "handler error" end
		
		GameNet:addEventListener(GameNet.CONNECT.name, _connectHandler)
		GameNet:addEventListener(GameNet.CONNECT_PROGRESS.name, _connectProgressHandler)
		GameNet:addEventListener(GameNet.CLOSE.name, _closeHandler)
	
	    _initNet = true
	end
	
	local ConfigParams = require("model.const.ConfigParams")
	local ip = CONFIG[ConfigParams.SERVER_IP]
	local port = CONFIG[ConfigParams.SERVER_PORT]
	local timeout = CONFIG[ConfigParams.CONNECT_TIMEOUT]
	local isFlashServer = CONFIG[ConfigParams.FLASH_SERVER]
    local ret = GameNet.connect(ip, port, timeout)
    if( not ret ) then return false, "connect error" end

	local User = require("model.User")
	User.acct = acct
	User.pwd = pwd
	User.token = token or ""
	
	return true
end

--- 
-- 网络连接成功
-- @function [parent=#logic.LoginLogic] _connectHandler
-- @param utils.GameNet#CONNECT event
-- 
function _connectHandler( event )
	if _reconnectAlert then
		_reconnectAlert:hide()
		_reconnectAlert:release()
		_reconnectAlert = nil
	end

	if( not event.success ) then
		if _isReconnecting then
			_isReconnecting = false
			_showBrokenAlert()
			return
		end
		
		local Alert = require("view.notify.Alert")
		local item = {text=tr("确定")}
		if DEBUG>1 then
			item.listener = function( ... )
				local GameView = require("view.GameView")
				local MainView = require("view.main.MainView")
				GameView.replaceMainView(MainView.createInstance(), true)
			end
		end
		Alert.show({text=tr("连不上服务器：")..event.msg}, {item})
		return 
	end
	
	_isReconnecting = false

	local PlatformLogic = require("logic.PlatformLogic")
	PlatformLogic.sendLoginProto()

	--- 将配置保存一下
	local LocalConfig = require("utils.LocalConfig")
	LocalConfig.save(true)
	LocalConfig.save(false)

	-- 主循环
	local scheduler = require("framework.client.scheduler")
	scheduler.scheduleUpdateGlobal(_mainLoop)
end

--- 
-- 网络连接进度
-- @function [parent=#logic.LoginLogic] _connectProgressHandler
-- @param utils.GameNet#CONNECT_PROGRESS event
-- 
function _connectProgressHandler( event )
	if _isReconnecting then
		if _reconnectAlert then
			_reconnectAlert:release()
			_reconnectAlert:hide()
		end
		
		local msg = tr("正在重新连接网络中...")
		msg = msg.."("..event.curTry.."/"..event.maxTry..")"
		local Alert = require("view.notify.Alert")
		_reconnectAlert = Alert.show({text=msg})
		_reconnectAlert:retain()
	end
end

--- 
-- 网络断开连接
-- @function [parent=#logic.LoginLogic] _closeHandler
-- @param utils.GameNet#CLOSE event 事件
-- 
function _closeHandler( event )
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()
	
	-- 把提示隐藏掉
	local PlatformLogic = require("logic.PlatformLogic")
	PlatformLogic.hideLoginAlert()
	
	-- 不支持断线重连
	if not PlatformLogic.isSupportReconnect() then
		_showBrokenAlert()
		return
	end
	
	if not hasLogin then
		_showBrokenAlert()
		return
	end

	-- 在前台的时候重连,否则，等切换回来的时候再连
	local game = require("game")
	if game.isForeground then
		reconnect()
	end
end

--- 
-- 重连
-- @function [parent=#logic.LoginLogic] reconnect
-- 
function reconnect()
	if _isReconnecting then return end
	
	local EventCenter = require("utils.EventCenter")
	local Events = require("model.event.Events")
	EventCenter:dispatchEvent(Events.APP_RECONNECT)
	
	hasLogin = false
	
	_isReconnecting = true
	
	local GameNet = require("utils.GameNet")
	GameNet.reconnect()
end

--- 
-- 重启应用
-- @function [parent=#logic.LoginLogic] restartApp
-- @param #boolean needUpdate 是否需要更新
-- 
function restartApp( needUpdate )
	CCLuaLog("restart app")
	
	local GameNet = require("utils.GameNet")
	GameNet.disconnect()
	
	local EventCenter = require("utils.EventCenter")
	local Events = require("model.event.Events")
	EventCenter:dispatchEvent(Events.APP_RESTART)
	
	local GameView = require("view.GameView")
	GameView.reset()
	
	local audio = require("framework.client.audio")
	audio.stopMusic()
	audio.stopAllSounds()
	
	_reconnectAlert = nil
	hasLogin = false
	
	if needUpdate or needUpdate==nil then
		-- 更新游戏
		local update = require("update.update") 
		update.startup()
	else
		-- 进入游戏
		local game = require("game") 
	    game.startup(game.isForeground)
	end
end

---
-- 显示断网警告
-- @function [parent=#logic.LoginLogic] _showBrokenAlet
-- 
function _showBrokenAlert()
	local msg = tr("网络连接断开")
	local yesBtn = tr("重启游戏")
	local noBtn = tr("退出游戏")

	local device = require("framework.client.device")
	if device.platform=="android" then
		local className = "org/cocos2dx/lib/Cocos2dxHelper"
		local methodName = "showAlert"
		local args = {"", msg, yesBtn, noBtn, function(btn)
			if btn==noBtn then
				CCDirector:sharedDirector():endToLua()
				return
			end
			
			restartApp()
		end}
		
		local luaj = require("framework.client.luaj")
		luaj.callStaticMethod(className, methodName, args)
		return
	end
	
	if device.platform=="ios" then
		device.showAlert("", msg, {yesBtn, noBtn}, function(event)
			if event.buttonIndex==1 then
				restartApp()
			else
				CCDirector:sharedDirector():endToLua()
			end
		end)
		return
	end
	
	local Alert = require("view.notify.Alert")

	local item1 = {text=yesBtn}
	item1.listener = function( ... )
		restartApp()
	end
	
	local item2 = {text=noBtn}
	item2.listener = function( ... )
		CCDirector:sharedDirector():endToLua()
	end
	
	local item3 = {text=tr("转到主界面")}
	item3.listener = function( ... )
		local GameView = require("view.GameView")
		local MainView = require("view.main.MainView")
		GameView.replaceMainView(MainView.createInstance(), true)
	end
	Alert.show({text=msg}, {item1,item2,item3})
end

---
-- 游戏主循环
-- @function [parent=#logic.LoginLogic] _mainLoop
-- @param #number dt 时间间隔
-- 
function _mainLoop( dt )
	local GameNet = require("utils.GameNet")

	-- 检测socket，收发包
	GameNet.checkSocket()

	-- 处理收到的包
	GameNet.processReceivePacks()
end