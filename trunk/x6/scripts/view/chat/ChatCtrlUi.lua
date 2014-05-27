--- 
-- 聊天界面弹出的操作ui
-- @module view.chat.ChatCtrlUi
-- 

local class = class
local printf = printf
local require = require
local display = display
local ccp = ccp


local moduleName = "view.chat.ChatCtrlUi"
module(moduleName)


--- 
-- 类定义
-- @type ChatCtrlUi
-- 
local ChatCtrlUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 当前选中的玩家信息
-- @field [parent=#ChatCtrlUi] #table _playerInfo
-- 
ChatCtrlUi._playerInfo = nil

--- 
-- 构造函数
-- @function [parent=#ChatCtrlUi] ctor
-- @param self
-- 
function ChatCtrlUi:ctor()
	ChatCtrlUi.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#ChatCtrlUi] _create
-- @param self
-- 
function ChatCtrlUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_chat/ui_chat_floatbox.ccbi", true)
	
	self:handleButtonEvent("pkBtn", self._pkClkHandler)
	self:handleButtonEvent("chatBtn", self._chatClkHandler)
	
	local layer = display.newLayer()
	local size = self:getContentSize()
	--添加点击事件（屏蔽其他事件）
	local func = function(event, x, y)
			if not self:isVisible() then return end
			local pt = self:convertToNodeSpace(ccp(x,y))
			if pt.x < 0 or pt.x > size.width or pt.y < 0 or pt.y > size.height then
				self:setVisible(false)
			end
		end
	
	self:addChild(layer)
	layer:registerScriptTouchHandler(func)
	layer:setTouchEnabled(true)
end

--- 
-- 点击了切磋
-- @function [parent=#ChatCtrlUi] _pkClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function ChatCtrlUi:_pkClkHandler( sender, event )
	if self._playerInfo then
		-- 加载等待
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.show()
		
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_chat_pk", {user_id = self._playerInfo.id})
	end
	
	self:setVisible(false)
end

--- 
-- 点击了私聊
-- @function [parent=#ChatCtrlUi] _chatClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function ChatCtrlUi:_chatClkHandler( sender, event )
	if self._playerInfo then
		local ChatView = require("view.chat.ChatView")
		ChatView.createInstance():changeChannel(2, self._playerInfo)
	end
	
	self:setVisible(false)
end

--- 
-- 获取操作对象信息
-- @function [parent=#ChatCtrlUi] getPlayerInfo
-- @param self
-- 
function ChatCtrlUi:getPlayerInfo()
	return self._playerInfo
end

---
-- 打开界面调用
-- @function [parent=#ChatCtrlUi] openUi
-- @param self
-- @param #number x
-- @param #number y
-- @param #table info
-- 
function ChatCtrlUi:openUi(x, y, info)
	if not info or not info.id or not self:getParent() then return end
	self._playerInfo = info
	
	self:setVisible(true)
	local view = self:getParent()  --view.chat.ChatView#ChatView
	local pt = view:convertToNodeSpace(ccp(x,y))
	self:setPosition(pt.x -86, pt.y + 15)
end

---
-- 退出界面调用
-- @function [parent=#ChatCtrlUi] onExit
-- @param self
-- 
function ChatCtrlUi:onExit()
	instance = nil
	self.super.onExit(self)
end