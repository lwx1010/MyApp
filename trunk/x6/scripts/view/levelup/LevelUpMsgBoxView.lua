---
-- 升级界面
-- @module view.levelup.LevelUpMsgBoxView
--

local require = require
local class = class
local pairs = pairs
local tr = tr
local rawget = rawget

local dump = dump
local printf = printf
local assert = assert

local moduleName = "view.levelup.LevelUpMsgBoxView"
module(moduleName)

---
-- 类定义
-- @type LevelUpMsgBoxView
--
local LevelUpMsgBoxView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 记录升级播放的声音
-- @field [parent = #LevelUpMsgBoxView] _levelSound
-- 
LevelUpMsgBoxView._levelSound = nil

---
-- 设置显示类型标识，有物品
-- @field [parent = #view.levelup.LevelUpMsgBoxView] _HAVE_ITEM
-- 
local _HAVE_ITEM = 1

---
-- 无物品
-- @field [parent = #view.levelup.LevelUpMsgBoxView] _NO_ITEM
-- 
local _NO_ITEM = 2

---
-- 确定按钮的偏移位置
-- @field [parent = #view.levelup.LevelUpMsgBoxView] _BTN_OFFSETX
-- 
local _BTN_OFFSETX = 86

---
-- 构造函数
-- @function [parent = #LevelUpMsgBoxView] ctor
--
function LevelUpMsgBoxView:ctor()
	LevelUpMsgBoxView.super.ctor(self)
	self:_create()
	
	--播放升级声音
	local audio = require("framework.client.audio")
	self._levelSound = audio.playEffect("sound/sound_levelup.mp3")
end

---
-- 加载ccbi
-- @function [parent = #LevelUpMsgBoxView] _create
--
function LevelUpMsgBoxView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_levelup/ui_levelup.ccbi", true)
	
	self["confirmBtn"].startPosX = self["confirmBtn"]:getPositionX()
	
	
	self:handleButtonEvent("confirmBtn", self._confirmBtnHandler)
end 

---
-- 设置显示元素
-- @function [parent = #LevelUpMsgBoxView] setShowMsg
-- @param #table msg
-- 
function LevelUpMsgBoxView:setShowMsg(msg)
	--检测是否有item
	local itemName = rawget(msg, "name")
	if itemName == nil then
		self:setWinType(_NO_ITEM)
	else
		--显示物品
		local ItemViewConst = require("view.const.ItemViewConst")
		self:changeItemIcon("itemCcb.headPnrSpr", msg.photo)
		self:changeFrame("itemCcb.frameSpr", ItemViewConst.MARTIAL_RARE_COLORS1[msg.step])
		self:changeFrame("itemCcb.lvBgSpr", ItemViewConst.MARTIAL_RARE_COLORS2[msg.step])
		self["itemCcb.lvLab"]:setString("" .. msg.num)
		self["itemLab"]:setString(ItemViewConst.MARTIAL_STEP_COLORS[msg.step]..msg.name.." * "..msg.num)
		
		self:setWinType(_HAVE_ITEM)
	end

	self["levelLab"]:setString(msg.grade1.."→"..msg.grade2)
	self["wugongLevelLab"]:setString((msg.grade1*3).."→"..(msg.grade2*3))
	self["equitLevelLab"]:setString((msg.grade1*3).."→"..(msg.grade2*3))
	
	--local HeroAttr = require("model.HeroAttr")
	self["warLab"]:setString("" .. msg.fight_num .. tr("人"))
	self["expLab"]:setString("" .. msg.exp .. "/" .. msg.max_exp)
	
	local data = require("xls.LevelUpXls").data
	local info = data[msg.grade2]
	if not info then 
		self["ybLab"]:setString("0")
		self["ylLab"]:setString("0")
		self["physicalLab"]:setString("0")
		self["vigorLab"]:setString("0")
		return
	end
	
	self["ybLab"]:setString("".. (info.YuanBao or 0))
	self["ylLab"]:setString("" .. (info.Cash or 0))
	self["physicalLab"]:setString("" .. (info.Physical or 0))
	self["vigorLab"]:setString("" .. (info.Vigor or 0))
end

---
-- 点击了确定按钮
-- @function [parent = #LevelUpMsgBoxView] _confirmBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function LevelUpMsgBoxView:_confirmBtnHandler(sender, event)
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
    
    -- 更新背包，碎片最大值
    local gameNet = require("utils.GameNet")
    gameNet.send("C2s_hero_baginfo", {place_holder = 1, uiid = 1})
    
    local PlayOpenView = require("view.levelup.PlayOpenView")
    if PlayOpenView.hasNewPlayOpened() then
    	if PlayOpenView.instance == nil then
    		local PlayOpenViewIns = PlayOpenView.createInstance()
    		PlayOpenViewIns:openUi()
    	else
    		assert(PlayOpenView.instance:getParent())
    	end
    end
    
    --显示Loading动画
    local netLoading = require("view.notify.NetLoading")
	netLoading.show()
end

---
-- 设置窗口的显示类型
-- @function [parent = #LevelUpMsgBoxView] setWinType
-- @param #number type
-- 
function LevelUpMsgBoxView:setWinType(type)
	if type == _HAVE_ITEM then
		self["itemCcb"]:setVisible(true)
		self["itemNameBgSpr"]:setVisible(true)
		self["itemLab"]:setVisible(true)
		self["confirmBtn"]:setPositionX(self["confirmBtn"].startPosX)
		self["confirmBtnSpr"]:setPositionX(self["confirmBtn"]:getPositionX())
	elseif type == _NO_ITEM then
		self["itemCcb"]:setVisible(false)
		self["itemNameBgSpr"]:setVisible(false)
		self["itemLab"]:setVisible(false)
		self["confirmBtn"]:setPositionX(self["confirmBtn"]:getPositionX() - _BTN_OFFSETX)
		self["confirmBtnSpr"]:setPositionX(self["confirmBtn"]:getPositionX())
	end
end

---
-- 处理升级情况
-- @function [parent = #view.levelup.LevelUpMsgBoxView] dealGradeUp
-- @param #table event
-- 
function dealGradeUp(event)
	local levelupLogic = require("logic.LevelUpLogic")
	levelupLogic.addLevelUpMsg("view.levelup.LevelUpMsgBoxView", event)
	
	local fightCCBView = require("view.fight.FightCCBView")
	if fightCCBView.isInBattle() == false then
		levelupLogic.dealMsg()
	end
end

---
-- 场景退出回调
-- @function [parent = #LevelUpMsgBoxView] onExit
-- 
function LevelUpMsgBoxView:onExit()
	--停止声音
	local audio = require("framework.client.audio")
	audio.stopEffect(self._levelSound)

	require("view.levelup.LevelUpMsgBoxView").instance = nil
	LevelUpMsgBoxView.super.onExit(self)
end






