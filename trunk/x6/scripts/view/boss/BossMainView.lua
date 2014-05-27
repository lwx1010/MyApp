---
-- BOSS界面
-- @module view.boss.BossMainView
--

local require = require
local class = class
local math = math
local tostring = tostring
local printf = printf
local os = os
local string = string
local display = display
local CCScaleTo = CCScaleTo
local CCFadeOut = CCFadeOut
local CCDelayTime = CCDelayTime
local CCCallFunc = CCCallFunc
local CCLayerColor = CCLayerColor
local CCLabelTTF = CCLabelTTF
local CCSize = CCSize
local ccp = ccp
local ccc3 = ccc3

local dump = dump
local assert = assert

local ui = ui

local moduleName = "view.boss.BossMainView"
module(moduleName)

---
-- 类定义
-- @type BossMainView
--
local BossMainView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 记录服务端发过来的剩余活动时间
-- @field [parent = #view.boss.BossMainView] #table _relifeTimeCal
--  
local _relifeTimeCal = {}
_relifeTimeCal.startClock = 0
_relifeTimeCal.startTime = 0

---
-- 记录服务端发过来的挑战BOSS冷却时间
-- @field [parent = #view.boss.BossMainView] #table _bossCoolTimeCal
-- 
local _bossCoolTimeCal = {}
_bossCoolTimeCal.startClock = 0
_bossCoolTimeCal.startTime = 0

---
-- 缩放时间
-- @field [parent = #view.boss.BossMainView] #number SCALE_TIME
-- 
local SCALE_TIME = 0.2

---
-- 显示时间
-- @field [parent = #view.boss.BossMainView] #number SHOW_TIME
-- 
local SHOW_TIME = 3.0

---
-- 消隐时间
-- @field [parent = #view.boss.BossMainView] #number FADE_TIME
-- 
local FADE_TIME = 1

---
-- 最大提示数目
-- @field [parent = #view.boss.BossMainView] #number MAX_NOTIFY
-- 
local MAX_NOTIFY = 4

---
-- 边框宽度
-- @field [parent = #view.boss.BossMainView] #number BORDER_WIDTH
-- 
local BORDER_WIDTH = 10

---
-- 垂直间距
-- @field [parent = #view.boss.BossMainView] #number V_SPACE
-- 
local V_SPACE = 4

---
-- 攻击提示表
-- @field [parent = #view.boss.BossMainView] #table _attackerTable
-- 
local _attackerTable = {}

---
-- 重用lab
-- @field [parent = #view.boss.BossMainView] #table _freeLabTable
-- 
local _freeLabTable = {}

---
-- 保存显示信息表
-- @field [parent = #view.boss.BossMainView] #table _showMsg
-- 
local _showMsg = {}

---
-- 保存正在滚动的字幕
-- @field [parent = #view.boss.BossMainView] #table _rollingMsg
-- 
local _rollingMsg = {}

---
-- 滚动字幕回调句柄
-- @field [parent = #view.boss.BossMainView] #scheduler _tipScheHandle
-- 
local _tipScheHandle = nil

---
-- 滚动条开始位置 Y 
-- @field [parent = #view.boss.BossMainView] #number _START_Y
-- 
local _START_Y = 20

---
-- 滚动条开始位置 X
-- @field [parent = #view.boss.BossMainView] #number _START_X
-- 
local _START_X = 510

---
-- 滚动距离
-- @field [parent = #view.boss.BossMainView] #number _distance
--  
local _distance = 500

---
-- 滚动秒数
-- @field [parent = #view.boss.BossMainView] #number _during
-- 
local _during = 6

---
-- 同一时间显示消息的条数
-- @field [parent = #view.boss.BossMainView] #number _MSG_NUM
-- 
local _MSG_NUM = 2

---
-- 当前消息的ID
-- @field [parent = #view.boss.BossMainView] #nunber _currTipNo
-- 
local _currTipNo = 1

---
-- 消息之间间隔的距离
-- @field [parent = #view.boss.BossMainView] #number _msgDistance
-- 
local _msgDistance = 40

---
-- 保存结算信息
-- @field [parent = #view.boss.BossMainView] #table _saveEndMsg
-- 
local _saveEndMsg = nil

---
-- 构造函数
-- @function [parent = #BossMainView] ctor
--
function BossMainView:ctor()
	BossMainView.super.ctor(self)
	self:_create()
	--self:retain()
end

---
-- 加载ccbi
-- @function [parent = #BossMainView] _create
--
function BossMainView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_boss/ui_boss.ccbi")
	
	--换BOSS模型
	display.addSpriteFramesWithFile("body/1009999.plist", "body/1009999.png")
	self:changeFrame("bossSpr", "1009999/idle2/7/10000.png")
	self["bossSpr"]:setFlipX(true)
	
	--添加动作
	local spriteAction = require("utils.SpriteAction")
	spriteAction.spriteRunForeverAction(self["bossSpr"], "1009999/idle1/7/100%02d.png", 0, 11)
	
	-- 加入boss触控
	self:createClkHelper()
	self:addClkUi("bossSpr")
	
	self["textLab"]:setVisible(false)
	
	self["tipTextLab"]:setString("")
	self["tipTextLab"]:setAnchorPoint(ccp(0,0.5))
	self["tipTextLayer"]:setCascadeOpacityEnabled(false)
	self["tipTextLayer"]:setOpacity(0)
	self["tipTextLayer"]:setClipEnabled(true)
	
	--隐藏排名信息
	self:setSortMsgShow(false)
	
	self:handleButtonEvent("clearBtn", self._clearBtnHandler)
	self:handleButtonEvent("closeBtn", self._closeBtnHandler)
	
	self["clearBtn"]:setEnabled(false)
	
	self:_loadBossTip()
	self:_showBossTip()
	for i = 1, #_showMsg do
		self["tipTextLayer"]:addChild(_showMsg[i])
	end
	
	self["bossSayLab"]:setOpacity(0)
	self["bossSayBgS9Spr"]:setOpacity(0)
end

---
-- 场景进入自动回调
-- @function [parent = #BossMainView] onEnter
--  
function BossMainView:onEnter()
	BossMainView.super.onEnter(self)
	
	local gameNet = require("utils.GameNet")
	gameNet.send("C2s_worldboss_join_exit", {is_join = 0})
	
	self:_showBossTip()
end

---
-- 设置库银
-- @function [parent = #BossMainView] setSilVer
-- @param #number num
-- 
function BossMainView:setSilVer(num)
	local NumberUtil = require("utils.NumberUtil")
	self["silverCountLab"]:setString(NumberUtil.numberForShort(num))
end

---
-- 设置元宝
-- @function [parent = #BossMainView] setGlod
-- @param #number num
-- 
function BossMainView:setGlod(num)
	local NumberUtil = require("utils.NumberUtil")
	self["glodCountLab"]:setString(num)
end

---
-- 设置自己的伤害百分比
-- @function [parent = #BossMainView] setMyHurt
-- @param #number num
-- 
function BossMainView:setMyHurt(num)
	num = string.format("%.4f", num)
	num = num * 100
	if num > 100 then
		num = 100
	end
	self["myHurtLab"]:setString("我的伤害 "..num.."%")
end

---
-- 设置自己的排名
-- @function [parent = #BossMainView] setMySort
-- @param #number num
-- 
function BossMainView:setMySort(num)
	local addString = ""
	if num > 100 then
		addString = "以外"
	end
	self["mySortLab"]:setString("我的排名 "..num..addString)
end

--- 
-- 设置自己获得的银两
-- @function [parent = #BossMainView] setAddRewardSilver
-- @param #number num
-- 
function BossMainView:setAddRewardSilver(num)
	self["addRewardLab"]:setString(num)
end

---
-- 挑战BOSS的冷却时间
-- @function [parent = #BossMainView] setCoolTime
-- @param #number num
-- 
function BossMainView:setCoolTime(num)
	_relifeTimeCal.startTime = num
	_relifeTimeCal.startClock = os.time()
	
	local scheduler = require("framework.client.scheduler")
	if self._bossCoolSche ~= nil then
		scheduler.unscheduleGlobal(self._bossCoolSche)
		self._bossCoolSche = nil
	end
	self._bossCoolSche = scheduler.scheduleGlobal(
		function ()
			if _relifeTimeCal.startTime - os.difftime(os.time(), _relifeTimeCal.startClock) >= 0 then
				self:_updateTime("relifeColdLab", _relifeTimeCal.startTime - os.difftime(os.time(), _relifeTimeCal.startClock))
				self["clearBtn"]:setEnabled(true)
			else
				self:_updateTime("relifeColdLab", 0)
				self["clearBtn"]:setEnabled(false)
			end
		end,
		0.5
	)
end

---
-- 设置BOSS名字
-- @function [parent = #BossMainView] setBossName
-- @param #string bossName
-- 
function BossMainView:setBossName(bossName)
	self["bossNameLab"]:setString(bossName)
end

---
-- 设置BOSS血量
-- @function [parent = #BossMainView] setBossBlood
-- @param #number currBlood
-- @param #number maxBlood
-- 
function BossMainView:setBossBlood(currBlood, maxBlood)
	if currBlood < 0 then
		currBlood = 0
	end
	self._bossMaxBlood = maxBlood
	self["bossBloodLab"]:setString(currBlood.."/"..maxBlood)
	self["bossBloodPBar"]:setPercentage(currBlood/maxBlood*100)
end

---
-- 设置活动剩余时间
-- @function [parent = #BossMainView] setEndTime
-- @param #number time
-- 
function BossMainView:setEndTime(time)
	_bossCoolTimeCal.startTime = time
	_bossCoolTimeCal.startClock = os.time()
	
	local scheduler = require("framework.client.scheduler")
	if self._leftTimeSche ~= nil then
		scheduler.unscheduleGlobal(self._leftTimeSche)
		self._leftTimeSche = nil 
	end
	self._leftTimeSche = scheduler.scheduleGlobal(
		function ()
			if _bossCoolTimeCal.startTime - os.difftime(os.time(), _bossCoolTimeCal.startClock) >= 0 then
				self:_updateTime("endTimeLab", _bossCoolTimeCal.startTime - os.difftime(os.time(), _bossCoolTimeCal.startClock))
			else
				self:_updateTime("endTimeLab", 0)
			end
		end,	
		0.5
	)
end

---
-- 更新时间
-- @function [parent = #BossMainView] updateTime
-- @param #string label 
-- @param #number time 秒数
-- 
function BossMainView:_updateTime(label, time)
	--获取秒
	local numUtil = require("utils.NumberUtil")
	local time = numUtil.secondToDate(time)
	
	self[label]:setString(time)
end

---
-- 设置前5名玩家信息
-- @function [parent = #BossMainView] setSortPlayer
-- @param #table playerTable
-- 
function BossMainView:setSortPlayer(playerTable)
	for i = 1, #playerTable do
		if playerTable[i].rank <= 3 then
			self["sortSpr"..playerTable[i].rank]:setVisible(true)
		else
			self["sortLab"..playerTable[i].rank]:setVisible(true)
		end
		self["sortNameLab"..playerTable[i].rank]:setVisible(true)
		self["sortNameLab"..playerTable[i].rank]:setString(playerTable[i].user_name)
		self["sortHurtLab"..playerTable[i].rank]:setVisible(true)
		local hurtValue = playerTable[i].hurt_hp/self._bossMaxBlood
		hurtValue = string.format("%.4f", hurtValue)
		hurtValue = hurtValue * 100
		if hurtValue > 100 then
			hurtValue = 100
		end
		--self["sortHurtLab"..playerTable[i].rank]:setString(playerTable[i].hurt_hp/self._bossMaxBlood.."%")
		self["sortHurtLab"..playerTable[i].rank]:setString(hurtValue.."%")
	end
end

---
-- 设置boss说的话
-- @function [parent = #BossMainView] setBossSay
-- @param #string str
-- 
function BossMainView:setBossSay(str)
	self["bossSayLab"]:stopAllActions()
	self["bossSayLab"]:setOpacity(255)
	self["bossSayBgS9Spr"]:stopAllActions()
	self["bossSayBgS9Spr"]:setOpacity(255)
	
	self["bossSayLab"]:setString(str)
	local transition = require("framework.client.transition")
	transition.fadeOut(self["bossSayLab"],
		{
			delay = 2.0,
			time = 1.0
		}
	)
	transition.fadeOut(self["bossSayBgS9Spr"],
		{
			delay = 2.0,
			time = 1.0
		}
	)
end

---
-- 显示，隐藏排名信息
-- @function [parent = #BossMainView] setSortMsgShow
-- @param #bool show
--  
function BossMainView:setSortMsgShow(show)
	for i = 1, 5 do
		if i <= 3 then
			self["sortSpr"..i]:setVisible(show)
		else
			self["sortLab"..i]:setVisible(show)
		end
		self["sortNameLab"..i]:setVisible(show)
		self["sortHurtLab"..i]:setVisible(show)
	end
end

---
-- 点击了关闭按钮
-- @function [parent = #BossMainView] _closeBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function BossMainView:_closeBtnHandler(sender, event)
	local GameView = require("view.GameView")
    --local MainView = require("view.main.MainView")
    --GameView.replaceMainView(MainView.createInstance())
    GameView.removePopUp(self, true)
end

---
-- 场景退出自动回调
-- @function [parent = #BossMainView] onExit
-- 
function BossMainView:onExit()
	self:setSortMsgShow(false)
	
	local scheduler = require("framework.client.scheduler")
	 
	if self._bossCoolSche then
		scheduler.unscheduleGlobal(self._bossCoolSche)
		self._bossCoolSche = nil
	end
	if self._leftTimeSche then
		scheduler.unscheduleGlobal(self._leftTimeSche)
		self._leftTimeSche = nil
	end
	
	self:_resetBossTip()
	
	--清空表
	_freeLabTable = {}
	_attackerTable = {}
	
	--退出战斗
	local gameNet = require("utils.GameNet")
	gameNet.send("C2s_worldboss_join_exit", {is_join = 1})
	
	instance = nil
	BossMainView.super.onExit(self)
end

---
-- 点击了特定监控的UI 
-- @function [parent = #BossMainView] uiClkHandler
-- @param #CCNode ui 
-- @param #CCRect rect
-- 
function BossMainView:uiClkHandler(ui, rect)
	if ui == self["bossSpr"] then
		local gameNet = require("utils.GameNet")
		gameNet.send("C2s_worldboss_fight", {place_holder = 1})
		
		-- 记录战斗完跳转界面
		local changeWinLogic = require("logic.ChangeWindowLogic")
		local viewConst = require("view.const.ResultShowConst")
		changeWinLogic.setChangeWinType(viewConst.BOSS_VIEW_TYPE)
	end
end

---
-- 点击了消除按钮
-- @function [parent = #BossMainView] _clearBtnHandler
-- @param #CCControlButtton sender
-- @param #table event
-- 
function BossMainView:_clearBtnHandler(sender, event)
	local bossCost = require("view.boss.BossCostView")
	if bossCost.isShowWindow() == true then
		local gameView = require("view.GameView")
		gameView.addPopUp(bossCost.createInstance(), true)
		gameView.center(bossCost.instance)
	else
		local gameNet = require("utils.GameNet")
		gameNet.send("C2s_worldboss_accelerate", {place_holder = 1})
		self["clearBtn"]:setEnabled(false)
	end
end

---
-- 添加攻击者信息
-- @function [parent = #BossMainView] addAttackerMsg
-- @param #string msg
-- 
function BossMainView:addAttackerMsg(msg)
	--dump(msg)
	local table = require("table")
	local lab
	if #_freeLabTable <= 0 then
		lab = CCLabelTTF:create()
		lab:setFontSize(24)
		lab:setHorizontalAlignment(1)
		self:addChild(lab)
	else
		lab = _freeLabTable[#_freeLabTable]
		table.remove(_freeLabTable, #_freeLabTable)
	end
	
	lab:setString(msg)
	lab:setScale(0.1)
	lab:setOpacity(255)
	lab:setPosition(self["textLab"]:getPositionX(), self["textLab"]:getPositionY())
	
	if #_attackerTable >= MAX_NOTIFY then
		_attackerTable[1]:stopAllActions()
		_attackerTable[1]:removeFromParentAndCleanup(true)
		
		table.remove(_attackerTable, 1)
		local TableUtil = require("utils.TableUtil")
        TableUtil.removeFromArr(_freeLabTable, _attackerTable[1]) 
	end
	
	local labSize = lab:getContentSize()
	
	-- 动画
	local transition = require("framework.client.transition")
	local action = transition.sequence({
        CCScaleTo:create(SCALE_TIME, 1),
        CCDelayTime:create(SHOW_TIME),
        CCFadeOut:create(FADE_TIME),
        CCCallFunc:create(function()
        	--lab:removeFromParentAndCleanup(true)
        	lab:stopAllActions()
        	_freeLabTable[#_freeLabTable + 1] = lab
        	
        	local TableUtil = require("utils.TableUtil")
        	TableUtil.removeFromArr(_attackerTable, lab)        	
        end)
    })
    lab:runAction(action)
    
    --移动之前的提示
    for i = 1, #_attackerTable do
    	if _attackerTable[i] then
    		transition.moveBy(_attackerTable[i], {time = SCALE_TIME, y = labSize.height + BORDER_WIDTH + V_SPACE})
    	end
    end
    
    
    _attackerTable[#_attackerTable + 1] = lab
end

---
-- 修改伤害数字
-- @function [parent = #BossMainView] setHurtNum
-- @param #number num  
--
function BossMainView:setHurtNum(num)
	self["hurtNumLab"]:stopAllActions()
	self["hurtNumLab"]:setOpacity(255)
	
	self["hurtNumLab"]:setBmpPathFormat("ccb/numeric/%d_1.png")
	self["hurtNumLab"]:setValue(-num)
	self["hurtNumLab"]:setShowAddSub(true)
	
	local transition = require("framework.client.transition")
	transition.fadeOut(self["hurtNumLab"],
		{
			time = 1.0,
			delay = SHOW_TIME,
		}
	)	
end

---
-- 添加滚动提示
-- @function [parent = #view.boss.BossMainView] _addShowMsg
-- @param #string msg
-- 
--
function _addShowMsg(msg)
	local text = ui.newTTFLabelWithShadow(
		{
			text = msg,
			size = 20,
			x = _START_X,
			y = _START_Y,
			align = ui.TEXT_ALIGN_LEFT,
			valign = ui.TEXT_VALIGN_LEFT,
			color = ccc3(255,215,0),
			dimensions = CCSize(0, 0),
		}
	)
	text:setVisible(false)
	_showMsg[#_showMsg + 1] = text
end

---
-- 加载BOSS TIP
-- @function [parent = #view.boss.BossMainView] _loadBossTip
-- 
function BossMainView:_loadBossTip()
	local tipData = require("xls.WorldBossTipXls").data
	for i = 1, #tipData do
		_addShowMsg(tipData[i].TipMsg)
	end
end

---
-- 初始化滚动条
-- @function [parent = #view.boss.BossMainView] _initRollTip
-- 
function BossMainView:_initRollTip()
	_currTipNo = 1
	
	local tipNo = _currTipNo
	for i = 1, _MSG_NUM do
		_rollingMsg[i] = _showMsg[tipNo]
		_rollingMsg[i]:setVisible(true)
		tipNo = tipNo + 1
		if i == 1 then
			_rollingMsg[i]:setPositionX(_rollingMsg[i]:getPositionX() - 10)
		elseif i == 2 then
			_rollingMsg[i]:setPositionX(_rollingMsg[i - 1]:getPositionX() + _rollingMsg[i - 1]:getContentSize().width + _msgDistance)
		end
	end
end

---
-- 更新位置
-- @function [parent = #BossMainView] _update
-- @param #number time
-- 
function _update(time)
	for i = 1, _MSG_NUM do
		local offsetX = time/_during*_distance
		_rollingMsg[i]:setPositionX(_rollingMsg[i]:getPositionX() - offsetX)
	end
	
	if _START_X - _rollingMsg[1]:getPositionX() - _rollingMsg[1]:getContentSize().width >= _distance then
		_rollingMsg[1]:setPositionX(_START_X)
		_rollingMsg[1]:setVisible(false)
		
		--换tip
		_currTipNo = _currTipNo + 1
		if _currTipNo > #_showMsg then
			_currTipNo = 1
		end
		
		local tipNo = _currTipNo
		
		for i = 1, _MSG_NUM do
			_rollingMsg[i] = _showMsg[tipNo]
			_rollingMsg[i]:setVisible(true)
			
			if i == 2 then
				_rollingMsg[i]:setPositionX(_rollingMsg[i - 1]:getPositionX() + _rollingMsg[i - 1]:getContentSize().width + _msgDistance)
			end
			
			tipNo = tipNo + 1
			if tipNo > #_showMsg then
				tipNo = 1
			end
		end
	end
end

---
-- 显示tip
-- @function [parent = #BossMainView] _showBossTip
-- 
function BossMainView:_showBossTip()
	self:_initRollTip()
	if _tipScheHandle == nil then
		local scheduler = require("framework.client.scheduler")
		_tipScheHandle = scheduler.scheduleUpdateGlobal(
			_update,
			false
		)
	end
end

---
-- 重置所有boss tip
-- @function [parent = #BossMainView] _resetBossTip
-- 
function BossMainView:_resetBossTip()
	_currTipNo = 1
--	for i = 1, #_showMsg do
--		_showMsg[i]:setVisible(false)
--		_showMsg[i]:setPositionX(_START_X)
--	end
	_showMsg = {}
	
	local scheduler = require("framework.client.scheduler")
	if _tipScheHandle then
		scheduler.unscheduleGlobal(_tipScheHandle)
		_tipScheHandle = nil
	end
end

---
-- 保存结算信息，当正在战斗的时候调用
-- @function [parent = #view.boss.BossMainView] saveEndMsg
-- @param #table msg
-- 
function saveEndMsg(msg)
	_saveEndMsg = msg
end

---
-- 处理结算信息
-- @function [parent = #view.boss.BossMainView] handleEndMsg
-- 
function handleEndMsg()
	if _saveEndMsg then
		--弹出结算信息
		local gameView = require("view.GameView")
		local bossEndMsg = require("view.boss.BossEndMsgView").createInstance()
		
		bossEndMsg:setShowMsg(_saveEndMsg)
		gameView.addPopUp(bossEndMsg, true)
		gameView.center(bossEndMsg)
		_saveEndMsg = nil
	end
end


