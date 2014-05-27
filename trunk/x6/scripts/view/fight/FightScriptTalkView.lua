---
-- 战斗人物对话界面
-- @module view.fight.FightScriptTalkView
--

local require = require
local class = class

local CCSize = CCSize
local ccp = ccp
local CCMoveTo = CCMoveTo
local CCRepeatForever = CCRepeatForever
local CCLayerColor = CCLayerColor
local ccc4 = ccc4

local printf = printf

local moduleName = "view.fight.FightScriptTalkView"
module(moduleName)

---
-- 类定义
-- @type FightScriptTalkView
--
local FightScriptTalkView = class(moduleName, require("ui.CCBView").CCBView) 

---
-- 玩家说话头像坐标
-- @field [parent = #FightScriptTalkView] #number _playerTalkPicPosX
-- 
FightScriptTalkView._playerTalkPicPosX = nil

---
-- 敌人说话头像坐标
-- @field [parent = #FightScriptTalkView] #number _enemyTalkPicPosX
-- 
FightScriptTalkView._enemyTalkPicPosX = nil

---
-- 玩家说话文本坐标
-- @field [parent = #FightScriptTalkView] #number _playerTalkTextPosX
-- 
FightScriptTalkView._playerTalkTextPosX = nil

---
-- 敌人说话文本坐标
-- @field [parent = #FightScriptTalkView] #number _enemyTalkTextPosX
-- 
FightScriptTalkView._enemyTalkTextPosX = nil

---
-- 三角形玩家说话坐标
-- @field [parent = #FightScriptTalkView] #number _dotPlayerPosX
-- 
FightScriptTalkView._dotPlayerPosX = nil

---
--	三角形敌人说话坐标
-- @field [parent = #FightScriptTalkView] #number _dotEnemyPosX
-- 
FightScriptTalkView._dotEnemyPosX = nil

---
-- 上 黑框图层
-- @field [parent = #FightScriptTalkView] #CCNode _blackUpLayer
-- 
FightScriptTalkView._blackUpLayer = nil

---
-- 下 黑框图层
-- @field [parent = #FightScriptTalkView] #CCNode _blackDownLayer
-- 
FightScriptTalkView._blackDownLayer = nil

---
-- 是否是战斗结束后剧情说话
-- @field [parent = #FightScriptTalkView] #bool _isEndFightTalk
-- 
FightScriptTalkView._isEndFightTalk = false

---
-- 保存自己的节点NODE
-- @field [parent = #FightScriptTalkView] #CCNode _selfNode
-- 
FightScriptTalkView._selfNode = nil

---
-- 构造函数
-- @function [parent = #FightScriptTalkView] ctor
--
function FightScriptTalkView:ctor()
	FightScriptTalkView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #FightScriptTalkView] _create
--
function FightScriptTalkView:_create()
	self._selfNode = self:load("ui/ccb/ccbfiles/ui_battle/ui_talkscript.ccbi")
	
	self:createClkHelper()
	
	local ui = require("framework.client.ui")
	--self["sayLab"]:setVerticalAlignment(ui.TEXT_VALIGN_TOP)
	self["sayLab"]:setAnchorPoint(ccp(0, 1))
	self["sayLab"]:setDimensions(CCSize(590, 0))
	self["mainNode"]:setVisible(false)
	
	-- 默认的是玩家的坐标
	self._playerTalkPicPosX = self["iconCcb"]:getPositionX()
	self._playerTalkTextPosX = self["sayLab"]:getPositionX()
	
	self._enemyTalkPicPosX = self._playerTalkPicPosX + 597
	self._enemyTalkTextPosX = self._playerTalkTextPosX - 100
	
	self._dotPlayerPosX = self["dotSpr"]:getPositionX()
	self._dotEnemyPosX = self._dotPlayerPosX - 710 
	
	self:_createBlackLayer()
	self:_playEnterAnim()
	
--	iconCcb
--	headPngSpr
--	nameLab 
end 

---
-- 场景进入自动回调
-- @function [parent = #FightScriptTalkView] onEnter
-- 
function FightScriptTalkView:onEnter()
	FightScriptTalkView.super.onEnter(self)
	
	--设置战斗场景不可触摸
	local fightCCBView = require("view.fight.FightCCBView")
	if fightCCBView.instance then
		fightCCBView.instance:setLayerTouch(false)
		--fightCCBView.instance:setEndTheFightBtnEnable(false, 0)
	end
end

---
-- 创建黑色图层
-- @function [parent = #FightScriptTalkView] _createBlackLayer
-- 
function FightScriptTalkView:_createBlackLayer()
	-- 新建黑色图层
	local display = require("framework.client.display")
	local blackUpLayer = CCLayerColor:create(ccc4(0, 0, 0, 255), display.width, self:getContentSize().height/8)
	--blackUpLayer:setAnchorPoint(ccp(0, 1))
	
	local blackDownLayer = CCLayerColor:create(ccc4(0, 0, 0, 255), display.width, self:getContentSize().height/8)
	--blackDownLayer:setAnchorPoint(ccp(0, 1))
	
	blackUpLayer:setPosition(0 - display.designLeft, self:getContentSize().height)
	self:addChild(blackUpLayer)
	
	blackDownLayer:setPosition(0 - display.designLeft, - self:getContentSize().height/8)
	self:addChild(blackDownLayer)
	
	self._blackUpLayer = blackUpLayer
	self._blackDownLayer = blackDownLayer
end

---
-- 进入场景动画
-- @function [parent = #FightScriptTalkView] _playEnterAnim
-- 
function FightScriptTalkView:_playEnterAnim()
	local transition = require("framework.client.transition")
	transition.moveTo(self._blackUpLayer,
		{
			x = self._blackUpLayer:getPositionX(),
			y = self:getContentSize().height - self:getContentSize().height/8,
			time = 0.4,
		}
	)
	
	transition.moveTo(self._blackDownLayer,
		{
			x = self._blackUpLayer:getPositionX(),
			y = 0, 
			time = 0.4,
			onComplete = function ()
				self["mainNode"]:setVisible(true)
				
				self:addClkUi(self._selfNode)
			end
		}
	)
end

---
-- 设置三角形位置
-- @function [parent = #FightScriptTalkView] setDotPositionX
-- @param #number x
-- 
function FightScriptTalkView:setDotPositionX(x)
	-- 三角形动画
	self["dotSpr"]:stopAllActions()
	self["dotSpr"]:setPositionX(x)
	local transition = require("framework.client.transition")
	--self["retangleSpr"]:setPositionY(self._initRetangleHeight)
	local y = self["dotSpr"]:getPositionY()
	local action = transition.sequence({
		CCMoveTo:create(0.35, ccp(x, y + 10)),  
		CCMoveTo:create(0.25, ccp(x, y)),  
	})
	action = CCRepeatForever:create(action)
	self["dotSpr"]:runAction(action)
end

---
-- 界面退出自动回调
-- @function [parent = #FightScriptTalkView] onExit
-- 
function FightScriptTalkView:onExit()
	instance = nil
	FightScriptTalkView.super.onExit(self)
end

---
-- 设置显示信息
-- @function [parent = #FightScriptTalkView] setShowMsg
-- @param #string msg
-- 
function FightScriptTalkView:setShowMsg(msg)
	self["sayLab"]:setString(msg)
end

---
-- 设置显示头像
-- @function [parent = #FightScriptTalkView] setShowParnerIcon
-- @param #number iconNo
-- 
function FightScriptTalkView:setShowParnerIcon(iconNo)
	self["iconCcb.headPnrSpr"]:showIcon(iconNo)
end

---
-- 设置说话者的名字
-- @function [parent = #FightScriptTalkView] setParnterName
-- @param #string name
-- 
function FightScriptTalkView:setParnterName(name)
	self["iconCcb.nameLab"]:setString(name)
end

---
-- 设置喊话信息表
-- @function [parent = #view.fight.FightScriptTalkView] setPlotMsgTl
-- @param #table msgTl
-- 
function setPlotMsgTl(msgTl)
	local showMsgTl = {}
	for i = 1, #msgTl.chat_id do
		local id = msgTl.chat_id[i]
		local plotData = require("xls.FightPlotChatXls").data
		showMsgTl[#showMsgTl + 1] = {}
		showMsgTl[#showMsgTl].chatMsg = plotData[id].ChatMsg
		showMsgTl[#showMsgTl].partnerId = plotData[id].ChatPhoto
	end
	
	if msgTl.type == 0 then --战斗结束后说话
		instance._isEndFightTalk = true
	else
		instance._isEndFightTalk = false
	end
	
	require("model.FightData").FightPlotMsgTl = showMsgTl
	require("model.FightData").FightLeftPlotMsgNum = #msgTl.chat_id - 1
	require("model.FightData").FightCurrPlotNum = 1
end

---
-- 出现/隐藏对话框
-- @function [parent = #FightScriptTalkView] setShow
-- @param #bool isShow
--  
function FightScriptTalkView:setShow(isShow)
	if isShow == true then
		local msgTl = require("model.FightData").FightPlotMsgTl
		local currNum = require("model.FightData").FightCurrPlotNum
		
		if msgTl[currNum] then
			self:setShowMsg(msgTl[currNum].chatMsg)
			if msgTl[currNum].partnerId == 0 then --表示玩家自己
				self:setPlayerTalkType()
				local playerId = require("view.fight.FightScene").getPlayerPhotoId()
				self:setShowParnerIcon(playerId)
				local name = require("model.HeroAttr").Name
				self:setParnterName(name)
				
				self:setDotPositionX(self._dotPlayerPosX)
			else
				self:setEnemyTalkType()
				--self:setShowParnerIcon(msgTl[currNum].partnerId)
				local NpcMsgData = require("xls.NpcMsgXls").data
				local id = msgTl[currNum].partnerId
				local msg = NpcMsgData[id]
				self:setShowParnerIcon(msg.Photo)
				local name = msg.Name
				self:setParnterName(name)
				
				self:setDotPositionX(self._dotEnemyPosX)
			end	
		end
	else
		self:setShowMsg("")
	end
	self:setVisible(isShow)
end

---
-- 选中特定UI后回调
-- @function [parent = #FightScriptTalkView] uiClkHandler
-- @param self
-- @param #CCNode ui
-- @param #CCRect rect
-- 
function FightScriptTalkView:uiClkHandler(ui, rect)
	require("model.FightData").FightLeftPlotMsgNum = require("model.FightData").FightLeftPlotMsgNum - 1
	local fightCCBView = require("view.fight.FightCCBView")
	if require("model.FightData").FightLeftPlotMsgNum < 0 then
		self:setShow(false)
		--self:removeFromParentAndCleanup(true)
		
		--继续战斗逻辑
		local fightStateMachine =require("view.fight.FightStateMachine")
		
		if self._isEndFightTalk == false then
			local fightCCBView = require("view.fight.FightCCBView").instance
			if fightCCBView then
				fightCCBView:playEnterAnim()
			end
			local actorTable = require("view.fight.FightScene").getActorTable()
			fightStateMachine.startActor(actorTable)
			
			self:removeFromParentAndCleanup(true)
			
			--开启战斗场景触摸和速战速决
			if fightCCBView then
				fightCCBView:setLayerTouch(true)
				--fightCCBView:setEndTheFightBtnEnable(true, 0)
			end
		else
			require("view.fight.FightScene").getFightScene():endTheFight()
		end
		
	else
		--设置战斗场景不可触摸
		if fightCCBView.instance then
			fightCCBView.instance:setLayerTouch(false)
			--fightCCBView.instance:setEndTheFightBtnEnable(false, 0)
		end
		
		require("model.FightData").FightCurrPlotNum = require("model.FightData").FightCurrPlotNum + 1
		self:setShow(true)
	end	
end

---
-- 设头像位置
-- @function [parent = #FightScriptTalkView] setHeadPicPosX
-- @param #number x
-- 
function FightScriptTalkView:setHeadPicPosX(x)
	self["iconCcb"]:setPositionX(x)
end

---
-- 设置文字框位置
-- @function [parent = #FightScriptTalkView] setTextLabPosX
-- @param #number x
--  
function FightScriptTalkView:setTextLabPosX(x)
	self["sayLab"]:setPositionX(x)
end

---
-- 设为玩家说话模式
-- @function [parent = #FightScriptTalkView] setPlayerTalkType
--
function FightScriptTalkView:setPlayerTalkType()
	self:setHeadPicPosX(self._playerTalkPicPosX)
	self:setTextLabPosX(self._playerTalkTextPosX)
end

---
-- 设为敌人说话模式
-- @function [parent = #FightScriptTalkView] setEnemyTalkType
-- 
function FightScriptTalkView:setEnemyTalkType()
	self:setHeadPicPosX(self._enemyTalkPicPosX)
	self:setTextLabPosX(self._enemyTalkTextPosX)
end
