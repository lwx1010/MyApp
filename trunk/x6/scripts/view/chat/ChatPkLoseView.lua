---
-- 聊天室pk结束失败
-- @module view.chat.ChatPkLoseView
--

local require = require
local class = class
local printf = printf


local moduleName = "view.chat.ChatPkLoseView"
module(moduleName)


--- 
-- 类定义
-- @type ChatPkLoseView
-- 
local ChatPkLoseView = class(moduleName, require("ui.CCBView").CCBView, true)

---
-- 构造函数
-- @function [parent = #ChatPkLoseView] ctor
-- 
function ChatPkLoseView:ctor()
	ChatPkLoseView.super.ctor(self)
	self:_create()
--	self:retain()
end

---
-- 创建加载ccbi文件
-- @function [parent = #ChatPkLoseView] _create
-- 
function ChatPkLoseView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_pk/ui_pklose.ccbi")
	
	self:createClkHelper()
	self:addClkUi(node)
	
	self["jsNode"]:setVisible(false)
end

---
-- ui点击处理
-- @function [parent=#ChatPkLoseView] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function ChatPkLoseView:uiClkHandler( ui, rect )
	local gameView = require("view.GameView")
	
	local fightScene = require("view.fight.FightScene").getFightScene()
	local scene = gameView.getScene()
	--scene:removeChild(fightScene, false)
	fightScene:removeFromParentAndCleanup(true)
	
	gameView.removePopUp(self, true)
end

---
-- 退出界面调用
-- @function [parent=#ChatPkLoseView] onExit
-- @param self
-- 
function ChatPkLoseView:onExit()
	instance = nil
	
	self.super.onExit(self)
end
