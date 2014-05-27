---
-- 战斗时背包/碎片已满提示界面
-- @module view.fight.FightCheckBagView
--

local require = require
local class = class

local CCSize = CCSize
local ccp = ccp

local tr = tr

local printf = printf

local moduleName = "view.fight.FightCheckBagView"
module(moduleName)

---
-- 类定义
-- @type FightCheckBagView
--
local FightCheckBagView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 保存当前点击的cell
-- @field [parent = #view.fight.FightCheckBagView] #CCNode _enemyCell
-- 
FightCheckBagView._enemyCell = nil

---
-- 常量 正常战斗情况
-- @field [parent = #view.fight.FightCheckBagView] #number NORMAL_FIGHT
-- 
NORMAL_FIGHT = 1

---
-- 常量 正常战斗情况
-- @field [parent = #view.fight.FightCheckBagView] #number HANGOUT_FIGHT
-- 
HANGOUT_FIGHT = 2

---
-- 构造函数
-- @function [parent = #FightCheckBagView] ctor
--
function FightCheckBagView:ctor()
	FightCheckBagView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #FightCheckBagView] _create
--
function FightCheckBagView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_battle/ui_checkbag.ccbi", true)
	
	--self["textLab"]:setAnchorPoint(ccp(0, 1))
	self["textLab"]:setDimensions(CCSize(445, 0))
	self:handleButtonEvent("winCcb.aNoBtn", self._closeBtnHandler)
	self:handleButtonEvent("winCcb.aYesBtn", self._yesBtnHandler)
	--textLab
end 

---
-- 点击了确定按钮
-- @function [parent = #FightCheckBagView] _yesBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function FightCheckBagView:_yesBtnHandler(sender, event)
	if self._enemyCell then
		self._enemyCell:enterFight()
	else  --副本扫荡的情况
		local fubenHangOutCountView = require("view.fuben.FubenHangOutCountView").instance
		if fubenHangOutCountView then
			fubenHangOutCountView:sendHangoutMsg()
		end
	end
	
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end 

---
-- 点击了关闭按钮
-- @function [parent = #FightCheckBagView] _closeBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function FightCheckBagView:_closeBtnHandler(sender, event)
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 设置显示文本
-- @function [parent = #FightCheckBagView] setText
-- @param #string text
-- 
function FightCheckBagView:setText(text)
	self["textLab"]:setString(text)
end

---
-- 设置敌人ID
-- @function [parent = #FightCheckBagView] setEnemyCell
-- @param #CCNode cell
-- 
function FightCheckBagView:setEnemyCell(cell)
	self._enemyCell = cell
end

---
-- 窗口退出自动回调
-- @function [parent = #FightCheckBagView] onExit
-- 
function FightCheckBagView:onExit()
	instance = nil
	FightCheckBagView.super.onExit(self)
end

---
-- 判断背包/碎片是否满了
-- @function [parent = #FightCheckBagView] isBagChipFull
-- @return #string
--
function isBagChipFull()
	local fightData = require("model.FightData")
	local itemData = require("model.ItemData")
	
	local partnerNum = require("model.PartnerData").partnerSet:getLength()
	--printf("partnerNum = "..partnerNum)
	local equitNum = itemData.itemEquipListSet:getLength()
	--printf("equitNum = "..equitNum)
	local martialNum = itemData.getMartCount()
	--printf("martialNum = "..martialNum)
	local partnerChipNum = itemData.itemPartnerChipListSet:getLength()
	--printf("partnerChipNum = "..partnerChipNum)
	local equitChipNum = itemData.itemEquipChipListSet:getLength()
	--printf("equitChipNum = "..equitChipNum)
	local martialChipNum = itemData.itemMartialChipListSet:getLength()
	--printf("martialChipNum = "..martialChipNum)
	
	local returnStr = nil
	if partnerNum >= fightData.BagPartnerMaxNum then
		if returnStr then
			returnStr = returnStr..tr("、")
		else
			returnStr = ""
		end
		returnStr = returnStr..tr("侠客")
	end
	
	if martialNum >= fightData.BagMartialMaxNum then
		if returnStr then
			returnStr = returnStr..tr("、")
		else
			returnStr = ""
		end
		returnStr = returnStr..tr("武学")
	end
	
	if equitNum >= fightData.BagEquitMaxNum then
		if returnStr then
			returnStr = returnStr..tr("、")
		else
			returnStr = ""
		end
		returnStr = returnStr..tr("装备")
	end
	
	if partnerChipNum >= fightData.PartnerChipMaxNum then
		if returnStr then
			returnStr = returnStr..tr("、")
		else
			returnStr = ""
		end
		returnStr = returnStr..tr("侠客碎片")
	end
	
	if equitChipNum >= fightData.EquitChipMaxNum then	
		if returnStr then
			returnStr = returnStr..tr("、")
		else
			returnStr = ""
		end
		returnStr = returnStr..tr("装备碎片")
	end
	
	if martialChipNum >= fightData.MartialChipMaxNum then
		if returnStr then
			returnStr = returnStr..tr("、")
		else
			returnStr = ""
		end
		returnStr = returnStr..tr("武学碎片")
	end
	
	return returnStr
end
	







