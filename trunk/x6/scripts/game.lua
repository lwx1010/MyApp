
require("framework.init")
require("framework.client.init")

---
-- 运行中通知ID
-- @field [parent=#global] #number RUNNING_NOTIFY_ID
-- 
local RUNNING_NOTIFY_ID = 1000

---
-- 游戏对象
-- @module game
-- 
game = {}

---
-- 是否在前台
-- @field [parent=#game] #boolean isForeground
-- 
game.isForeground = true

---
-- 游戏启动
-- @function [parent=#game] startup
-- @param #boolean foreground 是否在前台
-- 
function game.startup(foreground)
    local device = require("framework.client.device")
    
    -- 自更新
    if( device.platform=="windows" ) then
    	if( not io.exists("assets/notread.txt") and 
    		(io.exists("assets/LuaHostWin32.exe") or io.exists("assets/libquickcocos2dx.dll")) ) then
    		-- exe, dll 需要更新
    		os.execute("start selfUpdate.bat")
    		CCDirector:sharedDirector():endToLua()
    		return
    	end
    end

    -- 读取游戏配置
    local LocalConfig = require("utils.LocalConfig")
    LocalConfig.loadGameConfig()
    
    local GameConfigs = require("model.const.GameConfigs")
    
    -- 第一次，创建快捷方式
    if device.platform=="android" then
	    local created = LocalConfig.getValue(true, GameConfigs.CREATE_SHORTCUT)
	    if not created then
	    	LocalConfig.setValue(true, GameConfigs.CREATE_SHORTCUT, 1)
	    	
	    	-- 安装程序
			local className = "org/cocos2dx/lib/Cocos2dxHelper"
		    local luaj = require("framework.client.luaj")
			luaj.callStaticMethod(className, "createShortCut")
	    end
	end

    -- 读取最后登录的用户配置
    local lastAcct = LocalConfig.getValue(true, GameConfigs.LAST_ACCT)
    if( lastAcct ) then
        LocalConfig.loadUserConfig(lastAcct)
    end
    
    -- 设置富文本标签
    local RichTextTags = require("model.config.RichTextTags")
    local colorTags = RichTextTags.colorTags
    for k, v in pairs(colorTags) do
    	X6FontCache:addFontColorMark(k, v)
    end
    
    local fontSizeTags = RichTextTags.fontSizeTags
    for k, v in pairs(fontSizeTags) do
    	X6FontCache:addFontSizeMark(k, v)
    end

	-- ccb的资源路径
	CCBProxy:setResRoot("ui/ccb/")
	
	-- 进入后台监听
    local notifyCenter = CCNotificationCenter:sharedNotificationCenter()
    notifyCenter:unregisterScriptObserver(nil, "APP_ENTER_BACKGROUND")
    notifyCenter:unregisterScriptObserver(nil, "APP_ENTER_FOREGROUND")
    notifyCenter:registerScriptObserver(nil, game._enterBackgroundHandler, "APP_ENTER_BACKGROUND")
    notifyCenter:registerScriptObserver(nil, game._enterForegroundHandler, "APP_ENTER_FOREGROUND")
    
    game.isForeground = foreground
    
    local GameView = require("view.GameView")
	GameView.create()
	
	local display = require("framework.client.display")
	if display.getRunningScene()~=GameView.getScene() then
		display.replaceScene(GameView.getScene())
	end
	
	local PlatformLogic = require("logic.PlatformLogic")
	if not PlatformLogic.initPlatform() then
		local Alert = require("view.notify.Alert")
		local item = {text=tr("确定")}
		Alert.show({text=tr("平台sdk初始化失败")}, {item})
		return
	end
    
    -- 充值
    local ConfigParams = require("model.const.ConfigParams")
    if CONFIG[ConfigParams.OPEN_PAY]~=nil then
    	local PlatformLogic = require("logic.PlatformLogic")
    	PlatformLogic.setOpenPay(CONFIG[ConfigParams.OPEN_PAY]>0, "本次封测不开启充值服务")
    end

    -- 开始登录
    require("logic.LoginLogic").start()
end

--- 
-- 进入后台
-- @function [parent=#game] _enterBackgroundHandler
-- 
function game._enterBackgroundHandler( )
	printf("_enterBackgroundHandler")
	
	local sharedApplication = CCApplication:sharedApplication()
	local target = sharedApplication:getTargetPlatform()
	if target==kTargetAndroid then 
		local className = "org/cocos2dx/lib/Cocos2dxHelper"
		local args = {0, "", "", "正在运行中...", false, RUNNING_NOTIFY_ID}
		local sig  = "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;ZI)V"
		CCLuaJavaBridge.callStaticMethod(className, "pushNotify", args, sig)
	end
	
	game.isForeground = false
	
	-- ios7的iphone,来回切换后，音效会播放不了，这里把所有音效释放，来解决这个问题
	local device = require("framework.client.device")
	if device.platform=="ios" then
		local audio = require("framework.client.audio")
		audio.unloadAllEffect()
	end
end

--- 
-- 进入前台
-- @function [parent=#game] _enterForegroundHandler
-- 
function game._enterForegroundHandler( )
	printf("_enterForegroundHandler")
	
	local PlatformLogic = require("logic.PlatformLogic")
	PlatformLogic.showPausePage()
	
	game.isForeground = true
	
	local sharedApplication = CCApplication:sharedApplication()
	local target = sharedApplication:getTargetPlatform()
	if target==kTargetAndroid then
		local className = "org/cocos2dx/lib/Cocos2dxHelper"
		local args = {RUNNING_NOTIFY_ID}
		local sig  = "(I)V"
		CCLuaJavaBridge.callStaticMethod(className, "cancelNotify", args, sig)
	end

	-- 检测网络
	local GameNet = require("utils.GameNet")
	if not GameNet.isConnected() and not GameNet.isConnecting() then
		-- 重连
		local LoginLogic = require("logic.LoginLogic")
		LoginLogic.reconnect()
	end
end

return game
