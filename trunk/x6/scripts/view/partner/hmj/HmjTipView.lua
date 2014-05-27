--- 
-- 选择灵兽提示界面
-- @module view.partner.hmj.HmjTipView
-- 

local class = class
local printf = printf
local require = require
local tr = tr

local moduleName = "view.partner.hmj.HmjTipView"
module(moduleName)


--- 
-- 类定义
-- @type HmjTipView
-- 
local HmjTipView = class(moduleName, require("ui.CCBView").CCBView)

--- 创建实例
-- @return HmjTipView实例
function new()
	return HmjTipView.new()
end

--- 
-- 构造函数
-- @function [parent=#HmjTipView] ctor
-- @param self
-- 
function HmjTipView:ctor()
	HmjTipView.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#HmjTipView] _create
-- @param self
-- 
function HmjTipView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_onbattle/ui_hongmengjue2.ccbi", true)
	
	self:createClkHelper()
	self:addClkUi(node)
end

---
-- ui点击处理
-- @function [parent=#HmjTipView] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function HmjTipView:uiClkHandler( ui, rect )
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

