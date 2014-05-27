---
-- 新副本结算界面
-- @module view.fuben.FubenSettlement
--

local require = require
local class = class
local tostring = tostring
local ccp = ccp

local tr = tr
local printf = printf

local moduleName = "view.fuben.FubenSettlement"
module(moduleName)

---
-- 类定义
-- @type FubenSettlement
--
FubenSettlement = class(moduleName, require("ui.CCBView").CCBView)

---
-- 保存结算数据
-- @field [parent = #view.fuben.FubenSettlement] #table _rewardMsg
-- 
local _rewardMsg = nil

---
-- 上面条形Y原来位置
-- @field [parent = #FubenSettlement] #number _upNodeBeforeY
-- 
FubenSettlement._upNodeBeforeY = nil

---
-- 上面条形Y偏移位置
-- @field [parent = #FubenSettlement] #number _upNodeOffsetY
-- 
FubenSettlement._upNodeOffsetY = 200

---
-- 侠客偏移X位置
-- @field [parent = #FubenSettlement] #number _partnerNodeOffsetX
-- 
FubenSettlement._partnerNodeOffsetX = 460

---
-- 最大侠客数
-- @field [parent = #FubenSettlement] #number _maxPartner
-- 
FubenSettlement._maxPartner = 6

---
-- 四边横条偏移X位置
-- @field [parent = #FubenSettlement] #number _lineOffsetX
-- 
FubenSettlement._lineOffsetX = 260

---
-- 场景进入自动回调
-- @function [parent = #FubenSettlement] onEnter
-- 
function FubenSettlement:onEnter()
	FubenSettlement.super.onEnter(self)
	
	--条形动画
	local spriteAction = require("utils.SpriteAction")
	spriteAction.resultLayoutAction(self["upNode"],
		{
			x = self["upNode"]:getPositionX(),
			y = self._upNodeBeforeY,
			easing = "CCEaseSineOut",
			time = 0.4,
			onComplete = self:_starAnimation()
		}
	)
	
	--胜利图片
	self["winLoseSpr"]:setOpacity(0)
	local winLoseDelayTime = 0.4
	local transition = require("framework.client.transition")
	transition.fadeIn(self["winLoseSpr"],
		{
			time = 0.1,
			delay = winLoseDelayTime,
		}
	)
	spriteAction.resultScaleSprAction(self["winLoseSpr"], 
		{
			scale = 1.0,
			delay = winLoseDelayTime,
		}
	)
	
	--四边条动画
	--self:_quarLineAnim()
	
	--侠客动画
	self:partnerAnimation()
end

---
-- 星星动画
-- @function [parent = FubenSettlement] _starAnimation
-- 
function FubenSettlement:_starAnimation()
	--星星动画
	local spriteAction = require("utils.SpriteAction")
	local scoreNum = _rewardMsg.score or 0
	for i = 1, scoreNum do
		local transition = require("framework.client.transition")
		transition.fadeIn(self["starSpr"..i],
			{
				time = 0.1,
				delay = (i + 1) * 0.2,
			}
		)
		spriteAction.resultScaleSprAction(self["starSpr"..i], 
			{
				--easing = "CCEaseExponentialOut",
				scale = 1.5,
				delay = (i + 1) * 0.2,
				time = 0.2
			}
		)
	end
end

---
-- 侠客动画
-- @function [parent = #FubenSettlement] partnerAnimation
-- 
function FubenSettlement:partnerAnimation()
	for i = 1, self._maxPartner do
		local transition = require("framework.client.transition")
		transition.fadeIn(self["PCcb"..i],
			{
				time = 0.2,
				delay = (i + 1) * 0.2,
			}
		)
	end
end

---
-- 构造函数
-- @function [parent = #FubenSettlement] ctor
--
function FubenSettlement:ctor()
	FubenSettlement.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #FubenSettlement] _create
--
function FubenSettlement:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_copy/ui_chapter_settlement.ccbi")
	
	self:handleButtonEvent("restartBtn", self._restartBtnHandler)
	self:handleButtonEvent("leftBtn", self._closeBtnHandler)
	
	self:init()
	
	self:showInfo(_rewardMsg)
end

---
-- 初始化信息
-- @function [parent = #FubenSettlement] init
-- 
function FubenSettlement:init()
	--初始化信息
	for i = 1, self._maxPartner do
		self["PCcb"..i]:setVisible(false)
		self["PCcb"..i]:setOpacity(0)
	end
	
	for i = 1, 3 do
		self["starSpr"..i]:setVisible(false)
	end
	
	--动画
	self["winLoseSpr"]:setScale(5.0)
	--self["winLoseSpr"]:setOpacity(0)
	for i = 1, 3 do
		self["starSpr"..i]:setScale(5)
		self["starSpr"..i]:setOpacity(0)
	end
	--self["upNode"]:setPosition(480, 930) --640
	
	self._upNodeBeforeY = self["upNode"]:getPositionY()
	self["upNode"]:setPositionY(self._upNodeBeforeY + self._upNodeOffsetY)	
end

---
-- 设置回合数
-- @function [parent = #FubenSettlement] setFightCount
-- @param #number count
-- 
function FubenSettlement:setFightCount(count)
	if count > 10 then
		count = 10
	end
	self["fightCountLab"]:setString(tostring(count))
end

---
-- 战斗重播
-- @function [parent = #FubenSettlement] _restartBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function FubenSettlement:_restartBtnHandler(sender, event)
	-- 回放
	local fightBout = require("view.fight.FightBout")
	fightBout.setCurrItem(1)
	
	local gameView = require("view.GameView")
	gameView.removePopUp(self, true)
	local fightScene = require("view.fight.FightScene")
	local fightInitFighters = require("view.fight.FightInit").getFighterInitTl()
	fightScene.setIsEndTheFight(false)
	for i = 1, #fightInitFighters do
		fightScene.initFighter(fightInitFighters[i])
	end
	
	local fightCCBView = require("view.fight.FightCCBView")
	if fightCCBView.instance then
		fightCCBView.instance:setIsReplay(true)
		fightCCBView.instance:setLayerTouch(true)
		fightCCBView.instance:setEndTheFightBtnEnable(true, 0)
		fightCCBView.instance:setPlayersBlood()
		fightCCBView.instance:setEnemysBlood()
		fightCCBView.instance:playBattleMusic()
	end
	
	local fightBout = require("view.fight.FightBout")
	fightScene.playBout(fightBout.getFightBoutTable())
end

---
-- 点击了关闭按钮
-- @function [parent = #FubenSettlement] _closeBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function FubenSettlement:_closeBtnHandler(sender, event)
	local changeWinLogic = require("logic.ChangeWindowLogic")
	local gameView = require("view.GameView")
	local winIns = changeWinLogic.getChangeWinIns()
	if winIns then
		gameView.addPopUp(winIns, true)
	end
	
	gameView.removePopUp(self, true)
	
				
	local fightScene = require("view.fight.FightScene").getFightScene()
	fightScene:removeFromParentAndCleanup(true)
	--local scene = gameView.getScene()
	--scene:removeChild(fightScene, true)
end

---
-- 显示奖励信息
-- @function [parent = #FubenSettlement] showInfo
-- @param #table info
-- 
function FubenSettlement:showInfo(info)
	if not info then return end
	
	self["silverLab"]:setString(info.cash or 0)
	self["famouseLab"]:setString(info.exp or 0)
	
	--星星
	local scoreNum = info.score or 0
	for i = 1, scoreNum do
		self["starSpr"..i]:setVisible(true)
	end
	
	--显示人物信息
	for i = 1, #info.partner_info do
		self["PCcb"..i]:setVisible(true)
		self["PCcb"..i..".partnerCcb.headPnrSpr"]:showIcon(info.partner_info[i].icon)
		local ItemViewConst = require("view.const.ItemViewConst")
		self:changeFrame("PCcb"..i..".partnerCcb.frameSpr", ItemViewConst.MARTIAL_RARE_COLORS1[info.partner_info[i].step])
		self:changeFrame("PCcb"..i..".partnerCcb.lvBgSpr", ItemViewConst.MARTIAL_RARE_COLORS2[info.partner_info[i].step])
		if info.partner_info[i].add_grade and info.partner_info[i].add_grade > 0 then
			self["PCcb"..i..".partnerCcb.lvLab"]:setString(info.partner_info[i].grade)
			self["PCcb"..i..".levelStartLab"]:setString((info.partner_info[i].grade - info.partner_info[i].add_grade).." → ")
			self["PCcb"..i..".levelEndLab"]:setString(info.partner_info[i].grade)
		else
			self["PCcb"..i..".partnerCcb.lvLab"]:setString(info.partner_info[i].grade)
			self["PCcb"..i..".levelStartLab"]:setString(info.partner_info[i].grade)
			self["PCcb"..i..".levelEndLab"]:setString("")
		end
		local partnerColor = require("view.const.PartnerShowConst").STEP_COLORS[info.partner_info[i].step]
		self["PCcb"..i..".xiakeNameLab"]:setString(info.partner_info[i].name)
		
		-- 新建描边字体
		local ui = require("framework.client.ui")
		local newPartnerName = ui.newTTFLabelWithShadow(
			{
				text = partnerColor..info.partner_info[i].name,
				size = self["PCcb"..i..".xiakeNameLab"]:getFontSize(),
				ajustPos = true,
			}
		)
		self["PCcb"..i]:addChild(newPartnerName)
		newPartnerName:setPosition(self["PCcb"..i..".xiakeNameLab"]:getPositionX(), 
		self["PCcb"..i..".xiakeNameLab"]:getPositionY() - 7)
		
		self["PCcb"..i..".xiakeNameLab"]:setVisible(false)
		
		self["PCcb"..i..".expLab"]:setString(tr("EXP：+ "..info.partner_info[i].add_exp))
		
	end
	
	-- 判断是否是战斗重播
	local isReplay = false
	local fightCCBViewIns = require("view.fight.FightCCBView").instance
	if fightCCBViewIns then
		isReplay = fightCCBViewIns:isReplay()
	end
	if isReplay == false then
		-- 显示奖励信息
		if info.list_info then
			local fubenReward = require("view.fuben.FubenRewardView")
			for i = 1, #info.list_info do
				fubenReward.addRewardMsg(info.list_info[i])
			end
			fubenReward.showReward()
		end
	end
end

---
-- 场景退出自动回调
-- @function [parent = #FubenSettlement] onExit
-- 
function FubenSettlement:onExit()
	local fightData = require("model.FightData")
	fightData.resetFightData()

	instance = nil
	FubenSettlement.super.onExit(self)
end

---
-- 设置界面结算内容
-- @function [parent = #view.fuben.FubenSettlement] setRewardMsg
-- @param #table msg
-- 
function setRewardMsg(msg)
	_rewardMsg = msg
end

---
-- 获取结算信息
-- @function [parent = #view.fuben.FubenSettlement] getRewardMsg
-- @return #table
-- 
function getRewardMsg()
	return _rewardMsg
end







