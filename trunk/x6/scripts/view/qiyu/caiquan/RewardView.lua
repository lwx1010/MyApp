---
-- 猜拳奖励界面
-- @module view.qiyu.caiquan.RewardView
--

local class = class
local require = require
local printf = printf
local display = display
local CCPoint = CCPoint
local string = string


local moduleName = "view.qiyu.caiquan.RewardView"
module(moduleName)

---
-- 类定义
-- @type RewardView
--
local RewardView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 创建实例
-- @function [parent=#view.qiyu.caiquan.RewardView] new
-- @return #RewardView
--
function new()
	return RewardView.new()
end

---
-- 构造函数
-- @function [parent=#RewardView] ctor
-- @param self
--
function RewardView:ctor()
	RewardView.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#RewardView] _create
-- @param self
--
function RewardView:_create()
	local undumps = self:load("ui/ccb/ccbfiles/ui_adventure/ui_getsomething.ccbi", true)
	
	self:handleButtonEvent("confirmBtn", self._okClkHandler)
end

---
-- 设置label银两数
-- @function [parent=#RewardView] setLabel
-- @param self
-- @param #number num
-- 
function RewardView:setLabel(num)
	local str = self["rewardLab"]:getString()
	str = string.gsub(str, "9999", num)
	self["rewardLab"]:setString(str)
end

---
-- 确定按钮处理
-- @function [parent=#RewardView] _okClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function RewardView:_okClkHandler()
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
	
	local CaiQuanView = require("view.qiyu.caiquan.CaiQuanView")
	if CaiQuanView.instance and CaiQuanView.instance:getParent() then
		CaiQuanView.instance:qiYuFinish()
	end
end

---
-- 退出界面调用
-- @function [parent=#RewardView] onExit
-- @param self
-- 
function RewardView:onExit()
	instance = nil
	
	self.super.onExit(self)
end