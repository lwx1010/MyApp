---
-- 副本扫荡次数选择界面
-- @module view.fuben.FubenHangOutCountView
--

local require = require
local class = class

local tonumber = tonumber

local printf = printf
local tr = tr

local moduleName = "view.fuben.FubenHangOutCountView"
module(moduleName)

---
-- 类定义
-- @type FubenHangOutCountView
--
local FubenHangOutCountView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 最大次数
-- @field [parent = #FubenHangOutCountView] _maxCount
-- 
FubenHangOutCountView._maxCount = 0

---
-- 设置当前CELL 
-- @field [parent = #FubenHangOutCountView] _currCell
-- 
FubenHangOutCountView._currCell = nil

---
-- 神行描边文本
-- @field [parent = #FubenHangOutCountView] _shenXingLab
-- 
FubenHangOutCountView._shenXingLab = nil

---
-- 构造函数
-- @function [parent = #FubenHangOutCountView] ctor
--
function FubenHangOutCountView:ctor()
	FubenHangOutCountView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #FubenHangOutCountView] _create
--
function FubenHangOutCountView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_copy/ui_copy_sd2.ccbi", true)
	
	self["countLab"]:setString(1)
	self:handleButtonEvent("addBtn", self._addBtnHandler)
	self:handleButtonEvent("subBtn", self._subBtnHandler)
	self:handleButtonEvent("confirmBtn", self._yesBtnHandler)
	self:handleButtonEvent("closeBtn", self._closeBtnHandler)
	
	-- 添加神行信息
	local heroAttr = require("model.HeroAttr")
	local color = ""
	if heroAttr.ShenXing < 1 then
		color = "<c5>"
	else
		color = "<c1>"
	end
	
	self["shenXingLab"]:setString(tr("<c0>需消耗神行: "..color.."0<c0>/"..color..heroAttr.ShenXing))
	
	-- 新建描边字体
	local ui = require("framework.client.ui")
	local newOutLineLab = ui.newTTFLabelWithShadow(
		{
			text = self["shenXingLab"]:getString(),
			size = self["shenXingLab"]:getFontSize(),
			ajustPos = true,
		}
	)
	self:addChild(newOutLineLab)
	newOutLineLab:setPosition(self["shenXingLab"]:getPositionX() - newOutLineLab:getContentSize().width/2, 
	self["shenXingLab"]:getPositionY() - 7)
	self["shenXingLab"]:setVisible(false)
	self._shenXingLab = newOutLineLab
end 

---
-- 设置最大挑战次数
-- @function [parent = #FubenHangOutCountView] setMaxCount
-- @param #number max
-- 
function FubenHangOutCountView:setMaxCount(max)
	self._maxCount = max
end

---
-- 设置当前cell
-- @function [parent = #FubenHangOutCountView] setCurrCell
-- @param #CCNode cell
-- 
function FubenHangOutCountView:setCurrCell(cell)
	self._currCell = cell
end

---
-- 点击了添加按钮
-- @function [parent = #FubenHangOutCountView] _addBtnHandler
-- @param #FubenHangOutCountView sender
-- @param #table event
-- 
function FubenHangOutCountView:_addBtnHandler(sender, event)
	local currCount = tonumber(self["countLab"]:getString())
	local physic = require("model.HeroAttr").Physical
	if currCount < self._maxCount and currCount < physic then
		currCount = currCount + 1
		self["countLab"]:setString(currCount)
		local heroAttr = require("model.HeroAttr")
		local color = ""
		local shenXingCostNum = currCount - 1
		if heroAttr.ShenXing < shenXingCostNum then
			color = "<c5>"
		else
			color = "<c1>"
		end
		
		if shenXingCostNum < 0 then
			shenXingCostNum = 0
		end
		
		self._shenXingLab:setString(tr("<c0>需消耗神行: "..color..shenXingCostNum.."<c0>/"..color..heroAttr.ShenXing))
		--self["shenXingLab"]:setString(tr("需消耗神行: "..currCount.."/"..heroAttr.ShenXingMax))
	end
end

---
-- 点击了减少按钮
-- @function [parent = #FubenHangOutCountView] _subBtnHandler
-- @param #FubenHangOutCountView sender
-- @param #table event
-- 
function FubenHangOutCountView:_subBtnHandler(sender, event)
	local currCount = tonumber(self["countLab"]:getString())
	if currCount > 0 then
		currCount = currCount - 1
		self["countLab"]:setString(currCount)
		
		local heroAttr = require("model.HeroAttr")
		local color = ""
		local shenXingCostNum = currCount - 1
		if heroAttr.ShenXing < shenXingCostNum then
			color = "<c5>"
		else
			color = "<c1>"
		end
		
		if shenXingCostNum < 0 then
			shenXingCostNum = 0
		end
		self._shenXingLab:setString(tr("<c0>需消耗神行: "..color..shenXingCostNum.."<c0>/"..color..heroAttr.ShenXing))
	end
end

---
-- 点击了确定按钮
-- @function [parent = #FubenHangOutCountView] _yesBtnHandler
-- @param #FubenHangOutCountView sender
-- @param #table event
-- 
function FubenHangOutCountView:_yesBtnHandler(sender, event)
	local currCount = tonumber(self["countLab"]:getString())
	printf("currCount = "..currCount)
	if currCount == 1 then -- 特殊处理
		if self._currCell:isBagFull() == false then
			self._currCell:enterFight()
			
			local GameView = require("view.GameView")
    		GameView.removePopUp(self, true)
    	else
    		local GameView = require("view.GameView")
    		GameView.removePopUp(self, true)
		end
	elseif currCount > 1 then
		-- 扫荡
		local fightCheckBagView = require("view.fight.FightCheckBagView")
		local isFull = fightCheckBagView.isBagChipFull()
		local shenXingNum = require("model.HeroAttr").ShenXing
		if isFull then
			local viewIns = fightCheckBagView.createInstance()
			viewIns:setText(tr("你的")..isFull..tr("背包已满, 无法获取新道具，是否要继续扫荡？"))
			local gameView = require("view.GameView")
			gameView.addPopUp(viewIns, true)
			gameView.center(viewIns)
		elseif shenXingNum < currCount - 1 then
			local notify = require("view.notify.FloatNotify")
			notify.show(tr("神行点数不足，请重新选择或积累神行点数"))
		else
			self:sendHangoutMsg()
		end
	end
end

---
-- 发送扫荡信息
-- @function [parent = #FubenHangOutCountView] _sendHangoutMsg
-- 
function FubenHangOutCountView:sendHangoutMsg()
	-- 扫荡
	local gameNet = require("utils.GameNet")
	gameNet.send("C2s_fuben_raids", 
		{
			chapterno = self._currCell:getChapterId(), 
			enemyno = self._currCell:getEnemyId(),
			times = tonumber(self["countLab"]:getString())
		}
	)
	
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 点击了关闭按钮
-- @function [parent = #FubenHangOutCountView] _closeBtnHandler
-- @param #FubenHangOutCountView sender
-- @param #table event
-- 
function FubenHangOutCountView:_closeBtnHandler(sender, event)
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 退出自动回调
-- @function [parent = #FubenHangOutCountView] onExit
-- 
function FubenHangOutCountView:onExit()
	instance = nil
	FubenHangOutCountView.super.onExit(self)
end









