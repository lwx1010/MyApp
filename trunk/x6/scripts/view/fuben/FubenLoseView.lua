---
-- 副本战斗胜利界面
-- @module view.fuben.FubenLoseView
--

local require = require
local class = class
local printf = printf
local tr = tr

local moduleName = "view.fuben.FubenLoseView"
module(moduleName)

---
-- 类定义
-- @type 
-- 
local FubenLoseView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 保存结算数据
-- @field [parent = #view.fuben.FubenLoseView] #table _rewardMsg
-- 
local _rewardMsg = nil

---
-- 点击处理定时器句柄保存
-- @field [parent = #view.fuben.FubenLoseView] #scheduler _clickSche
-- 
FubenLoseView._clickSche = nil

---
-- 回调句柄表
-- @field [parent = #view.fuben.FubenLoseView] #scheduler _loseSprSche
-- 
local _loseSprSche = nil

---
-- 点击返回界面
-- @field [parent = #view.fuben.FubenLoseView] #CCNode _returnWindow
-- 
local _returnWindow = nil

---
-- 构造函数
-- @function [parent = #FubenLoseView] ctor
-- 
function FubenLoseView:ctor()
	FubenLoseView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi文件
-- @function [parent = #FubenLoseView] _create
-- 
function FubenLoseView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_copy/ui_chapter_battlelose.ccbi")
	
	--添加背景界面为触控区域
	self:createClkHelper()
	self:addClkUi(node)
	
	--动画
	self["loseSpr"]:setScale(6.0)
	self["loseSpr"]:setOpacity(0)
	self["upSpr"]:setPosition(480, 930) --640
	self["downSpr"]:setPosition(480, -240) --0
	self["resultSpr"]:setPosition(480, 750)--353
	
	if _rewardMsg then
		self:setShowMsg(_rewardMsg)
		_rewardMsg = nil
	end
end

---
-- 场景进入后自动回调
-- @function [parent = #FubenLoseView] onEnter
-- 
function FubenLoseView:onEnter()
	FubenLoseView.super.onEnter(self)

	local SpriteAction = require("utils.SpriteAction")
	
	SpriteAction.resultLayoutAction(self["upSpr"],
		{
			x = 480,
			y = 670,--640,
			time = 0.3,
			onComplete = function ()
				SpriteAction.resultLayoutAction(self["resultSpr"],
					{
						x = 480,
						y = 353,
						time = 0.2,
						easing = "CCEaseRateAction",
						onComplete = function ()
							if _loseSprSche == nil then
								local scheduler = require("framework.client.scheduler")
								_loseSprSche = scheduler.performWithDelayGlobal(
									function ()
										self["loseSpr"]:setOpacity(255)
										SpriteAction.resultScaleSprAction(self["loseSpr"], {scale = 2.0})
									end,
									0.2
								)
							end
						end
					}
				)
				
				--继续upSpr的动画
				SpriteAction.resultLayoutAction(self["upSpr"],
					{
						time = 0.1,
						x = 480,
						y = 640,
					}
				)
			end
		}
	)
	SpriteAction.resultLayoutAction(self["downSpr"],
		{
			x = 480, 
			y = 0,
			time = 0.3,
		}
	)
end

---
-- 设置显示内容
-- @function [parent = #FubenLoseView] setShowMsg
-- @param #table msg
-- 
function FubenLoseView:setShowMsg(msg)
	msg.exp = msg.exp or 0
	msg.exp_partner = msg.exp_partner or 0
	msg.cash = msg.cash or 0
	self["famousNumLab"]:setBmpPathFormat("ccb/number1/%d.png")
	self["famousNumLab"]:setValue(msg.exp)
	self["expNumLab"]:setBmpPathFormat("ccb/number3/%d.png")
	self["expNumLab"]:setValue(msg.exp_partner)
	self["yuanbaoNumLab"]:setBmpPathFormat("ccb/number3/%d.png")
	self["yuanbaoNumLab"]:setValue(msg.cash)
end

---
-- 触控后回调
-- @function [parent = #FubenLoseView] uiClkHandler
-- @param #CCNode ui
-- @param #CCRect rect
-- 
function FubenLoseView:uiClkHandler(ui, rect)
	local gameView = require("view.GameView")
	
	--更新章节信息
	--local fubenLogic = require("logic.FubenLogic")
	--fubenLogic.updateFubenChapterItem()
	
	local scheduler = require("framework.client.scheduler")
	if self._clickSche == nil then
		self._clickSche = scheduler.performWithDelayGlobal(
			function ()
				self._clickSche = nil
				local changeWinLogic = require("logic.ChangeWindowLogic")
				local winIns = changeWinLogic.getChangeWinIns()
				if winIns then
					gameView.addPopUp(winIns, true)
				end
				
				local fightScene = require("view.fight.FightScene").getFightScene()
				local scene = gameView.getScene()
				scene:removeChild(fightScene, true)
				
				gameView.removePopUp(self, true)
			end,
			0.5
		)
	end
end
	
---
-- 场景退出自动回调
-- @function [parent = #FubenLoseView] onExit
-- 
function FubenLoseView:onExit()
	--停止动画
	self["loseSpr"]:stopAllActions()
	self["upSpr"]:stopAllActions()
	self["downSpr"]:stopAllActions()
	self["resultSpr"]:stopAllActions()
		
	--动画
	self["loseSpr"]:setScale(6.0)
	self["loseSpr"]:setOpacity(0)
	self["upSpr"]:setPosition(480, 930) --640
	self["downSpr"]:setPosition(480, -240) --0
	self["resultSpr"]:setPosition(480, 750)--353
	
	if _loseSprSche then
		local scheduler = require("framework.client.scheduler")
		scheduler.unscheduleGlobal(_loseSprSche)
		_loseSprSche = nil
	end
	
	require("view.fuben.FubenLoseView").instance = nil
	FubenLoseView.super.onExit(self)
end
	
---
-- 设置界面结算内容
-- @function [parent = #view.fuben.FubenLoseView] setRewardMsg
-- @param #table msg
-- 
function setRewardMsg(msg)
	_rewardMsg = msg
end
	
---
-- 设置点击返回界面
-- @function [parent = #view.fuben.FubenLoseView] setReturnWindow
-- @param #CCNode win
-- 
function setReturnWindow(win)
	_returnWindow = win
end
	
	
	
	
	
	
	
	
	
	