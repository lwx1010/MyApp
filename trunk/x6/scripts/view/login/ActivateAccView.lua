---
-- 激活账号界面
-- @module view.login.ActivateAccView
--

local require = require
local class = class

local printf = printf

local moduleName = "view.login.ActivateAccView"
module(moduleName)

---
-- 类定义
-- @type ActivateAccView
--
local ActivateAccView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent = #ActivateAccView] ctor
--
function ActivateAccView:ctor()
	ActivateAccView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #ActivateAccView] _create
--
function ActivateAccView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_login/ui_acc_activitate.ccbi", true)
	
	self:createClkHelper()
	self:addClkUi("activeSpr")
	
	self:handleButtonEvent("activeBtn", self._sendActiveNo)
end 

---
-- 发送账号
-- @function [parent = #ActivateAccView] _sendActiveNo
-- 
function ActivateAccView:_sendActiveNo()
	local activeAccText = self["activeEdit"]:getText()
	
	local gameNet = require("utils.GameNet")
	gameNet.send("C2s_login_jihuo", {jihuoma = activeAccText})
	
	local netLoading = require("view.notify.NetLoading")
	netLoading.show()
end

---
-- 选中特定UI后回调
-- @function [parent = #ActivateAccView] uiClkHandler
-- @param self
-- @param #CCNode ui
-- @param #CCRect rect
-- 
function ActivateAccView:uiClkHandler(ui, rect)
	local device = require("framework.client.device")
	device.openURL("http://x6.millionhero.com/key.html")
end

---
-- 关闭窗口
-- @function [parent = #ActivateAccView] closeWindow
-- 
function ActivateAccView:closeWindow()
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 场景退出自动回调
-- @function [parent = #ActivateAccView] onExit
-- 
function ActivateAccView:onExit()
	instance = nil
	
	ActivateAccView.super.onExit(self)
end











