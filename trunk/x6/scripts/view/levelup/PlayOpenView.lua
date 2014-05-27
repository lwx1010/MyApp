---
-- 玩法开放提示
-- @module view.levelup.PlayOpenView
--

local require = require
local class = class
local pairs = pairs
local table = table

local printf = printf
local dump = dump

local moduleName = "view.levelup.PlayOpenView"
module(moduleName)

---
-- 类定义
-- @type PlayOpenView
--
local PlayOpenView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 当前开放玩法信息
-- @field [parent=#view.levelup.PlayOpenView] #table _curOpenPlayInfos
-- 
local _curOpenPlayInfos = nil

--- 
-- 当前显示的玩法
-- @field [parent=#PlayOpenView] #tabel _curShowPlay
-- 
PlayOpenView._curShowPlay = nil

---
-- 构造函数
-- @function [parent = #PlayOpenView] ctor
--
function PlayOpenView:ctor()
	PlayOpenView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #PlayOpenView] _create
--
function PlayOpenView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_levelup/wanfatishi.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeBtnHandler)
	self:handleButtonEvent("goBtn", self._goBtnHandler)
end 

---
-- 当前是否有开放的玩法
-- @function [parent = #view.levelup.PlayOpenView] hasNewPlayOpened
-- @return #boolean 
-- 
function hasNewPlayOpened()
	local HeroAttr = require("model.HeroAttr")
	if not HeroAttr.Grade or HeroAttr.Grade <= 1 then return false end
	
	_curOpenPlayInfos = {}
	local data = require("xls.PlayOpenXls").data
	for k,v in pairs (data) do
		if v.StartLevel == HeroAttr.Grade and (v.HasOpenTip and v.HasOpenTip == 1) and v.OpenIcon then
			table.insert(_curOpenPlayInfos, v)
		end
	end
	
	if #_curOpenPlayInfos > 0 then
		return true
	else
		return false
	end
end

---
-- 打开界面调用
-- @function [parent=#PlayOpenView] openUi
-- @param self
-- 
function PlayOpenView:openUi()
	if not _curOpenPlayInfos or #_curOpenPlayInfos == 0 then return end
	
	local play 
	for i = 1, #_curOpenPlayInfos do
		play = _curOpenPlayInfos[i]
		if play then
			table.remove(_curOpenPlayInfos, i)
			break
		end
	end
	
	self._curShowPlay = play
	self:changeTexture("playSpr", "res/ui/ccb/ccbResources/layout/notice/" .. play.OpenIcon .. ".jpg")
	self["playLab"]:setString(play.OpenDesc)
	
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
end

---
-- 点击了关闭按钮
-- @function [parent = #PlayOpenView] _closeBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function PlayOpenView:_closeBtnHandler(sender, event)
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
    
    --self:openUi()
end

---
-- 点击了前往
-- @function [parent = #PlayOpenView] _goBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function PlayOpenView:_goBtnHandler(sender, event)
	local showPlay = self._curShowPlay.Name
	
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
    --local MainView = require("view.main.MainView")
    
    --检测是否有引导
	local isGuiding = require("ui.CCBView").isGuiding
	if isGuiding == false then
    	GameView.removeAllAbove(true)
    end
    
    local MainView = require("view.main.MainView")
	GameView.replaceMainView(MainView.createInstance(), true)
			
    printf("go go go 点击了前往")
    printf("showPlay = "..showPlay)
    local Uiid = require("model.Uiid")
    Uiid.openUi( showPlay )
    
    --self:openUi()
end

---
-- 场景退出回调
-- @function [parent = #PlayOpenView] onExit
-- 
function PlayOpenView:onExit()
	printf("Player Open View Exit ...")
	require("view.levelup.PlayOpenView").instance = nil
	PlayOpenView.super.onExit(self)
end






