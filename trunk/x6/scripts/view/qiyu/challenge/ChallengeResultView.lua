---
-- 大侠挑战结果界面
-- @module view.qiyu.challenge.ChallengeResultView
-- 

local class = class
local require = require
local printf = printf


local moduleName = "view.qiyu.challenge.ChallengeResultView"
module(moduleName)

---
-- 类定义
-- @type ChallengeResultView
-- 
local ChallengeResultView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 是否收到结果信息
-- @field [parent=#view.qiyu.challenge.ChallengeResultView] #boolean _receiveResult 
-- 
local _receiveResult = false

---
-- 收到结果信息
-- @field [parent=#view.qiyu.challenge.ChallengeResultView] #string _msg 
-- 
local _msg = nil

---
-- 构造函数
-- @function [parent=#ChallengeResultView] ctor
-- @param self
-- 
function ChallengeResultView:ctor()
	self.super.ctor(self)
	
	self:_create()
--	self:retain()
end

---
-- 创建
-- @function [parent=#ChallengeResultView] _create
-- @param self
-- 
function ChallengeResultView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_getsomething.ccbi", true)
	
	self:handleButtonEvent("confirmBtn", self._okClkHandler)
end

---
-- 点击了确定
-- @function [parent=#ChallengeResultView] _okClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function ChallengeResultView:_okClkHandler( sender, event )
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
	
	local ChallengeView = require("view.qiyu.challenge.ChallengeView")
	if ChallengeView.instance and ChallengeView.instance:getParent() then
		ChallengeView.instance:qiYuFinish()
	end
end

---
-- 设置挑战结果信息
-- @function [parent=#view.qiyu.challenge.ChallengeResultView] setResultInfo
-- @field [parent=#view.qiyu.challenge.ChallengeResultView] #string msg 结果信息
-- 
function setResultInfo(msg)
	_msg = msg
	_receiveResult = true
end

---
-- 弹出挑战结果界面
-- @function [parent=#ChallengeResultView] showResultInfo
-- @param self
-- 
function ChallengeResultView:showResultInfo()
	self["rewardLab"]:setString(_msg)
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	_receiveResult = false
end

---
-- 退出界面调用
-- @function [parent=#ChallengeResultView] onExit
-- @param self
-- 
function ChallengeResultView:onExit()
	instance = nil
	
	self.super.onExit(self)
end

---
-- 获取是否弹出挑战结果界面
-- @function [parent=#view.qiyu.challenge.ChallengeResultView] getReceiveResult
-- @return #boolean 
-- 
function getReceiveResult()
	return _receiveResult
end


