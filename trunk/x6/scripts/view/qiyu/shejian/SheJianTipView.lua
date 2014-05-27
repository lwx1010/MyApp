---
-- 百发百中提示界面
-- @module view.qiyu.shejian.SheJianTipView
--

local require = require
local class = class
local printf = printf
local tr = tr


local moduleName = "view.qiyu.shejian.SheJianTipView"
module(moduleName)


--- 
-- 类定义
-- @type SheJianTipView
-- 
local SheJianTipView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 射击结果 -1：过期，0：重来，1：力度不够，2：射中，3：射爆
-- @field [parent=#SheJianTipView] #number _type
-- 
SheJianTipView._type = 0

---
-- 创建实例
-- @return SheJianTipView实例
-- 
function new()
	return SheJianTipView.new()
end

---
-- 构造函数
-- @function [parent = #SheJianTipView] ctor
-- 
function SheJianTipView:ctor()
	SheJianTipView.super.ctor(self)
	self:_create()
end

---
-- 创建加载ccbi文件
-- @function [parent = #SheJianTipView] _create
-- 
function SheJianTipView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_getsomething.ccbi", true)
	
	self:handleButtonEvent("confirmBtn", self._confirmClkHandler)
end

---
-- 点击了确认
-- @function [parent=#SheJianTipView] _confirmClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function SheJianTipView:_confirmClkHandler( sender, event )
	if self._type ~= 0 then
		local SheJianView = require("view.qiyu.shejian.SheJianView")
		if SheJianView.instance and SheJianView.instance:getParent() then
			SheJianView.instance:qiYuFinish()
		end
	end
	
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end 

---
-- 打开界面调用
-- @function [parent=#SheJianTipView] openUi
-- @param self
-- @param #number type
-- @param #string tip
-- 
function SheJianTipView:openUi( type, tip )
	local GameView = require("view.GameView")
	GameView.addPopUp(self,true)
	GameView.center(self)
	
	self._type = type
	self["rewardLab"]:setString(tip)
end

---
-- 退出界面调用
-- @function [parent=#SheJianTipView] onExit
-- @param self
-- 
function SheJianTipView:onExit()
	instance = nil
	
	local SheJianView = require("view.qiyu.shejian.SheJianView").instance
	if SheJianView then
		SheJianView:setIsDoing(false)
	end
	
	SheJianTipView.super.onExit(self)
end
