--- 
-- 是否需要引导提示
-- @module view.main.NeedGuideTipView
-- 

local class = class
local printf = printf
local require = require
local tr = tr

local moduleName = "view.main.NeedGuideTipView"
module(moduleName)


--- 
-- 类定义
-- @type NeedGuideTipView
-- 
local NeedGuideTipView = class(moduleName, require("ui.CCBView").CCBView)


--- 创建实例
-- @return NeedGuideTipView实例
function new()
	return NeedGuideTipView.new()
end

--- 
-- 构造函数
-- @function [parent=#NeedGuideTipView] ctor
-- @param self
-- 
function NeedGuideTipView:ctor()
	NeedGuideTipView.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#NeedGuideTipView] _create
-- @param self
-- 
function NeedGuideTipView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_wulinbang/ui_tiaozhancishu.ccbi", true)
	
	self:handleButtonEvent("confirmBtn", self._okClkHandler)
	self:handleButtonEvent("cancelBtn", self._cancelClkHandler)
end

---
-- 点击了确定
-- @function [parent=#NeedGuideTipView] _okClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function NeedGuideTipView:_okClkHandler( sender, event )
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_guide_accept", {place_holder = 1})

	self:_cancelClkHandler()
	
--	local GuideUi = require("view.guide.GuideUi")
--	GuideUi.createGuide(1001)
end

--- 
-- 点击了取消
-- @function [parent=#NeedGuideTipView] _cancelClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function NeedGuideTipView:_cancelClkHandler( sender, event )
	local GameView = require("view.GameView")
	GameView.removePopUp(self)
end

---
-- 打开界面调用
-- @function [parent=#NeedGuideTipView] openUi
-- @param self
-- @param #number partnerid
-- 
function NeedGuideTipView:openUi( )
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	
	self["tipLab"]:setString(tr("是否需要新手指引？"))
end
