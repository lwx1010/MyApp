---
-- 选择服务器界面
-- @module view.login.SelectServerView
--

local class = class
local require = require
local tr = tr
local ccp = ccp
local CCSize = CCSize
local tr = tr
local display = display
local transition = transition
local CONFIG = CONFIG
local ipairs = ipairs
local CCDirector = CCDirector
local printf = printf


local moduleName = "view.login.SelectServerView"
module(moduleName)

---
-- 类定义
-- @type SelectServerView
--
local SelectServerView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 登录账号
-- @field [parent=#SelectServerView] _acct
--
SelectServerView._acct = nil

---
-- 登录密码
-- @field [parent=#SelectServerView] _pwd
--
SelectServerView._pwd = nil

---
-- 口令
-- @field [parent=#SelectServerView] _token
--
SelectServerView._token = nil

---
-- logo精灵
-- @field [parent=#SelectServerView] _logoSpr
-- 
SelectServerView._logoSpr = nil

---
-- 构造函数
-- @function [parent=#SelectServerView] ctor
-- @param self
--
function SelectServerView:ctor()
	SelectServerView.super.ctor(self)

	self:_create()
end

---
-- 创建
-- @function [parent=#SelectServerView] _create
-- @param self
--
function SelectServerView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_login/ui_selectserver.ccbi")

	self:createClkHelper()
	self:addClkUi(self["accountSpr"])
	self:addClkUi(self["selSpr"])
	
	self:addLogoEffect()

	self:handleButtonEvent("okBtn", self._okClkHandler)
	self["lastLab"]:setString(tr("测试区"))
	local device = require("framework.client.device")
	local SelectServerLogic = require("logic.SelectServerLogic")
	if device.platform ~= "windows" or SelectServerLogic.WINDOS_SELECTSERVER_SWITCH then
		self["lastLab"]:setString("")

		local NetLoading = require("view.notify.NetLoading")
		NetLoading.show()
		
		local Events = require("model.event.Events")
		local EventCenter = require("utils.EventCenter")
		EventCenter:addEventListener(Events.SELECTEDSERVERLIST_UPDATE.name, self._serverListandWhiteListCallBack, self)
		EventCenter:addEventListener(Events.WHITELIST_UPDATE.name, self._serverListandWhiteListCallBack, self)
	
		local SelectServerLogic = require("logic.SelectServerLogic")
		if SelectServerLogic.readLastServerFromConfig() then
			self["lastLab"]:setString(SelectServerLogic.defaultServerName)
		end
	end
end

---
-- 打开界面
-- @function [parent=#SelectServerView] openUi
-- @param self
-- @param #string acct
-- @param #string pwd
-- @param #string token
-- @param #string showAcct
--
function SelectServerView:openUi(acct, pwd, token, showAcct)
	local GameView = require("view.GameView")
	GameView.replaceMainView(self, true)
	
	if (not acct or showAcct == "") then
		self["selNode"]:setPositionY(100)
		self["accountNode"]:setVisible(false)
	end

	self._acct, self._pwd, self._token = acct, pwd, token
	self["accountLab"]:setString(showAcct and showAcct or acct)
	
	local ConfigParams = require("model.const.ConfigParams")
	local plat = CONFIG[ConfigParams.PLATFORM_ID]
	
	local device = require("framework.client.device")
	local SelectServerLogic = require("logic.SelectServerLogic")
	if device.platform ~= "windows" or SelectServerLogic.WINDOS_SELECTSERVER_SWITCH then
		local WhiteListLogic = require("logic.WhiteListLogic")
		WhiteListLogic.isInWhiteList(showAcct and showAcct or acct, plat, nil)
	end
end

---
-- 列表刷新处理函数
-- @function [parent=#SelectServerView] _serverListCallBack
-- @param self
-- 
function SelectServerView:_serverListandWhiteListCallBack()
	local SelectServerLogic = require("logic.SelectServerLogic")
	local WhiteListLogic = require("logic.WhiteListLogic")
	
	if (not SelectServerLogic.hasGetServerList) or (not WhiteListLogic.isRequestReturn) then
		return
	end
	
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()
	
	local isWhiteListAccount = WhiteListLogic.isWhiteListAccount
	local ds = SelectServerLogic.serverList
	local arr = ds:getArray()
	
	-- 非白名单用户，刷选列表(-1 => '停服', 0 => '内测')
	if not isWhiteListAccount then
		printf("no wite list account")
		for _ , v in ipairs(arr) do
			if (v.server_state == -1) or (v.server_state == 0) then
				ds:removeItem(v)
			end
		end
	end
	
	local SelectServerLogic = require("logic.SelectServerLogic")
	if not SelectServerLogic.defaultServerAreaID then
		if SelectServerLogic.serverList:getLength() == 0 then
			local Alert = require("view.notify.Alert")
			local LoginLogic = require("logic.LoginLogic")
			local item1 = {text = tr("重启游戏")}
			item1.listener = function(...)
				LoginLogic.restartApp()
			end
			Alert.show({text=tr("选服列表为空，请维护人员检查后台配置")}, {item1, {text=tr("确定")}})
			return
		end
		
		local default =  SelectServerLogic.serverList:getItemAt(1)
			SelectServerLogic.defaultServerName = default.server_name
			SelectServerLogic.defaultServerIP = default.server_ip
			SelectServerLogic.defaultServerPort = default.server_port
			SelectServerLogic.defaultServerID = default.server_id
			SelectServerLogic.defaultServerAreaID = default.server_area_id
			SelectServerLogic.defaultServerState = default.server_state
			SelectServerLogic.defaultServerTip = default.server_tip
			self["lastLab"]:setString(SelectServerLogic.defaultServerName)
	else	
		for _ , v in ipairs(arr) do
			if SelectServerLogic.defaultServerAreaID == v.server_area_id or SelectServerLogic.defaultServerAreaID==v.obj_id then
				SelectServerLogic.defaultServerName = v.server_name
				SelectServerLogic.defaultServerIP = v.server_ip 
				SelectServerLogic.defaultServerPort = v.server_port
				SelectServerLogic.defaultServerID = v.server_id
				SelectServerLogic.defaultServerState = v.server_state
				SelectServerLogic.defaultServerTip = v.server_tip
				self["lastLab"]:setString(SelectServerLogic.defaultServerName)
				return
			end
		end
		-- 状态为'停'的服
--		SelectServerLogic.defaultServerState = -1
--		SelectServerLogic.defaultServerTip = tr("您选择的游戏服务器不存在，请重新选择")
		
		if SelectServerLogic.serverList:getLength() == 0 then
			local Alert = require("view.notify.Alert")
			local LoginLogic = require("logic.LoginLogic")
			local item1 = {text = tr("重启游戏")}
			item1.listener = function(...)
				LoginLogic.restartApp()
			end
			Alert.show({text=tr("选服列表为空，请维护人员检查后台配置")}, {item1, {text=tr("确定")}})
			return
		end
		local default =  SelectServerLogic.serverList:getItemAt(1)
		SelectServerLogic.defaultServerName = default.server_name
		SelectServerLogic.defaultServerIP = default.server_ip
		SelectServerLogic.defaultServerPort = default.server_port
		SelectServerLogic.defaultServerID = default.server_id
		SelectServerLogic.defaultServerAreaID = default.server_area_id
		SelectServerLogic.defaultServerState = default.server_state
		SelectServerLogic.defaultServerTip = default.server_tip
		self["lastLab"]:setString(SelectServerLogic.defaultServerName)
	end
end

---
-- ui点击处理函数
-- @function [parent=#SelectServerView] uiClkHandler
-- @param self
-- @param #CCNode ui 被点击ui
-- @param #CCRect rect 点击区域
--
function SelectServerView:uiClkHandler(ui, rect)
	if ui == self["selSpr"] then
		local SelectServerListView = require("view.login.SelectServerListView").createInstance()
		SelectServerListView:openUi(self["lastLab"]:getString())
	else
		local PlatformLogic = require("logic.PlatformLogic")
		PlatformLogic.switchAccount()
		printf("enter PlatformLogic uiClkHandler")
	end
end

---
-- 确定按钮处理函数
-- @function [parent=#SelectServerView] _okClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
--
function SelectServerView:_okClkHandler(sender, event)
	-- 登录
	local device = require("framework.client.device")
	local SelectServerLogic = require("logic.SelectServerLogic")
	if device.platform ~= "windows" or SelectServerLogic.WINDOS_SELECTSERVER_SWITCH then
		local GameNet = require("utils.GameNet")
		GameNet.disconnect()
		
		local SelectServerLogic = require("logic.SelectServerLogic")
		local newServerIP = SelectServerLogic.newServerIP
		local newServerPort = SelectServerLogic.newServerPort
		local newServerID = SelectServerLogic.newServerID
		local newServerAreaID = SelectServerLogic.newServerAreaID
		local newServerState = SelectServerLogic.newServerState
		local newServerTip = SelectServerLogic.newServerTip
		
		local defaultServerIP = SelectServerLogic.defaultServerIP
		local defaultServerPort = SelectServerLogic.defaultServerPort
		local defaultServerID = SelectServerLogic.defaultServerID
		local defaultServerAreaID = SelectServerLogic.defaultServerAreaID
		local defaultServerState = SelectServerLogic.defaultServerState
		local defaultServerTip = SelectServerLogic.defaultServerTip
		
		local msg = newServerTip and newServerTip or defaultServerTip
		local state = newServerState and newServerState or defaultServerState
		local WhiteListLogic = require("logic.WhiteListLogic")
		
		if state == -1  or (state == 1 and not WhiteListLogic.isWhiteListAccount) then
			local Alert = require("view.notify.Alert")
			local LoginLogic = require("logic.LoginLogic")
			local item1 = {text = tr("重启游戏")}
			item1.listener = function(...)
				LoginLogic.restartApp()
			end
--			
--			local item2 = {text = tr("退出")}
--			item2.listener = function(...)
--				CCDirector:sharedDirector():endToLua()
--			end
			if not msg then
				msg = ""
			end
			
			Alert.show({text=tr(msg)}, {item1, {text=tr("确定")}})
			return
		end
	
		local ConfigParams = require("model.const.ConfigParams")
		if not CONFIG[ConfigParams.USE_MCS_SERVER] or CONFIG[ConfigParams.USE_MCS_SERVER]==0 then
			CONFIG[ConfigParams.SERVER_IP] = newServerIP and newServerIP or defaultServerIP
			CONFIG[ConfigParams.SERVER_PORT] = newServerPort and newServerPort or defaultServerPort
			CONFIG[ConfigParams.SERVER_ID] = newServerID and newServerID or defaultServerID
			CONFIG[ConfigParams.AREA_ID] = newServerAreaID and newServerAreaID or defaultServerAreaID
		end
	end

	local LoginLogic = require("logic.LoginLogic")
	local ret, err = LoginLogic.login(self._acct, self._pwd, self._token)
	local device = require("framework.client.device")

	if ret then
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.show()

		local SelectServerLogic = require("logic.SelectServerLogic")
		if device.platform ~= "windows" or SelectServerLogic.WINDOS_SELECTSERVER_SWITCH then
			local SelectServerLogic = require("logic.SelectServerLogic")
			SelectServerLogic.saveLastServerToConfig()
		end
	else
		-- 登录失败
		local Alert = require("view.notify.Alert")
		Alert.show({text=tr("登录失败："..err)}, {{text=tr("确定")}})
		printf("登录失败")
	end
end

---
-- 点击选区按钮处理函数
-- @function [parent=#SelectServerView] _selectClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
--
function SelectServerView:_selectClkHandler(sender, event)
	local SelectServerListView = require("view.login.SelectServerListView").createInstance()
	SelectServerListView:openUi(self["lastLab"]:getString())
end

---
-- 设新选区文字
-- @function [parent=#SelectServerView] setNewLab
-- @param self
-- @param #string str
--
function SelectServerView:setNewLab(str)
	self["lastLab"]:setString(str)
end

---
-- 添加logo特效
-- @function [parent=#SelectServerView] addLogoEffect
-- @param self
--
function SelectServerView:addLogoEffect()
	display.addSpriteFramesWithFile("res/ui/effect/logo_effect.plist", "res/ui/effect/logo_effect.png")
	self._logoSpr = display.newSprite()
	self:addChild(self._logoSpr)
	self._logoSpr:setPositionX(492.5)
	self._logoSpr:setPositionY(490.5)
--	self._logoSpr:setScaleX(0.8)
--	self._logoSpr:setScaleY(0.8)
--	
	local frames = display.newFrames("logo_effect/1000%d.png", 0, 5)
	
	local ImageUtil = require("utils.ImageUtil")
	local frame = ImageUtil.getFrame()
	frames[#frames + 1] = frame
	
	local animation = display.newAnimation(frames, 1/5)
	transition.playAnimationForever(self._logoSpr, animation, 1.5)
	
end

---
-- 移除logo特效
-- @function [parent=#SelectServerView] removeLogoEffect
-- @param self
--
function SelectServerView:removeLogoEffect()
	transition.stopTarget(self._logoSpr)
	self._logoSpr = nil
end

---
-- 菜单项点击处理函数
-- @function [parent=#SelectServerView] _menuItemClkHandler
-- @param self
--
function SelectServerView:_menuItemClkHandler()
	if self["selRGrp"]:getSelectedIndex() == 1 then

	else

	end
end

---
-- 退出场景
-- @function [parent=#SelectServerView] onExit
-- @param self
--
function SelectServerView:onExit()
	instance = nil
	
	self:removeLogoEffect()
	
	local SelectServerLogic = require("logic.SelectServerLogic")
	local device = require("framework.client.device")
	if device.platform ~= "windows" or SelectServerLogic.WINDOS_SELECTSERVER_SWITCH then
		local Events = require("model.event.Events")
		local EventCenter = require("utils.EventCenter")
		EventCenter:removeEventListener(Events.SELECTEDSERVERLIST_UPDATE.name, self._serverListandWhiteListCallBack, self)
		EventCenter:removeEventListener(Events.WHITELIST_UPDATE.name, self._serverListandWhiteListCallBack, self)
	end
	
	SelectServerView.super.onExit(self)
end