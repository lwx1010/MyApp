--- 
-- 聊天界面邀请切磋
-- @module view.chat.ChatInviteFightUi
-- 

local class = class
local printf = printf
local require = require
local display = display
local ccp = ccp
local tr = tr
local os = os
local transition = transition
local CCMoveTo = CCMoveTo
local CCScaleTo = CCScaleTo
local CCCallFunc = CCCallFunc


local moduleName = "view.chat.ChatInviteFightUi"
module(moduleName)


--- 
-- 类定义
-- @type ChatInviteFightUi
-- 
local ChatInviteFightUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 当前选中的玩家信息 id,name,starttime
-- @field [parent=#ChatInviteFightUi] #table _playerInfo
-- 
ChatInviteFightUi._playerInfo = nil

--- 
-- 构造函数
-- @function [parent=#ChatInviteFightUi] ctor
-- @param self
-- 
function ChatInviteFightUi:ctor()
	ChatInviteFightUi.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#ChatInviteFightUi] _create
-- @param self
-- 
function ChatInviteFightUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_chat/ui_chat_tipbox2.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self.closeUi)
	
	self:createClkHelper()
	self:addClkUi("closeSpr")
	
	local layer = display.newLayer()
	local size = self:getContentSize()
	--添加点击事件（屏蔽其他事件）
	local func = function(event, x, y)	
			local pt = self:convertToNodeSpace(ccp(x,y))
			if pt.x < 0 or pt.x > size.width or pt.y < 0 or pt.y > size.height then
				self:closeUi()
			end
		end
	
	layer:registerScriptTouchHandler(func)
	layer:setTouchEnabled(true)
end

---
-- 打开界面调用
-- @function [parent=#ChatInviteFightUi] openUi
-- @param self
-- @param #table info
-- 
function ChatInviteFightUi:openUi(info)
	if not info then return end
	self._playerInfo = info
	
	self["tipLab"]:setString(tr("您正在邀请与") .. info.name .. tr("进行切磋"))
	
	local curtime = os.time()
	if curtime < (info.starttime + 10) then
		local func = function()
			local cur = os.time()
			if cur < (info.starttime + 10) then
				self["timeLab"]:setString("" .. (info.starttime + 10 - cur))
			else
				self["timeLab"]:setString("0")
				self:stopAllActions()
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
-- @function [parent=#ChatInviteFightUi] closeUi
-- @param self
-- 
function ChatInviteFightUi:closeUi()
--	local ChatView = require("view.chat.ChatView")
--	if ChatView.intance and ChatView.instance:getParent() then
--		local x = ChatView.intance:getPkBtn():getPositionX()
--		local y = ChatView.intance:getPkBtn():getPositionY()
--		local pt = ChatView.intance:convertToWorldSpace(ccp(x,y))
--		local action1 = transition.sequence({
--				CCMoveTo:create(0.2, ccp(pt.x, pt.y)),   -- moving down
--				CCCallFunc:create(function()
--						local GameView = require("view.GameView")
--						GameView.removePopUp(self) 
--					 end),          -- call function
--			})
--		local action2 = CCScaleTo:create(0.2, 0.1)
--		
--		self:runAction(action1)
--		self:runAction(action2)
--	else
--		local GameView = require("view.GameView")
--		GameView.removePopUp(self) 
--	end
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true) 
end

---
-- 退出界面调用
-- @function [parent=#ChatInviteFightUi] onExit
-- @param self
-- 
function ChatInviteFightUi:onExit()
	
	self:stopAllActions()
--	self:setScaleX(1)
--	self:setScaleY(1)
	
	instance = nil
	ChatInviteFightUi.super.onExit(self)
end

---
-- ui点击处理
-- @function [parent=#ChatInviteFightUi] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function ChatInviteFightUi:uiClkHandler( ui, rect )
	if ui == self["closeSpr"] then
		self:closeUi()
	end
end