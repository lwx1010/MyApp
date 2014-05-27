---
-- BOSS战斗失败界面
-- @module view.boss.BossLoseView
--

local require = require
local class = class
local dump = dump

local moduleName = "view.boss.BossLoseView"
module(moduleName)

---
-- 类定义
-- @type BossLoseView
--
local BossLoseView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 战斗结算信息
-- @field [parent = #view.boss.BossLoseView] _rewardMsg
-- 
local _rewardMsg = nil

---
-- 构造函数
-- @function [parent = #BossLoseView] ctor
--
function BossLoseView:ctor()
	BossLoseView.super.ctor(self)
	self:_create()
	--self:retain()
end

---
-- 加载ccbi
-- @function [parent = #BossLoseView] _create
--
function BossLoseView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_boss/ui_boss_battlelose.ccbi")
	
	-- 添加背景界面为触控区域
	self:createClkHelper()
	self:addClkUi("bgSpr1")
	self:addClkUi("bgSpr2")
	
	if _rewardMsg then
		self:setShowMsg(_rewardMsg)
	end
end

---
-- 设置结算信息
-- @function [parent = #view.boss.BossLoseView] setRewardMsg
-- @param #table msg
-- 
function setRewardMsg(msg)
	_rewardMsg = msg
end

---
-- 设置显示内容
-- @function [parent = #BossLoseView] setShowMsg
-- @param #table msg
-- 
function BossLoseView:setShowMsg(msg)
	self["silverNumLab"]:setBmpPathFormat("ccb/number1/%d.png")
	self["silverNumLab"]:setValue(msg.get_cash)
end

---
-- 触控后回调
-- @function [parent = #BossLoseView] uiClkHandler
-- @param #CCNode ui
-- @param #CCRect rect
-- 
function BossLoseView:uiClkHandler(ui, rect)
	local gameView = require("view.GameView")
	
	local fightScene = require("view.fight.FightScene").getFightScene()
	local scene = gameView.getScene()
	--scene:removeChild(fightScene, true)
	fightScene:removeFromParentAndCleanup(true)
	
	local changeWinLogic = require("logic.ChangeWindowLogic")
	local winIns = changeWinLogic.getChangeWinIns()
	if winIns then
		gameView.addPopUp(winIns, true)
	end
	
	gameView.removePopUp(self, true)
end

---
-- 场景退出的时候自动调用
-- @function [parent = #BossLoseView] onExit
-- 
function BossLoseView:onExit()
	instance = nil
	
	BossLoseView.super.onExit(self)
end













