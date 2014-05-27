--- 
-- 登录界面
-- @module view.login.LoginView
-- 

local string = require("string")
local class = class
local dump = dump
local CCLuaLog = CCLuaLog
local require = require
local kEditBoxInputFlagPassword = kEditBoxInputFlagPassword
local ccc3 = ccc3
local tr = tr
local display = display
local transition = transition
local ccp = ccp
local CCScaleTo = CCScaleTo
local CCRotateTo = CCRotateTo
local CCDelayTime = CCDelayTime
local CCLayerColor = CCLayerColor
local ccc4 = ccc4
local CCSize = CCSize
local CCFileUtils = CCFileUtils
local ENCODE_PATH = ENCODE_PATH
local printf = printf
local CCHTTPRequest = CCHTTPRequest
local pairs = pairs
local PLATFORM_NAME = PLATFORM_NAME

local moduleName = "view.login.LoginView"
module(moduleName)

--- 
-- 类定义
-- @type LoginView
-- 
local LoginView = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 密码加密的KEY
-- @field [parent=#view.login.LoginView] #string PWD_CRYPTO_KEY
-- 
local PWD_CRYPTO_KEY = "mhx6_pwd"

--- 
-- 创建实例
-- @function [parent=#view.login.LoginView] new
-- @return #LoginView
-- 
function new()
	return LoginView.new()
end

----- 
---- 大侠特效
---- @field [parent=#LoginView] #CCSprite _daXiaSprite
---- 
--LoginView._daXiaSprite = nil
--
-----
---- 大雁特效
---- @field [parent=#LoginView] #CCSprite _daYanSprite
---- 
--LoginView._daYanSprite = nil
--
----- 
---- 星星
---- @field [parent=#LoginView] #CCSprite _starSpr
---- 
--LoginView._starSpr = nil

--- 
-- 构造函数
-- @function [parent=#LoginView] ctor
-- @param self
-- 
function LoginView:ctor()
	LoginView.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#LoginView] _create
-- @param self
-- 
function LoginView:_create()

	local undumps = self:load("ui/ccb/ccbfiles/ui_login/ui_accountlogin.ccbi")

	self:handleButtonEvent("signupBtn", self._signupClkHandler)
	self:handleButtonEvent("okBtn", self._okClkHandler)
	self:handleButtonEvent("findPwdBtn", self._findPwdClkHandler)
	
--	self:addTeXiao()

	local acctEdit = self["acctEdit"]
	acctEdit:setPlaceHolder(tr("点击输入账号"))
	acctEdit:setFontColor(ccc3(0,0,0))
	acctEdit:setMaxLength(16)

	local pwdEdit = self["pwdEdit"]
	pwdEdit:setPlaceHolder(tr("点击输入密码"))
	pwdEdit:setInputFlag(kEditBoxInputFlagPassword)
	pwdEdit:setFontColor(ccc3(0,0,0))
	pwdEdit:setMaxLength(16)

	--if( true ) then return end

	-- 读取保存的信息
	local LocalConfig = require("utils.LocalConfig")
	local UserConfigs = require("model.const.UserConfigs")

	local acctId = LocalConfig.getValue(false, UserConfigs.ACCT_ID)
	if( acctId ) then
		acctEdit:setText(acctId)

		local savePwd = LocalConfig.getValue(false, UserConfigs.SAVE_PWD)
		if( savePwd ) then
			--local pwdChk = self["pwdChk"]
			--pwdChk:setSelectedIndex(1)

			local pwd = LocalConfig.getValue(false, UserConfigs.PWD)
			if( pwd ) then
				local crypto = require("framework.client.crypto")
				pwd = crypto.decryptAES256(pwd, PWD_CRYPTO_KEY)
				pwdEdit:setText(pwd)
			end
		end
	end
end

--- 
-- 设置账号和密码
-- @function [parent=#LoginView] setAcctAndPwd
-- @param self
-- @param #string acct 账号
-- @param #string pwd 密码
-- 
function LoginView:setAcctAndPwd( acct, pwd )
	if acct then
		self["acctEdit"]:setText(acct)
	end
	
	if pwd then
		self["pwdEdit"]:setText(pwd)
	end
end

--- 
-- 点击了注册
-- @function [parent=#LoginView] _signupClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function LoginView:_signupClkHandler( sender, event )
	local PlatformLogic = require("logic.PlatformLogic")
	if not PlatformLogic.isUseMHSdk() then return end

	local GameView = require("view.GameView")
	local SignupView = require("view.login.SignupView")
	GameView.replaceMainView(SignupView.new())
end

--- 
-- 点击了确定
-- @function [parent=#LoginView] _okClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function LoginView:_okClkHandler( sender, event )
	local acctEdit = self["acctEdit"]
	local pwdEdit = self["pwdEdit"]
	local acct = acctEdit:getText()
	local pwd = pwdEdit:getText()

	if not acct or not pwd or string.len(acct)<=0 or string.len(pwd)<=0 then
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("用户名或密码为空")}, {{text=tr("确定")}})
		return 
	end
	
	local PlatformLogic = require("logic.PlatformLogic")

	-- 自有用户系统
	if PlatformLogic.isUseMHSdk() then
		-- 登录
		local MHSdk = require("logic.sdk.MHSdk")
		MHSdk.signin(acct, PLATFORM_NAME, pwd)
		return
	end

	-- 没账号，或者账号变动
	local LocalConfig = require("utils.LocalConfig")
	local UserConfigs = require("model.const.UserConfigs")
	local GameConfigs = require("model.const.GameConfigs")

	local curAcct = LocalConfig.getValue(false, UserConfigs.ACCT_ID)
	if( not curAcct or acct~=curAcct ) then
		LocalConfig.loadUserConfig(acct)
	end

	LocalConfig.setValue(true, GameConfigs.LAST_ACCT, acct)

	-- 保存密码
	--local pwdChk = self["pwdChk"]
	--local selIdx = pwdChk:getSelectedIndex()
	local selIdx = 1
	if( selIdx==1 ) then
		LocalConfig.setValue(false, UserConfigs.SAVE_PWD, 1)

		local crypto = require("framework.client.crypto")
		local savePwd = crypto.encryptAES256(pwd, PWD_CRYPTO_KEY)
		LocalConfig.setValue(false, UserConfigs.PWD, savePwd)
	else
		LocalConfig.setValue(false, UserConfigs.SAVE_PWD, nil)
		LocalConfig.setValue(false, UserConfigs.PWD, nil)
	end
	
	-- 选服
	local SelectServerView = require("view.login.SelectServerView")
	SelectServerView.createInstance():openUi(acct, pwd)
end

--- 
-- 点击了找回密码
-- @function [parent=#LoginView] _findPwdClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function LoginView:_findPwdClkHandler( sender, event )
	local PlatformLogic = require("logic.PlatformLogic")
	if not PlatformLogic.isUseMHSdk() then return end

	local GameView = require("view.GameView")
	local FindPwd1View = require("view.login.FindPwd1View")
	GameView.replaceMainView(FindPwd1View.new())
end

--- 
-- 添加特效
-- @function [parent=#LoginView] addTeXiao
-- @param self
-- 
function LoginView:addTeXiao()
	-- 我是大侠特效
--	display.addSpriteFramesWithFile("res/ui/effect/login_1.plist", "res/ui/effect/login_1.png")
--	self._daXiaSprite = display.newSprite()
--	self:addChild(self._daXiaSprite)
--	self._daXiaSprite:setPositionX(492)
--	self._daXiaSprite:setPositionY(319)
--	
--	local frames = display.newFrames("login_1/1000%d.png", 0, 10)
--	local animation = display.newAnimation(frames, 1/6)
--	transition.playAnimationForever(self._daXiaSprite, animation, 0.6)
	
	-- 大雁特效
--	display.addSpriteFramesWithFile("res/ui/effect/login_2.plist", "res/ui/effect/login_2.png")
--	self._daYanSprite = display.newSprite()
--	self:addChild(self._daYanSprite)
--	self._daYanSprite:setPositionX(-220)
--	self._daYanSprite:setPositionY(170)
--	self._daYanSprite:setScaleX(0.8)
--	self._daYanSprite:setScaleY(0.8)
--	
--	local frames = display.newFrames("login_2/1000%d.png", 0, 10)
--	local animation = display.newAnimation(frames, 1/6)
--	transition.playAnimationForever(self._daYanSprite, animation)
	
	-- 星点
--	self._starSpr = display.newSprite("res/ui/effect/star.png", 480+210, 320+245)
--	starSpr:setColor(ccc3(255,255,0))
--	self:addChild(self._starSpr)
--	self._starSpr:setScaleX(0.01)
--	self._starSpr:setScaleY(0.01)
--	local action1 = transition.sequence({CCDelayTime:create(0.9),CCRotateTo:create(0.3, 180),})
--	local action2 = transition.sequence({CCDelayTime:create(0.9),CCScaleTo:create(0.3, 1, 1),})
--	local args2 = {}
--	args2.onComplete = function()
--		self._starSpr:setScaleX(0.01)
--		self._starSpr:setScaleY(0.01)
--	end
--	
--	local args1 = {}
--	args1.onComplete = function() 
--		self._starSpr:setVisible(false)
--		self._starSpr:setRotation(0)
--		local scheduler = require("framework.client.scheduler")
--		local endFunc = function()
--					if not self._proxy then return end
--					if not self or not self._starSpr then return end
--					local action3 = transition.sequence({CCRotateTo:create(0.3, 180),})
--					local action4 = transition.sequence({CCScaleTo:create(0.3, 1, 1),})
--					self._starSpr:setVisible(true)
--					transition.execute(self._starSpr, action3, args1)
--					transition.execute(self._starSpr, action4, args2)
--				end
--		
--		scheduler.performWithDelayGlobal(endFunc, 2/3+1.220)
--	end
--	
--	self._starSpr:setVisible(true)
--	transition.execute(self._starSpr, action1, args1)
--	transition.execute(self._starSpr, action2, args2)
end

---
-- 释放动画
-- @function [parent=#LoginView] removeTeXiao
-- @param self
-- 
function LoginView:removeTeXiao()
--	transition.stopTarget(self._daXiaSprite)
--	transition.stopTarget(self._daYanSprite)
--	transition.stopTarget(self._starSpr)
--	self._starSpr = nil
end

---
-- 退出场景
-- @function [parent=#LoginView] onExit
-- @param self
-- 
function LoginView:onExit()
	self:removeTeXiao()
	
	instance = nil
	LoginView.super.onExit(self)
end
