--- 
-- 购买挑战次数
-- @module view.wulinbang.BuyCntTipView
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local CCSpriteFrameCache = CCSpriteFrameCache
local CCTextureCache = CCTextureCache
local display = display

local moduleName = "view.wulinbang.BuyCntTipView"
module(moduleName)


--- 
-- 类定义
-- @type BuyCntTipView
-- 
local BuyCntTipView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 购买挑战次数所需元宝
-- @field [parent=#BuyCntTipView] #number _needYB
-- 
BuyCntTipView._needYB = 0

---  
-- 是否选中
-- @field [parent=#BuyCntTipView] #boolean _selected
-- 
--BuyCntTipView._selected = false

--- 创建实例
-- @return PlayerCell实例
function new()
	return BuyCntTipView.new()
end

--- 
-- 构造函数
-- @function [parent=#BuyCntTipView] ctor
-- @param self
-- 
function BuyCntTipView:ctor()
	BuyCntTipView.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#BuyCntTipView] _create
-- @param self
-- 
function BuyCntTipView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_wulinbang/ui_tiaozhancishu.ccbi", true)
	
	self:handleButtonEvent("yesBtn", self._okClkHandler)
	self:handleButtonEvent("cancelBtn", self._cancelClkHandler)
end

---
-- 点击了确定
-- @function [parent=#BuyCntTipView] _okClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BuyCntTipView:_okClkHandler( sender, event )
	local HeroAttr = require("model.HeroAttr")
	
	local FloatNotify = require("view.notify.FloatNotify")
	printf(HeroAttr.YuanBao)
	printf(self._needYB)
	if HeroAttr.YuanBao < self._needYB then
		FloatNotify.show(tr("元宝不足，无法购买挑战次数！"))
		return
	end
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_wulin_buy", {buy_num = 1})
	
	self:_cancelClkHandler()
end

--- 
-- 点击了取消
-- @function [parent=#BuyCntTipView] _cancelClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BuyCntTipView:_cancelClkHandler( sender, event )
	local GameView = require("view.GameView")
	GameView.removePopUp(self)
end

---
-- 打开界面调用
-- @function [parent=#BuyCntTipView] openUi
-- @param self
-- 
function BuyCntTipView:openUi( needYB )
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	
	self._needYB = needYB
	self["tipLab"]:setString(tr("确定花费") .. needYB .. tr("元宝购买挑战次数?"))
end
