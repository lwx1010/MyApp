---
-- 奖励提示界面
-- @module view.shilian.RewardTipView
-- 

local class = class
local require = require
local printf = printf
local pairs = pairs
local dump = dump
local tonumber = tonumber
local tr = tr


local moduleName = "view.shilian.RewardTipView"
module(moduleName)

---
-- 类定义
-- @type RewardTipView
-- 
local RewardTipView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 挑战的类型(1-普通， 2-困难， 3-地狱)
-- @field [parent=#RewardTipView] #number _type
-- 
RewardTipView._type = 1

---
-- 挑战的关卡信息
-- @field [parent=#RewardTipView] #table _chapterInfo
-- 
RewardTipView._chapterInfo = nil

---
-- 构造函数
-- @function [parent=#RewardTipView] ctor
-- @param self
-- 
function RewardTipView:ctor()
	self.super.ctor(self)
	
	self:_create()
end

---
-- 创建ccb
-- @function [parent=#RewardTipView] _create
-- @param self
-- 
function RewardTipView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_zhizunshilianpiece2.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("challengeCcb.aBtn", self._challengeClkHandler)
end

---
-- 点击了关闭按钮
-- @function [parent=#RewardTipView] _closeClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function RewardTipView:_closeClkHandler(sender,event)
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 点击了挑战
-- @function [parent=#RewardTipView] _challengeClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function RewardTipView:_challengeClkHandler(sender,event)
	if not self._chapterInfo then return end
	
	local HeroAttr = require("model.HeroAttr")
	local FloatNotify = require("view.notify.FloatNotify")
	if self._type == 2 then
		if self._chapterInfo.is_difffight == 1 then
			if HeroAttr.YuanBao < 16 then
				FloatNotify.show(tr("元宝不足，无法挑战！"))
				return
			end
		end
	elseif self._type == 3 then
		if self._chapterInfo.is_hellfight == 1 then
			if HeroAttr.YuanBao < 24 then
				FloatNotify.show(tr("元宝不足，无法挑战！"))
				return
			end
		end
	end
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_shilian_fight", {shilian_no=self._chapterInfo.shilian_no, fight_type=self._type})
	
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 打开界面调用
-- @function [parent=#RewardTipView] openUi
-- @param self
-- @param #table chapterInfo
-- @param #number type 1-普通，2-困难，3-地狱
-- 
function RewardTipView:openUi(chapterInfo,type)
	self._chapterInfo = chapterInfo
	self._type = type
	
	local xls = require("xls.ShiLianXls").data
	local npcName = xls[chapterInfo.shilian_no].GuanQiaName
	if type == 1 then
		self["npcNameLab"]:setString(tr(npcName.." 普通难度"))
		self["yuanBaoSpr"]:setVisible(false)
		self["yuanBaoLab"]:setVisible(false)
		self["rewardLab"]:setString(tr(xls[chapterInfo.shilian_no].SimpRewardMsg))
		
		self["cashLab"]:setString(xls[chapterInfo.shilian_no].SimpMathRewardInfo[1])
		self["expLab"]:setString(xls[chapterInfo.shilian_no].SimpMathRewardInfo[2])
		self["renownLab"]:setString(xls[chapterInfo.shilian_no].SimpMathRewardInfo[3])
		
		if chapterInfo.simp_shousha and chapterInfo.simp_shousha ~= "" then
			self["firstKillLab"]:setVisible(true)
			self["firstKillLab"]:setString(tr("(首杀："..chapterInfo.simp_shousha..")"))
		else
			self["firstKillLab"]:setVisible(false)
		end
	elseif type == 2 then
		self["npcNameLab"]:setString(tr(npcName.." 困难难度"))
		self["rewardLab"]:setString(tr(xls[chapterInfo.shilian_no].DiffRewardMsg))
		if chapterInfo.is_difffight == 1 then
			self["yuanBaoSpr"]:setVisible(true)
			self["yuanBaoLab"]:setVisible(true)
			self["yuanBaoLab"]:setString(16)
		else
			self["yuanBaoSpr"]:setVisible(false)
			self["yuanBaoLab"]:setVisible(false)
		end
		
		self["cashLab"]:setString(xls[chapterInfo.shilian_no].DiffMathRewardInfo[1])
		self["expLab"]:setString(xls[chapterInfo.shilian_no].DiffMathRewardInfo[2])
		self["renownLab"]:setString(xls[chapterInfo.shilian_no].DiffMathRewardInfo[3])
		
		if chapterInfo.diff_shousha and chapterInfo.diff_shousha ~= "" then
			self["firstKillLab"]:setVisible(true)
			self["firstKillLab"]:setString(tr("(首杀："..chapterInfo.diff_shousha..")"))
		else
			self["firstKillLab"]:setVisible(false)
		end
	elseif type == 3 then
		self["npcNameLab"]:setString(tr(npcName.." 地狱难度"))
		self["rewardLab"]:setString(tr(xls[chapterInfo.shilian_no].HellRewardMsg))
		if chapterInfo.is_hellfight == 1 then
			self["yuanBaoSpr"]:setVisible(true)
			self["yuanBaoLab"]:setVisible(true)
			self["yuanBaoLab"]:setString(24)
		else
			self["yuanBaoSpr"]:setVisible(false)
			self["yuanBaoLab"]:setVisible(false)
		end
		
		self["cashLab"]:setString(xls[chapterInfo.shilian_no].HellMathRewardInfo[1])
		self["expLab"]:setString(xls[chapterInfo.shilian_no].HellMathRewardInfo[2])
		self["renownLab"]:setString(xls[chapterInfo.shilian_no].HellMathRewardInfo[3])
		
		if chapterInfo.hell_shousha and chapterInfo.hell_shousha ~= "" then
			self["firstKillLab"]:setVisible(true)
			self["firstKillLab"]:setString(tr("(首杀："..chapterInfo.hell_shousha..")"))
		else
			self["firstKillLab"]:setVisible(false)
		end
	end
	
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
end

---
-- 退出界面调用
-- @function [parent=#RewardTipView] onExit
-- @param self
-- 
function RewardTipView:onExit()
	instance = nil
	
	self.super.onExit(self)
end




