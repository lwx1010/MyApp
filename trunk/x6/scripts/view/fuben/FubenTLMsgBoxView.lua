---
-- 副本体力不足弹出窗口
-- @module view.fuben.FubenTLMsgBoxView
--

local require = require
local class = class
local printf = printf

local moduleName = "view.fuben.FubenTLMsgBoxView"
module(moduleName)

---
-- 类定义
-- @type FubenTLMsgBoxView
-- 
local FubenTLMsgBoxView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 判断窗口是否激活
-- @field [parent = #view.fuben.FubenTLMsgBoxView] #bool _isShow
-- 
local _isActivity = false

---
-- 构造函数
-- @function [parent = #FubenTLMsgBoxView] ctor
-- @param self
-- 
function FubenTLMsgBoxView:ctor()
	FubenTLMsgBoxView.super.ctor(self)
	self:_create()
end

---
-- 加载ccb
-- @function [parent = #FubenTLMsgBoxView] _create
-- @param self
-- 
function FubenTLMsgBoxView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_copy/ui_cost_tl.ccbi", true)
	
	self:handleButtonEvent("msgBoxCcb.closeBtn", self._closeBtnHandler)
	self:handleButtonEvent("msgBoxCcb.aNoBtn", self._closeBtnHandler)
	self:handleButtonEvent("msgBoxCcb.aYesBtn", self._YesBtnHandler)
end

---
-- 场景进入自动回调
-- @function [parent = #FubenTLMsgBoxView] onEnter
-- 
function FubenTLMsgBoxView:onEnter()
	FubenTLMsgBoxView.super.onEnter(self)

end

---
-- 设置窗口激活
-- @function [parent = #view.fuben.FubenTLMsgBoxView] setActivity
-- @param #bool activity
-- 
function setActivity(activity)
	_isActivity = activity
end

---
-- 窗口是否激活
-- @function [parent = #view.fuben.FubenTLMsgBoxView] isShow
-- @return #bool _isShow
-- 
function isActivity()
	return _isActivity
end

---
-- 设置显示要素
-- @function [parent = #FubenTLMsgBoxView] setShowMsg
-- @param #table msg
-- 
function FubenTLMsgBoxView:setShowMsg(msg)
	if msg.type == 1 then --体力
		local phyData = require("xls.PhysicXls").data
		local yuanbao = phyData[msg.hasbuy_c + 1]
		if yuanbao == nil then
			yuanbao = phyData[#phyData].Yuanbao
		else
			yuanbao = phyData[msg.hasbuy_c + 1].Yuanbao
		end
		self["yuanbaoLab"]:setString(yuanbao)
		self["revertActityLab"]:setString(msg.hasbuy_c.."/"..msg.maxbuy_c)
	end
end

---
-- 点击了关闭按钮
-- @function [parent = #FubenTLMsgBoxView] _closeBtnHandler
-- 
function FubenTLMsgBoxView:_closeBtnHandler(sender, event)
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 点击了确定
-- @function [parent = #FubenTLMsgBoxView] _YesBtnHandler
-- 
function FubenTLMsgBoxView:_YesBtnHandler(sender, event)
	local gameNet = require("utils.GameNet")
	gameNet.send("C2s_phyvigor_buy", {type = 1})--购买体力
	
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 窗口关闭自动回调
-- @function [parent = #FubenTLMsgBoxView] onExit
-- 
function FubenTLMsgBoxView:onExit()
	FubenTLMsgBoxView.super.onExit(self)
	
	_isActivity = false
	
	require("view.fuben.FubenTLMsgBoxView").instance = nil
	FubenTLMsgBoxView.super.onExit(self)
end



