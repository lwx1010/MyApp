---
-- 新手引导升星界面
-- @module view.guide.GuideStarView
--

local require = require
local class = class

local moduleName = "view.guide.GuideStarView"
module(moduleName)

---
-- 类定义
-- @type GuideStarView
--
local GuideStarView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 保存延迟信息表
-- @field [parent = #GuideStarView] _delayMsg
-- 
local _delayMsg = nil

---
-- 保存服务端的grade数据
-- @field [parent = #GuideStarView] #number _serverGrade
-- 
GuideStarView._serverGrade = 0

---
-- 构造函数
-- @function [parent = #GuideStarView] ctor
--
function GuideStarView:ctor()
	GuideStarView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #GuideStarView] _create
--
function GuideStarView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_levelup/ui_levelupstar.ccbi", true)
	
	self:handleButtonEvent("getBtn.aBtn", self._getBtnHandler)

end 

---
-- 点击了确定按钮
-- @function [parent = #GuideStarView] _getBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function GuideStarView:_getBtnHandler(sender, event)
	local gameNet = require("utils.GameNet")
	gameNet.send("C2s_guide_get_gift", {grade = self._serverGrade})

	local gameView = require("view.GameView")
    gameView.removePopUp(self, true)
    
    --战力提示清空，不然removeAllAbove会出错
    local scoreUpMsg = require("view.notify.ScoreUpMsg")
    scoreUpMsg.clearMsgTl()
    
    --检测是否有新手引导
	local isGuiding = require("ui.CCBView").isGuiding
	if isGuiding == false then
		gameView.removeAllAbove(true)
		local MainView = require("view.main.MainView")
		gameView.replaceMainView(MainView.createInstance(), true)
	end
end

---
-- 场景退出自动回调
-- @function [parent = #GuideStarView] onExit
-- 
function GuideStarView:onExit()
	instance = nil
	GuideStarView.super.onExit(self)
end

---
-- 设置显示信息
-- @function [parent = #GuideStarView] showMsg
-- 
function GuideStarView:showMsg(msg)
	self._serverGrade = msg.grade
end

---
-- 添加延迟信息
-- @function [parent = #view.guide.GuideStarView] addDelayMsg
-- @param #table msg
-- 
function addDelayMsg(msg)
	_delayMsg = msg
end

---
-- 处理延迟信息
-- @function [parent = #view.guide.GuideStarView] dealDelayMsg
-- 
function dealDelayMsg()
 	if _delayMsg then
 		local gameView = require("view.GameView")
		local guideStarView = require("view.guide.GuideStarView").createInstance()
		guideStarView:showMsg(_delayMsg)
		gameView.addPopUp(guideStarView, true)
		_delayMsg = nil
	end
end








