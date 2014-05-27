---
-- 登陆协议的处理
-- @module protocol.handler.LoginHandler
-- 

local require = require
local print = print
local dump = dump
local tr = tr
local CCFileUtils = CCFileUtils
local ENCODE_PATH = ENCODE_PATH
local PLATFORM_NAME = PLATFORM_NAME
local CCSprite = CCSprite
local CCLayerColor = CCLayerColor
local ccc4 = ccc4
local CCSequence = CCSequence
local CCFadeIn = CCFadeIn
local CCFadeOut = CCFadeOut
local CCDelayTime = CCDelayTime
local CCCallFunc = CCCallFunc

callBackBeginMovieFunctionIOS = function()
	local audio = require("framework.client.audio")
	local LocalConfig = require("utils.LocalConfig")
	local GameConfigs = require("model.const.GameConfigs")
	local musicDisabled = LocalConfig.getValue(true, GameConfigs.MUSIC_OFF, nil)
		
	if not musicDisabled then
		audio.musicEnable()
		audio.playBackgroundMusic("sound/bgm.mp3")
	end
				
--        local GameView = require("view.GameView")
--        local CreateNameView = require("view.login.CreateNameView")
--        GameView.replaceMainView(CreateNameView.new(), true)
end

module("protocol.handler.LoginHandler")


