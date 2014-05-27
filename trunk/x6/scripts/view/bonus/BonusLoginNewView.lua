---
-- 新连续登陆界面主界面
-- @module view.bonus.BonusLoginNewView
--

local class = class
local require = require
local printf = printf
local next = next
local pairs = pairs
local tostring = tostring
local table = table
local tr = tr
local display = display
local transition = transition
local math = math
local dump = dump
local CCDelayTime = CCDelayTime
local CCCallFunc = CCCallFunc

local moduleName = "view.bonus.BonusLoginNewView"
module(moduleName)


---
-- 类定义
-- @type BonusLoginNewView
-- 
local BonusLoginNewView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent=#BonusLoginNewView] ctor
-- @param self
-- 
function BonusLoginNewView:ctor()
	BonusLoginNewView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

---
-- 创建
-- @function [parent=#BonusLoginNewView] _create
-- @param self
-- 
function BonusLoginNewView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_loginbonus/ui_denglujiangli.ccbi", true)
	
--	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	
	local itemBox = self["itemVCBox"]  --ui.CellBox#CellBox
	itemBox:setVSpace(25)
	itemBox.owner = self
	local BonusLoginNewCell = require("view.bonus.BonusLoginNewCell")
	itemBox:setCellRenderer(BonusLoginNewCell)
	
	local BonusLoginData = require("model.BonusLoginData")
	local set = BonusLoginData.rewardSet
	itemBox:setDataSet(set)
end

---
-- 关闭界面
-- @function [parent=#BonusLoginNewView] closeView
-- @param self
-- 
function BonusLoginNewView:closeView()
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 滚动到子项
-- @function [parent=#BonusLoginNewView] scrollToIndex
-- @param self
-- @param #number index
-- 
function BonusLoginNewView:scrollToIndex(index)
	local BonusLoginData = require("model.BonusLoginData")
	local daysTbl = BonusLoginData.getDaysTbl()
	self["itemVCBox"]:validate()
	self["itemVCBox"]:scrollToIndex(daysTbl[1].day)
end

---
-- 检测能否关闭界面
-- @function [parent=#BonusLoginNewView] checkClose
-- @param self
-- 
function BonusLoginNewView:checkClose()
	local BonusLoginData = require("model.BonusLoginData")
	local daysTbl = BonusLoginData.getDaysTbl()
	
	local canClose = true
	for i=1, #daysTbl do
		if daysTbl[i].receive == false then
			canClose = false
			break
		end
	end
	
	-- 奖励领取完成，关闭界面
	if canClose then
		local GameView = require("view.GameView")
		GameView.removePopUp(self, true)
	end
end

---
-- 退出界面调用
-- @function [parent=#BonusLoginNewView] onExit
-- @param self
-- 
function BonusLoginNewView:onExit()
	instance = nil
	
	self.super.onExit(self)
end




