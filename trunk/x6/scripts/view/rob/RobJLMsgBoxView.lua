---
-- 精力不足界面
-- @module view.rob.RobJLMsgBoxView
--

local require = require
local class = class

local moduleName = "view.rob.RobJLMsgBoxView"
module(moduleName)

---
-- 类定义
-- @type RobJLMsgBoxView
--
local RobJLMsgBoxView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 判断窗口是否激活
-- @field [parent = #view.rob.RobJLMsgBoxView] #bool _isShow
-- 
local _isActivity = false

---
-- 构造函数
-- @function [parent = #RobJLMsgBoxView] ctor
--
function RobJLMsgBoxView:ctor()
	RobJLMsgBoxView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #RobJLMsgBoxView] _create
--
function RobJLMsgBoxView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_rob/ui_cost_jl.ccbi", true)
	
	self:handleButtonEvent("msgBoxCcb.aNoBtn", self._closeBtnHandler)
	self:handleButtonEvent("msgBoxCcb.aYesBtn", self._YesBtnHandler)
end 

---
-- 设置显示要素
-- @function [parent = #RobJLMsgBoxView] setShowMsg
-- @param #table msg
-- 
function RobJLMsgBoxView:setShowMsg(msg)
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
		self["yuanbaoLab"]:setString("您只需花费"..yuanbao.."元宝就可以恢复"..getVigtor.."点精力，请问是否需要恢复？")
		self["timeLab"]:setString(msg.hasbuy_c.."/"..msg.maxbuy_c)
	end
end

---
-- 设置窗口激活
-- @function [parent = #view.rob.RobJLMsgBoxView] setActivity
-- @param #bool activity
-- 
function setActivity(activity)
	_isActivity = activity
end

---
-- 窗口是否激活
-- @function [parent = #view.rob.RobJLMsgBoxView] isShow
-- @return #bool _isShow
-- 
function isActivity()
	return _isActivity
end

---
-- 点击了取消按钮
-- @function [parent = #RobJLMsgBoxView] _closeBtnHandler
-- 
function RobJLMsgBoxView:_closeBtnHandler(sender, event)
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 点击了确定
-- @function [parent = #RobJLMsgBoxView] _YesBtnHandler
-- 
function RobJLMsgBoxView:_YesBtnHandler(sender, event)
	local gameNet = require("utils.GameNet")
	gameNet.send("C2s_phyvigor_buy", {type = 2})--购买精力
	
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 窗口退出自动回调
-- @function [parent = #RobJLMsgBoxView] onExit
-- 
function RobJLMsgBoxView:onExit()
	_isActivity = false
	
	require("view.rob.RobJLMsgBoxView").instance = nil
	RobJLMsgBoxView.super.onExit(self)
end











