---
-- 切磋结算界面
-- @module view.qiyu.qiecuo.QieCuoEndView
--

local require = require
local class = class
local printf = printf


local moduleName = "view.qiyu.qiecuo.QieCuoEndView"
module(moduleName)


--- 
-- 类定义
-- @type QieCuoEndView
-- 
local QieCuoEndView = class(moduleName, require("ui.CCBView").CCBView, true)

---
-- 构造函数
-- @function [parent = #QieCuoEndView] ctor
-- 
function QieCuoEndView:ctor()
	QieCuoEndView.super.ctor(self)
	self:_create()
--	self:retain()
end

---
-- 创建加载ccbi文件
-- @function [parent = #QieCuoEndView] _create
-- 
function QieCuoEndView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_qiecuo.ccbi")
	
	self:handleButtonEvent("confirmBtn", self._confirmClkHandler)
	
	self:createClkHelper()
	self:addClkUi(node)
end

---
-- 点击了确认
-- @function [parent=#QieCuoEndView] _confirmClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function QieCuoEndView:_confirmClkHandler( sender, event )
	self:uiClkHandler()
end

---
-- 显示信息
-- @function [parent=#QieCuoEndView] showInfo
-- @param self
-- @param #S2c_biwu_result pb
-- 
function QieCuoEndView:showInfo( pb )
	if not pb then return end
	
	
end

---
-- ui点击处理
-- @function [parent=#QieCuoEndView] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function QieCuoEndView:uiClkHandler( ui, rect )
	local gameView = require("view.GameView")
	
	local fightScene = require("view.fight.FightScene").getFightScene()
	local scene = gameView.getScene()
	--scene:removeChild(fightScene, false)
	fightScene:removeFromParentAndCleanup(true)
	
	gameView.removePopUp(self, true)
end

---
-- 退出界面调用
-- @function [parent=#QieCuoEndView] onExit
-- @param self
-- 
function QieCuoEndView:onExit()
	instance = nil
	
	self.super.onExit(self)
end