---
-- 游戏逻辑网络
-- @field [parent = #protocol.handler.LoginHandler] #module GameNet
-- 
local GameNet = require("utils.GameNet")

---
-- 服务器返回角色列表
-- 
GameNet["S2c_login_player_list"] = function( pb )
	local LoginLogic = require("logic.LoginLogic")
	LoginLogic.hasLogin = true
	
	local PlatformLogic = require("logic.PlatformLogic")
	PlatformLogic.hideLoginAlert()
	
    if( #pb.list_info>0 ) then
        print(tr("选择第一个角色登录服务器"),pb.list_info[1].name)
        GameNet.send("C2s_login_player_enter", {id=pb.list_info[1].id})
    else
    	local NetLoading = require("view.notify.NetLoading")
		NetLoading.hide()
		
		-- 播放片头动画
		local device = require("framework.client.device")
		if (device.platform == "android") or (device.platform == "ios") then
			local audio = require("framework.client.audio")
			local LocalConfig = require("utils.LocalConfig")
			local GameConfigs = require("model.const.GameConfigs")
			local musicDisabled = LocalConfig.getValue(true, GameConfigs.MUSIC_OFF, nil)
		
			if not musicDisabled then
				audio.stopBackgroundMusic(true)
				audio.musicDisable()
			end
			
			local delayTime
		
			if device.platform == "android" then
            
            	local callBackBeginMovieFunctionAndroid = function()
					local device = require("framework.client.device")
					local audio = require("framework.client.audio")
					local LocalConfig = require("utils.LocalConfig")
					local GameConfigs = require("model.const.GameConfigs")
					local musicDisabled = LocalConfig.getValue(true, GameConfigs.MUSIC_OFF, nil)
		
					if not musicDisabled then
						audio.musicEnable()
						audio.playBackgroundMusic("sound/bgm.mp3")
					end
				end
            	
                local className = "org.cocos2dx.lib.Cocos2dxHelper"
                local luaj = require("framework.client.luaj")
                local path = CCFileUtils:sharedFileUtils():fullPathForFilename("sound/movie.mp4")
                if ENCODE_PATH then
                    path = CCFileUtils:sharedFileUtils():encodePath(path)
                end
                local args = {path, callBackBeginMovieFunctionAndroid}
                local sig = "(Ljava/lang/String;I)V"
                luaj.callStaticMethod(className, "playVideo", args, sig)
             elseif device.platform == "ios" then
             	local path = CCFileUtils:sharedFileUtils():fullPathForFilename("sound/movie.mp4")
            	if ENCODE_PATH then
                 	path = CCFileUtils:sharedFileUtils():encodePath(path)
                end

                local luaoc = require("framework.client.luaoc")
                
                local className = "CCPlayVideoView"
--              local registerCallBackMethodName = "registerLuaCallBack"
--              local params = {callback = callBackMyFunction, callB}
--              luaoc.callStaticMethod(className, registerCallBackMethodName, params)
                
                local methodName = "playVideo"
                local args = {filepath = path, callBackFunName = "callBackBeginMovieFunctionIOS"}
                
				local Platforms = require("model.const.Platforms")
--				if PLATFORM_NAME ~= Platforms.PP then
                	luaoc.callStaticMethod(className, methodName, args)
--                else
--        			local bgLayer = CCLayerColor:create(ccc4(0, 0, 0, 255))
--        			local GameView = require("view.GameView")
--        			GameView.replaceMainView(bgLayer, true)
--        			
--                	local PPLogo = CCSprite:create("ui/ccb/ccbResources/layout/9377logo.png")
--                	
--                	local display = require("framework.client.display")
--                	PPLogo:setPosition(display.designCx, display.designCy)
--                	PPLogo:setOpacity(0)
--           			bgLayer:addChild(PPLogo)
--           			
--           			delayTime = 3.7
--                	
--                	local func = function()
--                		luaoc.callStaticMethod(className, methodName, args)
--                	end
--                	
--                	
--                	local action = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCFadeIn:create(1))
--					action = CCSequence:createWithTwoActions(action, CCDelayTime:create(1))
--					action = CCSequence:createWithTwoActions(action, CCFadeOut:create(1))
--					action = CCSequence:createWithTwoActions(action, CCCallFunc:create(func))
--					PPLogo:runAction(action)
--                end
             end
             
             local scheduler = require("framework.client.scheduler")
			 scheduler.performWithDelayGlobal(function( ... )
				-- 创建新角色
        		local GameView = require("view.GameView")
        		local CreateNameView = require("view.login.CreateNameView")
        		GameView.replaceMainView(CreateNameView.new(), true)
			 end, delayTime or 0.5)
		else
			-- 创建新角色
        		local GameView = require("view.GameView")
        		local CreateNameView = require("view.login.CreateNameView")
        		GameView.replaceMainView(CreateNameView.new(), true)
		end

--        local CreateRoleView = require("view.login.CreateRoleView")
--        local GameView = require("view.GameView")
--
--        GameView.replaceMainView(CreateRoleView.new(), true)
    end

end

---
-- 登录错误
-- 
GameNet["S2c_login_error"] = function( pb )
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()
	
	local PlatformLogic = require("logic.PlatformLogic")
	PlatformLogic.hideLoginAlert()
	
	if pb.err_no == 906 then --还未激活账号，弹出激活界面
		local activateAccView = require("view.login.ActivateAccView")
		local gameView = require("view.GameView")
		gameView.addPopUp(activateAccView.createInstance(), true)
		return	
	elseif pb.err_no == 907 then --无效激活码
		local notify = require("view.notify.FloatNotify")
		notify.show(tr("无效激活码"))
		return 
	elseif pb.err_no == 908 then --激活码已被使用
		local notify = require("view.notify.FloatNotify")
		notify.show(tr("激活码已被使用"))
		return
	end 
	
    local Alert = require("view.notify.Alert")
    if pb.err_no == 0 then --如果错误码为0， 则不显示
		Alert.show({text=pb.err_desc},{{text=tr("确定")}})
	else
		Alert.show({text=pb.err_no.."\n"..pb.err_desc},{{text=tr("确定")}})
	end
end

---
-- 登录提示
-- 
GameNet["S2c_login_tips"] = function( pb )
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()
	
    local Alert = require("view.notify.Alert")
	Alert.show({text=pb.msg},{{text=tr("确定")}})
end

---
-- 登录状态
-- 
GameNet["S2c_login_status"] = function( pb )
    if( pb.status==0 ) then
        print(tr("登录失败"))
    elseif( pb.status==1 ) then
        print(tr("登录成功，开始接收数据..."))
    elseif( pb.status==2) then
        print(tr("登录数据接收完毕"))
        
        local GameLogic = require("logic.GameLogic")
        GameLogic.start()
    else
        print(tr("未知登录状态！！！"))
    end
end

---
-- 检测名字是否可用
-- 
GameNet["S2c_login_playername"] = function( pb )
	local GameView = require("view.GameView")
	local view = GameView.getMainView()
	if view.isCreateNameShow then 
		view:updateCanEnter( pb.exist )
		return
	end
	
	local ChangeNameView = require("view.treasure.ChangeNameView")
	if ChangeNameView.instance and ChangeNameView.instance:getProxy() then
		ChangeNameView.instance:updateCanChange( pb.exist )
		return
	end
end

---
-- 从服务端接受guid
-- 
GameNet["S2c_ptduijie_mmguid"] = function( pb )
	if not pb then return end
	
	local PlatformLogic = require("logic.PlatformLogic")
	if pb.acct then
		PlatformLogic.setPayAccount(pb.acct)
	end
	
	if pb.guid then
    	PlatformLogic.setGuid(pb.guid)
    end
end

