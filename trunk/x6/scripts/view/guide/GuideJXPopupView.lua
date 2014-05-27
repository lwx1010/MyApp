---
-- 引导聚贤弹出窗口
-- @module view.guide.GuideJXPopupView
--

local require = require
local class = class

local CCSize = CCSize
local ccp = ccp

local tr = tr

local moduleName = "view.guide.GuideJXPopupView"
module(moduleName)

---
-- 类定义
-- @type GuideJXPopupView
--
local GuideJXPopupView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent = #GuideJXPopupView] ctor
--
function GuideJXPopupView:ctor()
	GuideJXPopupView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #GuideJXPopupView] _create
--
function GuideJXPopupView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_mainstage/ui_levelguide2.ccbi", true)
	
	self["descLab"]:setDimensions(CCSize(415, 0))
	self["descLab"]:setAnchorPoint(ccp(0, 0.7))
	
	self:setShowMsg(tr("<c5>土豪<c0>托我带个话，只要您升到<c5>9<c0>级，就可以在任务里领取大量<c5>元宝<c0>奖励。"))
	
	self:handleButtonEvent("yesBtn", self._yesBtnHandler)
end 

---
-- 设置描述信息
-- @function [parent = #GuideJXPopupView] setShowMsg
-- @param #string msg
--  
function GuideJXPopupView:setShowMsg(msg)
	self["descLab"]:setString(msg)
end

---
-- 点击了关闭按钮
-- @function [parent = #GuideJXPopupView] _yesBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function GuideJXPopupView:_yesBtnHandler(sender, event)
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 场景退出自动回调
-- @function [parent = #GuideJXPopupView] onExit
-- 
function GuideJXPopupView:onExit()
	instance = nil
	GuideJXPopupView.super.onExit(self)
end










