---
-- 副本次数不足弹出窗口
-- @module view.fuben.FubenCCMsgBoxView
--

local require = require
local class = class
local printf = printf
local tr = tr

local moduleName = "view.fuben.FubenCCMsgBoxView"
module(moduleName)

---
-- 类定义
-- @type FubenCCMsgBoxView
-- 
local FubenCCMsgBoxView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 敌人ID
-- @field [parent = #view.fuben.FubenCCMsgBoxView] #number _enemyId
-- 
local _enemyId

---
-- 章节
-- @field [parent = #view.fuben.FubenCCMsgBoxView] #number _chapter
-- 
local _chapter

---
-- 是否可以购买
-- @field [parent=#view.fuben.FubenCCMsgBoxView] #bool _canBuy
--
local _canBuy

---
-- 构造函数
-- @function [parent = #FubenCCMsgBoxView] ctor
-- @param self
-- 
function FubenCCMsgBoxView:ctor()
	FubenCCMsgBoxView.super.ctor(self)
	self:_create()
end

---
-- 加载ccb
-- @function [parent = #FubenCCMsgBoxView] _create
-- @param self
-- 
function FubenCCMsgBoxView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_copy/ui_cost_cc.ccbi", true)
	
	self["descLab"]:setString(tr("您今日免费攻打该关卡的次数已经用完，是否需要花费 5 元宝购买额外攻击次数？"))
	
	self:handleButtonEvent("msgBoxCcb.closeBtn", self._closeBtnHandler)
	self:handleButtonEvent("msgBoxCcb.aNoBtn", self._closeBtnHandler)
	self:handleButtonEvent("msgBoxCcb.aYesBtn", self._YesBtnHandler)
end

---
-- 设置显示要素
-- @function [parent = #FubenCCMsgBoxView] setShowMsg
-- @param #table msg
-- 
function FubenCCMsgBoxView:setShowMsg(msg)
	self["canBuyLab"]:setString(msg.buytimes.."/"..msg.maxbuytimes)
	
	if msg.buytimes >= msg.maxbuytimes then
			_canBuy = false
		else
			_canBuy = true
		end
end

---
-- 点击了关闭按钮
-- @function [parent = #FubenCCMsgBoxView] _closeBtnHandler
-- 
function FubenCCMsgBoxView:_closeBtnHandler(sender, event)
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 设置敌人ID
-- @function [parent = #view.fuben.FubenCCMsgBoxView] setEnemyId
-- @param #number id
--
function setEnemyId(id)
	_enemyId = id
end

---
-- 设置章节
-- @function [parent = #view.fuben.FubenCCMsgBoxView] setChapter
-- @param chapter
-- 
function setChapter(chapter)
	_chapter = chapter
end

---
-- 点击了确定
-- @function [parent = #FubenCCMsgBoxView] _YesBtnHandler
-- 
function FubenCCMsgBoxView:_YesBtnHandler(sender, event)
	if not _canBuy  then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("您今天的此关卡购买次数已满，无法再购买更多的次数了!"))
		self:_closeBtnHandler()
		return 
	end

	local gameNet = require("utils.GameNet")
	gameNet.send("C2s_fuben_buytime", {chapterno = _chapter, enemyno = _enemyId})--购买次数
	
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 场景退出自动回调
-- @function [parent = #FubenCCMsgBoxView] onExit
-- 
function FubenCCMsgBoxView:onExit()
	require("view.fuben.FubenCCMsgBoxView").instance = nil
	FubenCCMsgBoxView.super.onExit(self)
end

