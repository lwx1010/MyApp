---
-- 射箭时装备背包已满提示界面
-- @module view.qiyu.shejian.SheJianConfirmView
--

local require = require
local class = class

local CCSize = CCSize
local ccp = ccp

local tr = tr

local printf = printf

local moduleName = "view.qiyu.shejian.SheJianConfirmView"
module(moduleName)

---
-- 类定义
-- @type SheJianConfirmView
--
local SheJianConfirmView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent = #SheJianConfirmView] ctor
--
function SheJianConfirmView:ctor()
	SheJianConfirmView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #SheJianConfirmView] _create
--
function SheJianConfirmView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_battle/ui_checkbag.ccbi", true)
	
	--self["textLab"]:setAnchorPoint(ccp(0, 1))
	self["textLab"]:setDimensions(CCSize(445, 0))
	self:handleButtonEvent("winCcb.aNoBtn", self._closeBtnHandler)
	self:handleButtonEvent("winCcb.aYesBtn", self._yesBtnHandler)
	--textLab
end 

---
-- 点击了确定按钮
-- @function [parent = #SheJianConfirmView] _yesBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function SheJianConfirmView:_yesBtnHandler(sender, event)
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end 

---
-- 点击了关闭按钮
-- @function [parent = #SheJianConfirmView] _closeBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function SheJianConfirmView:_closeBtnHandler(sender, event)
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
    
    local SheJianView = require("view.qiyu.shejian.SheJianView").instance
    if SheJianView then
    	SheJianView:qiYuFinish()
    end
end

---
-- 设置显示文本
-- @function [parent = #SheJianConfirmView] setText
-- @param #string text
-- 
function SheJianConfirmView:setText(text)
	self["textLab"]:setString(text)
end

---
-- 窗口退出自动回调
-- @function [parent = #SheJianConfirmView] onExit
-- 
function SheJianConfirmView:onExit()
	instance = nil
	SheJianConfirmView.super.onExit(self)
end