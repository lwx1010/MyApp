---
-- 精力不足界面
-- @module view.biwu.BWJLMsgBoxView
--

local require = require
local class = class
local tr = tr

local moduleName = "view.biwu.BWJLMsgBoxView"
module(moduleName)

---
-- 类定义
-- @type BWJLMsgBoxView
--
local BWJLMsgBoxView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 判断窗口是否激活
-- @field [parent = #view.biwu.BWJLMsgBoxView] #bool _isShow
-- 
local _isActivity = false

---
-- 构造函数
-- @function [parent = #BWJLMsgBoxView] ctor
--
function BWJLMsgBoxView:ctor()
	BWJLMsgBoxView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #BWJLMsgBoxView] _create
--
function BWJLMsgBoxView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_pk/ui_cost_jl.ccbi", true)
	
	self:handleButtonEvent("tipCcb.aNoBtn", self._closeBtnHandler)
	self:handleButtonEvent("tipCcb.aYesBtn", self._YesBtnHandler)
end 

---
-- 设置显示要素
-- @function [parent = #BWJLMsgBoxView] setShowMsg
-- @param #table msg
-- 
function BWJLMsgBoxView:setShowMsg(msg)
	if msg.type == 2 then --精力
		local vigorData = require("xls.VigorXls").data
		local yuanbao = vigorData[msg.hasbuy_c + 1]
		local getVigtor
		if yuanbao == nil then
			yuanbao = vigorData[#vigorData].Yuanbao
			getVigtor = vigorData[#vigorData].GetVigor
		else
			yuanbao = vigorData[msg.hasbuy_c + 1].Yuanbao
			getVigtor = vigorData[msg.hasbuy_c + 1].GetVigor
		end
		self["tip2Lab"]:setString(tr("您只需花费")..yuanbao..tr("元宝就可以恢复")..getVigtor..tr("点精力，请问是否需要恢复？"))
		self["tip3Lab"]:setString(tr("今日已恢复精力次数") .. msg.hasbuy_c.."/"..msg.maxbuy_c)
	end
end

---
-- 设置窗口激活
-- @function [parent = #view.biwu.BWJLMsgBoxView] setActivity
-- @param #bool activity
-- 
function setActivity(activity)
	_isActivity = activity
end

---
-- 窗口是否激活
-- @function [parent = #view.biwu.BWJLMsgBoxView] isShow
-- @return #bool _isShow
-- 
function isActivity()
	return _isActivity
end

---
-- 点击了取消按钮
-- @function [parent = #BWJLMsgBoxView] _closeBtnHandler
-- 
function BWJLMsgBoxView:_closeBtnHandler(sender, event)
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 点击了确定
-- @function [parent = #BWJLMsgBoxView] _YesBtnHandler
-- 
function BWJLMsgBoxView:_YesBtnHandler(sender, event)
	local gameNet = require("utils.GameNet")
	gameNet.send("C2s_phyvigor_buy", {type = 2})--购买精力
	
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 窗口退出自动回调
-- @function [parent = #BWJLMsgBoxView] onExit
-- 
function BWJLMsgBoxView:onExit()
	require("view.biwu.BWJLMsgBoxView").instance = nil

	_isActivity = false
	BWJLMsgBoxView.super.onExit(self)
end











