---
-- 聊天室pk结束胜利
-- @module view.chat.ChatPkWinView
--

local require = require
local class = class
local printf = printf


local moduleName = "view.chat.ChatPkWinView"
module(moduleName)


--- 
-- 类定义
-- @type ChatPkWinView
-- 
local ChatPkWinView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent = #ChatPkWinView] ctor
-- 
function ChatPkWinView:ctor()
	ChatPkWinView.super.ctor(self)
	self:_create()
--	self:retain()
end

---
-- 创建加载ccbi文件
-- @function [parent = #ChatPkWinView] _create
-- 
function ChatPkWinView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_pk/ui_pkbestwin.ccbi")
	
	self:createClkHelper()
	self:addClkUi(node)
	
	self["jsNode"]:setVisible(false)
	self["smallWinSpr"]:setVisible(false)
end


---
-- ui点击处理
-- @function [parent=#ChatPkWinView] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function ChatPkWinView:uiClkHandler( ui, rect )
	local gameView = require("view.GameView")
	
	local fightScene = require("view.fight.FightScene").getFightScene()
	local scene = gameView.getScene()
	--scene:removeChild(fightScene, false)
	fightScene:removeFromParentAndCleanup(true)
	
	gameView.removePopUp(self, true)
end

---
-- 退出界面调用
-- @function [parent=#ChatPkWinView] onExit
-- @param self
-- 
function ChatPkWinView:onExit()
	instance = nil
	
	self.super.onExit(self)
end

