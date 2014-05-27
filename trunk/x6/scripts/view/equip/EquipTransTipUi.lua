--- 
-- 强化转移提示
-- @module view.equip.EquipTransTipUi
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs


local moduleName = "view.equip.EquipTransTipUi"
module(moduleName)

--- 
-- 类定义
-- @type EquipTransTipUi
-- 
local EquipTransTipUi = class(moduleName, require("ui.CCBView").CCBView)

--- 创建实例
-- @return EquipTransTipUi实例
function new()
	return EquipTransTipUi.new()
end

--- 
-- 构造函数
-- @function [parent=#EquipTransTipUi] ctor
-- @param self
-- 
function EquipTransTipUi:ctor()
	EquipTransTipUi.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#EquipTransTipUi] _create
-- @param self
-- 
function EquipTransTipUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_equip/ui_caozuotishi.ccbi", true)
	
	self:handleButtonEvent("confirmBtn", self._confirmClkHandler)
	self:handleButtonEvent("cancelBtn", self._cancelClkHandler)
end

---
-- 点击了确定
-- @function [parent=#EquipTransTipUi] _confirmClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function EquipTransTipUi:_confirmClkHandler( sender, event )
	local EquipStrengTransView = require("view.equip.EquipStrengTransView")
	if EquipStrengTransView.instance and EquipStrengTransView.instance:getParent() then
		EquipStrengTransView.instance:transCall()
	end
	
	--关闭提示界面
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 点击了取消
-- @function [parent=#EquipTransTipUi] _cancelClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function EquipTransTipUi:_cancelClkHandler( sender, event )
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 打开界面调用
-- @function [parent=#EquipTransTipUi] openUi
-- @param self
-- 
function EquipTransTipUi:openUi()
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
end
