---
-- 神秘老人提示界面
-- @module view.qiyu.laoren.LaoRenTipView
--

local require = require
local class = class
local printf = printf
local tr = tr


local moduleName = "view.qiyu.laoren.LaoRenTipView"
module(moduleName)


--- 
-- 类定义
-- @type LaoRenTipView
-- 
local LaoRenTipView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 货币类型1，元宝，2，银两
-- @field [parent=#LaoRenTipView] #number _type
-- 
LaoRenTipView._type = 0

---
-- 货币数量
-- @field [parent=#LaoRenTipView] #number _cnt
-- 
LaoRenTipView._cnt = 0

---
-- 奇遇sid
-- @field [parent=#LaoRenTipView] #string _sid
-- 
LaoRenTipView._sid = nil

---
-- 创建实例
-- @return LaoRenTipView实例
-- 
function new()
	return LaoRenTipView.new()
end

---
-- 构造函数
-- @function [parent = #LaoRenTipView] ctor
-- 
function LaoRenTipView:ctor()
	LaoRenTipView.super.ctor(self)
	self:_create()
end

---
-- 创建加载ccbi文件
-- @function [parent = #LaoRenTipView] _create
-- 
function LaoRenTipView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_ask.ccbi", true)
	
	self:handleButtonEvent("okBtn", self._okClkHandler)
	self:handleButtonEvent("cancelBtn", self._cancelClkHandler)
end

---
-- 点击了确认
-- @function [parent=#LaoRenTipView] _okClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function LaoRenTipView:_okClkHandler( sender, event )
	local HeroAttr = require("model.HeroAttr")
	if self._type == 1 then
		if (HeroAttr.YuanBao or 0) < self._cnt then
			local FloatNotify = require("view.notify.FloatNotify")
			FloatNotify.show(tr("元宝不足，无法购买!"))
		else
			local GameNet = require("utils.GameNet")
			GameNet.send("C2s_randomev_finish", {sid = self._sid})
			
			local LaoRenView = require("view.qiyu.laoren.LaoRenView")
			if LaoRenView.instance and LaoRenView.instance:getParent() then
				LaoRenView.instance:qiYuFinish()
			end
		end
	elseif self._type == 2 then
	
	end
	
	self:_cancelClkHandler()
--	local LaoRenView = require("view.qiyu.laoren.LaoRenView")
--	if LaoRenView.instance and LaoRenView.instance:getParent() then
--		LaoRenView.instance:qiYuFinish()
--	end
end

---
-- 点击了取消
-- @function [parent=#LaoRenTipView] _cancelClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function LaoRenTipView:_cancelClkHandler( sender, event )
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 打开界面调用
-- @function [parent=#LaoRenTipView] openUi
-- @param self
-- @param #string tip 提示内容
-- @param #number type 货币类型 1，元宝，2，银两
-- @param #number cnt 货币数量
-- @param #string sid 奇遇sid
-- 
function LaoRenTipView:openUi( tip, type, cnt, sid )
	local GameView = require("view.GameView")
	GameView.addPopUp(self,true)
	GameView.center(self)
	
	self["curLab"]:setString(tip)
--	printf(tip)
	self._type = type
	self._cnt = cnt
	self._sid = sid
end

---
-- 退出界面调用
-- @function [parent=#LaoRenTipView] onExit
-- @param self
-- 
function LaoRenTipView:onExit()
	instance = nil
	
	self.super.onExit(self)
end
