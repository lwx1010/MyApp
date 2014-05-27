--- 
-- 系统设置界面
-- @module view.help.SystemView
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local PLATFORM_NAME = PLATFORM_NAME
local CONFIG = CONFIG

local moduleName = "view.help.SystemView"
module(moduleName)


--- 
-- 类定义
-- @type SystemView
-- 
local SystemView = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 构造函数
-- @function [parent=#SystemView] ctor
-- @param self
-- 
function SystemView:ctor()
	SystemView.super.ctor(self)
	
	self:_create()
	--self:retain()
end

--- 
-- 创建
-- @function [parent=#SystemView] _create
-- @param self
-- 
function SystemView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_sysmanage/ui_sysmanage.ccbi")
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	
	local vBox = self["sysVBox"]
	vBox.owner = self
--	vBox:setSnapWidth(10)
	-- 显示游戏活动
--	local RewardData = require("model.RewardData")
--	if RewardData.starHideTime > 0 then
--		local ActivityUi = require("view.help.ActivityUi").new()
--		vBox:addItem(ActivityUi)
--		vBox:setVSpace(20)
--		vBox:setSnapHeight(200)
--	end
	
	local Platforms = require("model.const.Platforms")
	-- pp平台显示pp用户中心
	if PLATFORM_NAME==Platforms.PP then
		local PPUi = require("view.help.PPUi").new()
		vBox:addItem(PPUi)
		vBox:setVSpace(20)
		vBox:setSnapHeight(200)
	-- 同步推平台显示用户中心
	elseif PLATFORM_NAME==Platforms.TB then
		local TBUi = require("view.help.TBUi").new()
		vBox:addItem(TBUi)
		vBox:setVSpace(20)
		vBox:setSnapHeight(200)
	end
	
	-- 基本系统设置
	local SysBaseUi = require("view.help.SysBaseUi").new()
	vBox:addItem(SysBaseUi)
	
	-- 91助手不显示微博绑定
	if PLATFORM_NAME~=Platforms.P91 then
		local WeiBoUi = require("view.help.WeiBoUi").new()
		vBox:addItem(WeiBoUi)
	end
	
	-- 公司用户平台
	local PlatformLogic = require("logic.PlatformLogic")
	if PlatformLogic.isUseMHSdk() then
		local MHUserOpUi = require("view.help.MHUserOpUi").new()
		vBox:addItem(MHUserOpUi)
	end
	
	-- 防沉迷
	local ConfigParams = require("model.const.ConfigParams")
	if CONFIG[ConfigParams.IS_FCM] and CONFIG[ConfigParams.IS_FCM]>0 then
		local BindCardUi = require("view.help.BindCardUi").new()
		vBox:addItem(BindCardUi)
	end
end

--- 
-- 点击了关闭
-- @function [parent=#SystemView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function SystemView:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
    local MainView = require("view.main.MainView")
    GameView.replaceMainView(MainView.createInstance(), true)
end

---
-- 关闭界面时调用
-- @function [parent=#SystemView] onExit
-- @param self
-- 
function SystemView:onExit()
--	local LocalConfig = require("utils.LocalConfig")
--	LocalConfig.save(true)
	
	instance = nil
	
	SystemView.super.onExit(self)
end

---
-- 打开界面调用
-- @function [parent=#SystemView] openUi
-- @param self
-- 
function SystemView:openUi()
	local GameView = require("view.GameView")
	GameView.replaceMainView(self, true)
end

