---
-- 大侠挑战界面
-- @module view.qiyu.challenge.ChallengeView
-- 

local class = class
local require = require
local printf = printf
local pairs = pairs
local dump = dump
local tonumber = tonumber


local moduleName = "view.qiyu.challenge.ChallengeView"
module(moduleName)

---
-- 类定义
-- @type ChallengeView
-- 
local ChallengeView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 大侠挑战信息
-- @field [parent=#ChallengeView] #table _info 
-- 
ChallengeView._info = nil

---
-- 构造函数
-- @function [parent=#ChallengeView] ctor
-- @param self
-- 
function ChallengeView:ctor()
	self.super.ctor(self)
	
	self:_create()
--	self:retain()
end

---
-- 创建
-- @function [parent=#ChallengeView] _create
-- @param self
-- 
function ChallengeView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_tiaozhan3.ccbi", true)
	self["rewardCcb.lvBgSpr"]:setVisible(false)
	self["rewardCcb.lvLab"]:setVisible(false)
	self:handleButtonEvent("challengeBtn", self._challengeClkHandler)
end

---
-- 点击了挑战
-- @function [parent=#ChallengeView] _challengeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function ChallengeView:_challengeClkHandler( sender, event )
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_randomev_finish", {sid=self._info.sid})
end

---
-- 显示奖励物品
-- @function [parent=#ChallengeView] openUi
-- @param self
-- @param #table info 
-- 
function ChallengeView:openUi(info)
	self._info = info
	
--	dump(info)
	local StringUtil = require("utils.StringUtil")
	local rewardTbl = StringUtil.subStringToTable(info.extdata)
	if( not rewardTbl ) then return end
	
	-- 武学
	if( rewardTbl.type == "1" ) then
		self["rewardCcb.headPnrSpr"]:showReward("item", tonumber(rewardTbl.photo))
	-- 侠客
	elseif( rewardTbl.type == "2" ) then
		self["rewardCcb.headPnrSpr"]:showIcon(tonumber(rewardTbl.photo))
	end
	
	local PartnerShowConst = require("view.const.PartnerShowConst")
	self:changeFrame("rewardCcb.frameSpr", PartnerShowConst.STEP_FRAME[tonumber(rewardTbl.rare)])
	self["nameLab"]:setString(PartnerShowConst.STEP_COLORS[tonumber(rewardTbl.rare)]..rewardTbl.name)
	-- 碎片
	if( rewardTbl.issubkind == "1" ) then
--		self:changeFrame("chipSpr", "ccb/mark/mark_piece.png")
		self["chipSpr"]:setVisible(true)
	else
		self["chipSpr"]:setVisible(false)
	end
end

---
-- 关闭界面调用
-- @function [parent=#ChallengeView] closeUi
-- @param #self
-- 
function ChallengeView:closeUi()
	
end

---
-- 奇遇完成
-- @function [parent=#ChallengeView] clkOver
-- @param self
-- 
function ChallengeView:qiYuFinish()
	self:closeUi()
	
	--奇遇结束时，关闭整个界面
	if self:getParent() then
		local PlayView = require("view.qiyu.PlayView")
		PlayView.instance:qiYuFinish()
	end
end

---
-- 退出界面调用
-- @function [parent=#ChallengeView] onExit
-- @param self
-- 
function ChallengeView:onExit()
	instance = nil
	
	self.super.onExit(self)
end


