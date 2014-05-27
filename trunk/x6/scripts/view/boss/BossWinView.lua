---
-- BOSS胜利界面
-- @module view.boss.BossWinView
--

local require = require
local class = class

local moduleName = "view.boss.BossWinView"
module(moduleName)

---
-- 类定义
-- @type BossWinView
--
local BossWinView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 战斗结算信息
-- @field [parent = #view.boss.BossWinView] _rewardMsg
-- 
local _rewardMsg = nil

---
-- 构造函数
-- @function [parent = #BossWinView] ctor
--
function BossWinView:ctor()
	BossWinView.super.ctor(self)
	self:_create()
	--self:retain()
end

---
-- 加载ccbi
-- @function [parent = #BossWinView] _create
--
function BossWinView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_boss/ui_boss_battlewin.ccbi")
	
	-- 隐藏星星
	for i = 1, 3 do
		self["starSpr"..i]:setVisible(false)
	end
	
	-- 添加背景界面为触控区域
	self:createClkHelper()
	self:addClkUi("bgSpr1")
	self:addClkUi("bgSpr2")
	
	if _rewardMsg then
		self:setShowMsg(_rewardMsg)
	end
end

---
-- 设置显示内容
-- @function [parent = #BossWinView] setShowMsg
-- @param #table msg
-- 
function BossWinView:setShowMsg(msg)
	for i = 1, 3 do
		self["starSpr"..i]:setVisible(true)
	end
	self["silverNumLab"]:setBmpPathFormat("ccb/number1/%d.png")
	self["silverNumLab"]:setValue(msg.get_cash)
end

---
-- 设置结算信息
-- @function [parent = #view.boss.BossWinView] setRewardMsg
-- @param #table msg
-- 
function setRewardMsg(msg)
	_rewardMsg = msg
end

---
-- 触控后回调
-- @function [parent = #BossWinView] uiClkHandler
-- @param #CCNode ui
-- @param #CCRect rect
-- 
function BossWinView:uiClkHandler(ui, rect)
	local gameView = require("view.GameView")
	
	local fightScene = require("view.fight.FightScene").getFightScene()
	local scene = gameView.getScene()
	--scene:removeChild(fightScene, true)
	fightScene:removeFromParentAndCleanup(true)
	
	gameView.removePopUp(self, true)
end

---
-- 场景退出后回调
-- @function [parent = #BossWinView] onExit
-- 
function BossWinView:onExit()
	
	-- 隐藏星星
	for i = 1, 3 do
		self["starSpr"..i]:setVisible(false)
	end
	
	instance = nil
	
	BossWinView.super.onExit(self)
end













