---
-- 副本详细描述
-- @module view.fuben.FubenChapterStageView
--

local require = require
local class = class
local printf = printf
local string = string
local CCSize = CCSize

local moduleName = "view.fuben.FubenChapterStageView"
module(moduleName)

---
-- 类定义
-- @type FubenChapterStageView
-- 
local FubenChapterStageView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent = #FubenChapterStageView] ctor
-- @param self
-- 
function FubenChapterStageView:ctor()
	FubenChapterStageView.super.ctor(self)
	self:_create()
end

---
-- 加载ccb
-- @function [parent = #FubenChapterStageView] _create
-- @param self
-- 
function FubenChapterStageView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_copy/ui_chapter_stageinfo.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeBtnHandler)
end

---
-- 设置显示要素
-- @function [parent = #FubenChapterStageView] setShowMsg
-- @param #table msg
-- 
function FubenChapterStageView:setShowMsg(msg)
	self["nameLab"]:setString(msg.name)
	self["discLab"]:setString(msg.des)
	self["leftCountLab"]:setString(msg.freeTimes)
	if msg.level == 1 then -- 普通关卡
		self:changeFrame("levelSpr", "ccb/mark/stage_normaltitle.png")
	elseif msg.level == 2 then
		self:changeFrame("levelSpr", "ccb/mark/stage_hardtitle.png")
	elseif msg.level == 3 then
		self:changeFrame("levelSpr", "ccb/mark/stage_bosstitle.png")
	elseif msg.level == 4 then
		self:changeFrame("levelSpr", "ccb/mark/stage_deathtitle.png")
	end
	
	--经验，奖励相关
	local reward = msg.rewardDes
--	local posSB, posStart = string.find(reward, "exp1_")
--	local posEB, posEnd = string.find(reward, ";")
--	local parnerExp = string.sub(reward, posStart + 1, posEnd - 1)
	
	local parnerExp, reward = _getStringData(reward, "exp1_")
	local famouse, reward = _getStringData(reward, "exp2_")
	local money, reward = _getStringData(reward, "money_")
	local item, reward = _getStringData(reward, "item_")
	
	self["expLab"]:setString(parnerExp)
	self["famousLab"]:setString(famouse)
	self["moneyLab"]:setString(money)
	
	self["itemLab"]:setString(item)
	self["itemLab"]:setDimensions(CCSize(430, 50))
end

---
-- 获取字符串中特定内容
-- @function [parent = #view.fuben.FubenChapterStageView] _getStringData
-- @param #string str
-- @param #string subStr
-- 
function _getStringData(str, subStr)
	local posSB, posStart = string.find(str, subStr)
	local posEB, posEnd = string.find(str, ";")
	if not posStart and not posEnd then
		return "", ""
	end
	
	local wantStr
	if posEnd == nil then
		wantStr = string.sub(str, posStart + 1)
	else
		wantStr = string.sub(str, posStart + 1, posEnd - 1)
		str = string.sub(str, posEnd + 1)
	end
	
	return wantStr, str
end

---
-- 点击了关闭按钮
-- @function [parent = #FubenChapterStageView] _closeBtnHandler
-- 
function FubenChapterStageView:_closeBtnHandler(sender, event)
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 退出自动回调
-- @function [parent = #FubenChapterStageView] onExit
-- 
function FubenChapterStageView:onExit()
	require("view.fuben.FubenChapterStageView").instance = nil
	FubenChapterStageView.super.onExit(self)
end



