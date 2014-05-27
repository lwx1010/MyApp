---
-- 世界BOSS提示前往界面
-- @module view.boss.BossNoticeView
--

local require = require
local class = class

local moduleName = "view.boss.BossNoticeView"
module(moduleName)

---
-- 类定义
-- @type BossNoticeView
--
local BossNoticeView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent = #BossNoticeView] ctor
--
function BossNoticeView:ctor()
	BossNoticeView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #BossNoticeView] _create
--
function BossNoticeView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_boss/ui_boss_tishi.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeBtnHandler)
	self:handleButtonEvent("goBtn", self._goBtnHandler)
end 

---
-- 点击了关闭按钮
-- @function [parent = #BossNoticeView] _closeBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function BossNoticeView:_closeBtnHandler(sender, event)
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 点击了前往按钮
-- @function [parent = #BossNoticeView] _goBtnHandler
-- 
function BossNoticeView:_goBtnHandler()
	local PlayView = require("view.qiyu.PlayView").createInstance()
	local uiId = require("model.Uiid")
	PlayView:openUi(1, uiId.UIID_BOSS_ENTER)
	
	--setSelected
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 场景退出自动回调
-- @function [parent = #BossNoticeView] onExit
-- 
function BossNoticeView:onExit()
	BossNoticeView.super.onExit(self)
	instance = nil
end











