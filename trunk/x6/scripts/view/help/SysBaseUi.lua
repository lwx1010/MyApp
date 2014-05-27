--- 
-- 系统设置界面
-- @module view.help.SysBaseUi
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local PLATFORM_NAME = PLATFORM_NAME

local moduleName = "view.help.SysBaseUi"
module(moduleName)


--- 
-- 类定义
-- @type SysBaseUi
-- 
local SysBaseUi = class(moduleName, require("ui.CCBView").CCBView)


--- 创建实例
-- @return SysBaseUi实例
function new()
	return SysBaseUi.new()
end

--- 
-- 构造函数
-- @function [parent=#SysBaseUi] ctor
-- @param self
-- 
function SysBaseUi:ctor()
	SysBaseUi.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#SysBaseUi] _create
-- @param self
-- 
function SysBaseUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_sysmanage/ui_sysmanagepiece.ccbi", true)
	
	self:handleMenuItemEvent("musicCcb.aChk", self._musicClkHandler)
	self:handleMenuItemEvent("soundCcb.aChk", self._soundClkHandler)
	self:handleButtonEvent("exchangeCcb.aBtn", self._exchangeClkHandler)
	self:handleButtonEvent("checkCcb.aBtn", self._checkClkHandler)
	
	local inputEdit = self["inputEdit"]
	inputEdit:setMaxLength(20)
	inputEdit:setPlaceHolder(tr("请输入CD-KEY"))
	
	local LocalConfig = require("utils.LocalConfig")
	local GameConfigs = require("model.const.GameConfigs")
	local audio = require("framework.client.audio")
	local isMusicOff = LocalConfig.getValue(true, GameConfigs.MUSIC_OFF)
	if not isMusicOff then
		self["musicCcb.aChk"]:setSelectedIndex(1)
	end
	
	local isSoundOff =  LocalConfig.getValue(true, GameConfigs.SOUND_OFF)
	if not isSoundOff then
		self["soundCcb.aChk"]:setSelectedIndex(1)
	end
	
--	-- pp平台显示客服QQ
--	local Platforms = require("model.const.Platforms")
--	if PLATFORM_NAME==Platforms.PP then
	-- ios平台显示客服QQ
	local device = require("framework.client.device")
	if device.platform=="ios" then
		self["qqLab"]:setVisible(true)
	else
		self["qqLab"]:setVisible(false)
	end
end

---
-- 关闭界面时调用
-- @function [parent=#SysBaseUi] onExit
-- @param self
-- 
function SysBaseUi:onExit()
	local LocalConfig = require("utils.LocalConfig")
	LocalConfig.save(true)
	
	instance = nil
	
	SysBaseUi.super.onExit(self)
end

---
-- 点击了音乐
-- @function [parent=#SysBaseUi] _musicClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function SysBaseUi:_musicClkHandler( sender, event )
	local audio = require("framework.client.audio")
	local LocalConfig = require("utils.LocalConfig")
	local GameConfigs = require("model.const.GameConfigs")
	local index = self["musicCcb.aChk"]:getSelectedIndex()
	if index == 1 then
		audio.musicEnable()
		audio.playBackgroundMusic("sound/bgm.mp3")
		LocalConfig.setValue(true, GameConfigs.MUSIC_OFF, nil)
	else
		audio.stopBackgroundMusic(true)
		audio.musicDisable()
		LocalConfig.setValue(true, GameConfigs.MUSIC_OFF, 1)
	end
end

---
-- 点击了音效
-- @function [parent=#SysBaseUi] _soundClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function SysBaseUi:_soundClkHandler( sender, event )
	local audio = require("framework.client.audio")
	local LocalConfig = require("utils.LocalConfig")
	local GameConfigs = require("model.const.GameConfigs")
	if self["soundCcb.aChk"]:getSelectedIndex() == 1 then
		audio.soundEnable()
		LocalConfig.setValue(true, GameConfigs.SOUND_OFF, nil)
	else
		audio.soundDisable()
		LocalConfig.setValue(true, GameConfigs.SOUND_OFF, 1)
	end
end

---
-- 点击了兑换
-- @function [parent=#SysBaseUi] _exchangeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function SysBaseUi:_exchangeClkHandler( sender, event )
	local str = self["inputEdit"]:getText()
	if str == "" then return end
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_giftcode_getgift", {gift_str = str})
end

---
-- 点击了查看帮助
-- @function [parent=#SysBaseUi] _checkClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function SysBaseUi:_checkClkHandler( sender, event )
	local HelpView = require("view.help.HelpView")
	HelpView.createInstance():openUi()
end


