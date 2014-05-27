--- 
-- 玩法整合界面：招财
-- @module view.qiyu.zhaocai.PlayZhaoCaiView
-- 

local class = class
local printf = printf
local require = require
local tr = tr


local moduleName = "view.qiyu.zhaocai.PlayZhaoCaiView"
module(moduleName)

--- 
-- 类定义
-- @type PlayZhaoCaiView
-- 
local PlayZhaoCaiView = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 构造函数
-- @function [parent=#PlayZhaoCaiView] ctor
-- @param self
-- 
function PlayZhaoCaiView:ctor()
	PlayZhaoCaiView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#PlayZhaoCaiView] _create
-- @param self
-- 
function PlayZhaoCaiView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_zhaocai.ccbi", true)
	
	self:handleButtonEvent("zhaoCaiCcb.aBtn", self._zhaoCaiBtnHandler)
end

---
-- 点击了招财
-- @function [parent=#PlayZhaoCaiView] _zhaoCaiBtnHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function PlayZhaoCaiView:_zhaoCaiBtnHandler( sender, event )
	local gameNet = require("utils.GameNet")
	gameNet.send("C2s_treasure_get_cash", {place_holder = 1})
end

---
-- 设置显示信息
-- @function [parent = #BossEnterView] setShowMsg
-- 
function PlayZhaoCaiView:setShowMsg(msg)
	self["freeTimeLab"]:setString(msg.rest_fcount)
	self["leftZhaoCaiLab"]:setString(msg.rest_count)
	self["desLab"]:setString("使用"..msg.need_yuanbao.."元宝招财， 获得"..msg.get_cash.."银两")
end

---
-- 打开界面调用
-- @function [parent=#PlayZhaoCaiView] openUi
-- @param self
-- @param #Randomev_info info
-- 
function PlayZhaoCaiView:openUi( info )
	if not info then return end
	
	self:setVisible(true)
	
	local gameNet = require("utils.GameNet")
	gameNet.send("C2s_treasure_info", {place_holder = 1})
end

---
-- 关闭界面
-- @function [parent=#PlayZhaoCaiView] closeUi
-- @param self
-- 
function PlayZhaoCaiView:closeUi()
	self:setVisible(false)
end

---
-- 退出界面调用
-- @function [parent=#PlayZhaoCaiView] onExit
-- @param self
-- 
function PlayZhaoCaiView:onExit()
	instance = nil
	
	PlayZhaoCaiView.super.onExit(self)
	
	
end