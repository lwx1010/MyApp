---
-- 切磋结束失败
-- @module view.qiyu.qiecuo.QieCuoLoseView
--

local require = require
local class = class
local printf = printf


local moduleName = "view.qiyu.qiecuo.QieCuoLoseView"
module(moduleName)


--- 
-- 类定义
-- @type QieCuoLoseView
-- 
local QieCuoLoseView = class(moduleName, require("ui.CCBView").CCBView, true)

---
-- 结算信息
-- @field [parent = #view.qiyu.qiecuo.QieCuoLoseView] _rewardMsg
-- 
local _rewardMsg = nil

---
-- 构造函数
-- @function [parent = #QieCuoLoseView] ctor
-- 
function QieCuoLoseView:ctor()
	QieCuoLoseView.super.ctor(self)
	self:_create()
--	self:retain()
end

---
-- 场景进入自动回调
-- @function [parent = #QieCuoLoseView] onEnter
-- 
function QieCuoLoseView:onEnter()
	QieCuoLoseView.super.onEnter(self)
	local SpriteAction = require("utils.SpriteAction")
	self["loseSpr"]:setOpacity(255)
	SpriteAction.resultScaleSprAction(self["loseSpr"], {scale = 2.0})
end

---
-- 创建加载ccbi文件
-- @function [parent = #QieCuoLoseView] _create
-- 
function QieCuoLoseView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_rob/ui_roblose.ccbi")
	
	self:createClkHelper()
	self:addClkUi(node)
	
	self["starSpr1"]:setVisible(false)
	self["starSpr2"]:setVisible(false)
	self["starSpr3"]:setVisible(false)
	
	if _rewardMsg then
		self:showInfo(_rewardMsg)
	end
	
	--动画
	self["loseSpr"]:setScale(6.0)
	self["loseSpr"]:setOpacity(0)
end

---
-- 设置结算信息
-- @function [parent = #view.qiyu.qiecuo.QieCuoLoseView] setRewardMsg
-- @param #table msg
--  
function setRewardMsg(msg)
	_rewardMsg = msg
end

---
-- 显示信息
-- @function [parent=#QieCuoLoseView] showInfo
-- @param self
-- @param #S2c_biwu_result pb
-- 
function QieCuoLoseView:showInfo( pb )
	if not pb then return end
	
	self["expNumLab"]:setBmpPathFormat("ccb/number1/%d.png")
	self["expNumLab"]:setValue( pb.exp or 0 )
end

---
-- ui点击处理
-- @function [parent=#QieCuoLoseView] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function QieCuoLoseView:uiClkHandler( ui, rect )
	local gameView = require("view.GameView")
	
	local fightScene = require("view.fight.FightScene").getFightScene()
	local scene = gameView.getScene()
	--scene:removeChild(fightScene, false)
	fightScene:removeFromParentAndCleanup(true)
	
	gameView.removePopUp(self, true)
	
	local QieCuoView = require("view.qiyu.qiecuo.QieCuoView")
	if QieCuoView.instance then
		QieCuoView.instance:qiYuFinish()
	end
end

---
-- 退出界面调用
-- @function [parent=#QieCuoLoseView] onExit
-- @param self
-- 
function QieCuoLoseView:onExit()
	_rewardMsg = nil
	instance = nil
	
	self.super.onExit(self)
end

