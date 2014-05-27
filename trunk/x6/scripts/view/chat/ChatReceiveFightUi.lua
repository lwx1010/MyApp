--- 
-- 聊天界面收到切磋邀请
-- @module view.chat.ChatReceiveFightUi
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local os = os


local moduleName = "view.chat.ChatReceiveFightUi"
module(moduleName)


--- 
-- 类定义
-- @type ChatReceiveFightUi
-- 
local ChatReceiveFightUi = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 构造函数
-- @function [parent=#ChatReceiveFightUi] ctor
-- @param self
-- 
function ChatReceiveFightUi:ctor()
	ChatReceiveFightUi.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#ChatReceiveFightUi] _create
-- @param self
-- 
function ChatReceiveFightUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_chat/ui_chat_tipbox.ccbi", true)
	
	self:handleButtonEvent("yesBtn", self._yesClkHandler)
	self:handleButtonEvent("noBtn", self._noClkHandler)	
end

--- 
-- 点击了是
-- @function [parent=#ChatReceiveFightUi] _yesClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function ChatReceiveFightUi:_yesClkHandler( sender, event )
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_chat_pk_result", {pk_result = 1})
	self:closeUi()
end

--- 
-- 点击了否
-- @function [parent=#ChatReceiveFightUi] _noClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function ChatReceiveFightUi:_noClkHandler( sender, event )
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_chat_pk_result", {pk_result = 0})
	self:closeUi()
end

---
-- 打开界面调用
-- @function [parent=#ChatReceiveFightUi] openUi
-- @param self
-- @param #S2c_chat_pk pb
-- 
function ChatReceiveFightUi:openUi( pb )
	self["tipLab"]:setString(pb.user_name .. tr("想要与你切磋，你愿意与他较量一下么？切磋不会有任何损失"))
	
	local starttime = os.time()
	if pb.wait_time > 0 then
		local func = function()
			local cur = os.time()
			if cur < (starttime + 10) then
				self["timeLab"]:setString("" .. (starttime + 10 - cur))
			else
				self["timeLab"]:setString("0")
				self:closeUi()
			end
		end
		
		self:schedule(func, 1)
	else
		return
	end
	
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
end

---
-- 关闭界面
-- @function [parent=#ChatReceiveFightUi] closeUi
-- @param self
-- 
function ChatReceiveFightUi:closeUi()
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 退出界面调用
-- @function [parent=#ChatReceiveFightUi] onExit
-- @param self
-- 
function ChatReceiveFightUi:onExit()
	self:stopAllActions()
	
	instance = nil
	ChatReceiveFightUi.super.onExit(self)
end