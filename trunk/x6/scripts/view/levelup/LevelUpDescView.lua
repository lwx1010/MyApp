---
-- 升级描述
-- @module view.levelup.LevelUpDescView
--

local require = require
local class = class

local CCSize = CCSize
local ccp = ccp

local moduleName = "view.levelup.LevelUpDescView"
module(moduleName)

---
-- 类定义
-- @type LevelUpDescView
--
local LevelUpDescView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent = #LevelUpDescView] ctor
--
function LevelUpDescView:ctor()
	LevelUpDescView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #LevelUpDescView] _create
--
function LevelUpDescView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_mainstage/ui_levelguide.ccbi", true)
	
	self["descLab"]:setDimensions(CCSize(415, 0))
	self["descLab"]:setAnchorPoint(ccp(0, 0.7))
	
	self:handleButtonEvent("yesBtn", self._yesBtnHandler)
end 

---
-- 设置描述信息
-- @function [parent = #LevelUpDescView] setShowMsg
-- @param #string msg
--  
function LevelUpDescView:setShowMsg(msg)
	self["descLab"]:setString(msg)
end

---
-- 点击了关闭按钮
-- @function [parent = #LevelUpDescView] _yesBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function LevelUpDescView:_yesBtnHandler(sender, event)
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 场景退出自动回调
-- @function [parent = #LevelUpDescView] onExit
-- 
function LevelUpDescView:onExit()
	instance = nil
	LevelUpDescView.super.onExit(self)
end










