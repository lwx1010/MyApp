---
-- 夺宝失败界面
-- @module view.rob.RobLoseView
--


local class = class
local require = require
local printf = printf

local moduleName = "view.rob.RobLoseView"
module(moduleName)

---
-- 类定义
-- @type
-- 
local RobLoseView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent = #RobLoseView] ctor
-- 
function RobLoseView:ctor()
	RobLoseView.super.ctor(self)
	self:_create()
end

---
-- 场景进入自动回调
-- @function [parent = #RobLoseView] onEnter
-- 
function RobLoseView:onEnter()
	RobLoseView.super.onEnter(self)
	local SpriteAction = require("utils.SpriteAction")
	self["loseSpr"]:setOpacity(255)
	SpriteAction.resultScaleSprAction(self["loseSpr"], {scale = 2.0})
end

---
-- 加载CCB场景以及初始化
-- @function [parent = #RobLoseView] _create
-- 
function RobLoseView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_rob/ui_roblose.ccbi")
	
	--添加背景界面为触控区域
	self:createClkHelper()
	self:addClkUi(node)
	
	--动画
	self["loseSpr"]:setScale(6.0)
	self["loseSpr"]:setOpacity(0)
end

---
-- 设置经验值
-- @function [parent = #RobLoseView] setExpValue
-- @param #number value
-- 
function RobLoseView:setExpValue(value)
	self["expNumLab"]:setBmpPathFormat("ccb/numeric/%d_2.png")
	self["expNumLab"]:setValue(value)
end



---
-- 点击了触控区域 
-- @function [parent = #RobLoseView] uiClkHandler
-- @param #CCNode ui 
-- @param #CCRect rect
-- 
function RobLoseView:uiClkHandler(ui, rect)
	local gameView = require("view.GameView")
	
	local fightScene = require("view.fight.FightScene").getFightScene()
	local scene = gameView.getScene()
	--scene:removeChild(fightScene, true)
	fightScene:removeFromParentAndCleanup(true)
	
	gameView.removePopUp(self, true)
end

---
-- 场景退出回调
-- @function [parent = #RobLoseView] onExit
-- 
function RobLoseView:onExit()
	require("view.rob.RobLoseView").instance = nil
	RobLoseView.super.onExit(self)
end

	
	
	
	
	
	


