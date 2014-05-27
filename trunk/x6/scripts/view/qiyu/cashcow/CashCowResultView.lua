---
-- 摇钱结果界面
-- @module view.qiyu.cashcow.CashCowResultView
-- 

local class = class
local require = require
local printf = printf


local moduleName = "view.qiyu.cashcow.CashCowResultView"
module(moduleName)

---
-- 类定义
-- @type CashCowResultView
-- 
local CashCowResultView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 摇钱是否结束
-- @field [parent=#CashCowResultView] #boolean _end 
-- 
CashCowResultView._end = false

---
-- 构造函数
-- @function [parent=#CashCowResultView] ctor
-- @param self
-- 
function CashCowResultView:ctor()
	self.super.ctor(self)
	
	self:_create()
--	self:retain()
end

---
-- 创建
-- @function [parent=#CashCowResultView] _create
-- @param self
-- 
function CashCowResultView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_getsomething.ccbi", true)
	
	self:handleButtonEvent("confirmBtn", self._okClkHandler)
end

---
-- 点击了确定
-- @function [parent=#CashCowResultView] _okClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function CashCowResultView:_okClkHandler( sender, event )
	-- 摇钱结束
	if( self._end ) then
		local CashCowView = require("view.qiyu.cashcow.CashCowView")
		CashCowView.instance:qiYuFinish()
	end
	
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 弹出摇钱奖励界面
-- @function [parent=#CashCowResultView] showResultInfo
-- @param self
-- @param #number value 奖励银两
-- @param #boolean isEnd 摇钱是否结束
-- 
function CashCowResultView:showRewardInfo(value, isEnd)
	self["rewardLab"]:setString("摇钱结束获得<c1>"..value.."<c0>银两")
	self._end = isEnd or false
end

---
-- 退出界面调用
-- @function [parent=#CashCowResultView] onExit
-- @param self
-- 
function CashCowResultView:onExit()
	instance = nil
	
	self.super.onExit(self)
end



