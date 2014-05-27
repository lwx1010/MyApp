---
-- 引导聚贤结束弹出窗口
-- @module view.guide.GuideJXEndPopupView
--

local require = require
local class = class
local CCSize = CCSize
local ccp = ccp
local tr = tr
local display = display
local transition = transition

local moduleName = "view.guide.GuideJXEndPopupView"
module(moduleName)

---
-- 类定义
-- @type GuideJXEndPopupView
--
local GuideJXEndPopupView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent = #GuideJXEndPopupView] ctor
--
function GuideJXEndPopupView:ctor()
	GuideJXEndPopupView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #GuideJXEndPopupView] _create
--
function GuideJXEndPopupView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_mainstage/ui_chongzhiyindao.ccbi", true)

	self:handleButtonEvent("chongZhiBtn", self._chongZhiBtnHandler)
	self:handleButtonEvent("closeBtn", self._closeBtnHandler)
	
	-- 特效Spr
	local texiaospr = display.newSprite()
	display.addSpriteFramesWithFile("res/ui/effect/cardeffect.plist", "res/ui/effect/cardeffect.png")
	self:addChild(texiaospr)
	texiaospr:setScale(1.7)
	texiaospr:setPosition(130,185)
	local frames = display.newFrames("cardeffect/100%02d.png", 0, 12)
	local animation = display.newAnimation(frames, 1/12)
	transition.playAnimationForever(texiaospr, animation)
	
	self["Lab1"]:setString(tr("首次<c5>充值任意金额<c0>即可获得极品侠客--\n<c4>令少侠<c0>(游戏最强侠客之一)"))
	self["Lab2"]:setString(tr("首次<c4>充值任意金额<c0>都将获得<c4>200%充值金额<c0>返还，冲的越多，返还越多"))
end

---
-- 点击了充值按钮
-- @function [parent = #GuideJXEndPopupView] _chongZhiBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function GuideJXEndPopupView:_chongZhiBtnHandler(sender, event)
	local shopMainView = require("view.shop.ShopMainView").createInstance()
	shopMainView:openUi(4) --充值页面
end

---
-- 点击了关闭按钮
-- @function [parent = #GuideJXEndPopupView] _closeBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function GuideJXEndPopupView:_closeBtnHandler(sender, event)
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 场景退出自动回调
-- @function [parent = #GuideJXEndPopupView] onExit
-- 
function GuideJXEndPopupView:onExit()
	instance = nil
	GuideJXEndPopupView.super.onExit(self)
end










