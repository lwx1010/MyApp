---
-- 5级新手引导界面
-- @module view.guide.GuideLevelView
--

local require = require
local class = class

local moduleName = "view.guide.GuideLevelView"
module(moduleName)

---
-- 类定义
-- @type GuideLevelView
--
local GuideLevelView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 保存延迟信息表
-- @field [parent = #GuideLevelView] _delayMsg
-- 
local _delayMsg = nil

---
-- 保存服务端的grade数据
-- @field [parent = #GuideLevelView] #number _serverGrade
-- 
GuideLevelView._serverGrade = 0

---
-- 构造函数
-- @function [parent = #GuideLevelView] ctor
--
function GuideLevelView:ctor()
	GuideLevelView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #GuideLevelView] _create
--
function GuideLevelView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_levelup/ui_guide.ccbi", true)
	
	self:handleButtonEvent("getBtn.aBtn", self._getPartnerBtnHandler)
end 

---
-- 点击了确定按钮
-- @function [parent = #GuideLevelView] _getPartnerBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function GuideLevelView:_getPartnerBtnHandler(sender, event)
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
-- 显示
-- @function [parent = #GuideLevelView] showMsg
-- @param #table msg
-- 
function GuideLevelView:showMsg(msg)
	local PartnerShowConst = require("view.const.PartnerShowConst")
	msg.item_photo = msg.item_photo or 0
	self:changeTexture("partnerSpr", "card/"..msg.item_photo..".jpg")
	local color = PartnerShowConst.STEP_COLORS[msg.step] or ""
	self["nameLab"]:setString(color..msg.item_name)
	self["descLab"]:setString(msg.tips)
	self._serverGrade = msg.grade
end

---
-- 添加延迟信息
-- @function [parent = #view.guide.GuideLevelView] addDelayMsg
-- @param #table msg
-- 
function addDelayMsg(msg)
	_delayMsg = msg
end

---
-- 处理延迟信息
-- @function [parent = #view.guide.GuideLevelView] dealDelayMsg
-- 
function dealDelayMsg()
 	if _delayMsg then
 		local gameView = require("view.GameView")
		local guideLevelView = require("view.guide.GuideLevelView").createInstance()
		guideLevelView:showMsg(_delayMsg)
		gameView.addPopUp(guideLevelView, true)
		_delayMsg = nil
	end
end
		
---
-- 场景退出自动回调
-- @function [parent = #GuideLevelView] onExit
-- 
function GuideLevelView:onExit()
	instance = nil
	GuideLevelView.super.onExit(self)
end





