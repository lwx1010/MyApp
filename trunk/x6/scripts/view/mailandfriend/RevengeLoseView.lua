---
-- 复仇pk结束失败
-- @module view.mailandfriend.RevengeLoseView
--

local require = require
local class = class
local printf = printf


local moduleName = "view.mailandfriend.RevengeLoseView"
module(moduleName)


--- 
-- 类定义
-- @type RevengeLoseView
-- 
local RevengeLoseView = class(moduleName, require("ui.CCBView").CCBView, true)

---
-- 保存结算信息
-- @field [parent = #view.mailandfriend.RevengeLoseView] #table _rewardMsg
-- 
local _rewardMsg = nil

---
-- 构造函数
-- @function [parent = #RevengeLoseView] ctor
-- 
function RevengeLoseView:ctor()
	RevengeLoseView.super.ctor(self)
	self:_create()
end

---
-- 创建加载ccbi文件
-- @function [parent = #RevengeLoseView] _create
-- 
function RevengeLoseView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_rob/ui_roblose.ccbi")
	
	self:createClkHelper()
	self:addClkUi(node)
	
	self["starSpr1"]:setVisible(false)
	self["starSpr2"]:setVisible(false)
	self["starSpr3"]:setVisible(false)
	self:changeFrame("typeSpr", "ccb/zhandoujiesuan/coin_3.png")
	
	if _rewardMsg then
		self:showInfo(_rewardMsg)
	end
end

---
-- 设置结算信息
-- @function [parent = #RevengeLoseView] setRewardMsg
-- @param #table msg
-- 
function setRewardMsg(msg)
	_rewardMsg = msg
end

---
-- 显示信息
-- @function [parent=#RevengeLoseView] showInfo
-- @param self
-- @param #S2c_biwu_result pb
-- 
function RevengeLoseView:showInfo( pb )
	if not pb then return end
	
	self["expNumLab"]:setBmpPathFormat("ccb/number1/%d.png")
	self["expNumLab"]:setValue( 0 )
end

---
-- ui点击处理
-- @function [parent=#RevengeLoseView] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function RevengeLoseView:uiClkHandler( ui, rect )
	local gameView = require("view.GameView")
	
	local fightScene = require("view.fight.FightScene").getFightScene()
	local scene = gameView.getScene()
	--scene:removeChild(fightScene, false)
	fightScene:removeFromParentAndCleanup(true)
	 
	gameView.removePopUp(self)
end

---
-- 退出界面时调用
-- @field [parent=#RevengeLoseView] onExit
-- @param self
--
function RevengeLoseView:onExit()
	_rewardMsg = nil
	instance = nil
	
	self.super.onExit(self)
end

