---
-- 任务确定提示界面
-- @module view.task.TaskConfirmView
--

local require = require
local class = class
local CCSize = CCSize
local ccp = ccp
local tr = tr
local printf = printf

local moduleName = "view.task.TaskConfirmView"
module(moduleName)

---
-- 类定义
-- @type TaskConfirmView
--
local TaskConfirmView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 回调函数owner
-- @field [parent = #TaskConfirmView] _owner
-- 
TaskConfirmView._owner = nil

---
-- 回调函数
-- @function [parent = #TaskConfirmView] _callBack
-- @param self
-- 
TaskConfirmView._callBack = nil

---
-- 构造函数
-- @function [parent = #TaskConfirmView] ctor
--
function TaskConfirmView:ctor()
	TaskConfirmView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #TaskConfirmView] _create
--
function TaskConfirmView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_battle/ui_checkbag.ccbi", true)
	
	--self["textLab"]:setAnchorPoint(ccp(0, 1))
	self["textLab"]:setDimensions(CCSize(445, 0))
	self:handleButtonEvent("winCcb.aNoBtn", self._closeBtnHandler)
	self:handleButtonEvent("winCcb.aYesBtn", self._yesBtnHandler)
end

---
-- 打开界面
-- @function [parent=#TaskConfirmView] openUi
-- @param self
-- @param #function callback 回调函数
-- @param #CCNode owner 回调函数的对象
-- 
function TaskConfirmView:openUi(callback, owner)
	self._callBack = callback
	self._owner = owner
	
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
end

---
-- 点击了确定按钮
-- @function [parent = #TaskConfirmView] _yesBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function TaskConfirmView:_yesBtnHandler(sender, event)
	if self._owner and self._callBack then
		self._callBack(self._owner)
	elseif self._callBack then
		self._callBack()
	end

	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end 

---
-- 点击了关闭按钮
-- @function [parent = #TaskConfirmView] _closeBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function TaskConfirmView:_closeBtnHandler(sender, event)
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
    
    local SheJianView = require("view.qiyu.shejian.SheJianView").instance
    if SheJianView then
    	SheJianView:qiYuFinish()
    end
end

---
-- 设置显示文本
-- @function [parent = #TaskConfirmView] setText
-- @param #string text
-- 
function TaskConfirmView:setText(text)
	self["textLab"]:setString(text)
end

---
-- 窗口退出自动回调
-- @function [parent = #TaskConfirmView] onExit
-- 
function TaskConfirmView:onExit()
	self._owner = nil
	self._callBack = nil
	instance = nil
	TaskConfirmView.super.onExit(self)
end